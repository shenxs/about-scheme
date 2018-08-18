#lang racket
;; 在calc的例子中错误延续ek在apply-op, complain, 和 do-calc.中传递
;; 尽可能向内移动这些定义消除对于ek参数的传递

(define calc #f)
(let ()
  (set! calc
        (lambda (expr)
          ; grab an error continuation ek
          (call/cc
           (lambda (ek)
             (define do-calc
               (lambda (expr)
                 (define complain
                   (lambda (msg expr)
                     (ek (list msg expr))))
                 (define apply-op
                   (lambda ( op args)
                     (op (do-calc  (car args)) (do-calc (cadr args)))))
                 (cond
                   [(number? expr) expr]
                   [(and (list? expr) (= (length expr) 3))
                    (let ([op (car expr)] [args (cdr expr)])
                      (case op
                        [(add) (apply-op  + args)]
                        [(sub) (apply-op  - args)]
                        [(mul) (apply-op  * args)]
                        [(div) (apply-op  / args)]
                        [else (complain  "invalid operator" op)]))]
                   [else (complain "invalid expression" expr)])))
             (do-calc  expr))))))

(calc '(add 345  (sub 4 5)))
