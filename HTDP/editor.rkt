;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname editor) (read-case-sensitive #t) (teachpacks ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp")))))
;;Editor = (make-editor string string )
(define-struct editor [pre post])
;;定义背景的长和宽
(define CANVAS-HEIGHT 40)
(define CANVAS-WIDTH 400)
(define CURSOR-WIDTH 1)
;;editor->image
;;将editor中的文字内容转换成有光标的图像
(define (render edt)
  (overlay/align "left" "center"
   (beside
         (text (editor-pre edt) 24 "olive")
         (rectangle CURSOR-WIDTH 24 "solid" "red")
         (text (editor-post edt) 24 "olive"))
   (empty-scene CANVAS-WIDTH CANVAS-HEIGHT)))
;;editor->image
;;不包括背景empty-scene
(define (editor-image edt)
 ( beside
         (text (editor-pre edt) 24 "olive")
         (rectangle CURSOR-WIDTH 24 "solid" "red")
         (text (editor-post edt) 24 "olive")))
;;string->string
;;去掉字符串最后一个字符true
;;字符串至少要有一个字符
(define (string-remove-last str)
  (substring str 0 (- (string-length str) 1)))
;;string->string
;;get the last char of the string
(define (string-get-last str)
  (substring str  (- (string-length str) 1)    (string-length str)))
;;string->string
;;去掉字符串的第一个字
;;字符串的长度至少为1
(define (string-remove-first str)
 (substring str 1 (string-length str) ))
;;string->T/F
;;判断一个字符串的长度是不是一
(define (1string? str)
  (if (= 1 (string-length str)) true false))
;;editor->editor
;;将editor的光标向右移动，若到达最右边则不再移动
(define (editor-right edt)
  (if (= (string-length (editor-post edt) ) 0)
     edt
  (make-editor
   (string-append  (editor-pre edt) (substring (editor-post edt ) 0 1 ))
   (substring (editor-post edt) 1 (string-length (editor-post edt))))))
;;editor->editor
;;将光标向左移动，若至最左则停
(define (editor-left edt)
  (if (= (string-length (editor-pre edt) ) 0)
     edt
  (make-editor
   (substring (editor-pre edt) 0 (- (string-length (editor-pre edt)) 1))
   (string-append (string-get-last (editor-pre edt)) (editor-post edt)))))
;;editor,key ->editor
;;向editor中添加一个字符，实际上是添加了对应key的字符串
(define (editor-add edt k)
  (make-editor (string-append (editor-pre edt) k) (editor-post edt)))
;;string->string
;;删除光标前的一个字母
;;backspace
(define (editor-back edt)
 ( if (string=? "" (editor-pre edt))
  edt
  (make-editor (string-remove-last (editor-pre edt)) (editor-post edt))))
;;editor->editor
;;editor-delete 将post的第一个字符删除
(define (editor-delete edt)
  (make-editor (editor-pre edt)
              (if (string=? "" (editor-post edt)) "" (string-remove-first (editor-post edt)))))
;;editor->T/F
;;决定editor是否已经满
(define (editor-can-add? edt)
  (if  (> (image-width (editor-image edt)) CANVAS-WIDTH) false true) )
;;editor ,key->editor
;;key-event   hander
(define (edit edt k)
  (cond
    [(key=? k "left") (editor-left edt)]
    [(key=? k "right") (editor-right edt)]
    [(key=? k "\b") (editor-back edt)]
    [ (key=? k "\u007F") (editor-delete edt)]
    [(or (key=? k "\r") ( key=? k "\t")) edt]
    [(and (1string? k) (editor-can-add? edt)) (editor-add edt k)]
    [else edt]))

(define (run pre)
(big-bang (make-editor pre "")
         [on-draw render]
         [on-key edit])  )
(run "Hello World")
