#lang racket/base
;let 是一个从λ定义出来的语法扩展

;语法是可以扩展的,其实没有太大必要区分核心语法和扩展语法

;编译器会先将扩展语法还原为核心语法

;核心语法包括 define 常量 变量 过程 quote表达式 λ表达式 if表达式 set!表达式


(begin 'a 'b 'c)
;可以转化为
((lambda () 'a 'b 'c))

