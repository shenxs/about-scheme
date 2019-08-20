#lang racket

(require "tensor.rkt")
(provide square-lose
         sqrt-lose)

(define (auto-alpha target)
  (define (auto-alpha-inner x y)
    (cond
      [(< x 1)  y]
      [else (auto-alpha-inner (* x 0.1) (* y 0.1))]))
  ;; (auto-alpha-inner gap 1)
  (auto-alpha-inner target 1))


;;trensor expected-value alpha mini-lose continue iterate_n
(define (square-lose t y mini-lose k i)
  (define lose (sqrt (sqr (- (tensor-get t) y))))
  (cond
    [(> lose mini-lose) (tensor-update! t (* (auto-alpha y ) (-  (tensor-get t) y)) )]
    [else (k i)])
  lose)

(define (sqrt-lose t y alpha mini-lose k i)
  (define lose  (* (if (>  (tensor-get t) y)
                       1
                       -1)
                   (sqrt (abs (-  (tensor-get t) y)))))
  (cond
    [(> (abs lose) mini-lose) (tensor-update! t (* alpha 1/2 lose))]
    [else (k i)])
  lose)

