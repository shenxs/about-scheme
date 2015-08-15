;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname space-game) (read-case-sensitive #t) (teachpacks ((lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp")) #f)))
;;///////////////////////////////////////
;;常量和类型定义
(define Height 300)
(define Width 200)
(define Tank-Height 10)
(define Tank-Width 40)
(define Background (empty-scene Width Height))
(define Ufo
  (overlay
   (circle 5 "solid"  "green")
   (rectangle 30 3 "solid" "green") ))
(define Tank (rectangle Tank-Width Tank-Height "solid" "blue"))
(define Missile (triangle 10 "solid" "red"))
(define Tank-Vel 2)
(define Missile-Vel 10)
(define Ufo-Vel 1)
(define Judge-Distance 10)
;;(make-game Posn tank Posn/false)
(define-struct game [ufo tank missile])
;;(make-tank x v)
;;x轴的位置，v-》速度
;;(make-tank number number)
(define-struct tank [loc vel])
;;////////////////////////////////////////////////
;;辅助函数定义

;;missile->image
;;Posn->将missile加到背景
;;false-》直接返回background
(define (missile-render mis)
  (cond
    [(posn? mis) (place-image Missile (posn-x mis) (posn-y mis) Background ) ]
    [else Background]))

;;SIGS->Image
;;将Tank,ufo,可能也有missile加到background上
(define (drawer s)
  (place-images
   (list Ufo Tank)
   (list (game-ufo s)
         (make-posn (tank-loc (game-tank s)) (- Height (/ Tank-Height 2))))
   (missile-render (game-missile s))))

;;posn->T/F
;;确定posn是否在画布内，是否超出画布
;;超出->false,没超出->true
(define (in-rich? p)
  (if (and (<= 0 (posn-x p) Width) (<= 0 (posn-y p) Height) ) true false))
;;number->number
;;产生一个在n左右为5的平均数
(define (creat-random-number n)
  (+ n (* (random 5) (if (odd? (random 10)) 1 -1) )))
;;posn,posn->number
;;计算两个点之间的距离
(define (distance p1 p2)
  (sqrt (+
         (* (- (posn-x p1) (posn-x p2)) (- (posn-x p1) (posn-x p2)))
         (* (- (posn-y p1) (posn-y p2)) (- (posn-y p1) (posn-y p2))))))


;;ufo->ufo
(define (ufo-next u)
  (make-posn (creat-random-number (posn-x u))
             (+ (posn-y u) Ufo-Vel) ))
;;posn->posn/false
;;如果在范围内就在y坐标减去速度，如果超出范围则改为false
(define (missile-next mis)
  (cond
    [(posn? mis)
     (if (in-rich? mis )
         (make-posn (posn-x mis) (- (posn-y mis) Missile-Vel) )
         false)
     ]
    [else mis]))
;;tank-tank
(define (tank-next-bytime t)
  (make-tank
   (+ (tank-loc t) (tank-vel t))
   (cond [(< (tank-loc t) 0) Tank-Vel]
         [(> (tank-loc t) Width) (* -1 Tank-Vel)]
         [else (tank-vel t)])))

(define (tank-next-bykey tank key)
  (make-tank (tank-loc tank)
             (cond
               [(key=? key "left") (* -1 Tank-Vel)]
               [(key=? key "right") Tank-Vel]
               [else (tank-vel tank)])))
(define (missile-next-by-key tank mis key )
   (cond
     [(and (not (posn? mis)) (key=? key " ")) (make-posn (tank-loc tank) (- Height Tank-Height))]
     [else mis]))
;;state->state
(define (time-hander s)
  (make-game (ufo-next (game-ufo s))
             (tank-next-bytime (game-tank s))
             (missile-next (game-missile s))))
;;state->state
(define (key-hander g k)
  (make-game (game-ufo g)
             (tank-next-bykey (game-tank g) k )
             (missile-next-by-key  (game-tank g) (game-missile g) k)))

(define (stop-render g)
  (cond
    [(not (in-rich? (game-ufo g))) true]
    [(and (posn? (game-missile g)) (< (distance (game-ufo g) (game-missile g)) Judge-Distance)) true]
    [else false]))
(define (judge g)
  (cond
    [(not (in-rich? (game-ufo g)))
     (overlay (text "Game Over" 24 "red") (drawer g))]
    [(and (posn? (game-missile g)) (< (distance (game-ufo g) (game-missile g)) Judge-Distance))
     (overlay (text "You Win" 24 "indigo") (drawer g))]))
;;//////////////////////
;;主函数定义
(define (run asd)
  (big-bang (make-game (make-posn (/ Width 2) 0) (make-tank 0 Tank-Vel) false )
   [to-draw drawer]
   [on-key key-hander]
   [on-tick time-hander  ]
   [stop-when stop-render judge]
   ))
(run 1)