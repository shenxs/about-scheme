#lang racket

;;不使用call/cc重写product,使其保持特性,在遇到0的时候停止运算


(define (product ls)
  (cond
    [(empty? ls) 1]
    [(= 0 (car ls)) 0]
    [else (let ([next (product (cdr ls))])
            (* (car ls) next))]))

(product '(1 2 3 4 5 6))
(product '(1 2 3 0 x y z))
