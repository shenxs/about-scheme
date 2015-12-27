#lang racket
;这章是讲处理xml文档的
;xml可能已经过时了,但是json等等的处理原理相通

;;标签的参数,包括参数名和参数值
;(make-attribute symbol string)
(define-struct attribute [name value])
;标签,包括名字.属性,内容
;(make-element string (list of attribute) (list any))
(define-struct element [name attributes content])


#| '(machine ((initial "red")) |#
          #| (action ((state "red") (next "green"))) |#
          #| (action ((state "green") (next "yellow"))) |#
          #| (action ((state "yellow") (next "red")))) |#

#| ;用symbol来表示Xexpr(即X-expression) |#

#| ;- v.0 |#
#| '(cons Symbol '()) |#

#| ;v1 |#
#| '(cons Symbol [list of Xexpr]) |#

#| ;v2 |#
#| '(cons Symbol [list-of X-expr.v2]) |#
#| '(cons Symbol (cons [list-of attribute] [list-of X-expr.v2])) |#

#| ;attribute |#
#| '(Symbol string) |#

#| ;Exercise 351 |#
#| '(cons transition (cons (cons '(from "seen-e") '(to "seen-f")) '())) |#
#| '(cons ul (cons li (cons word (cons word '())))) |#

(define a0 '((initial "red")))

(define e0 '(machine))
(define e1 `(machine ,a0))
(define e2 '(machine (action)))
(define e3 '(machine () (action)))
(define e4 `(machine ,a0 (action) (action)))




(define (list_of_attributes? x)
  (cond
    [(empty? x) true]
    [else (cons? (first x))]))

(define (xexpr-attributes xe)
  (local ((define optional-loa+content (rest xe)))
    (cond
      [(empty? optional-loa+content ) '()]
      [else
        (local ((define may_attributes (first optional-loa+content)))
          (if (list_of_attributes? may_attributes)
            may_attributes
            '()))])))


(define (xexpr-name xe)
  (first xe))

(define (xexpr-content xe)
  (local ((define optional-loa+content (rest xe)))
    (cond
      [(empty? optional-loa+content) '() ]
      [else (local ((define may_attributes (first optional-loa+content)))
              (if (list_of_attributes? may_attributes)
                (rest optional-loa+content)
                optional-loa+content))])))

;Exercise 358

;word?
;判断一个isl值是否为xword

;xword 的格式为'(word ((text string)))
;(word ((text "one")))
;(word ((text "two"))))
(define (xword? x)
  (and (symbol=? 'word (first x))
       (symbol=? 'text (first (first (second x))))))

(define (word-text x)
  (if (xword? x)
    (second (first (second x)))
    (error "这不是一个xword")))




