#lang racket

(define-struct pair [left right])
(define our_cons? pair?)
(define (our_cons a_value a_list)
  (cond
    [(empty? a_list) (make-pair a_value a_list)]
    [(our_cons? a_list) (make-pair a_value a_list)]
    [else (error "第二个参数应该是一个list")]))

(define (our_first a_list)
  (cond
    [(empty? a_list) (error 'a_list "不能为空")]
    [else (pair-left a_list)]))

(define (our_rest a_list)
  (cond
    [(empty? a_list) (error 'a_list "不能为空")]
    [else (pair-right a_list)]))


(define (my_cons x y)
  (λ (choose)
     (cond
       [(= choose 1) x]
       [else y])))

(define (my_first a_list)
  (a_list 1))
(define (my_rest a_list)
  (a_list 2))


