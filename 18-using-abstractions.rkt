;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname 18-using-abstractions) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp")) #f)))
;18章,使用抽象
;之前17章一小节太少,所以这次18章就不分小节了
;似乎下一章19,就可以看到lambda,下一章要叫初识lambda(是不是有点着急,好了先看这一章)
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

;18.2 local function definitions 本地函数定义
;介绍local函数
;#|  ...|#是注释,vim自动注释
#| (define (listing.v2 l) |#
  #| (local |#
    #| ((define (string-append-with-space s t) |#
            #| (string-append " " s t))) |#
    #| (foldr string-append-with-space |#
           #| " " |#
           #| (sort (map address-first-name l) |#
                 #| string<?)))) |#
;local 的作用和private类似,私有代码在外部不能访问
;这里string-append-with-space 大概只能在函数内部使用
;(local (... 一系列的定义...) 主函数)
;这一系列的定义就像是一个完整的程序一样,常量,相互引用

;Exercise 246
;使用local重写画多边形的函数
(define (render-polygon p)
  (local(
         ;;背景
         (define MT (empty-scene 50 50))
         ;在im上连接p q两个点
         (define (render-line im p q)
           (scene+line
             im (posn-x p) (posn-y p) (posn-x q) (posn-y q) "red" ))
         ;找到p中的最后一个元素
         (define (last p)
           (cond
             [(empty? (rest (rest (rest p)))) (third p)]
             [else (last (rest p))]))
         ;从第一个到最后一个连接p中的点
         (define (connect-dots p)
           (cond
             [(empty? p) MT]
             [else
               (render-line (connect-dots (rest p)) (first p) (second p))]))
         (define first-last (connect-dots p)))
    ;-IN-
    (render-line first-last (first p) (last p))))



;Exercise 247
;重新排列一个单词
(define (arrangements w)
  (local(
;1string ,list of words ->list of words
;将一个字母插入到 a list of word
;这里前面((两个判断中第一个是判断low是否进入函数时就为空
;第二个判断条件在递归时会触发
;这样写可以区分递归时碰到empty元素时是递归一开始list就为空还是到达递归结束时才碰到的empty元素
(define (insert2words c low)
  (cond
    [(empty? low) (heart '() '() c)]
    [(empty? (rest low)) (heart '() (first low) c)]
    [else (append (heart '() (first low) c ) (insert2words c (rest low)))]))

;;这个程序的核心
;pre 必须为'() post可以是word
;c 为要插入的字母
;输出是将c 插入到post的所有位置  ->a list of words
(define (heart pre post c)
  (cond
    [(empty? post) (list (append pre (list c)))]
    [else (cons
            (append (append pre (list c)) post)
            (heart (append pre (list (first post))) (rest post) c))]))
)
    ;-IN-
    (cond
      [(empty? w) '() ]
      [else (insert2words (first w) (arrangements (rest w)))])))

;;local 可以把以前需要写在函数外面的辅助函数放到local内部,private专门调用
;而且local可以使得程序更加高效

#| (local (define some-value (s-express)) |#
  #| (...some-value ...some-value..)) |#
;可以事先算一边some-value,然后在主体中调用的时候就不用再做计算,可以大大提升程序效率
;nice!!!

