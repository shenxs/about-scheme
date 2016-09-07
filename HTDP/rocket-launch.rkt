;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname rocket-launch) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t write repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")))))
;;物理设定
(define HEIGHT 300)
(define WIDTH 100)
(define YDELTA 3);;

;;图片常量
(define BACKG (empty-scene WIDTH HEIGHT));;背景
(define ROCKET (rectangle 5 30 "solid" "red"))
(define ROCKET-CENTER (/ (image-height ROCKET) 2))
(define X-ROCKET (/ WIDTH 2))

(define (place-rocket y)
  (place-image ROCKET X-ROCKET y BACKG))

(define (show x)
  (cond
    [(string? x)
     (place-rocket  (- HEIGHT ROCKET-CENTER))]
    [(<= -3 x -1)
     (place-image (text (number->string x) 20 "red")
                  10 (* 3/4 WIDTH)
                   (place-rocket (- HEIGHT ROCKET-CENTER) ))]
    [(>= x 0)
     (place-rocket (- HEIGHT x ROCKET-CENTER) )]))

(define (launch x ke)
  (cond
    [(string? x)
     (if (string=? " " ke) -3 x)]
    [(<= -3 x -1) x ]
    [(>= x 0) x]))

(define (fly x)
(cond
    [(string? x) x]
    [(<= -3 x -1) (+ x 1)]
    [(>= x 0) (+ x YDELTA)]))
(define (stop x)
  (cond
    [(string? x) false]
    [(>= x HEIGHT) true]
    [else false]))

(define (main s)
  (big-bang s 
    [to-draw show]
    [on-key launch]
    [on-tick fly ]
    [stop-when stop]))

(main "resting")