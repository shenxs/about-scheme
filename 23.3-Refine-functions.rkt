#lang racket
(require htdp/dir)
(define d0 (create-dir "/home/richard/playground/ShanXun-master"))

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


(define (find d target-name)
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
                       (find-in-dirs target-name (rest dirs)))]))

         )
    (or (find-in-files target-name (dir-files d))
        (find-in-dirs target-name (dir-dirs d)))))

;(find d0 'fucq.py)
