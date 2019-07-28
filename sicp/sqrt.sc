(define (sqrt x)
  (define (average a b)
    (/ (+ a b) 2))
  (define (improve guess x)
    (average guess (/ x guess)))

  (define (good-enough? guess x)
    (< (abs (- (* guess guess) x))
       0.001))

  (define (sqrt-iter guess x)
    (if (good-enough? guess x)
        guess
        (sqrt-iter (improve guess x) x)))
  (sqrt-iter 1.0 x))

(sqrt 9)

