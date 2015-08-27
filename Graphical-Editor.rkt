;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname Graphical-Editor) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "abstraction.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "abstraction.rkt" "teachpack" "2htdp")) #f)))
(define-struct editor [pre post])
;An editor is (make-editor Los1S Los1S)
;An Los1S is one of ;
;- empty
;- (cons 1string Los1S)

;测试数据
(define string1 (cons "c" (cons "b" (cons "a" '()))) )
;add a at the end of list l
;'("b" '()) "a"  -> '("b" "a" '())
(define (add-at-end l a)
  (cond
    [(empty? l) (cons a '())]
    [else (cons (first l) (add-at-end (rest l) a ) )]))
;Los1S->Los1S
;字符串取反
(define (rev l)
  (cond
    [(empty? l) '()]
    [else (add-at-end (rev (rest l)) (first l) ) ]))

;(rev string1)

;constans
(define HEIGHT 20)
(define WIDTH 200)
(define FONT-SIZE 16)
(define FONT-COLOR "black")

; Graphical constans
(define MT (empty-scene WIDTH HEIGHT))
(define CURSOR (rectangle 1 HEIGHT "solid" "red"))

;string->Los1S
(define (Str->Los1S str)
  (cond
    [(string=? str "") '()]
    [(= 1 (string-length str)) (cons str '())]
    [else (cons (substring str 0 1 ) (Str->Los1S (substring str 1 (string-length str ))))]))
;string,string-> editor
(define (create-editor pre post)
  (make-editor (rev (Str->Los1S pre)) (Str->Los1S post)))

;Editor -> image
;把 editor 变成中间有光标的图像
(define (editor-render e)
  ...)

;string-> T/F
;判断一个字符串是否长度为1
(define (1string? str)
  (if (=  1 (string-length str)) true false))
;editor key -> editor
;对键盘事件做出响应
(define (key-render e k)
  (cond
    [(1string? k) (make-editor (cons k (editor-pre e)) (editor-post e))]))

(check-expect (key-render (create-editor "" "") "e")
              (create-editor "e" ""))

(define (main s)
  (big-bang (create-editor s "")
    [to-draw editor-render]
    [on-key key-render]))
