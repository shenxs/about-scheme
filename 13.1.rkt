;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |13.1|) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "abstraction.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t write repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "abstraction.rkt" "teachpack" "2htdp")) #f)))
(define DictionaryLocation "/usr/share/dict/words")
(define DictionaryAsList (read-lines DictionaryLocation))

;;String->list of String
;找到给定单词的所有可能字母组合

(check-member-of (alternativeWords "cat")
                 (list "act" "cat")
                 (list "cat" "act"))

(define (allWordsFromRat? w)
  (and (member? "rat" w)
       (member? "art" w)
       (member? "tar" w)))

(check-satisfied (alternativeWords "rat") allWordsFromRat?)




;list of words->list of strings
(define (words->strings low)
  (cond
    [(empty? low) '()]
    [else (cons (word->string (first low)) (words->strings (rest low)))]))

;stirng->word
;字符到一个个字母组成的列表
(define (string->word s)
  (cond
    [(= 0 (string-length s)) (error "字符串长度为0")]
    [(= 1 (string-length s)) (cons s '())]
    [else (cons (substring s 0 1)
                (string->word (substring s 1 (string-length s))))]))


;word->string
(define (word->string w)
  (cond
    [(empty? w) ""]
    [else (string-append (first w) (word->string (rest w)))]))

;;list of strings->list of strings
;找出所有出现在字典里面的字符
(define (in-dictionary los)
  (cond
    [(empty? los) '()]
    [else (if (member? (first los) DictionaryAsList )
            (cons (first los) (in-dictionary (rest los)))
            (in-dictionary (rest los)))]))

;word->list of string
;找到一个单词所有可能的组合
(define (arrangements word)
  (cond
    [(empty? word) '()]
    [else (insert2words (first word) (arrangements (rest word)))]))


;1string ,list of words ->list of words
;将一个字母插入到 a list of word
;这里前面两个判断中第一个是判断low是否进入函数时就为空
;第二个判断条件在递归时会触发
;这样写可以区分递归时碰到empty元素时是递归一开始list就为空还是到达递归结束时才碰到的empty元素
(define (insert2words c low)
  (cond
    [(empty? low) (heart '() '() c)]
    [(empty? (rest low)) (heart '() (first low) c)]
    [else (append (heart '() (first low) c ) (insert2words c (rest low)))]))

;;这个程序的核心
;pre 必须为'() post可以是word
;c 为要插入的字母
;输出是将c 插入到post的所有位置  ->a list of words
(define (heart pre post c)
  (cond
    [(empty? post) (list (append pre (list c)))]
    [else (cons
            (append (append pre (list c)) post)
            (heart (append pre (list (first post))) (rest post) c))]))

(define (alternativeWords s)
  (in-dictionary (words->strings (arrangements (string->word s)))))
(alternativeWords "rat")
