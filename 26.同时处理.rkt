;不是非常明白这一章节要讲什么
;似乎是关于有两个参数的函数的设计

#lang racket

(define (replace-eol-with front end)
  (cond
    [(empty? front) end]
    [else (cons
            (first front)
            (replace-eol-with (rest front) end))]))

;; (replace-eol-with '(1 2 3) '(4 5 6))


;Exercise 372
;[a list of number] [a list of symbol]
;===>
;all possible pair
;'(a b c) '(1 2)
;===>
;'((a 1) (a 2) (b 1) (b 2) (c 1) (c 2))

(define (cross los lon)
  (local(
         ;[a symbol] [a list of number] ==>[a list of (symbol number) pair
         ;'a '(1 2 3) ===> '((a 1) (a 2) (a 3))
         (define (one-to-all a lon)
           (cond
             [(empty? lon) '()]
             [else (cons `(,a ,(first lon)) (one-to-all a (rest lon)))]))
         )
    (cond
      [(empty? los) '()]
      [else (replace-eol-with (one-to-all (first los) lon) (cross (rest los) lon) )])))

;; (cross '(a b c) '(1 2))

;case 2
;支付薪水
; [List-of Number] [List-of Number] -> [List-of Number]
; computes weekly wages by multiplying the corresponding
; items on hours and hourly-wages
; assume the two lists are of equal length

(define (wages*.v2 hours hourly-wages)
  (cond
    [(empty? hours) '()]
    [(empty? hourly-wages) '()]
    [else
      (cons (* (first hours) (first hourly-wages))
            (wages*.v2 (rest hours) (rest hourly-wages)))]))

;; (wages*.v2 '(5.65) '(40))

;; (wages*.v2 '(1 2 3) '(4 5 6))

;Exercise 373
;[a list of employee] [list of work records] ===>[list of structure]
(define-struct employee [name social_security_name pay_rate])
(define-struct work_record [name hours])
(define-struct pay_record [name money])

(define (wages*.v3 loe lor)
  (local (
          (define (find-hours name lor)
            (cond
              [(empty? lor) 0]
              [(string=? name (work_record-name (first lor))) (work_record-hours (first lor)) ]
              [else (find-hours name (rest lor))]))
          (define (weekly-wages emplye lor)
            (make-pay_record
              (employee-name emplye)
              (* (employee-pay_rate emplye)
                 (find-hours (employee-name emplye) lor))))
          )
    ;-----IN------;
    (cond
      [(empty? loe) '()]
      [else (cons
              (weekly-wages (first loe) lor)
              (wages*.v3 (rest loe) lor))])))

;; (wages*.v3
;; (list (make-employee "a" 123 12)
;; (make-employee "b" 124 13))
;; (list (make-work_record "a" 3)))

;Exercise 374
;[a list of String] [a list of String] ===> [list of phone-record]
(define-struct phone-record [name number])
;A PhoneRecord is (make-phone-record String String)

(define (zip lon lop)
  (cond
    [(empty? lon) '()]
    [else (cons (make-phone-record (first lon) (first lop))
                (zip (rest lon) (rest lop)))]))

;case3

;[list of Symbol] number ===> Symbol
;n 自然数 l list
;取出 list中的第n个符号,如果list太短就报错
(define (list-pick l n)
  (cond
    [(< n 0) (error "not a nature number")]
    [(and (= 0 n) (cons? l) (first l))]
    [(and (> n 0) (cons? l)) (list-pick (rest l) (sub1 n))]
    [(and (> n 0) (empty? l)) (error "list too short")]))
;; (list-pick '(a b c d e f g) 1)

;Exercise 375
;a tree  [a list of directions] ===>a tree or error
(define-struct branch [left right])

(define (tree-pick t lod)
  (cond
    [(and (empty? lod) (branch? t)) t]
    [(and (symbol=? 'left (first lod)) (branch? t)) (tree-pick (branch-left t) (rest lod))]
    [(and (symbol=? 'right (first lod)) (branch? t)) (tree-pick (branch-right t) (rest lod))]
    [else (error "something wrong")]))
(define a-tree
  (make-branch
    (make-branch
      (make-branch 1 2)
      (make-branch "as" "bx"))
    (make-branch
      (make-branch 3 4)
      (make-branch "3" "4"))))

(tree-pick a-tree '(left left ))
