(define (cube-root x)
  (define last '())
  (define (good-enough? guess)
    (cond
     [(null? last) (set! last guess) #f]
     [(< (abs (- guess last)) 0.001) #t]
     [else (set! last guess) #f]
     ))
  (define (improve y x)
    (/ (+ (/ x (* y y)) (* 2 y)) 3))
  (define (cube-root-iter guess x)
    (if (good-enough? guess)
        guess
        (cube-root-iter (improve guess x) x)))
  (cube-root-iter 1.0 x))

(cube-root 27)
