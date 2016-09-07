#lang racket
;(define (f x) x)

;(cons f '())
;(f f)
;(cons f (cons 10 (cons (f 10) '())))



;(define (f x) (x 10))
;(define (f x) (x f))
(define (f x y) (x 'a y 'b))



;Exercise 232
(define (function=at-1.2-3-and-5.775? f1 f2)
  (and
    (= (f1 1.2) (f2 1.2))
    (= (f1 3) (f2 3))
    (= (f1 -5.775) (f2 -5.775))))

