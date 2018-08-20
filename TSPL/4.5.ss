(import (scheme))
;; 语法：(let-values ((formals expr) ..) body1 body2 ...)
;; 语法：(let*-values ((formals expr) ...) body1 body2 ...)

;;返回最后一个表达式的值

#|
let-values 是一个方便的方式将多个值绑定到变量上。let-values的结构和let类似，但是接受任意参数
就像lambda一样。
let*-values 的作用类似，但是从左向右的顺序绑定，就像let* 。
就像lambda所做的一样，如果形参和实参的数量不匹配那么就会引发异常

|#

(let-values ([(a b) (values 1 2)] [c (values 1 2 3)])
  (list a b c))

(let*-values ([(a b) (values 1 2)] [(a b) (values b a)])
  (list a b))
