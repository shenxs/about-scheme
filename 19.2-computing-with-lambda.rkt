#lang racket

(define (f x) (* 10 x))
;is short for

#| (define f |#
  #| (lambda (x) |#
    #| (* 10 x))) |#

;;exercise 268
;number->boolean
(define (compare x)
  (= (f-plain x) (f-lambda x)))

