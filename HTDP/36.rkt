#lang racket

; [List-of Number] -> [List-of Number]
; convert a list of relative distances to a list of absolute distances
; the first item on the list represents the distance to the origin
;将一系列的相对距离转换为绝对距离
;; (check-expect (relative->absolute '(50 40 70 30 30))  ;检验函数需要额外的头文件
              ;; '(50 90 160 190 220))

(define (relative->absolute l)
  (cond
    [(empty? l) '()]
    [else (local ((define rest-of-l (relative->absolute (rest l)))
                  (define adjusted  (add-to-each (first l) rest-of-l)))
            (cons (first l) adjusted))]))

; Number [List-of Number] -> [List-of Number]
; add n to each number on l

;; (check-expect (cons 50 (add-to-each 50 '(40 110 140 170)))
              ;; '(50 90 160 190 220))

(define (add-to-each n l)
  (cond
    [(empty? l) '()]
    [else (cons (+ (first l) n) (add-to-each n (rest l)))]))

;Exercise 464

(define (add-to-each-v2 n l)
  (map (λ (item) (+ n item)) l))
;; (time (relative->absolute (build-list 100 add1)) #t)

;Exercise 465
;relative->absolute O(n^2)
(define (relative->absolute/a l accu-dist)
  (cond
    [(empty? l) '()]
    [else (local ((define tally (+ (first l) accu-dist)))
             (cons tally (relative->absolute/a (rest l) tally)))]))

;; (time (relative->absolute/a  (build-list 20000 add1) 0) #t )

(define (remove-last l)
  (cond
    [(empty? l) '()]
    [(empty? (rest l)) '()]
    [else (cons (first l) (remove-last (rest l)))]))

(define (insert@last x l)
  (cond
    [(empty? l) (cons x '())]
    [else (cons (first l) (insert@last x (rest l)))]))
;list to a reversed list
(define (my-reverse l already)
  (cond
    [(empty? l) already]
    [else (my-reverse (rest l) (cons (first l) already))]))

;; (time (my-reverse (range 100000) '()) #t )
;; (time (reverse    (range 100000)) #t )

(define (relative->absolute.v2 l)
 (reverse
   (foldr (lambda (f l) (cons (+ f (first l)) l))
          (list (first l))
          (reverse (rest l)))))
;; (time (relative->absolute.v2 (build-list 20000 add1)) #t)

;;[list of numbers]===>number\
;不加入辅助参数(accumulater直接翻译过来是迭代器,有点难翻译,就叫辅助参数巴)
(define (sum l)
  (cond
    [(empty? l) 0]
    [else (+ (first l) (sum (rest l)))]))
;加入辅助参数
(define (sum.v2 l)
  (local (
          (define (sum already l)
            (cond
              [(empty? l) already]
              [else (sum (+ already (first l)) (rest l))])))
    (sum 0 l)))
;; (time (sum (range 10000)))
;; (time (sum.v2 (range 10000)))
;; 几乎没有什么差别
;; 注意虽然在效率上这两者没有什么区别,但是计算的顺序是不一样的
;; 对于之前讨论过的inexct number计算的顺序和结果是有关系的
;; 对于exact number 当然没什么区别


;;下面是计算阶乘的函数
(define (! n)
  (cond
    [(zero? n) 1]
    [else (* n (! (sub1 n)))]))

;;迭代版

(define (!.v2 n)
  (local(
         (define (! already n)
           (cond
             [(zero? n) already]
             [else (! (* already n) (sub1 n))])))
    (! 1 n)))


(time (! 20) #t)
(time (!.v2 20) #t)

;; 时间上似乎有差别,但是在常数级,迭代的版本并不比普通的递归要优化多少,反而会慢
;; 我以为普通的递归会占用比较多的内存,事实上并没有,racket对于递归并不是一直展开下去的吗?


;;计算树的高度
;;a-tree is one of
;-- '()
;-- (make-node tree tree)

(define-struct node [left right])

(define (height abt)
  (cond
    [(empty? abt) 0]
    [else (+ 1 (max (height (node-left abt)) (height (node-right abt))))]))

(define (height.v2 abt0)
  (local (; Tree N -> N
          ; measure the height of abt
          ; accumulator a is the number of steps
          ; it takes to reach abt from abt0
          (define (height/a abt a)
            (cond
              [(empty? abt) a]
              [else
                (max (height/a (node-left abt)  (+ a 1))
                     (height/a (node-right abt) (+ a 1)))])))
    (height/a abt0 0)))

(define (height.v3 abt0)
  (local (; Tree N N -> N
          ; measure the height of abt
          ; accumulator s is the number of steps
          ; it takes to reach abt from abt0
          ; accumulator m is the maximal height of
          ; the part of abt0 that is to the left of abt
          (define (h/a abt s m)
            (cond
              [(empty? abt) ...]
              [else
                (... (h/a (node-left abt) ... s ... ... m ...) ...
                 ... (h/a (node-right abt) ... s ... ... m ...) ...)])))
    (h/a abt0 ...)))

