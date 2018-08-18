#lang racket

;;用语法扩展重写complain函数

(define-syntax complain
  (syntax-rules ()
    [(_ ek msg expr) (ek (list msg expr))]))

