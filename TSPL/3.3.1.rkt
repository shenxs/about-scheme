#lang racket
;;使用call/cc写一个无限循环程序,打印一个从0开始的数字序列
;;不能使用递归,不能使用任何赋值操作

(let ([k.n (call/cc (lambda (k) (cons k 0)))])
  (let ([k (car k.n)]
        [n (cdr k.n)])
    (displayln n)
    (k (cons k (+ n 1)))))
