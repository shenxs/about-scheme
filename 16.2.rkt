#lang racket
(define (squared>? x c)
  (> (* x x) c))
(squared>? 3 10)
(squared>? 4 10)
(squared>? 5 10)


;;not empty list of number ->the biggest smallest or the most ... one
(define (most operator l)
  (cond
    [(empty? l) (error "列表为空无法判断") ]
    [(empty? (rest l)) (first l)]
    [else (cond
            [(operator (first l) (most operator (rest l))) (first l)]
            [else (most operator (rest l))])]))

(define (most.v2 R l)
  (cond
    [(empty? (rest l)) (first l)]
    [else (R (first l) (most.v2 R (rest l)))]))
(most.v2 max (list 1 21 2 3 23 2))
(most < (list 1 2 3 4 5 6 7 8 9 -1 5 19 -100))
(most.v2 max (list 1 12 12 34 43 45 456 56 56 56 565 6 5 65 6 5 6 56 5 6 2 23 43 45 5 6 6 7 7 7 7 6 6 6 4  4 4  4 4 32 2  2  2 2  2 22 222  ) )
