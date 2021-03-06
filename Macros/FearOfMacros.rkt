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

;; 就像list可以用' 代替
;syntax 可以用 #' 代替
;这是一种语法糖

;;于是我们可以这么写
(define-syntax (quoted-foo stx)
  #'"我们可以用#'来代替syntax")

;; (quoted-foo)


;;以上的macro似乎没什么意义,我们来干点有意义的事情

(define-syntax (say-hi stx)
  #'(displayln "hi!   :)"))

; say-hi
; (say-hi)
;;定义一个syntax的时候必须要有参数

;;可以像这样定义一个语句

(define-syntax (say-hi-wrong )
  #'(displayln "hi!   :)"))
;;只有函数名,没有参数
;但是你无法使用这条语法,因为一个macro至少会传进来一个参数,就是函数名
;以下语句会报错
; (say-hi-wrong)
;因为给一个无参函数传递了参数



;;其实syntax 在racket里面也是一种数据结构
;就好像你可以定义一个posn数据类型(struct posn [x y])
;syntax 也是这样

;来看看syntax里面到底卖的什么药吧


(define-syntax (show-me stx)
  (print stx)
  #'(void))

; (show-me 'pac )

;解释一下这个函数,他会输出stx的内容,因为define-syntax 必须返回一个syntax对象 所以在这里我就用了#'(void) ,理解返回为空

;; (define stx #'(if x (list  (list "helllo") "true") #f))

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


;ok铺垫的差不多了,开始让自己做些真正的输入输出吧

(define-syntax (reverse-my stx)
  (datum->syntax stx (reverse (cdr (syntax->datum stx)))))

;; (reverse-my "倒过来de" "是" "我" values)

;;传说中yoda说话的方式
;; (datum->syntax ctxt v )
;;以下是我对于官方文档的理解
;ctxt是代表了最终要加入的stx
;原文说是提供了上下文信息
;我觉得就相当于将ctxt中的datum部分去掉,换上v

;values 会返回给定的参数

;;通常的代码运行在运行的时候
;简单的说代码有编译期,执行期
;大部分的代码运行在执行期,但是racket的宏是在编译的时期起作用的
;语法的转换是在解析代码的时候发挥作用的
;也就是在编译的时候发挥作用


;宏可以让你做到在普通代码中不可能做到的事情
;比如,可以解决副作用的问题

;加入我们定义了自己的if

(define (our-if condition true-expr false-expr)
  (cond
    [condition true-expr]
    [else false-expr]))


;似乎没有什么问题

;; (our-if #t true false)

;;因为这些东西都是纯的,没有副作用(尽量避免副作用)
;; 当语句出现副作用呢?
;

(define (display-and-return x)
  (displayln x)
  x)

;; (our-if (display-and-return #t)
        ;; (display-and-return "true")
        ;; (display-and-return "false"))



;;以上语句racket在解析的时候会先将其每个语句都执行,相当于执行并且得到表达式的返回值
;但这并不是我们想要的
;我们所希望的是条件语句只是得到返回值,只有一个分支语句被执行


(define-syntax (our-if-v2 stx)
  (define mimo (syntax->datum stx))
  (datum->syntax stx `(cond
                        [,(cadr mimo) ,(caddr mimo)]
                        [else ,(cadddr mimo)])))

;; (our-if-v2 (display-and-return #t)
           ;; (display-and-return "true")
           ;; (display-and-return "false"))


;; (if (display-and-return #t)
  ;; (display-and-return "true")
  ;; (display-and-return "false"))

;;以上语句的返回值和racket的if是一致的
;在lazy racket 模式中一开始我们定义的our-if 和第二个版本的作用是一致的
;其实他只是吧锅给了cond 因为lisp的实现里面只要实现
;语句在被编译的时候并没有被求值,他们只是被(移动-组合)

(require (for-syntax racket/match))

;; (define stx #'(our-if-v2 #t "true" "false"))
;; (displayln stx)

;; (syntax->list stx)

;; (syntax->datum stx)

;但是一直用car cadr caddr 什么的是一件非常麻烦的事情,所以我们可以用match来
;完成这个事情
;由于在complie时期你只有racket/base是可以使用的
;要使用match ,一如12行之前那样引入就好了
(define-syntax (our-if-match-v2 stx)
  (match (syntax->datum stx)
    [(list _ condition true-expr false-expr)
     (datum->syntax stx `(cond
                           [,condition ,true-expr]
                           [else ,false-expr]))]))

;; (our-if-match-v2 #t "true" "fasle")

;; Joy.

(begin-for-syntax
  (define (my_function )
    "这是自己定义的编译时函数")
  my_function
  )

; (my_function)
; 编译时定义的函数无法在运行时调用



;;可以用(require (for-syntax 包名))来引入我们需要的包
;让其在编译时期可以被使用,那么我们自己定义的函数怎么办呢?
;
;
;

;;可以使用
;begin-for-syntax来实现
#|

(begin-for-syntax
  (define (自己定义的函数 ...)
    ...)

  (define-syntax (宏-用到自定义函数 stx)
    (自己定义的函数 ...)
    ...))

|#

;;除此之外当然也会有其他的方式
;可以使用
;(define-for-syntax (自定义函数 ...) .....)
;在处理syntax的时候就可以使用了,并不在需要写在
;(degin-for-syntax ....)中了

;;除了可以用match来进行语法处理,还可以用syntax-case
;(syntax-case stx (literal-id)
;   [(case) (result-expr)]
;   ...
;   )

(define (our-if-using-syntax-case stx)
  (syntax-case stx ()
    [(_ condition true-expr false-expr)
     #'(cond [condition true-expr]
             [else false-expr])]))

;这里stx的括号内的内容为空
;下面的例子是有用到literal-id的

 ;; (syntax-case #'(ops 1 2 3 => +) (=>)
    ;; [(_ x ... => op) #'(op x ...)])
;; ;; #<syntax:572:0 (+ 1 2 3)>
;; > (syntax-case #'(let ([x 5] [y 9] [z 12])
                   ;; (+ x y z))
               ;; (let)
    ;; [(let ([var expr] ...) body ...)
     ;; (list #'(var ...)
           ;; #'(expr ...))])
;; '(#<syntax:573:0 (x y z)> #<syntax:573:0 (5 9 12)>)


;;可以看到literal-id是精确匹配的,但是其他的匹配符号都是pattern
;模式匹配


;;事实上还有更加简单的方式来定义语法

(define-syntax-rule (our-if-using-syntax-rule condition true-expr false-expr)
  (cond
    [condition true-expr]
    [else false-expr]))

;; (our-if-using-syntax-rule #t "true" "false")

;;你会看到这简单了很多,但是,它也太简单了,所以如果你一开始就从define-syntax-rule开始学习
;你就会搞不明白这和define有什么区别





;;模式vs模板
;pattern 和templete ,pattern用于描述用于匹配的规则,template则是一个有待实例化的框架
;如果pattern匹配则实例化template

(define-syntax (hyphen-define stx)
  (syntax-case stx ()
    [(_ a b (args ...) body0 body ...)
     (syntax-case (datum->syntax stx (string->symbol (format "~a-~a"
                                                             (syntax->datum #'a)
                                                             (syntax->datum #'b)))) ()
                  [name #'(define (name args ...)
                            body0 body ...)])
     ]))


; (hyphen-define foo bar (x) (* x x))
; (foo-bar 7)


;; (define-syntax (my-hyphen-define stx)
  ;; (match (syntax->list stx)
    ;; ['( _ a b (args ...) body0 body ...)
     ;; (let ([name (string->symbol (format "~a-~a"
                                        ;; (symbol->string a)
                                        ;; (symbol->string b)))])
       ;; #'(define (a args...) body0 body ...))]))

;;似乎不可以,找不到pattern

;; (define-syntax (my-fun stx)
  ;; (syntax-case stx ()
    ;; [(_ a b (args ...) body0 body ...)
     ;; (let ([name (string->symbol (format "~a-~a"
                                         ;; (syntax->datum #'a)
                                         ;; (syntax->datum #'b) ))])
       ;; #'(define (name args ...) body0 body ...))]))

;;依旧不可以 name没有被真确滴绑定


;;可以使用类似let的with-syntax来办到


(require (for-syntax racket/syntax))
(define-syntax (hyphen-define/ok stx)
  (syntax-case stx ()
    [(_ a b (args ...) body0 body ...)
     (with-syntax ([name (format-id stx "~a-~a" #'a #'b)])
       #'(define (name args ...) body0 body ...))]))

(hyphen-define/ok foo baa (x) (* x x))
;; (foo-baa 3)

;;format-id可以简单得处理标识符,
;(format-id lctx      fmt v ...
;                    [  #:source src
;                           #:props props
;                                   #:cert ignored])

;lctx 语法上下文 fmt 模板 v-->value 要加入模板中的值 其他的可选


(require (for-syntax racket/string))
(define-syntax (hyphen-define* stx)
  (syntax-case stx ()
    [(_ (names ...) (args ...) body0 body ...)
     (let* ([names/sym (map syntax-e (syntax->list #'(names ...))) ]
            [names/str (map symbol->string names/sym)]
            [name/str (string-join  names/str "-")]
            [names/sym (string->symbol name/str)])
       (with-syntax ([name (datum->syntax stx names/sym)])
         #'(define (name args ...) body0 body ...)))]))

(hyphen-define* (a b c) (x) (* x 2))
;; (a-b-c 7)



;其实如果racket本身不提供struct 方法,通过宏我们也可以自定义struct
;现在假定racket没有struct,我们来自己创造一个
;(our-struct name (a b c d ...))
;通过这条语句我们需要定义出一个谓词
;name?
;不太喜欢用-来表示某个从属关系,那就让我们用.来表示好了

;比如(our-struct posn (x y))
;(posn 1 2)
;(define foo (posn 1 2))
;foo.x ==> 1
;foo.y ==> 2


(require (for-syntax racket/syntax))

(define-syntax (our-struct2 stx)
  (syntax-case stx ()
    [(_ id (fields ...))
     (with-syntax ([pred-id (format-id stx "~a?" #'id)])
       #`(begin
           ;;创建一个构造器
           (define (id fields ...)
             (apply vector (cons 'id (list fields ...))))
           ;;创建谓词
           (define (pred-id v)
             (and (vector? v)
                  (eq? (vector-ref v 0) 'id)))
           ;;创建选择器
           #,@(for/list ([x (syntax->list #'(fields ...))]
                         [n (in-naturals 1)])
                (with-syntax ([acc-id (format-id stx "~a-~a" #'id x)]
                              [ix n])
                  #`(define (acc-id v)
                      (unless (pred-id v)
                        (error 'acc-id "~a id not a  ~a struct" v 'id))
                      (vector-ref v ix))))
           ))]))


(define-syntax (our-struct stx)
  (syntax-case stx ()
    [(_ id (fields ...))
     (with-syntax ([pred-id (format-id stx "~a?" #'id)])
       #`(begin
           ; Define a constructor.
           (define (id fields ...)
             (apply vector (cons 'id  (list fields ...))))
           ; Define a predicate.
           (define (pred-id v)
             (and (vector? v)
                  (eq? (vector-ref v 0) 'id)))
           ; Define an accessor for each field.
           #,@(for/list ([x (syntax->list #'(fields ...))]
                         [n (in-naturals 1)])
                (with-syntax ([acc-id (format-id stx "~a.~a" #'id x)]
                              [ix n])
                  #`(define (acc-id v)
                      (unless (pred-id v)
                        (error 'acc-id "~a is not a ~a struct" v 'id))
                      (vector-ref v ix))))))]))

(our-struct fooo (a b))
(define s (fooo 1 2))
;; (fooo-a s)


;测试环节

;;测试包头文件
(require rackunit)

(check-equal? (fooo.a s) 1)
(check-equal? (fooo.b s) 2)
(check-equal? (fooo? s) true)
(check-equal? (fooo? 1) false)


(check-exn exn:fail?
           (lambda () (fooo.a "furbl")))

;; 失败报错测试
;; (our-struct "hahah" ("sfs" "sfa"))


;报错信息并不怎么友好
;由于我们给出的样例中,是字符串并不是操作符
;syntax-case 的一个case的格式
;可以是
;[pattern templete]
;还可以是
;[pattern guard templete]
;这样的三个部分组成

(define-syntax (our-struct-guard stx)
  (syntax-case stx ()
    [(_ id (filds ...))
     (for-each
       (lambda (x)
         (unless (identifier? x)
           (raise-syntax-error #f "不是标识符" stx x)))
       (cons #'id (syntax->list #'(filds ...))))
     (with-syntax ([pre-id (format-id stx "~a?" #'id) ])
       #`(begin
           ;;定义构造器
           (define (id filds ...)
             (apply vector (cons 'id (list filds ...))))
            ;;定义谓词
           (define (pred-id v)
             (and (vector? v)
                  (eq? (vector-ref v 0) 'id)))
            #,@(for/list ([x (syntax->list #'(filds ...))]
                          [n (in-naturals 1)])
                 (with-syntax ([acc-id (format-id stx "~a-~a" #'id x)]
                               [ix n])
                   #'(define (acc-id v)
                       (unless (pred-id v)
                         (error "非此类型数据"))
                       (vector-ref v ix))))
           ))]))
;;可以自定义报错信息
;; (our-struct-guard "hahha" [as bv])
