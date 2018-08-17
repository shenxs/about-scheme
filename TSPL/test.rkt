#lang racket

(let ([x (call/cc (lambda (k) k))])
  (x (lambda (ignore) (display ignore))))

(let f ()
  (display "hello")
  (f))
