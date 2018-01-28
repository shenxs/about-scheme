;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
;#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname learnXML) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t quasiquote repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
#lang racket
(require 2htdp/image)
(require test-engine/racket-tests)
(define SIZE 12)
(define COLOR 'black)
(define BULLET
  (beside (circle 1 'solid 'black) (text " " SIZE COLOR)))

; Image -> Image
; marks item with bullet
(define (bulletize item)
  (beside/align 'center BULLET item))


;判读list中是否为参数
(define (list_of_attributes? x)
  (or (empty? x) (cons? (first x))))

;x->T/F是否是一个word
(define (word? x)
  (and (symbol=? 'word (first x))
       (symbol=? 'text (first (first (second x))))
       (string? (second (first (second x))))))

(define (word-text x)
  (if (word? x)
    (second (first (second x)))
    (error "这不是一个xword")))

(define (xexpr-content xe)
  (local ((define optional-loa+content (rest xe)))
    (cond
      [(empty? optional-loa+content) '() ]
      [else (local ((define may_attributes (first optional-loa+content)))
              (if (list_of_attributes? may_attributes)
                (rest optional-loa+content)
                optional-loa+content))])))

(define (xexpr-attributes xe)
  (local ((define optional-loa+content (rest xe)))
    (cond
      [(empty? optional-loa+content ) '()]
      [else
        (local ((define may_attributes (first optional-loa+content)))
          (if (list_of_attributes? may_attributes)
            may_attributes
            '()))])))


(define (render-enum xe)
  (local ((define content (xexpr-content xe))
          ; XItem.v2 Image -> Image
          (define (deal-with-one-item fst-itm so-far)
            (above/align 'left (render-item fst-itm) so-far)))
    (foldr deal-with-one-item empty-image content)))

(define (render-item an-item)
  (local ((define content (first (xexpr-content an-item))))
    (beside/align
     'center BULLET
     (cond
       [(word? content) (text (word-text content) SIZE 'black)]
       [else (render-enum content)]))))
; XItem.v2 -> Image
; renders one XItem.v2 as an image

(define e0 '(ul ((kk "u")) (li (word ((text "one"))))))
(define e1 '(li (word ((text "one")))))

; XEnum.v2 -> Image
; renders an XEnum.v2 as an image

(check-expect
 (render-enum e0)
 (bulletize (text "one" SIZE COLOR)))


(check-expect
  (render-item e1)
  (bulletize (text "one" SIZE COLOR)))

(render-enum '(ul (li (word ((text "123"))))
                  (li (ul (li (word ((text "456"))))))))
