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


