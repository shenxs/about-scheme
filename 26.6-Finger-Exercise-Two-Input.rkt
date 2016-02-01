#lang racket
(require 2htdp/batch-io
         2htdp/image
         2htdp/universe)
;[a sorted list of number] [as before] ====>[a sorted list of number]


;Exercise 378
(define (merge l1 l2)
  (cond
    [(empty? l1) l2]
    [(empty? l2) l1]
    [(< (first l1) (first l2)) (cons (first l1) (merge (rest l1) l2) )]
    [else (cons (first l2) (merge l1 (rest l2)))]))

;; (merge '(1 2 3 4) '(1 2 3 4 9 9))

;Exercise 379
;[a list] Number ===> remove the NO.n list

(define (drop l n)
  (cond
    [(empty? l) (error 'l "too short")]
    [(> n 0) (cons (first l) (drop (rest l) (sub1 n)))]
    [(= n 0) (rest l)]
    [else (error 'n "小于0")]))

;; (drop '(a b c d e) 2)


(define (take l n)
  (cond
    [(empty? l) (error 'l "too short")]
    [(> n 0) (cons (first l) (take (rest l) (sub1 n)))]
    [(= n 0) '()]
    [else (error 'n "小于0")]))

;; (take '(a b c d e f) 2)


;;这会是一个叫做吊死鬼的游戏
(define DICTIONARY-LOCATION "/usr/share/dict/words")
(define DICTIONARY-AS-LIST (read-lines DICTIONARY-LOCATION))
(define DICTIONARY-SIZE (length DICTIONARY-AS-LIST))
;; DICTIONARY-SIZE

(define (explode str)
  (local ((define l (string-length str)))
    (cond
      [(= l 0) '()]
      [else (cons (substring str 0 1)
                  (explode (substring str 1 l)))])))

(define (member? ke l)
  (cond
    [(empty? l) #f]
    [(equal? ke (first l)) #t]
    [else (member? ke (rest l))]))


(define (implode l)
  (cond
    [(empty? l) ""]
    [else (string-append (first l) (implode (rest l)))]))

(define LETTERS (explode "abcdefghijklmnopqrstuvwxyz'"))

; A HM-Word is [List-of [Maybe Letter]]
; interpretation #false represents a letter to be guessed
; A Letter is member? of LETTERS.

; HM-Word N -> String
; run a simplistic Hangman game, produce the current state of the game
; assume the-pick does not contain #false
(define (play the-pick time-limit)
  (local ((define the-word  (explode the-pick))
          (define the-guess (make-list (length the-word) #false))

          ; HM-Word -> HM-Word
          (define (do-nothing s) s)

          ; HM-Word KeyEvent -> HM-Word
          (define (checked-compare current-status ke)
            (if (member? ke LETTERS)
                (compare-word the-word current-status ke)
                current-status)))

    ; the state of the game is a HM-Word

    (implode
     (big-bang the-guess
       [to-draw render-word]
       [on-tick do-nothing 1 time-limit]
       [on-key  checked-compare]))))

; HM-Word -> Image
; render the word, using "_" for places that are #false
(define (render-word w)
  (local ((define l (map (lambda (lt) (if (boolean? lt) "_" lt)) w))
          (define s (implode l)))
    (text s 22 "black")))

;;[list of String] [list of String/#false] String ====>[list of String/#f]
;;第一个list中是所有的字母
;第二个是#f 和已经猜到的字母
;key 对应的按键
(define (compare-word word guess key)
  (local((define (right-key? right current k)
           (if (and (string=? right k)
                    (false? current))
             #t
             #f)))
    ;-----IN---
    (cond
      [(empty? word) '()]
      [(right-key? (first word) (first guess) key) (cons key (rest guess))]
      [else (cons (first guess) (compare-word (rest word) (rest guess) key))])
    ))


;; (play (list-ref DICTIONARY-AS-LIST (random DICTIONARY-SIZE)) 100)

;Exercise 381
;略
;Exercise 382

(define (value l1 l2)
  (cond
    [(empty? l1) 0]
    [else (+ (* (first l1) (first l2))
             (value (rest l1) (rest l2)))]))

;Exerciser 383
;从列表中随机取出一个item
(define (random-pick l)
  (local ((define chang (length l)))
    (list-ref l (random chang))))

;; (random-pick '(a s d f g h j k l))


(define (non-same names ll)
  (cond
    [(empty? ll) '()]
    [else (cons
            (if (equal? names (first ll))
              '()
              (first ll))
            (non-same names (rest ll)))]))
