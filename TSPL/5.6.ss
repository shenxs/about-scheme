#|
延续是一个过程，代表了给定点的接下来的计算，这可以通过(call-with-current-continuation)得到，也可以简写成call/cc
|#

#|
过程：（call/cc produce）
过程：(call-with-current-continuation procedure)

这两个过程是一样的，前者是后者的简写
call/cc获得他的延续，并将此延续传递给procedure，procedure应该接受一个参数。延续可以看做是一个函数，每一次延续应用在0或者更多的值上时。
这个值就被返回给call/cc 作为call/cc这个application的延续。
也就是说当延续这个过程被调用的时候，他会将他的参数作为call/cc的返回值
延续可以用来实现非本地的退出，回溯，协程，以及多任务.


下面的例子展示了一个使用continuation来做非本地的退出的应用
|#

(define (member x ls)
  (call/cc (lambda (break)
             (do ([ls ls (cdr ls)])
                 ((null? ls) #f)
               (when (equal? x (car ls))
                 (break ls))))))

(member 'd '(a b c ))

(member 'd '(a b c d))

(member 'b '(a b c d))

#|
当前的延续在内部的表示方式是一个过程调用的栈，通过将栈封装在一个过程对象中的
方式来表示一个延续。由于封装的堆栈大小是不确定的，因此必须有某种机制无限地保留
堆栈中的内容。这可以以非常简单的高效的方式做到，并且不影响不使用延续的代码
|#


#|
过程：(dynamic-wind in body out)
返回： 从应用body返回的结果

dynamic-wind可以提供某种“保护”来抵抗延续调用。当需要执行一些无论body是一般
的代码或者延续都需要执行的任务时非常有用

三个参数 in,body,out都应该是接收0个参数的函数，也就是说他们是thunk(像中空的木头，里面放着过程)。

在应用body之前，或者每次body因为其内部的延续进入子表达式，in thunk会被调用。
一旦body正常地退出，或者因为body以外创造的延续退出时，out就会被调用
因此可以保证on至少被执行一次，另外，只要body退出，out就会被执行至少一次
下面的例子保证了输入口在处理之后是被关闭的，无论是正常退出还是意外关闭。
|#

;; (let ([p (open-input-file "inputgile")])
;;   (dynamic-wind
;;     (lambda () #f)
;;     (lambda () (process p))
;;     (lambda () (close-input-port p))))

#|
Common lisp提供了unwind-protect这种机制来保护非本地的退出。一般来说也够用了，
uwind-protect 提供了类似与out的保护，但是，这是因为common lisp不支持完整通用延续。可以如下定义unwind-protect

(define-syntax unwind-protect
(syntax-rules ()
[(_ body cleanup ...)
(dynamic-wind
(lambda () #f)
(lambda () body)
(lambda () cleanup ...))]))

((call/cc
(let ([x 'a])
(lambda (k)
(unwind-protect
(k (lambda () x))
(set! x 'b))))))

|#


#|
一些scheme的实现支持所谓的流式绑定，也就是说，变量在一个给定的计算中先取一个临时的值，在计算结束后再变成原来的值。一下用dynamic-win构造的fluid-let可以允许单变量x在b1 b2 ...里面流式绑定。
|#

(define-syntax fluid-let
  (syntax-rules ()
    [(_ ((x e)) b1 b2 ...)
     (let ([y e])
       (let ([swap (lambda () (let ([t x]) (set! x y) (set! y t)))])
         (dynamic-wind swap (lambda () b1 b2 ...) swap)))]))

#|
支持fluid-let的scheme实现通常会像let一样允许无限多的（x e） 序对
效果和在进入代码后对变量赋值，返回后又赋一个新的值
|#


(let ([x 3])
  (+ (fluid-let ([x 5])
       x)
     x))

;;即使在fuild-let外创造的延续被调用了，fuild-let中流式绑定的变量依然会变成旧值

(let ([x 'a])
  (let ([f (lambda () x)])
    (cons (call/cc (lambda (k)
                     (fluid-let ([x 'b])
                       (k (f)))))
          (f))))

;;如果当前的控制离开了 fluid-let的函数体，无论是正常退出还是因为调用了延续，然后调用延续之后重新进入函数体。通过fluid-bound 流式绑定的变量又恢复了,另外任何对于临时变量都会在重新进入的时候体现出来

(define reenter #f)
(define x 0)
(fluid-let ([x 1])
  (call/cc (lambda (k) (set! reenter k)))
  (set! x (+ x 1))
  x)
x
(reenter '*)
(reenter '*)
x

#|
以下函数库展示了dynamic-wind 如果没有内置，如何在库函数里面实现。，以下的代码还实现了一个call/cc来使得dynamic-wind得以实现
|#

(library (dynamic-wind)
  (export dynamic-wind call/cc
          (rename (call/cc call-with-current-continuation)))
  (import (rename (except (rnrs) dynamic-wind) (call/cc rnrs:call/cc)))
  (define winder '())

  (define common-tail
    (lambda (x y)
      (let ([lx (length x)] [ly (length y)])
        (do ([x (if (> lx ly) (list-tail x (- lx ly) x) (cdr x))]
             [y (if (> ly lx) (list-tail y (- ly lx) y) (cdr y))])
            ((eq? x y) x)))))

  (define do-wind
    (lambda (new)
      (let ([tail (common-tail new winders)])
        (let f ([ls winders])
          (if (not (eq? ls tail))
              (begin
                (set! winders (cdr ls))
                ((cdar ls))
                (f (cdr ls)))))
        (let f ([ls new])
          (if (not (eq? ls tail))
              (begin
                (f (cdr ls))
                ((caar ls))
                (set! winders ls)))))))

  (define call/cc
    (lambda (f)
      (rnrs:call/cc
       (lambda (k)
         (f (let ([save winders])
              (lambda (x)
                (unless (eq? save winders) (do-wind save))
                (k x))))))))

  (define dynamic-wind
    (lambda (in body out)
      (in)
      (set! winders (cons (cons in out) winders))
      (let-values ([ans* (body)])
        (set! winders (cdr winders))
        (out)
        (apply values ans*))))
  )

#|
dynamic-wind和call/cc一起处理winder列表。一个winder是一对in和out的thunk。无论何时dynamic-wind被调用了，in这个thunk就会被调用。
一个新的winder包含in和out的thunk的就会被放在winder里面，当body thunk被调用之后，winder被从winder list里面移除，然后out的thunk被调用。这个顺序保证了只有当控制权进入in而且还没有进入out时winder才在winder list里面。
每当一个延续被捕获之后，winder list就会被保存下来，无论何时延续被调用了，被保存下来的winders list 又被充填。在重新恢复的时候 ，每个winder的 没有保存在winders list的out就会被调用。然后是每个winder的不在当前winders list里面的in。
winders list 逐渐更新，还是为了保证winder在当前的winders list，当且仅当程序走到in还没到out这里。
在call/cc中的（not (eq? save winders))不是必要的，只是为了节省下当前的winders list和保存下来的winders list是一样的的时候的额外开销。
|#

