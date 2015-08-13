;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ufo-land) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t write repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")))))
; WorldState is a Number
; interpretation height of UFO (from top)

; constants:
(define WIDTH 300)
(define HEIGHT 100)
(define CLOSE (/ HEIGHT 3))

; visual constants:
(define MT (empty-scene WIDTH HEIGHT))


(define UFO
  (overlay (circle 10 "solid" "green")
           (rectangle 40 2 "solid" "green")))

; WorldState -> WorldState
(define (main y0)
  (big-bang y0
     [on-tick nxt ]
     [to-draw render]
     [stop-when touch]))

; WorldState -> WorldState
; computes next location of UFO
(define (nxt y)
  (+ y 1))

; WorldState -> Image
; place UFO at given height into the center of MT

(define (render y)
 (place-image (text (lable y) 12 "indigo")  (/ WIDTH 2) 10 (place-image UFO (/ WIDTH 2) y MT)))

(define (touch y0) (if (> (+ y0 0) HEIGHT) true false))

(define (lable y0) (cond [(< y0 CLOSE) "descending"] [(and (>= y0 CLOSE) (< y0 HEIGHT)) "closing in"] [(>= y0 HEIGHT) "landed"]))

(main 0)
