(define (fast-exp-iter x n)
  (define (fun a b n)
    (cond
     [(= 0 n) a]
     [(even? n) (fun a (* b b) (/ n 2))]
     [else (fun (* a b) b (- n 1))]))
  (fun 1 x n))
;;简直太巧妙了
(fast-exp-iter 2 10)
