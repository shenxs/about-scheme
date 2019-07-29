(define (pascal x y)
  (cond
   [(or (= y 1)
        (= y x)) 1]
   [else (+ (pascal (- x 1) (- y 1))
            (pascal (- x 1) y))]))

(pascal 5 3)
