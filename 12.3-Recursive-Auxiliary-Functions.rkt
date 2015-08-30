;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 12.3-Recursive-Auxiliary-Functions) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;n ,list of number -> list of number
;将n插入到alon中,要求n>=它右边的数字
(define (insert n alon)
  (cond
    [(empty? alon) (cons n alon)]
    [else (if (>= n (first alon))
            (cons n alon )
            (cons (first alon) (insert n (rest alon) )))]))


;list of number ->list of number
;对一列数字进行排序
(define (sort> alon)
  (cond
    [(empty? alon) '()]
    [else (insert (first alon) (sort> (rest alon)))]))
;(sort> (list 9 9 9 9 9 9 9 9 ))

;;exercise 187
;a program that sort list of email message by date
;............................................ name

(define-struct email [from date message])
;;(make-email stirng number string)


;;insert email by date
(define (insert-email e aloe)
  (cond
    [(empty? aloe)(cons e '())]
    [else (if (>= (email-date e) (email-date (first aloe)))
            (cons e aloe)
            (cons (first aloe) (insert-email e (rest aloe))))]))


;;aloe->a sorted list of email by date

(define (sort-email aloe)
  (cond
    [(empty? aloe) '()]
    [else (insert-email (first aloe) (sort-email (rest aloe)))]))

;;insert email by name
(define (insert-name e aloe)
  (cond
    [(empty? aloe) '()]
    [else (if (string<? (email-from e) (email-from (first aloe)))
            (cons e aloe)
            (cons (first aloe) (insert-name e (rest aloe))))]))

(define (sort-name aloe)
  (cond
    [(empty? aloe) '()]
    [else (insert-name (first aloe) (sort-name (rest aloe)) )]))


;;exercise 188
;sort game player by scores

(define-struct game-player [name score])
;;(make-game-player string number)

;;game player, a list of player->a list of player
(define (insert-player p alop)
  (cond
    [(empty? alop) (cons p alop)]
    [else (if (>= (game-player-score p) (game-player-score (first alop)))
            (cons p alop)
            (cons (first alop) (insert-player p (rest alop))))]))

(define (sort>player alop)
  (cond
    [(empty? alop) '()]
    [else (insert-player (first alop) (sort>player (rest alop)))]))



;;exercise 189
;search-sorted ,quickly find a number in a sorted list of number

;number,alon->T/F
;判断一个数字是否存在在一个从大到小的链表里
(define (search-sorted n alon)
  (cond
    [(empty? alon) false]
    [(= n (first alon)) true]
    [(> n (first alon)) false]
    [(< n (first alon)) (search-sorted n (rest alon))]))
;(search-sorted 3 (list 9 9  2 1))

;exercise 190
;得到一个列表所有的前缀子列表
;
(define (prefix l)
  (cond
    [(empty? l) '()]
    [else (cons l (prefix (reverse (rest (reverse l)))))]))


;;suffix
;后缀子列表
(define (suffix l)
  (cond
    [(empty? l) '()]
    [else (cons l (suffix (rest l)))]))
;(prefix (list 1 2 3 4 5 6))
;(suffix (list 1 2 3 4 5 6))
2015-08-30 17:20:34
