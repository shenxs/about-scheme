(import (scheme))
(define calc #f)
(let ()
  (define do-calc
    (lambda (expr)
      (cond
       [(number? expr) expr]
       [(and (list? expr) (= (length expr) 2))
        (let ([op (car expr)] [args  (cdr expr)])
          (case op
            [(minus) (apply-op - (cons 0 args))]
            [else (complain "invalid op" op)]
            ))]
       [(and (list? expr) (= (length expr) 3))
        (let ([op (car expr)] [args (cdr expr)])
          (case op
            [(add) (apply-op + args)]
            [(sub) (apply-op - args)]
            [(mul) (apply-op * args)]
            [(div) (apply-op / args)]
            [else (complain "invalid operator" op)]))]
       [else (complain "invalid expression" expr)])))
  (define apply-op
    (lambda (op args)
      (op (do-calc (car args)) (do-calc (cadr args)))))
  (define complain
    (lambda (msg expr)
      (assertion-violation 'calc msg expr)))
  (set! calc
    (lambda (expr)
      (do-calc expr))))

(calc '(add 2 3))
(calc '(minus (add 5 2)))

