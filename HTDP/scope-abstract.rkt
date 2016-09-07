;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname scope-abstract) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
;;这一节似乎就是和变量的作用范围与抽象有关
;似乎这一章没有太多的要点
(define (p1 x y)
  (+ (* x y)
     (+ (* 2 x)
        (+ (* 2 y) 22))))

(define (p2 x)
  (+ (* 55 x) (+ x 11)))

(define (p3 x)
  (+ (p1 x 0)
     (+ (p1 x 1) ) (p2 x)))


;[list of x]->[list of x]
;
(define (insert_sort alon)
  (local(
         )
    (sort )))
(define (h z)
  (local (
          (define (f x) (+ (* x x) 55))
          (define (g y) (+ (f y) 10))
          )
    (f z)))

;这里有两个f和g函数,调用的时候要区分函数块,了解到底调用了哪个函数
;里面的函数调用里面的f,g
;外部的函数调用外部的f,g
(define (a_function y)
  (local ((define (f x y) (+ (* x y) (+ x y)))
          (define (g z)
            (local ((define (f x) (+(* x x) 55))
                    (define (g y) (+ (f y) 10)))
              (f z)))
          (define (h x) (f x (g x))))
    (h y)))

;在这里x被使用了两次作为f的参数和作为g的参数
(define (f x)
  (local ((define (g x) (+ x (* x 2))))
    (g x)))


;;Exercise 288
;[list of X]-> [list of X]
;;插入排序
(define (insertion_sort alon)
  (local ((define (sort alon)
            (cond
              [(empty? alon) '()]
              [else (add (first alon) (sort (rest alon)))]))
          (define (add an alon)
            (cond
              [(empty? alon) (list an)]
              [(> an (first alon)) (cons an alon)]
              [else (cons (first alon) (add an (rest alon)))])))
    (sort alon)))


(lambda (x y)
  (+ x (* x y)))

(lambda (x y)
  (+ x
     (local ( (define x (* y y)))
       (+ (* 3 x)
          (/ 1 x)))))


(lambda (x y)
  (+ x
     (lambda (x)
       (+ (* 3 x)
          (/ 1 x)))
     (* y y)))

;;有关循环loops
;虽然可以用函数来实现
;但是把循环当做系统的一个语法有以下优点
;第一,程序在在被编译的时候可以特别优化
;第二,方便阅读
(for/list ((i 10))
  i)
(for/list ((i 2) (j '(a b)))
  (list i j))

(local ((define i_s (build-list 2 (lambda (i) i)))
        (define j_s '(a b)))
  (map list i_s j_s))

(define (enumerate l)
  (for*/list ((item l) (ith (length l)))
    (list (+ ith 1) item)))


(for/list ((i 2))
  (for/list ((j '(a b)))
    (list i j)))
;;for*/list 是嵌套循环
;for/list 是单重循环
(for/list ((i 3) (j '(a b c)) (k '(α β γ)))
  (list i j k))

(define (arrangements w)
  (cond
    [(empty? w) '(())]
    [else (for*/list ([item w]
                      [arrangements-without-item
                        (arrangements (remove item w))])
            (cons item arrangements-without-item))]))
(arrangements (list 'a 'b 'c  ))



(for*/list ([item1 (list 'a 'λ)]
            [item2 '(b c d)])
  (list item1 item2 ))


(for*/list ([item1 2]
            [item2 '(a b c)])
  (list (+ item1 1) item2))


(define a (string->int "a"))
(for/string ((j 10)) (int->string (+ a j)))
