;;终于要开始了
;;一直希望用emacs加上chez scheme 来做练习,racket用于补全,似乎多此一举
;;无奈emacs新手,spacemacs又已经不是原生的emacs配置结构了(好在十分清晰)
;;最后的配置抄了王垠的配置,它的ParEdit mode 和Drracket的快捷键比较相似,可惜已经用了vim mode Esc已经被占不可能用,现在的配置也还不错
;;今天就一直在配置环境了,果然挺耗费时间,配好了之后还是挺舒服的,有空研究一下emacs的配置吧,一直用别人的东西总不是办法



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

(define count
  (lambda ()
    (set! next (+ next 1))
    next))
(count)


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
