#lang racket

(require "tensor.rkt")
(require "operator.rkt")
(require "lose.rkt")

(define x (make-tensor 3))
(define y (make-tensor 4))
(define z (make-tensor 5))

(define q (ADD x y))
(define f (MUL q z))

(define (look)
  (writeln (format "X = ~a"  (tensor-get x)))
  (writeln (format "Y = ~a"  (tensor-get y)))
  (writeln (format "Z = ~a"  (tensor-get z)))
  (writeln (format "F = ~a"  (tensor-get f)))
  )

(call/cc (lambda (k)
           (for ([i (range 10)])
             (writeln (format "~a iteration:" i))
             (look)
             (writeln (format "Loss = ~a"  (square-lose f 100 0.001 1 k i)))
             (newline)
             )))



