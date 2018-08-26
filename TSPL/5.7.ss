#lang racket
;;语法形式delay和过程force通常一起使用来实现延迟计算。
;;传递给lazy的表达式在其值被需要前不会被解析，一旦被解析，不会再被二次解析。


#|
语法：(delay expr)
返回：一个承诺
过程：(force promise)
返回：执行promise的结果

当一个delay产生的promise被force之后，expr就被解析出来，又“记起”剩下的结果。在此之后每当一个promise被force，他会返回记住的值而不是重新解析一遍。

delay和force通常只在没有副作用的情况下使用，例如，赋值，因此解析的顺序是不一定的。

使用delay和force的好处是一些计算只有当正真需要的时候才会被执行，这可以节省大量的计算力。延迟计算可以用来实现概念上的无限的list，或者stream。以下展示了如何使用force和delay构建抽象的stream。
一个stream是一个承诺，当被froce之后，会返回一个序对，这个序对的cdr是stream

|#

(define stream-car
  (lambda (s)
    (car (force s))))

(define stream-cdr
  (lambda (s)
    (cdr (force s))))

(define counters
  (let net ([n 1])
    (delay (cons n (next (+ n 1))))))

(define stream-add
  (lambda (s1 s2)
    (delay (cons (+ (stream-car s1)
                    (stream-car s2))
                 (stream-add (stream-cdr s1)
                             (stream-cdr s2))))))


;;delay 可以如下定义
(define-syntax delay
  (syntax-rules ()
    [(_ expr) (make-promise (lambda () expr))]))

;;make-promise可以这样定义

(define make-promise
  (lambda (p)
    (let ([val #f] [set? #f])
      (lambda ()
        (unless set?
          (let ([x (p)])
            (unless set?
              (set! val x)
              (set! set? #t))
            ))
        val))))

;;有了delay的定义之后，force只是简单的调用promise就可以了
(define (force promise)
  (promise))


;;在make-promise中的第二次测试set？是有必要的。;;当在应用p的时候，promise是递归调用的。
;;因为一个promise必须返回相同的所以第一次应用p的结果被返回了。
;;当delay和force处理多值返回的时候是不确定的，上面的实现并没有这没做，但是下面的实现在call-with-values的帮助下实现了。


(define (make-promise p)
  (let ([vals #f] [set? #f])
    (lambda ()
      (unless set?
        (call-with-values p
                          (lambda x
                            (unless set?
                              (set! vals x)
                              (set! set? #t))))
        )
      (apply values vals))))

(define p (delay (values 1 2 3)))

(force p)

(call-with-values (lambda () (force p)) +)

#|
没有一个实现做得是相当正确的，因为force必须在给定的参数不是promise的时候返回异常。因为区分make-promise返回的过程和普通的过程基于现在的实现是不可能的，所以force还不能区分这两者。以下的make-promise实现和force的实现将promise作为一个promise类型的记录，这样force就可以检查其类型。
|#


(define-record-type promise
  (fields (immutable p) (mutable vals) (mutable set?))
  (protocol (λ(new) (λ (p) (new p #f #f)))))

(define force
  (λ (promise)
    (unless (promise? promise)
      (assertion-violation 'promise "invalid argument" promise)
      )
    (unless (promise-set? promise)
      (call-with-values (promise-p promise)
        (λ x
          (unless (promise-set? promise)
            (promise-val-set! promise x)
            (promise-set?-set! promise #t)
            ))))
    (apply values (promise-vals promise))))







