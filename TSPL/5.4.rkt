#lang racket

;;语法：(let name ((var expr) ...) body1 body2 ...)

#|
这种形式的let叫做命名的let(named let),是一种常用的的递归和迭代构造
这和更加常见的；let很类似，将expr ... 绑定到var ...上。这些变量的作用域是body1 body2 。。。
就像lambda那样。
此外变量名 name 在函数体中也可以用，所以可以递归或者迭代地调用，参数会变成var。。。的新绑定值
|#

;; 命名的let可以用letrec重写

;; ((letrec (name (lambda (var ...) body1 body2 ...))
;;    name)
;;  expr ...)



(define divisors
  (lambda (n)
    (let f ([i 2])
      (cond
        [(>= i n) '()]
        [(integer? (/ n i)) (cons i (f (+ i 1)))]
        [else (f (+ i 1))]))))

(divisors 1000)

;;以下是尾递归优化的版本。

;; (define divisors
;;   (lambda (n)
;;     (let f ([i 2] [ls '()])
;;       (cond
;;         [(>= i n) ls]
;;         [(integer? (/ n i)) (f (+ i 1) (cons i ls))]
;;         [else (f (+ i 1) ls)]))))


;;语法：(do ((var init update) ...) (test result ...) expr ...)
;;返回最后一个result的值

#|
do 可以让有所限制的迭代更容易表述。变量var ...一开始被绑定为init... 在其后的迭代中被绑定到update上。
test，update ...,expr ...,以及 result ... 都在var ... 的语法作用域范围内。
每一次迭代中 test都会被解析，如果返回值是true，迭代结束，result 。。。表达式依次执行，并且最后一个表达式的值被返回。如果result是空的那么do的返回值不确定。
如果test的值是false，表达式expr。。。 依次执行，update执行，新的值被绑定到var，迭代继续。

expr通常只为了产生副作用才存在，通常使用的时候可以整个不写。任何update也可以省略，
在这种情况下和update与var对应一样。

尽管大多数语言里面的循环是用赋值来更新循环变量的，do却是通过重新绑定来更新。事实上do语句不会产生任何副作用除非其自语句有副作用。
|#

(define factorial
  (lambda (n)
    (do ([i n (- i 1)]
         [a 1 (* a i)])
        ((zero? i) a))))


(define fibnacci
  (lambda (n)
    (if (= 0 n)
        0
        (do ([i n (- i 1)]
             [a1 1 (+ a1 a2)]
             [a2 0  a1])
            ((zero? i) a1)))))
(fibnacci 6)


(define divisors2
  (lambda (n)
    (do ([i 2 (+ i 1)]
         [ls '()
             (if (integer? (/ n i))
                 (cons i ls)
                 ls)])
        ((>= i n) ls))))

;;将向量v的每一个元素乘k

(define scale-vector
  (lambda (v k)
    (let ([n (vector-length v)])
      (do ([i 0 (+ i 1)])
          ((= i n))
        (vector-set! v i (* (vector-ref v i) k))))))

(define vec (vector 1 2 3 4 5))
(scale-vector vec 2)
vec
