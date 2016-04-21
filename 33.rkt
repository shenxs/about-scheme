;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname |33|) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "abstraction.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "abstraction.rkt" "teachpack" "2htdp")) #f)))

;回溯算法
;smaple problem
;给定一张图,两个节点,给出链接两个点的路径

;[string]==>[list of 1Strings]
;将字符串转换为一个字符表
;什么时候写在一个文件里省的老是自己写


(define sample-graph
  '((A B E)
    (B E F)
    (C D)
    (D)
    (E C F)
    (F D G)
    (G)))

;Exercise 445
(define (translate-graph g)
  (map (λ (node) (cons (first node) (cons (rest node) '())))
       g))

(define graph (translate-graph sample-graph) )

;; 给定图以及一个节点,给出次节点的相邻的节点

(define (neighbors n g)
  (cond
    [(empty? g) (error "no such node in the graph")]
    [(symbol=? n (first (first g))) (first (rest (first g)))]
    [else (neighbors n (rest g) )]))

;; (neighbors 'F graph)

;; Node Node Graph -> [Maybe Path]
;; finds a path from origination to destination in G
;; if there is no path, the function produces #false

(define (find-path origination destination G)
  (cond
    [(eq? origination destination) (list destination)]
    [else (local ((define next (neighbors origination G))
                  (define candidate (find-path/list next destination G)))
            (cond
              [(boolean? candidate) #false]
              [else (cons origination candidate)]))]))

; [List-of Node] Node Graph -> [Maybe Path]
; finds a path from some node on lo-Os to D
; if there is no path, the function produces #false
(define (find-path/list lo-Os D G)
  (cond
    [(empty? lo-Os) #false]
    [else (local ((define candidate (find-path (first lo-Os) D G)))
            (cond
              [(boolean? candidate) (find-path/list (rest lo-Os) D G)]
              [else candidate]))]))

;; (find-path 'A 'G graph)


;; 起点,终点,图===>#false 或正确的联通路径
;start end graph
(define (find-my-path s e g)
  (cond
    [(eq? s e) (list e)]
    [else (local(
                 (define next (neighbors s g))
                 (define maybe (find-my-path/list next e g)))
            (cond
              [(cons? maybe) (cons s maybe)]
              [else #f]))]))

;[list of nodes] [end node] [graph] ===>#f or [list of nodes]
(define (find-my-path/list lon e g)
  (cond
    [(empty? lon) #f]
    [else (local (
                  (define maybe-list
                    (map (λ (x) (find-my-path x e g)) lon))
                  (define (d? item)
                    (if (cons? item) item #f)))
            (ormap d? maybe-list))]))

;; (find-my-path 'A 'G graph)

;Exercise 446
;对于给定的图,找到任意两点之间的路径,如果成功返回#true else #false
(define (test-on-all-nodes graph)
  (local(
         ;;[a list of list] ===> [a list of item(the first item of the list in the list )]
         ;'((1212 12 12 1) (12 22) (1) (a s)) ====>'(1212 12 1 a)
         (define (get-every-first graph)
           (cond
             [(empty? graph) '()]
             [else (cons (first (first graph)) (get-every-first (rest graph)))]))
         ;;图中所有的节点
         (define lon (get-every-first graph))
         ;;[a node] [a list of node] [graph] ==>#t or #f
         ;测试item 是否和l中的所有的node都相通
         (define (test-one item l g)
           (cond
             [(empty? l) #t]
             [else (local
                     ((define result (cons? (find-path item (first l) g))))
                     (and result (test-one item (rest l) g)))]))
         ;;[list of node] [graph]===>#t or #f
         (define (test-all l g)
           (cond
             [(empty? l) #t]
             [else
               (and (test-one (first l) (rest l) g)
                    (test-all (rest l) g))]))
         )
    (test-all lon graph)))

;; (test-on-all-nodes graph)

;; 定义一个带有环的图的例子
(define circle-graph
  '((A (B C))
    (B (C))
    (C (A))))



(define-struct transition [current key next])
(define-struct fsm [initial transitions final])

; A FSM is (make-fsm FSM-State [List-of 1Transition] FSM-State)
; A 1Transition is
;   (make-transition FSM-State 1String FSM-State)
; A FSM-State is String

; data example: see exercise 111
(define fsm-a-bc*-d
  (make-fsm
   "AA"
   (list (make-transition "AA" "a" "BC")
         (make-transition "BC" "b" "BC")
         (make-transition "BC" "c" "BC")
         (make-transition "BC" "d" "DD"))
   "DD"))

;Exercise 450
; [有限状态机][某个序列]====>#t/f
; 如果可以从某一状态到达最终状态则#t,反之#f
(define (fsm-match? fsm str)
  (local(
         ;;将str转换为a list of 1Strings
         (define a-list-of-1Strs
           (explode str))
         ;;[fsm][string]==>#t/f
         ;string于fsm的最终状态是否一致
         (define (meet-end? fsm str)
           (string=? (fsm-final fsm) str))

         ;;[fsm][String][String]==>#t/f
         (define (find-next fsm current key)
           (local((define transitions (fsm-transitions fsm))
                  ;;[transition][String][String]===>#t/f
                  (define (right-key? t current key)
                    (and (string=? current (transition-current t))
                         (string=? key     (transition-key     t))))
                  ;;[list of transition] [String][String]===>[String]
                  ;给出下一个状态
                  (define (find-next ts current key)
                    (cond
                      [(empty? ts) current]
                      [(right-key? (first ts) current key) (transition-next (first ts))]
                      [else (find-next (rest ts) current key)])))
             (find-next transitions current key)))
         ;;[fsm][list of 1strings][string]==>#t/f
         (define (fsm-match fsm lo1s current)
           (cond
             [(meet-end? fsm current) #t]
             [(empty? lo1s) #f]
             [else (fsm-match fsm
                              (rest lo1s)
                              (find-next fsm current (first lo1s)) )]))
         )
    (fsm-match fsm a-list-of-1Strs (fsm-initial fsm) )))

;; (fsm-match? fsm-a-bc*-d "d")


; [List-of X] -> [List-of [List-of X]]
; creates a list of all rearrangements of the items in w
(define (arrangements w)
  (cond
    [(empty? w) '(())]
    [else
      (foldr (lambda (item others)
               (local ((define without-item
                         (arrangements (remove item w)))
                       (define add-item-to-front
                         (map (lambda (a) (cons item a)) without-item)))
                 (append add-item-to-front others)))
        '()
        w)]))

; test
(define (all-words-from-rat? w)
  (and (member (explode "rat") w)
       (member (explode "art") w)
       (member (explode "tar") w)))

;; (arrangements '("a" "b" "c" "d"))
;; (foldr string-append "" '("a" "b" "c"))




;Exercise 453
;判断两个皇后是否可以相互攻击
;[Posn][Posn]==>#t/f
(define (threatening? QP1 QP2)
  (local ((define x1 (posn-x QP1))
          (define x2 (posn-x QP2))
          (define y1 (posn-y QP1))
          (define y2 (posn-y QP2)))
    (cond
      [(or (= x1 x2) (= y1 y2)) #t];在同一行/列
      [(= 1 (/ (abs (- x1 x2)) (abs (- y1 y2)))) #t];在同一斜向上
      [else #f]);其他
    ))

;Exercise 454
;[Number of board][a list of QPs][a image of a queen]==>[a image]
;由给定的参数将queen绘制到棋盘上
(define (render-queens n l i)
  "还未完成")

;Exercise 455
;对于n和一个疑似解判断是否符合要求
(define (n-queens-solution? n loQP)
  (local((define l (length loQP))
         (define (good-posn? p l)
           (cond
             [(empty? l) #t]
             [(threatening? p (first l)) #f]
             [else (good-posn? p (rest l))]))
         (define (good-list? l)
           (cond
             [(empty? l) #t]
             [else (and (good-posn? (first l) (rest l))
                        (good-list? (rest l)))])))
    (if (= l n)
      (good-list? loQP)
      #f)))

;判断两个集合是否相等
;racket似乎提供了这个函数
;; (set=? '(1 2 3 4) '(4 3 2 1))
(define (my-set=? l1 l2)
  (local (
          (define (member? item l)
            (cond
              [(empty? l) #f]
              [(eq? item (first l)) #t]
              [else (member? item (rest l))]))
          (define (find-all-in l1 l2)
            (cond
              [(empty? l1) #t]
              [(member? (first l1) l2) (find-all-in (rest l1) l2)]
              [else #f])))
    (if (= (length l1) (length l2))
      (find-all-in l1 l2)
      #f)))
; N -> Board
; creates the initial n by n board
;; (define (board0 n)
  ;; ..)

; Board QP -> Board
; places a queen at qp on a-board
(define (add-queen a-board qp)
  a-board)

; Board -> [List-of QP]
; finds spots where it is still safe to place a queen
(define (find-open-spots a-board)
  '())

;;[Number]==>#f 或[list of [list of posns]]
(define (queen-question n)
  (local (
          (define (in-board? p)
            (and (<= 0 (posn-x p) (- n 1))
                 (<= 0 (posn-y p) (- n 1))))
          ;;p是否和已有的list中的点冲突?
          (define (ok? l p)
            (cond
              [(empty? l) #t]
              [(threatening? p (first l)) #false]
              [else (ok? (rest l) p)]))
          ;;给出正下方的坐标
          (define (under p)
            (make-posn (posn-x p) (+ 1 (posn-y p))))
          ;将p移动到下一列的第一个位置
          (define (next p)
            (make-posn (+ 1 (posn-x p)) 0))
          ;try 代表当前已有的位置,p[posn],
          (define (try already p)
            (cond
              ;是否还在棋盘内
              [(not (in-board? p)) #f]
              [(and (ok? already p) (= (sub1 n) (length already))) (cons p already)]
              [(ok? already p) (let ([maybe (try (cons p already) (next p))])
                                 (if (cons? maybe)
                                   maybe
                                   (try already (under p))))]
              [else (try already (under p))]
              )))
    (try '() (make-posn 0 0) )))

(queen-question 8)
