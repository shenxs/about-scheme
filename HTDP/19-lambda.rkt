#lang racket
;第十九章 lambda,匿名函数,构建一些小函数.
;可以用来不过来化简程序
;一门语言,希望可以在表达上给予程序员最大的表达能力,最简洁的表达方式.这在语言的设计上是一种艺术

(lambda (x) (* 10 x))
(lambda (name) (string-append "Hello ," name ",How are you?"))
((lambda (x) (* 10 x)) 2)
((lambda (name rst) (string-append name "," rst) ) "沈" "小双")
(map (lambda (x) (* x 10)) (list 1 2 3 4))
(  (lambda () 10)  )
( (lambda x 10) 2 )
( (lambda (x y) (x y y)) list 8)
((lambda (x y)
   (+ x (*  x y)))
 1 2)
((lambda (x y)
   (+ x
      (local ((define z (* y y)))
        (+ (* 3 z)
           (/ 1 x)))))
 1 2)
;Exercise 267
;1
(lambda x (< x 10))
;2
( (lambda (x y) (number->string (* x y))) 1 2)
;3
( (lambda (x) (if (odd? x) 1 0)) 5 )


