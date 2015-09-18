#lang racket
 (define (foo a l)
           (cond
             [(= a (first l)) (cons a '())]
             [else (cons (first l) (foo a  (rest l)))]))
(foo '() (list 1 2 3 4 5 6))
