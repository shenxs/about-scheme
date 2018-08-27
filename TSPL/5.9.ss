(import (scheme))

(+ 1 1)
(eval '(let ([x 3]) (cons x 4)) (environment '(rnrs)))


;;函数 (environment import-spec)
;;返回一个环境
;;environment返回一个由导入指定器指定的绑定组合而成的环境.每一个import-spec必须是一个代表了有效的导入指定器的s表达式

(define env (environment '(rnrs) '(prefix (rnrs lists) $)))

(eval '($cons* 3 4 (* 5 8)) env)

;;函数:(null-environment version)
;;函数:(scheme-report-environment version)
;;返回基本的r5rs的环境

;;version 必须是5

;;null-environment返回一个由r5rs规定的语义的一系列绑定，以及辅助关键词else,=>,...和_
;;scheme-report-environment 返回和null-environment一样的环境除了没有被r6rs定义的load, interaction-environment, transcript-on, transcript-off, and char-ready?.

;;这些过程返回的绑定是对应的r6rs的库的。所以不是完全向后兼容的，尽管标识符没有被使用
