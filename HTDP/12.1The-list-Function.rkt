;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 12.1The-list-Function) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "abstraction.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "abstraction.rkt" "teachpack" "2htdp")) #f)))
;exercise 181
(check-expect (cons "a" (cons "b" (cons "c" (cons "d" (cons "e" '())))))
              (list "a" "b" "c" "d" "e"))
(check-expect (cons (cons 1 (cons 2 '())) '())
              (list (list 1 2)))
(check-expect (cons "a" (cons (cons 1 '()) (cons #false '())))
              (list "a" (list 1) false))
(check-expect (cons (cons 1 (cons 2 '())) (cons (cons 2 '()) '()))
              (list (list 1 2) (list 2)))
(check-expect (cons (cons "a" (cons 2 '())) (cons "hello" '()))
              (list (list "a" 2) "hello"))

;excercise 182
(check-expect (list 0 1 2 3 4 5)
              (cons 0 (cons 1 (cons 2 (cons 3 (cons 4 (cons 5 '())))))))
(check-expect (list (list "adam" 0) (list "eve" 1) (list "louisXIV" 2))
              (cons (cons "adam" (cons 0 '())) (cons (cons "eve" (cons 1 '())) (cons (cons "louisXIV" (cons 2 '())) '())) ))
(check-expect (list 1 (list 1 2) (list 1 2 3))
              (cons 1 (cons (cons 1 (cons 2 '())) (cons (cons 1 (cons 2 (cons 3 '()))) '()))))

;excercise 183
(check-expect (cons "a" (list 0 #false))
              (cons "a" (cons 0 (cons false '()))))
(check-expect (list (cons 1 (cons 13 '())))
              (cons (cons 1 (cons 13 '())) '()))
(check-expect (cons (list 1 (list 13 '())) '())
              (cons (cons 1 (cons (cons 13 (cons '() '())) '())) '()))

(check-expect (list '() '() (cons 1 '()))
              (cons '()
                    (cons '()
                          (cons (cons 1 '()) '()))))

(check-expect (cons "a" (cons (list 1) (list #false '())))
              (cons "a"
                    (cons (cons 1 '()) (cons false (cons '() '())))))