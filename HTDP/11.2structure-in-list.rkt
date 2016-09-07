;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 11.2structure-in-list) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
(define-struct work [employee rate hour])
(define-struct pay-check [name amount])
(define (wage.v2 w)
  (* (work-rate w) (work-hour w)))

;;list of work -> list of number
(define (wage*.v2 low)
  (cond
    [(empty? low) '()]
    [else (cons
           (make-pay-check (work-employee (first low)) (wage.v2 (first low)) )
           (wage*.v2 (rest low)))]))

(wage*.v2 (cons (make-work "mike" 12.3 19) (cons (make-work "Tina" 100 100) '())))
;;list of posn -> number
;;sum the posn-x
(define (sum l)
  (cond
    [(empty? l) 0]
    [(cons? l) (+ (posn-x (first l)) (sum (rest l)))]))


(check-expect (sum (cons (make-posn 1 2) (cons (make-posn 3 4) '()))) 4)
;;list of posn -> list of posn
;;(make-posn x y)-> (make-posn x (+ y 1))
(define (translate lop)
  (cond
    [(empty? lop) '()]
    [(cons? lop) (cons
                  (make-posn (posn-x (first lop))
                             (+ 1 (posn-x (first lop))))
                  (translate (rest lop)))]))

(define-struct phone [area switch four])

;;a list of phone
;;replace area 713 with 281
(define (foo p)
  (make-phone
   (if (= (phone-area p) 713 ) 281 (phone-area p))
   (phone-switch p)
   (phone-four p)))
(define (replace lop)
  (cond
    [(empty? lop) '()]
    [(cons? lop) (cons (foo (first lop))
                       (replace (rest lop)))]))

