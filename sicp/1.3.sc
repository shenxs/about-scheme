(define (sum-square-of-max2 a b c)
  (cond
   [(and (> a b)
         (> a c)) (+ (* a a)
                     (* b b))]
   [else (sum-square-of-max2 b c a)]))

