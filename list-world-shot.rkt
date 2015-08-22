;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname list-world-shot) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
;;物理常量
(define Height 80)
(define Width 100)
(define Xshots (/ Width 2))

;;图片常量
(define Background (empty-scene Width Height))
(define Shot (triangle 6 "solid" "red"))

;;a list of shot is one of
;-'()
;-(cons shot list-of-shots)

;posn->T/F
;decide wheather a posn is in the canvas or not
(define (in-rich? p)
  (if (and (<= 0 (posn-x p) Width) (<= 0 (posn-y p) Height)) true false))
(define (key-hander l k)
  (cond
    [(key=? " " k) (cons (make-posn Xshots Height) l)]
    [else l]))

(define (drawer l)
  (cond
    [(empty? l)
     Background]
    [(cons? l)
     (place-image Shot (posn-x (first l)) (posn-y (first l)) (drawer (rest l)) )]
    [else
     l]))

(define (time-hander l)
  (cond
    [(empty? l) '()]
    [(cons? l)
     (if (in-rich? (first l))
         (cons (make-posn Xshots (sub1 (posn-y (first l)))) (time-hander (rest l)))
         (time-hander (rest l)))]
    [else l]))

(define (main l)
  (big-bang l
            [to-draw drawer]
            [on-key key-hander]
            [on-tick time-hander]
            ))
(main '())