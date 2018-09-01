#lang racket
;;这章会介绍scheme中判断两个对象是否相等的操作 以及是否是某个类别的
;;基本包括eq? eqv? 以及equal?


;;语法:(eq? obj1 obj2)
;;如果obj1和obj2有区别返回#t否则返回#f

;;在多数的scheme系统内,如果两个对象的指针是一样的那么这两个对象是相等的,反之则不等
;;尽管具体的规则每个系统都是有区别的,以下的规则总是一样的:
;;-不同类型的值是不同的
;;-同样的类型但是内容不一样,则不相等
;;-布尔值#t与#t无论在哪里都是相等的,#f与#f也是,但是#t和#f是不等的.
;;空list和他自身相等
;;-两个symbol只有在名字一样的时候相等
;;-常量pair,vector,string,bytevector和自身相等,
;;-两个pair,vector,string或bytevector是不相等的.
;;可以用cons来创建独一无二的对象,因为每个cons,vector,string,make-bytevector产生的对象都是不一样的.
;;两个表现不一样的函数是不一样的,一个用lambda创建的表达式和自身是相等的.
;;两个用相同的lambda表达式在不同时间定义的函数可能是一样的也有可能是不一样的.

;;eq?不能可靠地比较数字和字符串.尽管每个不精确的数字与每个确切的数字不同，但是两个确切的数字，两个不精确的数字或​​具有相同值的两个字符可能相同也可能不相同
;;因为常量对象是不可改变的,所有的或者部分的引用常量或者自解析的在内部有可能是用相同的对象表示的.因此eq有可能在比较不同的不可变常量的相同部分时会返回#t
;;eq通常被用来比较符号或者检查对象的指针是否相等,比如pair,vecttor或record.

