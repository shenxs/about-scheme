;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 11.1用函数生成列表) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
(define (wage h)
  (cond
    [(> h 100) (error "工作时间不得超过100小时")]
    [else (* 12 h)]))

(define (wage* l)
  (cond
    [(empty? (rest l)) (cons (wage (first l)) '())]
    [(cons? l) (cons (wage (first l)) (wage* (rest l)))]))

;;华氏度转化为摄氏度
(define (convertFC f)
  (* 5/9 (- f 32)))
(define (convertFC* l)
  (cond
    [(empty? (rest l)) (cons (convertFC (first l)) '())]
    [(cons? l) (cons (convertFC (first l)) (convertFC* (rest l)))]
    [else (error "ERROR")]))

;;美元转化为欧元，2015/8/23   汇率0.8781
(define (convert-euro US)
  (* US 0.8781))
(define (convert-euro* l)
  (cond
    [(empty? (rest l)) (cons (convert-euro (first l)) '())]
    [(cons? l) (cons (convert-euro (first l)) (convert-euro (rest l)))]
    [else (error "ERROR")]))

;;将一组字符串中的robot改为r2d2

(define (subst-robot l)
  (cond
    [(empty? l) '()]
    [else (if
           (string=? "robot" (first l))
           (cons "r2d2" (subst-robot (rest l)))
           (cons (first l) (subst-robot (rest l))))]))
