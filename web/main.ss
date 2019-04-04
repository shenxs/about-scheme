(import (igropyr http))

(define (logger in)
  (display in))

(define (main-page)
  "<HTML>
    <head>
    </head>
    <main>
        <h1>hello</h1>
        <p>
            this is a try
        </p>
    </main>
</HTML>")

(define get
  (lambda (header path query)
    ;; (logger (list header path query))
    (sendfile "" "index.html")
    )
  )

(define post
  (lambda (header path payload)
    (response 200 "text/plain" "Hello from post")))

(define fib
  (lambda x
    ((cond
      ([= x 1] 1)
      (else (* x (fib (- x 1))))))))


(server
 (request get)
 (request post)
 (set
  ('staticpath    "./")   ;to define the static path
  ('connections   3600)   ;to define the max connections, default is 1024
  ('keepalive     3600))
 (listen 8080))

