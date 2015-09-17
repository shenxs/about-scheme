;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname 18.7-练习和项目) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))


;Exercise 255
;将一系列的美元转换成欧元
;1$==1.22€
;[list of Number]->[list of Number]
(define (convert-euro lom)
  (local(
         ;美元到欧元
         ;Number->Number
         (define (to-euro n)
           (* n 1.22)))
    (map to-euro lom)))

;translates a list of Posns into a list of list of pairs of numbers
;list-of Posn-> [list-of [list Number Number ]]
(define (translate lop)
  (local(
         (define( Posn_to_list p)
           (list (posn-x p) (posn-y p)))
         )
    (map Posn_to_list lop)))



;Exercise 256
;
; sorts a list of inventory records by the difference between
;the two prices
;[a list of IR]-> a sorted [list of IR]

(define-struct ir [name price])

(define (sort_IR_price loir)
  (local(
         (define (cmp a b)
           (> (ir-price a) (ir-price b))))
    (sort loir cmp)))

;Exercise 257
;找到列表中价格低于ua的元素
(define (eliminate-exp ua loIR)
  (local(
         ;判断是否小于ua
         (define (small? a)
           (<= (ir-price a) ua)))
    (filter small? loIR)))


;除去名叫ty的ir元素
;X ,list of IR->list of ir
(define (recall ty loIR)
  (local(
         ;IR->boolean
         (define (not-ty? a)
           (not (string=? (ir-name a) ty))))
   (filter not-ty? loIR) ))

;两个列表,挑出两个列表公有的部分
;[list of X],[list of X]->[list of X]
(define (selection list1 list2)
  (local(
         ;string->boolean
         ;决定一个元素是否在list2中存在
         (define (in_list2? a)
           (find a list2))
         ;determine wheather a is in l
         ;由于要用到递归,所以我们再定义一个函数,拥有两个参数
         (define (find a l)
           (cond
             [(empty? l) false]
             [else (if (string=? a  (first l)) true (find a (rest l)))]))
         )
    (filter in_list2? list1)))


;Exercise 258


;N->(lsit 0 1 2 3 4 5 6 7 8 ..... (- n 1)
;
(define (build_naturl_number_list_from_zero n)
  (local(
         ;N->N
         (define (f n)
           n)
         )
    (build-list  n f)))


(define (build_naturl_number_list_from_1 n)
  (local(
         (define (f n)
           (+ n 1))
         )
    (build-list n f)))



;;N->(list 1 1/10 1/100 ...)
(define (build_fengshu_list n)
  (local(
         ;N->1/(10^n)
         (define (f n)
           (/ 1 (foo n)))
         ;N->10^n
         (define (foo n)
           (cond
             [(= 0 n) 1]
             [else (* 10 (foo (sub1 n)))]))
         )
    (build-list n f)))
;(build_fengshu_list 6)


;N->n个偶数
;M->list of numhber
(define (creat_even_number n)
  (local(
         (define (f n)
           (* 2 (+ n 1)))
         )
    (build-list n f)))
(creat_even_number 8)


;;tabulate制表函数
;Number {Number -> Y]->[list of y]
(define (tabulate n function)
  (build-list n function))



;Exercise 259
;give a name and a list of name
;i使用ormap判断是否list中的name都是包含啊name
;但是我觉得使用andmap才对吧
(define (find-name target_name lon)
  (local(
         ;确定是否为子列
         (define (sub? name)
           (local(
                  (define L (string-length target_name))
                  )(cond
                    [(< (string-length name) L) false]
                    [(string=? target_name (substring name 0 L)) true]
                    [else false]))))
    (andmap sub?　lon )))


;;Exercise 260
;自己设计append函数,利用foldr
;[list of X] {list of X]->[list of X]
;(check-expect (my_append (list 1 2 3 ) (list 4 5 6 7) )   (list 1 2 3 4 5 6 7))
;在;ist1的末尾连接list2
(define (my_append l1 l2)
  (local(
         (define (f a b)
           (cons a b))
         )
    (foldr f l2 l1 )))
;;;so easy以为会很复杂结果是如此的简单

;;Exercise 261
;使用foldr实现map
;
(define (my_map f alox )
  (local(
         (define (cons_f a  b)
           (cond
             [(empty? b) (cons (f a) '())]
             [else  (cons (f a)  b) ]))
         )
    (foldr cons_f '() alox )))
(define (abc n)
  (+ n 1))
(my_map abc (list 1 2 3 4 5 ))

;Exercise 262
;前缀吗和后缀吗
(define (prefix l)
  (local(
         ;;得到一个前缀码的基本操作
         (define (cut a b)
           (cond
             [(empty? b) (...)]
             [else (cons )]))
         )
    (foldr cut '() l )))
