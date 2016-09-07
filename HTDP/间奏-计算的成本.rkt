#lang racket

;Exercise 458
;不使用local定义的inf
;inf 的作用和max min差不多
(define (inf l)
  (cond
    [(empty? (rest l)) (first l)]
    [else (if (> (first l) (inf (rest l)))
            (first l)
            (inf (rest l)))]))

;时间消耗为2^n 不要轻易解注下一行代码
;; (inf (range 100))

(define (infL l)
  (cond
    [(empty? (rest l)) (first l)]
    [else (local ((define x (infL (rest l))))
            (if (> (first l) x) (first l) x))]))

;改良版,效率感人
;; (infL (range 100000))

;;number tree
;is one of
;--'()
;-- number
;-- (number-tree '())


;[number tree]==> Number
(define (sum-tree nt)
  (cond
    [(number? nt) nt]
    [(empty? nt) 0]
    [(cons? nt) (+ (sum-tree (first nt)) (sum-tree (rest nt)))]))

;; (sum-tree (list (range 101)))
;; (foldr + 0 (range 101))



(define (searchL x l)
  (cond
    [(empty? l) #false]
    [else
      (or (= (first l) x)
          (searchL x (rest l)))]))
;;length 异常消耗时间
(define (searchS x l)
  (cond
    [(= (length l) 0) #false]
    [else
      (or (= (first l) x)
          (searchS x (rest l)))]))

; N -> [List Boolean Boolean]
; how long do searchS and searchL take
; to look for n in (list 0 ... (- n 1))
(define (timing n)
  (local ((define long-list (build-list n (lambda (x) x))))
    (list
      (time (searchS n long-list))
      (time (searchL n long-list)))))

;; (timing 100000)
