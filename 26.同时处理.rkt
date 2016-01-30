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

(wages*.v2 '(5.65) '(40))

(wages*.v2 '(1 2 3) '(4 5 6))
