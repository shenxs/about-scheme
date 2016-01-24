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
;<transition from="seen-e" to="seen-f" />
;'(transition '((from "seen-e") (to "seen-f")))
;<ul>
;<li><word /><word /></li>
;<li><word /></li>
;</ul>


;'(ul (li word) (li word))
;'(end)
;;
;an Xexper.v2 is
;- (cons Symbol (cons Xexpr.v2 (cons Xexpr.v2 (cons Xexper.v2 ...))))
;- (cons Symbol (cons (cons Attribute (cons Attribute (cons Attribute)))  (cons Xexper.v2 (cons Xexper.v2 (cons Xexper.v2 (cons .....))))))
;- '(Symbol '(a a a ) x x x x)
;- '(Symbol x x x x x)
;an Attribute is
;-- (cons Symbol (cons Srting '()))
;-- '(Symbol String)
;Exercise 353. Interpret the following elements of Xexpr.v2 as XML data:
;'(server ((name "example.org")))
;<server name="example.org" ></server>
;'(carcassonne (board (grass)) (player ((name "sam"))))
;<carcassonne>
;   <board>
;       <grass></grass>
;   </board>
;   <player name="sam"></player>
;</carcassonne>
;'(start)
;<start></start>
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

(xexpr-attributes e4)

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

;Exercise 355
;; (define (list_of_attributes? x)
  ;; (or (empty? x) (cons? (first x))))
;因为这不是一个递归的定义
;Exercise 356
;
;Exercise 357
;list of attributes and a Symbol x -> String/false
;给定一个list,存放许多的参数,决定Symbol X 对应的参数的值是多少,如果没有就返回false,如果有返回值应该会是一个String值
(define (lookup-attributes l x)
  (local ((define pair-or-false (assq x l)))
    (if (false? pair-or-false)
      pair-or-false
      (rest pair-or-false))))

(lookup-attributes '((ha "123") (jk "123")) 'qw)

;Exercise 358

;word?
;判断一个isl值是否为xword

;xword 的格式为'(word ((text string)))
;(word ((text "one")))
;(word ((text "two"))))
(define (word? x)
  (and (symbol=? 'word (first x))
       (symbol=? 'text (first (first (second x))))))

(define (word-text x)
  (if (word? x)
    (second (first (second x)))
    (error "这不是一个xword")))




