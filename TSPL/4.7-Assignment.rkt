#lang racket
;;终于要开始了
;;一直希望用emacs加上chez scheme 来做练习,racket用于补全,似乎多此一举
;;无奈emacs新手,spacemacs又已经不是原生的emacs配置结构了(好在十分清晰)
;;最后的配置抄了王垠的配置,它的ParEdit mode 和Drracket的快捷键比较相似,可惜已经用了vim mode Esc已经被占不可能用,现在的配置也还不错
;;今天就一直在配置环境了,果然挺耗费时间,配好了之后还是挺舒服的,有空研究一下emacs的配置吧,一直用别人的东西总不是办法
;;发现现在的配置还是不完美,每次只能执行一条
;;依旧换回了racket mode


;;开始了


;;我所理解的assigment
;;语法(set! 标识符 表达式)
;;将某个标识符的值设定为某个表达式的动作
;;区别于define set!可以对同一标识符操作多次


;;计数器的例子

(define kons-count 0)

(define kount
  (lambda ( x y)
    (set! kons-count (+ kons-count 1))
    (cons x y)))

(kount 1 2)


;;加强版

(define next 0)

(define my-count
  (lambda ()
    (set! next (+ next 1))
    next))
(my-count)


(define next2 0)
(define ncount
  (lambda ()
    (set! next2 (+ next2 1))
    next2))


(ncount)


;;从0开始计数的写法,以上是从1开始计数的
(define next-real 0)

(define count-from-0
  (lambda ()
    (let ([v next-real])
      (set! next-real (+ next-real 1))
      v)
    ))

(count-from-0)

;;原理大致如此,?但如此实现一个计数器不是非常好的实现,计数变量是一个全局变量所以容易出事


(define count
  (let ([next 0])
    (lambda ()
      (let ([v next])
        (set! next (+ next 1))
        v))))
;;一个过程还是回和定义时的上下文环境绑定的所以返回的过程会绑定next
(count)


;;一个定义计数器的函数


(define make-count
  (lambda ()
    (let ([next 0])
      (lambda ()
        (let ([v next])
          (set! next (+ 1 next))
          v)))))
(define count1 (make-count))
(count1)

(define count2 (make-count))

(count2)

;;到这里先
;可以通过set!和内部定义来实现共享值


;所有的标识符必须在assign之前define
(define shhh #f)
(define tell #f)

(let ([secret 0])
  (set! shhh
    (lambda (message)
      (set! secret message)))
  (set! tell
    (lambda ()
      secret)))

(shhh "这是一句悄悄话")

(tell)


;;一个惰性求值的例子
;;表达式只有在需要的时候才被求值
;;Thunk经常被用于"冻结"求值的过程



(define lazy
  (lambda (t)
    (let ([val #f]
          [flag #f])
      (lambda ()
        (if (not flag)
            (begin (set! val (t))
                   (set! flag #t))
            val)))))


(define p
  (lazy (lambda ()
          (display "偶买噶")
          "抓到我了")))

(define q
  (lambda ()
    (display "hello")
    (newline)
    "world"))
(q)
(p)
(p)

;;在这里chez 和racket的返回结果略有区别
;;个人更加认可racket的结果


;;在这个例子里面 表达式的返回值被延迟了一次求值,flag的作用就是起到标示的作用(我想我们说不定可以将flag设定为数字来设定延迟求值的次数)






;;下面的例子用set!实现了一个栈的对象
;;包含4个操作 empty? push! pop! top


(define make-stack
  (lambda ()
    (let (;;设定初始化的栈为空
          [ls '()]
          )
      (lambda (op . args)
        (cond
          [(eqv? op 'empty?) (empty? ls)]
          [(eqv? op 'push) (set! ls (cons (car args) ls))]
          [(eqv? op 'pop) (set! ls (cdr ls))]
          [(eqv? op 'top) (first ls)]
          [else "what are you 弄啥类"])))))
(define s1 (make-stack))

(s1 'push 1)
(s1 'top)
(s1 'empty?)
(s1 'pop)
(s1 'empty?)

;;加上一个counter我们还可以得到栈的深度,将list换成vector可以得到更加好的性能表现

(define set-car!
  (lambda (l v)
    (set! l (cons v (rest l)))))

(define set-cdr!
  (lambda (l v)
    (set! l (cons (first l) v))))
;;这不是正确的实现,正确的实现应该使用到宏,因为l是对应的局部变量,并非top leave的binding,所以并不会有什么卵用,他只是改变了局部变量l的值
(define a-list '( 1 2 3))
(set-car! a-list 'two)
a-list
(set-cdr! a-list '())
a-list
