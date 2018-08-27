#lang racket
#|
虽然所有的scheme的原语以及大部分的用户定义的函数都只返回一个值。
一些编程问题最好可以通过返回多个值，0个值，或者变化的数值比较好。
例如一个将list分割为两部分的过程最好可以返回两个值。虽然将多个
返回值打包到一个数据结构内然后在使用的时候再解构这些数据可以解决
上述问题，通常使用内建的多值机制来达到同样的效果更加简洁。这个机制
涉及到两个函数：values以及call-with-values.前者返回多个值，后者
将产生多个值和消耗多个值的函数链接。
|#


#|
函数：(values obj ...)
返回：obj ...
函数values接收任意数量的参数，并且简单的将他们返回给自己的延续。
|#


(values)
(values 1)
(values 1 2 3)

(define (head&tail ls)
  (values (first ls) (rest ls)))

(head&tail '(a b c))

#|
函数：(call-with-values producer consumer)

producer和consumer一定要是函数，call-with-values将consumer应用到调用producer产生的值上
|#

(call-with-values
 (lambda () (values 'bond 'james))
 (lambda (x y) (cons x y)))

(call-with-values values list)

#|
在第二个例子里面，values扮演者producer的角色，他没有接收任何参数，
因此不返回值。list没有参数所以返回一个空列表。

|#


;;dxdy可以计算两个坐标的差值

(define (dxdy p1 p2)
  (values (- (car p2) (car p1))
          (- (cdr p2) (cdr p1))))

(dxdy '(0 . 0) '(0 . 5))


;;dxdy可以用来计算两个点表示的线段的长度和斜率。
(define (segment-length p1 p2)
  (call-with-values
   (lambda () (dxdy p1 p2))
   (lambda (dx dy) (sqrt (+ (* dx dx) (* dy dy))))))

(define (segment-slop p1 p2)
  (call-with-values
   (lambda () (dxdy p1 p2))
   (lambda (dx dy) (/ dy dx))))

;;当然我们可以将这两个组合

(define (describe-segment p1 p2)
  (call-with-values
   (lambda () (dxdy p1 p2))
   (lambda (dx dy)
     (values
      (sqrt (+ (* dx dx) (* dy dy)))
      (/ dy dx)))))


;;下面的例子中，列表被无损地转换成两个交替的列表

(define (split ls)
  (if (or (null? ls) (null? (cdr ls)))
      (values ls '())
      (call-with-values
       (λ () (split (cddr ls)))
       (λ (odds evens)
         (values (cons (car ls) odds)
                 (cons (car (cdr ls)) evens))))))

#|
在每次递归的时候，函数split返回两个值：一个奇数序列的list和一个偶数序列的list
values的调用的延续不一定是一个call-with-values的函数调用。
call-with-values也不一定一定要用values返回的值作为参数。
在特定的情况下，（values e）和e是等价的。例如
|#

(+ (values 2) 4)
(if (values #t) 1 2)

(call-with-values (lambda () 4) (lambda (x) x))


;;同样的values的延续可能无论values传递了几个值都忽略了values的值。

(begin (values 1 2 3 4 5 ) 'x)

;;因为一个延续可能接收0或者多个参数，通过call/cc获得的延续也有可能有一个或者
;;多个参数


(call-with-values
 (lambda () (call/cc (lambda (k) (k 2 3))))
 (lambda (x y) (list x y)))

;;当一个延续需要一个值但是收到多个值的时候,解释器的行为是不确定的.例如一下的语句的解释是不确定的.有些实现会报异常,但是有些实现会忽略多余的值或者给一个默认的值

;; (if (values 1 2) 1 2)
;; (+ (values) 5)


;;当我们希望在只需要一个参数而得到了多个的时候强制性忽略多余的参数,只保留第一个参数的时候我们可以用call-with-values实现.我们姑且称之为first,显然这是一种新的语法.

(define-syntax first
  (syntax-rules ()
    [(_ expr) (call-with-values (lambda () expr)
                                (lambda (x . y) x))]))



(if (first (values #t #f) ) 'true 'false)

;;因为当函数的参数的个数和其获得的个数不符的时候就会产生异常,以下是一些例子

;; (call-with-values
;;  (lambda () (values 1 2 3 4 5))
;;  (lambda (x y) (+ x y)))

;; (call-with-values
;;  (lambda () (call/cc (lambda (k) (k 0))))
;;  (lambda (x y) (+ x y)))

;;因为函数的定义通常需要使用lambda表达式,通常可以通过语法扩展可以省略一步以
;;增加程序的可读性

(define-syntax with-values
  (syntax-rules ()
    [(_ expr consumer)
     (call-with-values (lambda () expr) consumer)]))

(with-values (values 1 2 3 4 5) list)

(split '(1 2 3 4))


(with-values (split '(1 2 3 4 5 6))
  (lambda (o e) o ))


;;consumer也是一个lambda表达式 另一种let和let*的多值变种通常来说更加方便.


(let-values ([(odds even) (split '(1 2 3 4 5 6))])
  odds)

#| racket不支持这种let-values的语法|#
(let-values ([ls (values 'a 'b 'c)])
  ls)

#|
很多标准语法和函数会传递多值.大多数都是"自动"的,也就是说实现上不需要做什么就可以
做到这一点.通常将let转换为lambda表达式调用的时候let的主体产生的多值会被自动传播.
其他的操作符必须要小心地编码来实现多值的传递.以call-with-port为例子,他会调用他的函数参数,再返回函数值之前关闭端口参数,所以他必须将多值临时保存起来.这很容易通过let-value,apply,以及value做到.
|#


;; (define (call-with-port port proc)
;;   (let-values ([val* (proc port)])
;;     (close-input-port port)
;;     (apply values val*)))


;;如果只有一个值返回了,这么做似乎多此一举了,可以使用call-with-values 和case-lambda使得代码更加高效


(define (call-with-port proc port)
  (call-with-values (lambda () (proc peot))
                    (case-lambda
                      [(val) (close-input-port port) val]
                      [val* (close-input-port port) (apply values val*)])))


;;以下简单地实现一下values以及call-with-values.例子里面没有错误检查

(library (mrvs)
  (export call-with-values values call/cc
          (rename (call/cc call-with-composable-continuation)))
  (import
   (rename
    (except (rnrs) values call-with-values)
    (call/cc rnrs:call/cc)))

  (define magic (cons 'multiple values))

  (define magic? (lambda (p) (and (pair? x) (eq? (car x) magic ))))


  (define call/cc
    (lambda (p)
      (rnrs:call/cc
       (lambda (k)
         (p (lambda args
              (k (apply values args))))))))


  (define values
    (lambda args
      (if (and (not (null? args))
               (not (null? (cdr args))))
          (car args)
          (cons magic args))))

  (define (call-with-values proc consumer)
    (let ([x (proc)])
      (if (magic? x)
          (apply consumer (cdr x))
          (consumer x))))
  )



;;多值可以通过更有效的方式实现,这里只是为了展示作用而不是说正式实现的方式.
