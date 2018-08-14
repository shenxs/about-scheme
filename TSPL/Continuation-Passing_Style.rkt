#lang racket

;;Continuation Passing Style 是一种编程的风格 简称cps



;;这里f就是一个一个例子
;;对于f的调用的延续 被cons和'b一起组成了g的延续,
(letrec ([f (lambda (x) (cons 'a x))]
         [g (lambda (x) (cons 'b (f x)))]
         [h (lambda (x) (g (cons 'c x)))])
  (cons 'd (h '())))


(letrec ([f (lambda (x k) (k (cons 'a x)))]
         [g (lambda (x k)
              (f x (lambda (v) (k (cons 'b v)))))]
         [h (lambda (x k) (g (cons 'c x) k))])
  (h '() (lambda (v) (cons 'd v))))
