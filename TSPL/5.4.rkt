#lang racket

;;语法：(let name ((var expr) ...) body1 body2 ...)

#|
这种形式的let叫做命名的let(named let),是一种常用的的递归和迭代构造
这和更加常见的；let很类似，将expr ... 绑定到var ...上。这些变量的作用域是body1 body2 。。。
就像lambda那样。
此外变量名 name 在函数体中也可以用，所以可以递归或者迭代地调用，参数会变成var。。。的新绑定值
|#

;; 命名的let可以用letrec重写

;; ((letrec (name (lambda (var ...) body1 body2 ...))
;;    name)
;;  expr ...)



(define divisors
  (lambda (n)
    (let f ([i 2])
      (cond
        [(>= i n) '()]
        [(integer? (/ n i)) (cons i (f (+ i 1)))]
        [else (f (+ i 1))]))))

(divisors 1000)

;;以下是尾递归优化的版本。

(define divisors
  (lambda (n)
    (let f ([i 2] [ls '()])
      (cond
        [(>= i n) ls]
        [(integer? (/ n i)) (f (+ i 1) (cons i ls))]
        [else (f (+ i 1) ls)]))))
