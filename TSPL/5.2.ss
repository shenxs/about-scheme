#lang racket

#|
序列

语法：（begin  expr1 expr2 ...）
返回： 最后一个表达式的值

表达式expr1 expr2 。。。 会被依次解析。begin可以用来依次赋值，io或者其他需要产生副作用的操作
|#

(define x 3)
(begin
  (set! x (+ x 1))
  (+ x x))

#|
一个begin有可能包含0或更多的定义，所以可以出现在定义可以出现的地方。
|#

(let ()
  (begin (define x 3) (define y 4))
  (+ x y))

#|这种形式的begin会被首先转换为多值定义|#

#|
例如lambda, case-lambda, let, let*, letrec, and letrec*,的函数体，以及cond，case，do的结果部分
都可以被当做有一个隐式的begin ，依次执行表达式并且返回最后一个表达式的值。
|#

(define swap-pair!
  (lambda (x)
    (let ([temp (car x)])
      (set-car! x (cdr x))
      (set-cdr! x temp)
      x)))
(swap-pair! (cons 'a 'b))






