;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |13.3|) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "abstraction.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t write repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "abstraction.rkt" "teachpack" "2htdp")) #f)))

;;写一个贪吃蛇小游戏,哇哈哈
;
;游戏设定
;上下左右控制方向
;碰壁或者蛇咬到自己则游戏结束
;
;;一些固定数据常量
(define MinMove 5);设定最小的移动单位,target只可以出现再5的倍数的坐标上
(define Height (* 40 MinMove))
(define Width (* 40 MinMove))
(define StartPosnOfSnake (make-posn (/ Height 2) (/ Width 2)))
(define R-of-circle 5)
(define Target-color "green")
(define Snake-color "red")
;;图形常量
(define MT (empty-scene Height Width))
(define Target (circle R-of-circle "solid" Target-color))
(define Snake-body (circle R-of-circle "solid" Snake-color))

;;自定义数据类型
;
;(make-snake String (list of posn))
;direction up down left right no
(define-struct snake [direction body])
;(make-game snake Posn);;目标存在
;(make-game snake false);;被蛇吃掉
(define-struct game [snake target])

;;辅助类小函数

;(list of Posn)->img
;参数填(snake-body S) s是snake类型
;将snake放到画布MT上
(define (putSnake body)
  (cond
    [(empty? body) MT]
    [else (place-image
            Snake-body (posn-x (first body)) (posn-y (first body))
            (putSnake (rest body)))]))
;把Target 和snake 都放到MT 上
;game->img
(define (putTarget&Snake g)
  (place-image Target
               (posn-x (game-target g)) (posn-y (game-target g))
               (putSnake (snake-body (game-snake g)))))
;;target ->target
;判断target并给出下一个target
;这里先不做处理
(define (target-next t)
  (cond
    [(posn? t) t]
    [(false? t) (RandomTar 0)]
    [else (error "未知错误")]))
;posn->T/F
;判断一个posn是否在画布内
(define (in-rich? p)
  (if ( and (<= MinMove (posn-x p) Width) (<= MinMove (posn-y p) Height )) true false))

;产生一个不在蛇内的新的点
;list of posn ->Posn
(define (RandomTar a) (make-posn (* (* 2 MinMove) (+ 1 (random 19)))
                                 (* (* 2 MinMove) (+ 1 (random 19)))))
;产生合理的目标,不能是在snake上
(define (acceptTar body)
  (...))

;Posn,Posn, string(方向)-> T/F
;普安段蛇是否吃到目标
(define (rich-target? p1 p2 d)
  (cond
    [(and (string=? "up" d) (= (* 2 MinMove) (- (posn-y p2) (posn-y p1)  )) (= (posn-x p1) (posn-x p2)) ) true]
    [(and (string=? "down" d) (= (* 2 MinMove) (- (posn-y p1) (posn-y p2) )) (= (posn-x p1) (posn-x p2)) ) true]
    [(and (string=? "left" d) (= (* 2 MinMove) (- (posn-x p2) (posn-x p1)  )) (= (posn-y p1) (posn-y p2))) true]
    [(and (string=? "right" d) (= (* 2 MinMove) (- (posn-x p1) (posn-x p2)  )) (= (posn-y p1) (posn-y p2))) true]
    [else false]
    ))
;string ,game ->game
;d----direction
(define (snake-drict-change g d)
  (make-game (make-snake d (snake-body (game-snake g)))
             (game-target g)))
;;list ->list
;去掉列表的最后一个元素
(define (cutLast l)
  (cond
    [(empty? l) '()]
    [(empty? (rest l)) '()]
    [else (cons (first l) (cutLast (rest l)))]))
;;string ,(list of Posn )->(list of Posn)
;根据方向产生新的list
(define (snake-new d body)
  (cons
    (cond
      [(string=? d "up") (make-posn (posn-x (first body)) (- (posn-y (first body)) (* 2 MinMove) ))]
      [(string=? d "down") (make-posn (posn-x (first body)) (+ (* 2 MinMove) (posn-y (first body)) ))]
      [(string=? d "left") (make-posn (- (posn-x (first body))  (* 2 MinMove))  (posn-y (first body)) )]
      [(string=? d "right") (make-posn (+  (* 2 MinMove) (posn-x (first body))) (posn-y (first body)) )])
    (cutLast body)))
;;snake->snake
;根据sanke的direction产生新的snake
;s-----snake
(define (snake-go s)
  (cond
    [(string=? "no" (snake-direction  s)) s]
    [else  (make-snake (snake-direction s) (snake-new (snake-direction s) (snake-body s)))]))

;;主要的event响应函数
;g---game
;k---key

;game->img
(define (drawer g)
  (cond
    [(false? (game-target g)) (putSnake (snake-body (game-snake g))) ]
    [(posn? (game-target g)) (putTarget&Snake g)]
    [else (error "一些没有预想到的情况出现了")]))

;key,game->game
(define (key-hander g k)
  (cond
    [(key=? k "up") (snake-drict-change g "up" )]
    [(key=? k "down") (snake-drict-change g "down" )]
    [(key=? k "left") (snake-drict-change g "left" )]
    [(key=? k "right") (snake-drict-change g "right" )]
    [else g]))

;game->game
;根据snake的方向移动snake
;判断是否有target并生成新的target
(define (time-hander g)
  (cond
    [(and (posn? (game-target g) )
          (rich-target? (game-target g) (first (snake-body (game-snake g))) (snake-direction (game-snake g)) ))
     (make-game (make-snake (snake-direction (game-snake g)) (cons (game-target g) (snake-body (game-snake g)) )) false)]
    [else (make-game (snake-go (game-snake g)) (target-next (game-target g))) ]))
;game->T/F
(define (judger g)
  (cond
    [(not (in-rich? (first (snake-body (game-snake g))))) true]
    [(member? (first (snake-body (game-snake g)))
              (rest (snake-body (game-snake g)))) true]
    [else false]))

;game->img
;
(define (game-over-hander g)
  ( overlay
    (text (string-append "游戏结束,此次得分:" (number->string (- (length (snake-body (game-snake g))) 1))) 12 "black")
    (drawer g)))
;;主函数
(define (main G)
  (big-bang G
            [to-draw drawer]
            [on-key key-hander]
            [on-tick time-hander 0.1 ]
            [stop-when judger game-over-hander]
            ))
(main (make-game (make-snake "no" (list StartPosnOfSnake )) false))
