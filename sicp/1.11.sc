(define (f-r n)
  (cond
   [(< n 3) n]
   [else (+ (f-r (- n 1))
            (* 2 (f-r (- n 2)))
            (* 3 (f-r (- n 3))))]))

(define (f-iter n)
  (define (f a b c count)
    (cond
     [(<  count 3) count]
     [(= count 3) a]
     [else (f (+ a
                 (* 2 b)
                 (* 3 c))
              a b (- count 1))]))
  (f 4 2 1 n))

(f-iter 10)
(f-r 10)
