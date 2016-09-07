#lang racket

;[list of Number] [Number Number ->Boolean]->[list of Number]
;sort the Number accroading to the cmp of tow Number
(define (sort-cmp alon0 cmp)
  (local(
         ;[list of number]->[list of Number]
         (define (isort alist )
           (cond
             [(empty? alist ) '()]
             [else (insert (first alist) (isort (rest alist)))]))
         ;将n插入到已经排好序的alon中去
         (define (insert n alon)
           (cond
             [(empty? alon ) (cons n '())]
             [(cmp n (first alon)) (cons n alon)]
             [else (cons (first alon) (insert n (rest alon)) )]))
         )
    (isort alon0)))


(sort-cmp (list 1 2 3 5 2 3 1) <)
