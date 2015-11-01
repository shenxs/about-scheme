#lang racket
;Exercise 315
;列出一些用户经常会问的关于文件夹的问题
;文件名是什么?
;这个文件夹有多大?
;这个文件夹在哪里?
;文件夹里面有有什么?
;文件夹的所有者是谁?


;Model1
;; A Dir.v1 (short for directory) is one of:
; – '()
; – (cons File.v1 Dir.v1)
; – (cons Dir.v1 Dir.v1)
; A File.v1 is a Symbol.

;Exercise 316
;(cons 'file (cons 'file2 '() )))))


;Exercise 317

(define (how-many dir)
  (cond
    [(empty? dir) 0]
    [(symbol? dir) 1]
    [else (+ (how-many (first dir)) (how-many (rest dir)))]))

;(how-many (cons 'flie1 (cons 'file2 (cons 'file3 '()))))


;现在我们就要细化我们的模型啦
;Molde2

(define-struct dir [name content])

;所以我们的模型就便成
;; A Dir.v2 is a structure:
;   (make-dir Symbol LOFD)

; A LOFD (short for list of files and directories) is one of:
; – '()
; – (cons File.v2 LOFD)
; – (cons Dir.v2 LOFD)

; A File.v2 is a Symbol.

;Exercise 318
;model2 设计数据例子
(define dir-tree.v2
  (make-dir 'd (list 'file1 'file2 (make-dir 'dir2-name (list 'file3)) 'filename )))

(define (how-many.v2 d)
  (local(
         (define (count-content c)
           (cond
             [(empty? c) 0]
             [(symbol? c) 1]
             [(dir? c ) (how-many.v2 c)]
             [else (+ (count-content (first c)) (count-content (rest c)))]))
         )
    (count-content (dir-content d))))

;(how-many.v2 dir-tree.v2)