(eq? 'a 3)
(eq? #t 't)
(eq? "abc" 'abc)
(eq? 'hi '(hi))
(eq?  '())

(eq? 9/2 7/2)
(eq? 3.4 12312)
(eq? 3 3.0)
(eq? 1/3 #i1/3)

(eq? 9/2 9/2)
(eq? 3.4 (+ 3 0.4))
(let ([x (* 12345678987654321 2)])
  (eq? x x))
(eq? #\a #\b)
(eq? #\a #\a)
(let ([x (string-ref "hi" 0)])
  (eq? x x))

(eq? #t #t)
(eq?  )

(eq? (null? '()) #t)
(eq? (cdr '(a)) '())
(eq? '(a) '(a))
(eq? "abc" "abc")
(eq? (string #\a #\b)
     (string #\a #\b))

(eq? (bytes 65 112 112 108 101) (bytes 65 112 112 108 101))

(eq? "abc" "abc")
(eq? '#(a) '(a))

(eq? car car)

(let ([f (lambda (x) x )])
  (eq? f f))
(let ([f (lambda (y) (lambda (x) x))])
  (eq? (f 0) (f 0)))

(let ([f (lambda (x)
           (lambda ()
             (set! x (+ x 1))
             x))])
  (eq? (f 0) (f 0)))

;;语法:(eqv? obj1 obj2)
;;返回如果相等返回#t反之#f
;;eqv?和eq?很相似,除了eqv?保证在遇到字符时是通过char=?来判断的
;;数字相等的条件有两个:1通过等号判断相等 2无法通过除了eq? eqv?以外的任何操作符区分
;;对第二个条件加以说明;(eqv? -0.0 +0.0)返回的是#f,尽管(= -0.0 +0.0)在基于IEEE浮点数标准的系统里是#t.这是因为除法/可以区分这些区别:
(/ 1.0 -0.0)
(/ 1.0 +0.0)

;;相似的,尽管3.0和3.0+0.0i在数值上是相等的,他们也不会被eqv?认为是相等的.

;;对于参数是NaNs的情况,eqv?的返回值是不确定的

(eqv? +nan.0 (/ 0.0 0.0))  ;;racket 返回#t
;;eqv?在scheme的实现里更加通用,但是通常这是要付出代价的

(eqv? 'a 3)
(eqv? #t 't)
(eqv? "abc" 'abc)
(eqv? "hi" '(hi))
(eqv?  #f '())
(eqv? 9/2 7/2)
(eqv? 3.4 53344)
(eqv? 3 3.0)
(eqv? 1/3 #i1/3)



(eqv? 9/2 9/2)
(eqv? 3.4 (+ 3.0 .4))
(let ([x (* 12345678987654321 2)])
  (eqv? x x))
(eqv? #\a #\b)
(eqv? #\a #\a)
(let ([x (string-ref "hi" 0)])
  (eqv? x x))
(eqv? #t #t)
(eqv? #f #f)
(eqv? #t #f)
(eqv? (null? '()) #t)


(eqv? (null? '(a)) #f)
(eqv? (cdr '(a)) '())
(eqv? 'a 'a)
(eqv? 'a 'b)
(eqv? 'a (string->symbol "a"))
(eqv? '(a) '(b))
(eqv? '(a) '(a))
(let ([x '(a . b)]) (eqv? x x))

(let ([x (cons 'a 'b)])
  (eqv? x x))
(eqv? (cons 'a 'b) (cons 'a 'b))
(eqv? "abc" "cba")
(eqv? "abc" "abc")
(let ([x "hi"]) (eqv? x x))
(let ([x (string #\h #\i)]) (eqv? x x))
(eqv? (string #\h #\i)
      (string #\h #\i))
(eqv? '#vu8(1) '#vu8(1))
(eqv? '#vu8(1) '#vu8(2))
(let ([x (make-bytevector 10 0)])
  (eqv? x x))
(let ([x (make-bytevector 10 0)])
  (eqv? x (make-bytevector 10 0)))
(eqv? '#(a) '#(b))
(eqv? '#(a) '#(a))
(let ([x '#(a)]) (eqv? x x))
(let ([x (vector 'a)])
  (eqv? x x))
(eqv? (vector 'a) (vector 'a))
(eqv? car car)
(eqv? car cdr)
(let ([f (lambda (x) x)])
  (eqv? f f))
(let ([f (lambda () (lambda (x) x))])
  (eqv? (f) (f)))
(eqv? (lambda (x) x) (lambda (y) y))
(let ([f (lambda (x)
           (lambda ()
             (set! x (+ x 1))
             x))])
  (eqv? (f 0) (f 0)))

;;函数:(equal? obj1 obj2)
;;如果obj1和obj2的结构和内容一样则返回#t反之#f
;;如果两个对象根据eqv?是相等的那么两者相等,string用string=?比较,二进制向量使用bytevector=?比较,pairs如果car部分和cdr部分相等那么也是相等的,有想通长度的vector并且对应元素相等的向量也是相等的.

;;equal?需要终止并且返回#t,当且仅当未展开的参数转换成正则树时相等。
;;就是说如果equal？认为这两个对象是相等的，那么这个对象的任何位置的子对象都是相等的。
;;.要实现高效的equal？是比较tricky的事.就算可以实现的比较好，他也是很有可能比eqv？和eq？都要昂贵。
(equal? 'a 3)
(equal? #t 't)
(equal? "abc" 'abc)
(equal? "hi" '(hi))
(equal? #f '())
(equal? 9/2 7/2)
(equal? 3.4 53344)
(equal? 3 3.0)
(equal? 1/3 #i1/3)
(equal? 9/2 9/2)
(equal? 3.4 (+ 3.0 .4))
(let ([x (* 12345678987654321 2)])
  (equal? x x))
(equal? #\a #\b)
(equal? #\a #\a)
(let ([x (string-ref "hi" 0)])
  (equal? x x))
(equal? #t #t)
(equal? #f #f)
(equal? #t #f)
(equal? (null? '()) #t)
(equal? (null? '(a)) #f)
(equal? (cdr '(a)) '())
(equal? 'a 'a)
(equal? 'a 'b)
(equal? 'a (string->symbol "a"))
(equal? '(a) '(b))
(equal? '(a) '(a))
(let ([x '(a . b)]) (equal? x x))
(let ([x (cons 'a 'b)])
  (equal? x x))
(equal? (cons 'a 'b) (cons 'a 'b))
(equal? "abc" "cba")
(equal? "abc" "abc")
(let ([x "hi"]) (equal? x x))
(let ([x (string #\h #\i)]) (equal? x x))
(equal? (string #\h #\i)
        (string #\h #\i))
(equal? '#vu8(1) '#vu8(1))
(equal? '#vu8(1) '#vu8(2))
(let ([x (make-bytevector 10 0)])
  (equal? x x))
(let ([x (make-bytevector 10 0)])
  (equal? x (make-bytevector 10 0)))
(equal? '#(a) '#(b))
(equal? '#(a) '#(a))
(let ([x '#(a)]) (equal? x x))
(let ([x (vector 'a)])
  (equal? x x))
(equal? (vector 'a) (vector 'a))
(equal? car car)
(equal? car cdr)
(let ([f (lambda (x) x)])
  (equal? f f))
(let ([f (lambda () (lambda (x) x))])
  (equal? (f) (f)))
(equal? (lambda (x) x) (lambda (y) y))
(let ([f (lambda (x)
           (lambda ()
             (set! x (+ x 1))
             x))])
  (equal? (f 0) (f 0)))
(equal?
 (let ([x (cons 'x 'x)])
   (set-car! x x)
   (set-cdr! x x)
   x)
 (let ([x (cons 'x 'x)])
   (set-car! x x)
   (set-cdr! x x)
   (cons x x)))

;;函数：(boolean? obj)
;;如果obj是#t或者#f则返回#t反之返回#f

;;boolean?和以下表达式等价
(lambda (x) (or (eq? x #t)
                (eq? x #f)))

;;函数（null? obj)
;;obj是否是空列表

;;等价于
(lambda (x) (eq? obj '()))


;;函数 （pair? x）
;;返回x是否是一个pair

(pair? '(a b c))
(pair? '(3 . 4))
(pair? '())
(pair? '#(a b))

;;函数（number? x) 数字
;;(complex? x) 复数
;;(real? x) 实数
;;(rational? x)有理数
;;(integer? x)整数

;;任何整数都是有理数,有理数都是实数,实数都被包含在复数里面.复数都是数字.大多数实现都没有
;;提供无理数的内部表示,所以实数就和有理数等价了.

;;real? rational? integer?不把带有不准确的0虚部的复数当做是实数,有理数或者实数.


(integer? 1901)
(rational? 1901)
(real? 1901)
(complex? 1901)
(number? 1901)

(integer? -3.0)
(rational? -3.0)
(real? -3.0)
(complex? -3.0)
(number? -3.0)

(integer? 7+0i)
(rational? 7+0i)
(real? 7+0i)
(complex? 7+0i)
(number? 7+0i)

(integer? -2/3)
(rational? -2/3)
(real? -2/3)
(complex? -2/3)
(number? -2/3)

(integer? -2.345)
(rational? -2.345)
(real? -2.345)
(complex? -2.345)
(number? -2.345)

(integer? 7.0+0.0i)
(rational? 7.0+0.0i)
(real? 7.0+0.0i)
(complex? 7.0+0.0i)
(number? 7.0+0.0i)

(integer? 3.2-2.01i)
(rational? 3.2-2.01i)
(real? 3.2-2.01i)
(complex? 3.2-2.01i)
(number? 3.2-2.01i)

(integer? 'a)
(rational? '(a b c))
(real? "3")
(complex? '#(1 2))
(number? #\a)

;;(real-valued? obj)
;;(rational-valued? obj)
;;(integer-valued? obj)

;;把不准确的0虚部的复数考虑成实数,有理数,整数.
;;racket不内置

