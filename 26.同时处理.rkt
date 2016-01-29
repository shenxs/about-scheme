;不是非常明白这一章节要讲什么
;似乎是关于有两个参数的函数的设计

#lang racket

(define (replace-eol-with front end)
  (cond
    [(empty? front) end]
    [else (cons
            (first front)
            (replace-eol-with (rest front) end))]))

(replace-eol-with '(1 2 3) '(4 5 6))


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

(cross '(a b c) '(1 2))
