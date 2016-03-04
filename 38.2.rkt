#lang racket

(define-struct pair [left right])
(define our_cons? pair?)
(define (our_cons a_value a_list)
  (cond
    [(empty? a_list) (make-pair a_value a_list)]
    [(our_cons? a_list) (make-pair a_value a_list)]
    [else (error "第二个参数应该是一个list")]))

(define (our_first a_list)
  (cond
    [(empty? a_list) (error 'a_list "不能为空")]
    [else (pair-left a_list)]))

(define (our_rest a_list)
  (cond
    [(empty? a_list) (error 'a_list "不能为空")]
    [else (pair-right a_list)]))


(define (my_cons x y)
  (λ (choose)
     (cond
       [(= choose 1) x]
       [else y])))

(define (my_first a_list)
  (a_list 1))
(define (my_rest a_list)
  (a_list 2))

;;数据定义上的迭代,是指在数据结构中增加一项作为迭代器

;;count 作为一个计数迭代器存在
(define-struct cpair [count left right])

(define (c-cons f r)
  (cond
    [(empty? r) (make-cpair 1 f r)]
    [(cpair? r) (make-cpair (add1 (cpair-count r)) f r)]
    [else (error "不可以是这样")]))

;Exercise 494 495
;有了count,计算list的长度将变得十分得快捷,但是构造一个list将花费我们更多的时间
;如果需要频繁得求解list的长度,那么这种结构就比较有优势,但是大多数时候并不会这么做


;在一个所谓的人工智能棋盘游戏中,在数据结构的设计中添加一个累加器就变得十分重要

; PuzzleState -> PuzzleState
; determine whether the final state is reachable from the given state
; generative create search tree of possible boat rides
; termination ???

;; (check-expect (solve initial-puzzle) final-puzzle)

;虽然有时候,会回到初始状态但是,他不会死循环,因为最终会有结束状态出现
;宽度优先搜索


;[state]===>#t/f
;;对于一个status给出是否是我们要的最终结果
;;
;用如下数据代表游戏状态
;3黑3白 船在左边 0黑0白
;黑色代表食人族 白色代表传教士
;任何一方食人族不能大于传教士的人数
;可以只有一只食人族
;初始状态
;; '((3 3) l (0 0))
;最终状态
;; '((0 0) r (3 3))
(define (final? state)
  (if (and
        ((first (first state)) . = . 0)
        ((second (first state)) . = . 0)
        (symbol=? 'r (second state))
        ((first (third state)) . = . 3)
        ((second (third state)) . = . 3))
    #t #f))

;;用于改变s state
;f1 f2 f3 f4 都是对于数字的处理
;基本就是add1 sub1 f(定义在下面)之类 通过组合不同dev处理方法得到新的游戏状态
(define (c-s s f1 f2 f3 f4)
  (list (list (f1 (first (first s)))
              (f2 (second (first s))))
        (if (symbol=? 'l (second s))
          'r 'l)
        (list (f3 (first (third s)))
              (f4 (second (third s))))))
(define f
  (lambda (x) x))

(define (sub2 n)
  (- n 2))
(define (add2 n)
  (+ n 2))

;;[list of status]===>[list of status]
(define (create-next-states* los)
  (local ((define (creat-next-state s)
            (list (c-s s sub1 sub1 add1 add1)
                  (c-s s sub1 f add1 f)
                  (c-s s f sub1 f add1)
                  (c-s s sub2 f add2 f)
                  (c-s s f sub2 f add2))))
    (foldr append '() (map creat-next-state los))) )

(define (solve state0)
  (local (; [List-of PuzzleState] -> PuzzleState
          ; generative generate the successor states for all intermediate ones
          (define (solve* los)
            (cond
              [(ormap final? los) (first (filter final? los))]
              [else (solve* (create-next-states* los))])))
    (solve* (list state0))))

(solve '((3 3) l (0 0)))

