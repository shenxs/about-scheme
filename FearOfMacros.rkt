;;http://www.greghendershott.com/fear-of-macros/index.html
;关于racket的宏的使用在HTDP中是没有的
;一直希望可以搞明白宏如何人使用,但是练习的代码无处安放,
;每次练习都比较凌乱,所以就放在这里,也是对自己的督促
;每次push都会有成就感
#lang racket


(define-syntax foo
  (lambda (stx)
    (syntax "我是大笨蛋")))

;; foo
;; (foo)

;;这里定义了一个语法 foo
;它会告诉编译器 ==>"当你看到foo这条语法时, 就将其替换为对应foo所binding的东西"
;这里就是
  ;; (lambda (stx)
    ;; (syntax "我是大笨蛋"))

;;当然也可以这样写
(define-syntax (also-foo stx)
  (syntax "我也是大笨蛋"))
;; (also-foo)

;;就像list可以用' 代替
;syntax 可以用 #' 代替
;这是一种语法糖

;;于是我们可以这么写
(define-syntax (quoted-foo stx)
  #'"我们可以用#'来代替syntax")

;; (quoted-foo)


;;以上的macro似乎没什么意义,我们来干点有意义的事情

(define-syntax (say-hi stx)
  #'(displayln "hi!   :)"))

;; say-hi

;;定义一个syntax的时候必须要有参数

;;可以像这样定义一个语句

(define-syntax (say-hi-wrong )
  #'(displayln "hi!   :)"))
;;只有函数名,没有参数
;但是你无法使用这条语法,因为一个macro至少会传进来一个参数,就是函数名
;以下语句会报错
;; (say-hi-wrong)
;因为给一个无参函数传递了参数



;;其实syntax 在racket里面也是一种数据结构
;就好像你可以定义一个posn数据类型(struct posn [x y])
;syntax 也是这样

;来看看syntax里面到底卖的什么药吧


(define-syntax (show-me stx)
  (print stx)
  #'(void))

;; (show-me 'pac )

;解释一下这个函数,他会输出stx的内容,因为define-syntax 必须返回一个syntax对象 所以在这里我就用了#'(void) ,理解返回为空

(define stx #'(if x (list  (list "helllo") "true") #f))

;; stx

;;语句的文件路径
;; (syntax-source stx)

;;语句的行数
;; (syntax-line stx)

;;语句的列数
;; (syntax-column stx)

;;取出与语句的主体,这基本就是语法的重点,大多是对齐进行处理
;; (syntax->datum stx)

;;将语句的每一个初级元素取出,对于嵌套的语句并不展开 就像 (list "hello")这样的语句并没有展开
;; (syntax-e stx)

;;syntax-list 和 syntax-e 有所不同
;对于的单个的不是list形式的语句
;; 比如
;;(define stx #'a)
;;(syntax-e stx)将会返回 'a
;;而 (syntax-list stx)会返回false ,因为这不是一个list
