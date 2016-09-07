#lang racket


;;一个函数的注释是重用的关键
;所以你在描述一个函数时要概括出共性,以保证通用性
;list of X -> list of X
;list of Number-> list of Number
;list of X -> list of Y
;list of IR->list of String
 ;Exercise 241
 ;[Number->Boolean]
 (define (f1 n)
   (odd? n))
;[Boolean String ->String]
(define (f2 b s)
  (if b s "I have eat it hahahha ^-^?  "))
;[Number,Number,Number->Number]
(define (f3 n1 n2 n3)
  (+ n1 n2 n3))
;[Number ->list of Number]
(define (f4 n)
  (cond
    [(zero? n) '()]
    [else (cons n (f4 (sub1 n)))]))
;[list of Number ->Boolean]
(define (f5 l )
  (cond
    [(empty? (rest l)) true]
    [else (and (< (first l) (first (rest l))) (f5 (rest l)))]))
;Exercise 242
;[list of Number ,[Number,Number->boolean] ->list of Number]
;[list of string ,[String,String-> Boolean]->list of String]
;[lsit of X ,[X ,X -> Boolean] -> list of X]
;[lsit of IR,[IR,IR->boolean]->llst of IR]


;Exercise 243
;[list of Number [Number-> Number]->list of Number]
;[list of sting [string ->string]->list of string]
;[list of X [X->X] ->list of X]
