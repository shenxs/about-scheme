#lang racket
;;使用cps重写倒数

(define (reciprocal x success failure)
  (if (= x 0)
      (failure "gave a zero")
      (success ( / 1 x))))

(reciprocal 12 values (lambda (x) x))
(reciprocal 0 values values)
