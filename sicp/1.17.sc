(define (double x)
  (+ x x))

(define (halve x)
  (/ x 2))

(define (fast-multi a b)
  (define (iter x b)
    (cond
     [(= 0 b) 0]
     [(= 1 b) x]
     [(even? b) (iter (double x) (halve b))]
     [else (iter (+ x a) (- b 1))]))
  (iter a b))

(equal? 30 (fast-multi 5 6))
(equal? 0 (fast-multi 3 0))
(equal? 10 (fast-multi 10 1))
