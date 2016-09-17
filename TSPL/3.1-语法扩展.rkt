#lang racket/base
;let 是一个从λ定义出来的语法扩展

;语法是可以扩展的,其实没有太大必要区分核心语法和扩展语法

;编译器会先将扩展语法还原为核心语法

;核心语法包括 define 常量 变量 过程 quote表达式 λ表达式 if表达式 set!表达式


;;TODO f5运行 和在repl解释的结果不太一样
(begin 'a 'b 'c)
;可以转化为
((lambda () 'a 'b 'c))


;; ...允许0个或者是更多的表达式

(define-syntax and
  (syntax-rules ()
    [(_) #t]
    [(_ e) e]
    [(_ e1 e2 e3 ...)
     (if e1
         (and e2 e3 ...)
         #f)]))

;; 或表达式

(define-syntax or
  (syntax-rules ()
    [(_) #f]
    [(_ e) e]
    [(_ e1 e2 e3 ...)
     (if e1 e1 (or e2 e3 ...))]))

(or (begin (display "hello")
           #t)
    #f)

;;
(define-syntax or
  (syntax-rules ()
    [(_) #f]
    [(_ e) e]
    [(_ e1 e2 e3 ...)
     (let ([t e1])
       (if t t (or e2 e3 ...)))]))

;;多了一句let为什么要多一层 TODO

;;3.1.1


((lambda (x) (and x (memv 'b x))) (memv 'a ls))

((lambda (x) (if x (memv 'b x) #f)) (memv 'a ls))


;;3.1.2

(or (memv x '(a b c)) (list x))

;;====>

(let ([t (memv x '(a  b c))])
  (if t t (list x)))

;;多一层是为了防止副作用吗?
;;是的
(let ([t (begin (display "hello")
                #f)])
  (if t t "world"))

;;3,1,3


(define-syntax let*
  (syntax-rules ()
    [(_ ([v e])
        t)
     (let ([v e])
       t)]
    [(_ ([v0 e0] [v1 e1] [v2 e2] ...)
        t)
     (let ([v0 e0])
       (let* ([v1 e1] [v2 e2] ...)
         t))]))

(let* ([a 5]
       [b (+ a a)]
       [c (+ a b)])
  (list a b c))



;;3.1.4



(define-syntax when
  (syntax-rules ()
    [(_ test exp1 exp2 ...)
     (if test (begin exp1 exp2 ...) (void))]))

(define-syntax unless
  (syntax-rules ()
    [(_ test exp1 exp2 ...)
     (when (not test) exp1 exp2 ...)]))

(let ([x 3])
  (unless (= x 0) (set! x (+ x 1)))
  (when (= x 4) (set! x (* x 2)))
  x)
