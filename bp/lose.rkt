#lang racket

(require "tensor.rkt")
(provide square-lose)

;;trensor expected-value alpha mini-lose continue iterate_n
(define (square-lose t y alpha mini-lose k i)
  (define lose (sqr (- (tensor-get t) y)))
  (cond
    [(> (sqrt lose) mini-lose) (tensor-update! t  (* alpha 2 (-  (tensor-get t) y)) )]
    [else (k i)])
  lose)

