#lang racket
;;之前的文件有点长了，所以新建一个

;;之前的两个例子中，我们用两个标识符加“-”来构建自己的函数
;我们还自定义了struct类
;之前是将一小片一小片的语法碎片拼接，接下来试试看将一个语法元素展开


;如果你的程序和互联网打交道，你就回经常碰到一些json数据
;在racket中用jsexpr?来表示
;在一个json字典中通常会包含另一个字典，他们都使用 hashep来表示

;;哈希表
;(hash key val ... ...)
;key any/c
;val any/c
;还有hasheq
;hasheqv
;区别是
;equal? eq? eqv? 用来比较key的方式不同
;; (equal? 1 1)
;; (eq? 1 1)
;; (eqv? 1 1)
;; (struct posn [x y])
;; (define a (posn 1 2))
;; (define b (posn 1 2))
;; (equal? a b)
;; (eq? a b)
;; (eqv? a b)

;; (equal? 2 2.0)

;;eq? 只有当两个比较的东西是同一个对象之后，他们才是相等的

;; (hash 'q "df" 4 "fjjf" 'y "jfjf")

(define js (hasheq 'a (hasheq 'b (hasheq 'c "终于找到了"))))


;; (hash-ref js 'a)
;;由于嵌套的原因，我们可以一层一层的取出来，可是这么做在语法上过于啰嗦
;可以借鉴其他语言的dot的方式 js.a.b.c来实现吗？

;;辅助函数
(define/contract (hash-refs h ks [def #f])
  ((hash? (listof any/c)) (any/c) . ->* . any )
  (with-handlers ([exn:fail? (const (cond [(procedure? def) (def)]
                                          [else def]))])
    (for/fold ([h h])
              ([k (in-list ks)])
      (hash-ref h k)
      )))

(hash-refs js '(a b c) )


(require (for-syntax racket/syntax))

(define-syntax (hash.refs stx)
  (syntax-case stx ()
    [(_ chain) #'(hash.refs chain #f)]
    [(_ chain default)
     (let* ([chain-str (symbol->string (syntax->datum #'chain))]
            [ids (for/list ([str (in-list (regexp-split  #rx"\\." chain-)]))]))]))
