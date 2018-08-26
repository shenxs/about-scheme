#lang racket
#|
虽然所有的scheme的原语以及大部分的用户定义的函数都只返回一个值。
一些编程问题最好可以通过返回多个值，0个值，或者变化的数值比较好。
例如一个将list分割为两部分的过程最好可以返回两个值。虽然将多个
返回值打包到一个数据结构内然后在使用的时候再解构这些数据可以解决
上述问题，通常使用内建的多值机制来达到同样的效果更加简洁。这个机制
涉及到两个函数：values以及call-with-values.前者返回多个值，后者
将产生多个值和消耗多个值的函数链接。
|#


#|
函数：(values obj ...)
返回：obj ...
函数values接收任意数量的参数，并且简单的将他们返回给自己的延续。
|#


(values)
(values 1)
(values 1 2 3)

(define (head&tail ls)
  (values (first ls) (rest ls)))

(head&tail '(a b c))








