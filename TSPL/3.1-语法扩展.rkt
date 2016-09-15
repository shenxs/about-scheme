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


;;3.1.1


((lambda (x) (and x (memv 'b x))) (memv 'a ls))

((lambda (x) (if x (memv 'b x) #f)) (memv 'a ls))

