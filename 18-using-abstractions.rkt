;18章,使用抽象
;之前17章一小节太少,所以这次18章就不分小节了
;似乎下一章19,就可以看到lambda,下一章要叫初识lambda(是不是有点着急,好了先看这一章)
#lang racket
;一旦你拥有了抽象函数,你就应该尽可能的使用他们
;跟重要的是你的读者更加容易理解你的意图
;如果抽象函数来自这门语言的标准函数库,就会更加容易理解
;这章会了解已有的内建函数,还会介绍一个新的语法  local
;


; N [N->X] -> [list of X]
; (build-list n f) == (list (f 0) (f 1) (f (- n 1)))
; .e.g
(define (f1 N)
  N)

;构造1~8的列表
;(build-list 8 f1)


;[X-> boolean] [a list of X]  -> [list of X]
;(filter p alox)  找到alox中符合p函数要求的元素
;.e.g
(define (p1 X)
  (odd? X))

;找出奇数项
;(filter p1 (list 1 2 3 4 5 6 7 8 9))

;[list of X ] [X X ->boolean]->[list of X]
;(sort alox cmp)  根据cmp比较函数将alox列表进行排序
;.e.g
;
;从大到小排序
;(sort (list 1 2 3 4 5 6 7 8 9) >)

;[X->Y][list of X]-> [list of Y]
;(map f alox) 通过转换函数f 将列表alox转换成aloY
;.e.g
(define (f2 x)
  (* 2 x))
;将列表里的数字全部乘2
;(map f2 (list 1 2 3 4 5 6 7 8))

;[X->boolean][list of X]-> boolean
;(andmap p alox) 判断是否alox全部符合判定函数p的要求
;.e.g
;
;判断列表里面是不是全是奇数
;(andmap p1 (list 1 3 5 7 9))


;[x->boolean][list of x]->boolean
;(ormap p alox)  和andmap类似,只要找到一个就可以了(and  or)

;.e.g
;判断列表里面是否有奇数
;(ormap odd? (list 1 2 3 4 5 6 7 8 9))

;[X Y->Y] Y [list of X]->Y
;(foldr f base alox)
;将f从右向左应用到alox和base上,(什么意思,试一试)
;(foldr / 1 (list 1 2 3  9))

;[X Y->Y] Y [list of Y] ->Y
;(foldl f base alox)
;和foldr顺序相反,从左向右作用f
;
;.e.g
;(foldl / 1 (list 1 2 3  9))
;2015-09-11 01:17:57
;今天就到这里了
;
;
;go on
;继续测试foldr和foldl
(define (f3 x y)
  (string-append (number->string x) y))
;(foldl f3 "" (list 1 2 3 4 5 6 7 8 9))
;(foldr f3 "" (list 1 2 3 4 5 6 7 8 9))
;;ok 大概了解这些函数是干什么的了

;Exercise 244
;[X->Number] [list of X] ->X
;(argmax f alox)
;f 是将X转换成Number的函数,argmax(agree MAX)找到转换后最大的那个alox中的元素
;.e.g
(define (f4 x)
  (* x 2))
;(argmax f4 (list 1 2 3 45 7))

;[X->Number ][list of X]-> X
;(agrmin f alox )
;和agrmax类似,找到符合要求最小的


;Exercise 245


(define (my-foldr f base alox)
  (cond
    [(empty? alox) base]
    [else (f (first alox) (my-foldr f base (rest alox)))]))
;(my-foldr cons '() '(a b c))
(define (my-foldl f base alox)
  (my-foldr f base (reverse alox)))


;;X [list of X] -> [list of X]
;在一个列表的结尾插入X
(define (add-at-end x l)
  (cond
    [(empty? l) (cons x '())]
    [else (cons (first l) (add-at-end  x (rest l)))]))

(define (my_build_list n f)
  (cond
    [(= 0 n )  '()]
    [(> n 0) (add-at-end (f (- n 1)) (my_build_list (-  n 1) f))]))
;(my_build_list 8 f1)
