;; 控制语句
#lang racket


#|
这章会介绍scheme的控制结构的语法以及过程。第一节会介绍最基本的控制结构，过程应用，剩下的章节
会介绍squencing，条件解析，递归，mapping，延续，延迟求值，多值，解析在运行时刻构建的程序

|#

#|
过程的应用

语法: (expr0 expr1 ...)
返回：将expr0 应用于其后参数的返回值

一个过程的应用是scheme程序中最基本的结构。任何不以语法关键词开头的表达式中，第一个位置应该是一个过程。表达式expr0，expr1 。。。 会被解析；每个表达式解析后都会得到一个值。然后expr0的值就会被应用在expr1 ... 上。如果expr0解析后不是一个过程那么就会抛出异常。

过程和参数的解析顺序不是固定的，从左向右，从右向左或者任意的顺序。解析的顺序是确保依次的，无关顺序，解析时一定是先完全解析一个，然后才是下一个

|#

(+ 3 4)

((if (odd? 3) + -) 6 2)

((lambda (x) x) 5)

(let ([f (lambda (x) (+ x x))])
  (f 8))


#|
（apply procedure obj ... list）
返回将 procedure应用与obj... 和元素list的结果


apply 会调用 procedure ，将第一个obj作为procedure 的第一个参数，第二个obj作为第二个参数，以此类推。将list中剩下的元素当做是剩下的参数。因此 procedure所有的参数就是objs加上list中的元素。
apply对于参数是以list呈现的时候会非常有用，这样程序员就不用解构一个list来得到参数了。
|#

(apply + '(4 5))

(apply min '(6 8 3 2 5))

(apply min 1 2 3 4 '( 564 21 1 0 -1) )

(apply vector 'ab 'b '(c d e f))

(apply append '(1 2 3) '((a b ) (c d e) (f)))


