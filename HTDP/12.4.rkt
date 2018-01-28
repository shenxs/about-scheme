;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |12.4|) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define MT (empty-scene 50 50))

;polygon->image
;将一个多边形变成一个图形
(define (lineRender im p q)
  (scene+line im
              (posn-x p) (posn-y p) (posn-x q) (posn-y q) "red"))
;;找到poly的最后一个节点
(define (findLast p)
  (cond
    [(empty? (rest p)) (first p)]
    [else (findLast (rest p))]))
;;pre 是从第一个到最后一个的图像
;pre的基础上加上最后到第一个的线
(define (last2first p pre)
  (lineRender pre (first p) (findLast p)))
;;从第一个画到最后一个点
(define (first2last p)
  (cond
    [(empty? (rest p)) MT]
    [else (lineRender (first2last (rest p)) (first p) (first (rest p)))]))

(define (poly-render p)
    (cond
      [(< (length p) 3) (error "至少要有三个点") ]
      [else (last2first p (first2last p))]) )
(define (X a) (poly-render (list (make-posn 0 0) (make-posn 50 0) (make-posn 25 25 )(make-posn 50 50) (make-posn 0 50) (make-posn 25 25) )) )
(big-bang 0
          [to-draw X])
