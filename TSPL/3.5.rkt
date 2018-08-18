#lang racket

;;在之前的章节中,讨论过顶层定义.定义也可以出现在lambda let 或者 letrec 的body之前
;; 在这时这些定义是属于函数体的局部定义

(define f (lambda (x) (* x x)))
(let ([x 3])
  (define f (lambda (y) (+ y x)))
  (f 4))
(f 4)


;;局部定义可以相互递归调用

(let ()
  (define even?
    (lambda (x)
      (or (= x 0)
          (odd? (- x 1)))))
  (define odd?
    (lambda (x)
      (and (not (= x 0))
           (even? (- x 1)))))
  (even? 20))

(define list?
  (lambda (x)
    (define race
      (lambda (h t)
        (if (pair? h)
            (let ([h (cdr h)])
              (if (pair? h)
                  (and (not (eq? h t))
                       (race (cdr h) (cdr t)))
                  (null? h)))
            (null? h))))
    (race x x)))

;;实际上,内部变量定义和letrec是基本上通用的。除了语法上的唯一的区别，
;;他们的区别是变量的定义是可以保证被从左向右解析的,但是letrec有可能以任何顺序解析
;; 所以我们不能将一个包含内部定义的lambda,let,letrec的函数体用letrec替代.但是我们可以使用letrec*
;; let*来保证从左向右的解析顺序

#|
(define var expr0)

expr1
expr2


和以下的表达式等价

(letrec* ((var epr0) ...)  expr1 expr2..)

反过来 一个letrec*的形式

(letrec* ((var epr0) ...)  expr1 expr2..)
可以被一个包含内部定义的let表达式替代

(let ()
  (define var expr0)
  ...
  expr1
  expr2)

在这些变换中似乎缺少对称性.因为letrec* 表达式可以出现在一个合法表达式的任何位置
而内部定义只能出现在函数体前面.所以在使用内部定义替代letrec*的时候我们通常使用let表达式来
包裹define表达式

内部定义的另一个不同是,语法定义有可能出现在内部定义中,而letrec* 只是绑定变量

|#
(let ([x 3])
  (define-syntax set-x!
    (syntax-rules ()
      [(_ e) (set! x e)]))
  (set-x! (+ x x))
  x)


#|
使用内部定义的语法扩展的作用域也只限于内部定义所在的函数体中,就像定义一个变量一样

内部定义也许可以和顶层定义以及赋值联合起来帮助模块化程序
每个模块应该只将被其他模块需要的绑定暴露出来,将那些会污染顶层命名空间和有可能导致无意识的使用和重定义
的绑定隐藏起来.一个常见的模块构建如下


(define export-var #f)
(let ()
  (define var expr)
  ...
  内部表达式
  ...
  (set! export-var export-val))

首先定义一个顶层的值,这个值是之后需要暴露出去的
然后是一个模块的内部定义
最后使用set!将正确的值赋值给需要暴露的值

这种形式的模块化的一个优点就是let表达式中间的函数体可以被当做是被注释掉的,这使得测试比较容易,但是这也会带来一些缺点

|#

(define calc #f)
(let ()
  (define do-calc
    (lambda (ek expr)
      (cond
        [(number? expr) expr]
        [(and (list? expr) (= (length expr) 3))
         (let ([op (car expr)] [args (cdr expr)])
           (case op
             [(add) (apply-op ek + args)]
             [(sub) (apply-op ek - args)]
             [(mul) (apply-op ek * args)]
             [(div) (apply-op ek / args)]
             [else (complain ek "invalid operator" op)]))]
        [else (complain ek "invalid expression" expr)])))
  (define apply-op
    (lambda (ek op args)
      (op (do-calc ek (car args)) (do-calc ek (cadr args)))))
  (define complain
    (lambda (ek msg expr)
      (ek (list msg expr))))
  (set! calc
        (lambda (expr)
          ; grab an error continuation ek
          (call/cc
           (lambda (ek)
             (do-calc ek expr))))))

(calc '(add (mul 3 2 ) -4))
(calc '(add (mul 3 2) (div 4)))
