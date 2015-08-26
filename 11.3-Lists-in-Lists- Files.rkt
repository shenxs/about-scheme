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
(define (count-words-line line )
  (cond
    [(empty? line) 0]
    [else (+ 1 (count-words-line (rest line)))]))

; LLS(list of list of string) -> List-of-numbers
; determines the number of words on each line 
(define (words-on-line lls)
  (cond
    [(empty? lls) '()]
    [else (cons (count-words-line (first lls)) (words-on-line (rest lls)) )]))

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
;;list of list string -> string
(define (collapse ll)
 (cond
   [(empty? ll) ""]
   [else (string-append (append-a-line (first ll))  (collapse (rest ll)))]) )
;;(write-file "ttt.dat" (collapse (read-words/line "ttt.txt")))


;;remove specific artical
(define (append-a-line.v2 l)
  (cond
    [(empty? l) "\n"]
    [(string=? "a" (first l)) (append-a-line.v2 (rest l)) ]
    [(string=? "an" (first l)) (append-a-line.v2 (rest l)) ]
    [(string=? "the" (first l)) (append-a-line.v2 (rest l)) ]
    [else (string-append (first l) " " (append-a-line.v2 (rest l)))]))
;;lls->no-artical lls
(define (remove-artical lls)
  (cond
    [(empty? lls) ""]
    [else (string-append (append-a-line.v2 (first lls)) (remove-artical (rest lls)))]))



;;filename-> no-artical-filename
;;remove-all specific artical

(define (no-artical n)
  (write-file
   (string-append "no-artical-" n)
   (remove-artical (read-words/line n))))
;(no-artical "ttt.dat")


(check-expect (string->int " ") 32)
;;letter -> ascii字符串
(define (code1 s)
  (number->string(string->int s)))

;;letter -> 三位数字的字符串
(define (encode-letter s)
  (cond
    [(< (string->int s) 10 ) (string-append "00" (code1 s))]
    [(< (string->int s) 100 ) (string-append "0" (code1 s))]
    [else (code1 s)]
    ))
;;string->T/F
;;决定一个字符是否为单字符
(define (1string? s)
  (if (= (string-length s) 1) true false))
;;lw->number
;;how many 1string in the list of words
(define (count-1string lw)
  (cond
    [(empty? lw) 0]
    [else
     (+   (if (1string? (first lw)) 1 0)   (count-1string (rest lw)))]))


;;a file -> count the number of 1Strings, words, and lines
;;练习175
(define (foo175 n)
  (cons (count-1string (read-words n))
        (cons (length (read-words n))
              (cons (length (read-lines n)) '()))))

(foo175 "no-artical-ttt.dat")
(foo175 "ttt.txt")