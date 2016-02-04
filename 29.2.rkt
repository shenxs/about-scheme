#lang racket


(define (quick-sort alon)
  (local (
          (define (judge f l n)
            (filter (λ (x) (if (f x n) #t #f))
                    l)))
    ;;;----IN----
    (cond
      [(empty? alon) '()]
      [else (append
              (quick-sort (judge < (rest alon) (first alon)))
              (list (first alon))
              (quick-sort (judge >= (rest alon) (first alon))))])))
(define (random-list n M)
  (cond
    [(= n 0) '()]
    [else (cons (random M) (random-list (sub1 n) M))]))

(define a (quick-sort (random-list 10000 10000)))
