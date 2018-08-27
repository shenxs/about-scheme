#lang racket

;;scheme的eval允许程序员构造和写出解析其他程序的程序,在运行时进行编程的能力不能被用的太多,但是如果需要的话还是很有用的


;;函数:(eval obj env)
;;返回:在env中解析obj

;;如果obj不符合语法规范就会报语法错误.通过environment,scheme-report-environment,以及null-environment返回的值是不可被修改的.
;;所以如果obj中的语句有修改env中的值的行为的话也会报错.

(define cons 'not-cons)


(eval '(let ([x 1]) (+ x 1)) (make-base-namespace))




