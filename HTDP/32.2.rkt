#lang racket

;Exercise 432

;f a function [Number-->Number]
;a b, left and right side of the area
(define (intrgrate-kepler f a b)
  (local (
          (define mid (/ (+ a b) 2)))
    (+ (/ (* (- mid a) (+ (f a) (f mid))) 2)
       (/ (* (- b mid) (+ (f mid) (f b)))) 2)))

(define (f x)
  (* 3 x x))

;; (intrgrate-kepler f 0 10)

(define (integrate-rectangles f a b)
  (local(
         (define R 1000)
         (define W (/ (- b a) R))
         (define S (/ W 2))
         ;;计算长方形的面积
         (define (Area-rec w h) (* w h))
         (define (cal-height n)
           (f (+ a  S (* n W))))
         (define (Area n)
           (cond
             [(< n R) (+ (Area-rec W (cal-height n)) (Area (+ n 1)))]
             [else 0])))
    (Area 0)))

;; (integrate-rectangles f 0 10)

(define (integrate-dc f a b)
  (local(
         (define A 0.001)
         (define W (- b a))
         (define mid (/ (+ a b) 2)))
    (cond
      [(> W A) (+ (integrate-dc f a mid) (integrate-dc f mid b))]
      [else (* W (f mid))])))
(integrate-dc f 0 10)
