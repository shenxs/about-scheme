#lang racket
(define (quick-sort alon f)
  (local (
          (define (judge f l n)
            (filter (λ (x) (if (f x n) #t #f))  l)))
    ;;;----IN----
    (cond
      [(empty? alon) '()]
      [(= 1 (length alon)) alon]
      [(< (length alon) 10) (sort alon <)]
      [else (append
              (quick-sort (judge f (rest alon) (first alon)) f )
              (list (first alon))
              (quick-sort (judge (λ (a b) (not (f a b)) ) (rest alon) (first alon)) f))])))

(define (random-list n M)
  (cond
    [(= n 0) '()]
    [else (cons (random M) (random-list (sub1 n) M))]))

(quick-sort (random-list 100 10000) >)
