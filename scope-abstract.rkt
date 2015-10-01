#lang racket
;;这一节似乎就是和变量的作用范围与抽象有关
;似乎这一章没有太多的要点
(define (p1 x y)
  (+ (* x y)
     (+ (* 2 x)
        (+ (* 2 y) 22))))

(define (p2 x)
  (+ (* 55 x) (+ x 11)))

(define (p3 x)
  (+ (p1 x 0)
     (+ (p1 x 1) ) (p2 x)))


;[list of x]->[list of x]
;
(define (insert_sort alon)
  (local(
         )
    (sort )))
