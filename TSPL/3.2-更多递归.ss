(define (fibonacci-i n)
  (letrec ([f (lambda (i a b)
                (cond
                 [(= i 1) b]
                 [else (f (sub1 i) b (+ a b))]))])
    (f n 0 1)))

(fibonacci-i 100)

