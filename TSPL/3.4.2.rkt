#lang racket
;;使用cps重写retry

(define retry #f)

(define (factorial x k)
  (let f ([x x] [k k])
    (if (= x 0)
        ((lambda () (set! retry k) (k 1)))
        (f (- x 1) (lambda (v) (k (* v x)))))))

(factorial 3 (lambda (x) x))
