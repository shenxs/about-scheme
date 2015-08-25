;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |11.3-Lists-in-Lists- Files|) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
;;花式读取文件的函数
;(read-file "ttt.txt")
;(read-lines "ttt.txt")
;(read-words "ttt.txt")
;(read-words/line "ttt.dat")
;(read-words/line "ttt.txt")
;(read-words-and-numbers/line "ttt.txt")

;;测试数据
(define line0 (cons "hello" (cons "world" '())))
(define line1 '())
 
(define lls0 '())
(define lls1 (cons line0 (cons line1 '())))



;; 数出一行有多少单词
(define (count-words line )
  (cond
    [(empty? line) 0]
    [else (+ 1 (count-words (rest line)))]))

; LLS(list of list of string) -> List-of-numbers
; determines the number of words on each line 
(define (words-on-line lls)
  (cond
    [(empty? lls) '()]
    [else (cons (count-words (first lls)) (words-on-line (rest lls)) )]))

(check-expect (words-on-line lls0) '())
(check-expect (words-on-line lls1) (cons 2 (cons 0 '())))

;;lenght 用来计算一个列表的元素个数，靠不早讲
(define (words-on-line.v2 lls)
  (cond
    [(empty? lls) '()]
    [else (cons
            (length (first lls))
            (words-on-line.v2 (rest lls)))]))
(check-expect (words-on-line.v2 lls0) '())
(check-expect (words-on-line.v2 lls1) (cons 2 (cons 0 '())))



; String -> List-of-numbers
;计算出一个文件每一行的单词个数
(define (file-statistic file-name)
  (words-on-line
    (read-words/line file-name)))

;;a line of string-> string
(define (append-a-line l)
  (cond
    [(empty? l) "\n"]
    [else (string-append (first l) " " (append-a-line (rest l)))]))
;;逆read-lines
;;list of string -> string
(define (collapse ll)
 (cond
   [(empty? ll) ""]
   [else (string-append (append-a-line (first ll))  (collapse (rest ll)))]) )
(write-file "ttt.dat" (collapse (read-words/line "ttt.txt")))