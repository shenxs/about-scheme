#|

之前的章节,我们讨论了一个模块化的方式:
但是这种形式有几个缺点

- 没有可移植性,scheme的标准不保证顶层变量的行为甚至存在
- 需要赋值,这会使得代码显得有些尴尬和有可能使得编译器的分析和优化更难
- 不支持关键词绑定的发布,应为没有类似set!的关键词

使用libraries是避免这种问题的一个可选方案,
一个libraries会暴露出一些标识符,每个都由libraries定义
或者从其他libraries中导入,一个暴露的标识符不能被绑定为一个变量,可能是一个关键词

以下的代码库导出两个标识符 gpa->grade以及关键词 gpa. 变量gpa->grade 绑定在一个接收GPA的过程上,GPA是一个数字.这个过程返回对应的基于四分制的字母等级,abcd.
关键词gpa表示一个语法扩展

|#
(library (grades)
  (export gpa->grade gpa)
  (import (rnrs))

  (define in-range?
    (lambda (x n y)
      (and (>= n x) (< n y))))

  (define-syntax range-case
    (syntax-rules (- else)
      [(_ expr ((x - y) e1 e2 ...) ... [else ee1 ee2 ...])
       (let ([tmp expr])
         (cond
          [(in-range? x tmp y) e1 e2 ...]
          ...
          [else ee1 ee2 ...]))]
      [(_ expr ((x - y) e1 e2 ...) ...)
       (let ([tmp expr])
         (cond
          [(in-range? x tmp y) e1 e2 ...]
          ...))]))

  (define letter->number
    (lambda (x)
      (case x
        [(a)  4.0]
        [(b)  3.0]
        [(c)  2.0]
        [(d)  1.0]
        [(f)  0.0]
        [else (assertion-violation 'grade "invalid letter grade" x)])))

  (define gpa->grade
    (lambda (x)
      (range-case x
                  [(0.0 - 0.5) 'f]
                  [(0.5 - 1.5) 'd]
                  [(1.5 - 2.5) 'c]
                  [(2.5 - 3.5) 'b]
                  [else 'a])))

  (define-syntax gpa
    (syntax-rules ()
      [(_ g1 g2 ...)
       (let ([ls (map letter->number '(g1 g2 ...))])
         (/ (apply + ls) (length ls)))]))
  )
