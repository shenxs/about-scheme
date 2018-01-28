#lang racket
(require htdp/dir)
(define d0 (create-dir "/home/richard/.ssh"))

(define (how-many d)
  (local(

         ;file/dir/'() number ->number
         (define (f1 c n)
           (cond
             [(file? c) (+ 1 n)]
             [(dir? c) (+ n (how-many c))]
             [(empty? c) n]))
        (define (f2 c n)
          (cond
            [(dir? c) (+ n (how-many c))]
            [(empty? c) n]))
         (define files-number
           (foldr f1 0 (dir-files d)))
         (define dirs-file-number
           (foldr f2 0 (dir-dirs d)))
         )
    (+ files-number dirs-file-number)))

(how-many d0)


(define (find? d target-name)
  (local(
         (define (find-in-files target-name files)
           (cond
             [(empty? files) false]
             [(file? files) (if (symbol=? target-name (file-name files)) true false)]
             [else (or (find-in-files target-name (first files))
                       (find-in-files target-name (rest files)))]))
         (define (find-in-dirs target-name dirs)
           (cond
             [(empty? dirs) false]
             [else (or (find-in-files target-name (dir-files (first dirs) ))
                       (
                        find-in-dirs target-name (rest dirs)))]))

         )
    (or (find-in-files target-name (dir-files d))
        (find-in-dirs target-name (dir-dirs d)))))

;(find? d0 'fucq.py)

;ls
;列出当前文件夹下的文件夹以及文件;
;dir->string

(define (ls d)
  (local(
         ;list of dirs->list of symbol
         (define (ls-dir d)
           (cond
             [(empty? d) '()]
             [else (cons (dir-name (first d)) (ls-dir (rest d)))]))
         ;list of files->list of symbol
         (define (ls-files f)
           (cond
             [(empty? f) '()]
             [else (cons (file-name (first f)) (ls-files (rest f)))]))
         )
    (append (ls-dir (dir-dirs d)) (ls-files (dir-files d)))))


(ls d0)


;du
;dir->Number
;计算出整个文件树下面的文件的总共大小
;一个文件夹的大小记为1
(define (du d)
  (local(
         ;计算文件的大小
         (define (du-dirs d)
           (cond
             [(empty? d) 0]
             [else (+ 1 (du (first d)) (du-dirs (rest d))) ]))
         (define (du-files f)
           (cond
             [(empty? f) 0]
             [else (+ (file-size (first f)) (du-files (rest f)) )]))
         ;计算文件夹的大小
         )
    (+ 1 (du-dirs (dir-dirs d)) (du-files (dir-files d)))))
(du d0)
