;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname happiness-gauge) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")))))
;;最小0，，最大100
;;时间触发函输每秒减少0.1
;;number->number
;;give 100 expect 99.5
;;give 0.01 expect 0
(define (decrease-0.5 x)(if (>= x 0.1) (- x 0.1) 0 ))
;;
(define (increase-1/5 x) (if (<= (+ x (* x 1/5)) 100) (+ x (* x 1/5)) 100))
;;
(define (jump-1/3 x) (if (> (- x (* x 1/3)) 0 ) (- x (* x 1/3)) 0) )

;;number->string
;;give 50 expect "开心指数：50"
(define (happy x) (string-append "开心:" (number->string x) ))
(define (scene x)(
        cond
             [(= x 100) (rectangle 300 61.8 'solid 'red)]
             [(= x 0) (rectangle 300 61.8 'outline 'black)]
             [else (overlay  (rectangle 300 61.8  'outline 'black) (rectangle 300 61.8  'solid 'red) )]))

(define (display x) (overlay (text (happy x) 24 'indigo) (scene x)))
(define (key-event x a-key) (cond
                            [(key=? a-key "up" ) (increase-1/5 x)]
                            [(key=? a-key "down" ) (jump-1/3 x)]
                            [else x]))
(define (main x)
  (big-bang x
            [to-draw display]
            [on-tick decrease-0.5 1]
            [on-key key-event]))

(main 100)