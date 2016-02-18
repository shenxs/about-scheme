#lang racket

; [List-of Number] -> [List-of Number]
; convert a list of relative distances to a list of absolute distances
; the first item on the list represents the distance to the origin
;将一系列的相对距离转换为绝对距离
;; (check-expect (relative->absolute '(50 40 70 30 30))  ;检验函数需要额外的头文件
              ;; '(50 90 160 190 220))

(define (relative->absolute l)
  (cond
    [(empty? l) '()]
    [else (local ((define rest-of-l (relative->absolute (rest l)))
                  (define adjusted  (add-to-each (first l) rest-of-l)))
            (cons (first l) adjusted))]))

; Number [List-of Number] -> [List-of Number]
; add n to each number on l

;; (check-expect (cons 50 (add-to-each 50 '(40 110 140 170)))
              ;; '(50 90 160 190 220))

(define (add-to-each n l)
  (cond
    [(empty? l) '()]
    [else (cons (+ (first l) n) (add-to-each n (rest l)))]))

;Exercise 464

(define (add-to-each-v2 n l)
  (map (λ (item) (+ n item)) l))
;; (time (relative->absolute (build-list 100 add1)) #t)

;Exercise 465
;relative->absolute O(n^2)
(define (relative->absolute/a l accu-dist)
  (cond
    [(empty? l) '()]
    [else (local ((define tally (+ (first l) accu-dist)))
             (cons tally (relative->absolute/a (rest l) tally)))]))

;; (time (relative->absolute/a  (build-list 20000 add1) 0) #t )

(define (remove-last l)
  (cond
    [(empty? l) '()]
    [(empty? (rest l)) '()]
    [else (cons (first l) (remove-last (rest l)))]))

(define (insert@last x l)
  (cond
    [(empty? l) (cons x '())]
    [else (cons (first l) (insert@last x (rest l)))]))
;list to a reversed list
(define (my-reverse l already)
  (cond
    [(empty? l) already]
    [else (my-reverse (rest l) (cons (first l) already))]))

(time (my-reverse (range 100000) '()) #t )
(time (reverse    (range 100000)) #t )

(define (relative->absolute.v2 l)
 (reverse
   (foldr (lambda (f l) (cons (+ f (first l)) l))
          (list (first l))
          (reverse (rest l)))))
(time (relative->absolute.v2 (build-list 20000 add1)) #t)

