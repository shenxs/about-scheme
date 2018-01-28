#lang racket

(define (smaller-items alon threshold)
  (cond
    [(empty? alon) '()]
    [else (if (<= (first alon) threshold)
              (cons (first alon) (smaller-items (rest alon) threshold))
              (smaller-items (rest alon) threshold))]))


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
              ;;以下部分为练习410所用到
              ;;会造成(quick-sort)的第二个参数无效,造成结果无序
              ;; (quick-sort (smaller-items (rest alon) (first alon)) f)
              (list (first alon))
              (quick-sort (judge (λ (a b) (not (f a b)) ) (rest alon) (first alon)) f))])))

(define (random-list n M)
  (cond
    [(= n 0) '()]
    [else (cons (random M) (random-list (sub1 n) M))]))

(quick-sort (random-list 100 10000) <=)
