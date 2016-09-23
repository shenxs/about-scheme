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


