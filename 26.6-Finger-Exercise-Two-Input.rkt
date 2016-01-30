#lang racket
;[a sorted list of number] [as before] ====>[a sorted list of number]

;Exercise 378
(define (merge l1 l2)
  (cond
    [(empty? l1) l2]
    [(empty? l2) l1]
    [(< (first l1) (first l2)) (cons (first l1) (merge (rest l1) l2) )]
    [else (cons (first l2) (merge l1 (rest l2)))]))

;; (merge '(1 2 3 4) '(1 2 3 4 9 9))

;Exercise 379
;[a list] Number ===> remove the NO.n list

(define (drop l n)
  (cond
    [(empty? l) (error 'l "too short")]
    [(> n 0) (cons (first l) (drop (rest l) (sub1 n)))]
    [(= n 0) (rest l)]
    [else (error 'n "小于0")]))

;; (drop '(a b c d e) 2)


(define (take l n)
  (cond
    [(empty? l) (error 'l "too short")]
    [(> n 0) (cons (first l) (take (rest l) (sub1 n)))]
    [(= n 0) '()]
    [else (error 'n "小于0")]))

(take '(a b c d e f) 2)

