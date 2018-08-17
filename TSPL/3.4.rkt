#lang racket

;; 正如之前所讨论的，每一个表达式都有一个延续。
;; 确切地说，每一个过程调用都和延续联系在一起
;; 当一个过程通过非尾递归调用另一个过程，被调用的过程会收到一个隐式的延续
;; 这个延续是完成调用过程剩下的主体部份，以及返回调用过程的延续
;; 如果这个调用是尾部调用，被调用的过程会收到调用过程的延续
;; Continuation Passing Style 是一种编程的风格 简称cps

;; 我们可以通过将特定的"做什么"的写成一个明确的过程,作为一个参数传递给调用过程
;; 使得这个调用的延续显示化
;;这里f就是一个一个例子
;;对于f的调用的延续 被cons和'b一起组成了g的延续
;;g 的延续和h的延续是一样的,这个延续cons符号d和返回值
(letrec ([f (lambda (x) (cons 'a x))]
         [g (lambda (x) (cons 'b (f x)))]
         [h (lambda (x) (g (cons 'c x)))])
  (cons 'd (h '())))

;;我们可以用明确的过程来代替这些隐式延续.这种风格叫做continuation-passing style或者CPS

(letrec ([f (lambda (x k) (k (cons 'a x)))]
         [g (lambda (x k)
              (f x (lambda (v) (k (cons 'b v)))))]
         [h (lambda (x k) (g (cons 'c x) k))])
  (h '() (lambda (v) (cons 'd v))))

;; 和上一例子里面的隐式传递类似,明确的延续被传递给了h和g

(lambda (v) (cons 'd v))
;; 将'd和收到的v组合.类似的,传递给f的continuation

;(lambda (v) (k (cons 'b v)))
;;将b和收到的参数组合,将其交给g的continuation




;;使用cps风格编写的表达式通常来说会更加复杂,但是这种风格有一些有用的应用
;;cps可以向延续传递不止一个结果,因为实现延续的这个过程可以接受任意数量的参数


(define (car&cdr p k)
  (k (car p) (cdr p)))

(car&cdr '(a b c)
         (lambda (x y) (list y x)))

(car&cdr '(a b c) cons)
(car&cdr '(a b c) memv)
