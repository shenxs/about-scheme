#lang racket
(require 2htdp/image)
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

(define ex
  '(ul
    (li (word ((text "one"))))
    (li (word ((text "two"))))))


;Exercise 355
;; (define (list_of_attributes? x)
  ;; (or (empty? x) (cons? (first x))))
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

;; (xexpr-attributes e4)

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

;; (lookup-attributes '((ha "123") (jk "123")) 'qw)

;Exercise 358

;word?
;判断一个isl值是否为xword

;xword 的格式为'(word ((text string)))
;(word ((text "one")))
;(word ((text "two"))))
(define (word? x)
  (and (symbol=? 'word (first x))
       (symbol=? 'text (first (first (second x))))
       (string? (second (first (second x))))))

(define (word-text x)
  (if (word? x)
    (second (first (second x)))
    (error "这不是一个xword")))

(define SIZE 12)
(define COLOR 'black)
(define BULLET
    (beside (circle 1 'solid 'black) (text " " SIZE COLOR)))
;; (define little-dot(circle 2 'solid "black"))
;; (define BULLET
  ;; (beside/align 'center little-dot (rectangle 12 12 'outline "white")))
(define item1-rendered
  (beside/align 'center BULLET  (text "one" 15 'black)))
(define item2-rendered
  (beside/align 'center BULLET (text "two" 15 'black)))
(define e0-rendered
  (above/align 'left item1-rendered item2-rendered))
;在vim中调试看不到图形界面,然而vim使用起来又是那么的顺手的
;希望有ide可以保留vim的配置文件,但是又可以将ide自身的特点保留

;25.2 Rendering XML Enumerations
;这章我们要将xml转换为图片
; An XEnum.v1 is one of:
; – (cons 'ul [List-of XItem.v1])
; – (cons 'ul (cons [List-of Attribute] [List-of XItem.v1]))
; An XItem.v1 is one of:
; – (cons 'li (cons XWord '()))
; – (cons 'li (cons [List-of Attribute] (cons XWord '())))


; XItem.v1 -> Image
; renders a single item as a "word" prefixed by a bullet
(define (render-item1 i)
  (local ((define content (xexpr-content i))
          (define element (first content))
          (define word-in-i (word-text element)))
    (beside/align 'center BULLET (text word-in-i 12 'black))))


; XEnum.v1 -> Image
; renders a simple enumeration as an image


(define (render-enum1 xe)
  (local (
          (define content (xexpr-content xe) )
          ;Xitem.v1->image
          (define (deal_with_one_item fst_itm so_far)
            (above/align 'left so_far (render-item1 fst_itm)))
          )
    (foldr deal_with_one_item empty-image content)))
;; (render-enum1 ex)

;实际上我们会遇到在li元素里面出现ul元素的情况,这是一个嵌套的定义
; An XItem.v2 is one of:
; – (cons 'li (cons XWord '()))
; – (cons 'li (cons [List-of Attribute] (cons XWord '())))
; – (cons 'li (cons XEnum.v2 '()))
; – (cons 'li (cons [List-of Attribute] (cons XEnum.v2 '())))
; An XEnum.v2 is one of:
; – (cons 'ul [List-of XItem.v2])
; – (cons 'ul (cons [List-of Attribute] [List-of XItem.v2]))



(define (render-enum xe)
  (local ((define content (xexpr-content xe))
          ; XItem.v2 Image -> Image
          (define (deal-with-one-item fst-itm so-far)
            (above/align 'left (render-item fst-itm) so-far)))
    (foldr deal-with-one-item empty-image content)))

;由于嵌套定义对于enum并没有影响,所以需要改变的是对于item元素的处理
;'(li
;       (word (text "one"))
;       (ul
;           (li (word (text "two")))))
(define (render-item an-item)
  (local ((define content (first (xexpr-content an-item))))
(beside/align 'center BULLET
              (cond
                [(word? content) (text (word-text content) SIZE 'black)]
                [else (render-enum content)]))))

;Exercise 361
;直接从v2版本的定义开始构建rander函数估计是一样的
;所以略过
;Exercise 362
;不太喜欢原版还是不在cond外面加上beside/align看着逻辑更加清晰
;加上似乎代码更加漂亮


(define ceshi '(ul (li (word ((text "123"))))
                  (li (ul (li (word ((text "456"))))))
                  (li (word ((text "hello"))))))
;Exercise 363
;数一下enum中一共有几个hello
;enum->Number

(define (count-hello xe str)
  (local ((define content (xexpr-content xe))
          ;Xitem.v2->number
          (define (add fst so_far)
            (+ (how-many str fst) so_far))
          )
    (foldr add 0 content)))

(define (how-many str an-item)
  (local ((define content (first (xexpr-content an-item ))))
    (cond
      [(word? content)
       (cond
         [(string=? str (word-text content)) 1]
         [else 0])]
      [else (count-hello content str)])))
;; ceshi
;; (count-hello ceshi "hello")


;Exercise 364
;将xenum 中的hello全部替换为bye
(define (replace-hello xe str)
  (local ((define content (xexpr-content xe))
          (define (replace fst so-far)
            (cons (replace-item fst str) so-far)))
    (cons 'ul (foldr replace '() content))))

(define (replace-item an-item str)
  (local ((define content (first (xexpr-content an-item))))
    (cons 'li
          (cond
        [(word? content)
         (cond
           [(string=? "123" (word-text content)) `((word ((text ,str))))]
           [else `(,content)])]
        [else `(,(replace-hello content str))]))))

;; (replace-hello ceshi "bye")

(provide
  xexpr-name
  xexpr-attributes
  xexpr-content)
