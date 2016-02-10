#lang racket

;Exercise 432

;f a function [Number-->Number]
;a b, left and right side of the area
(define (intrgrate-kepler f a b)
  (local (
          (define mid (/ (+ a b) 2)))))
