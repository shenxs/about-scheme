#lang racket

;; 正如之前所讨论的，每一个表达式都有一个延续。
;; 确切地说，每一个过程调用都和延续联系在一起
;; 当一个过程通过非尾递归调用另一个过程，被调用的过程会收到一个隐式的延续
;; 这个延续是完成调用过程剩下的主体部份，以及返回调用过程的延续
;; 如果这个调用是尾部调用，被调用的过程会收到调用过程的延续
;; Continuation Passing Style 是一种编程的风格 简称cps


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
