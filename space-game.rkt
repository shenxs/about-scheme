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
(define Tank-Vel 4)
(define Missile-Vel 10)
(define Ufo-Vel 4)
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
  (if (and (< (posn-x p) Width) (< (posn-y p) Height)) true false))

(define (creat-random-number n)
  (+ n (* (random 5) (if (odd? (random 10)) 1 -1) )))
;;ufo->ufo
(define (ufo-next u)
  (make-posn (creat-random-number (posn-x u))
             (+ (posn-y u) Ufo-Vel) ))
(define (missile-next mis)
  (cond
    [(posn? mis) (make-posn (posn-x mis) (- (posn-y mis) Missile-Vel))]
    [else mis]))
;;state->state
(define (time-hander s)
  (make-game (ufo-next (game-ufo s))
             (make-tank (+ (tank-loc (game-tank s)) (tank-vel (game-tank s)) ) (tank-vel (game-tank s))  )
             (missile-next (game-missile s))))
;;//////////////////////
;;主函数定义
(define (run asd)
  (big-bang (make-game (make-posn (/ Width 2) 0) (make-tank 0 4) false )
   [to-draw drawer]
  ;; [on-key ...]
   [on-tick time-hander  0.1]
   [stop-when stop-render]
   ))
(run 1)