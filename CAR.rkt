;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname CAR) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")))))
(define WIDTH-OF-WORLD 400)
(define WHEEL-RADIUS 5)
(define WHEEL-DISTANCE (* WHEEL-RADIUS 3))
(define WHEEL (circle WHEEL-RADIUS 'solid 'black))
(define SPACE (rectangle WHEEL-DISTANCE WHEEL-RADIUS 'solid 'white))
(define BOTH-WHEEL (beside WHEEL SPACE WHEEL))
(define CAR-BODY1 (rectangle (* WHEEL-RADIUS 5) WHEEL-RADIUS 'solid 'red))
(define CAR-BODY2 (rectangle (* WHEEL-RADIUS 9) (* WHEEL-RADIUS 2) 'solid 'red))
(define CAR-BODY (above CAR-BODY1 CAR-BODY2))
(define CAR (underlay/xy CAR-BODY WHEEL-RADIUS (* 2 WHEEL-RADIUS) BOTH-WHEEL))
(define tree
  (underlay/xy (circle 10 'solid  'green)
              9 15
              (rectangle 2 20 'solid 'brown)))
; WorldState Number Number String -> WorldState
; places the car at the x coordinate if me is "button-down" 
(define (hyper x-position-of-car x-mouse y-mouse me)
  (cond
    [(string=? "button-down" me) x-mouse]
    [else x-position-of-car]))
(define BACKGROUND (empty-scene  WIDTH-OF-WORLD (* 10 WHEEL-RADIUS)))
(define (render x) (underlay/xy BACKGROUND x (+ (* WHEEL-RADIUS (sin x)) (* 3 WHEEL-RADIUS)) CAR))
(define (tock ws)
  (+ ws 3))
(define (smaller? ws) (>= ws WIDTH-OF-WORLD))
(define (main ws)
  (big-bang ws
        [on-tick tock]
        [to-draw render]
        [stop-when smaller?]
        [on-mouse hyper]))

(main 0)
