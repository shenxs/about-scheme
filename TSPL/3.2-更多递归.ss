(define (fibonacci-i n)
  (letrec ([f (lambda (i a b)
                (cond
                 [(= i 1) b]
                 [else (f (sub1 i) b (+ a b))]))])
    (f n 0 1)))

(fibonacci-i 100)

(define make-counter
  (lambda ()
    (let ([x 0])
      (lambda ()
        (let ([t x])
          (begin
            (set! x (+ x 1))
            t))))))


(define c1 (make-counter))

(define (fibnacci n)
  (letrec ([f (lambda (a b n)
                (begin (c1)
                       (cond
                        [(= n 0) b]
                        [else (f b (+ a b) (- n 1))])))])
    (f 0 1 n)))

(fibnacci 20)

(c1)

;;3.2.6
;;并不是尾递归,有可能消耗大量的空间
(define-syntax or
  (syntax-rules ()
    [(_) #f]
    [(_ e1 e2 ...)
     (let ([t e1])
       (if t t (or e2 ...)))]))


(or 1 )

(letrec ([even?
          (lambda (x)
            (or (= x 0)
                (odd? (- x 1))))]
         [odd?
          (lambda (x)
            (and (not (= x 0))
                 (even? (- x 1))))])
  (list (even? 100000000000) (odd? 1000)))

