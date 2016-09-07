;abstractions from templates
;从模板抽象
;以前一直从一般函数->抽象函数
;这一章直接从函数模板得到抽象函数
;有很厉害吗?
;尽管这个话题还在研究中,我们现在只是了解一下基本的idea
#lang racket

(define (fun_for_l l)
  (cond
    [(empty? l) ...]
    [else (... (first l) ... (fun_for_l (rest l)))]))
;;这是一般的列表处理函数模板,确实这种形式出现了很多次
;
;
;
;抽象之后就是以下的函数
(define (reduce l base combine)
  (cond
    [(empty? l) base]
    [else (combine (first l) (reduce (rest l base combine)))]))
;之后就可以用一行定义出sum ,product(将列表里面的数字全部×qilai)




;[list of sum] -> number
(define (sum l)
  (reduce l 0 +))

;[list of number ]->number
(define (product l)
  (reduce l 1 *))

;(reduce 运算对象(列表) 幺元 运算符)
