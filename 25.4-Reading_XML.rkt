;似乎从这一节开始要开始读取xml文件了
;管理员有时候希望可以从本地或者是web上获取(读取)xml配置文件
;所以这一章节在2htdp/batch-io的帮助下我们要做到以上的需求
#lang racket
(require
  2htdp/batch-io
  2htdp/universe
  2htdp/image
  "25-XML.rkt")

;以下是teachpack的关于xexpr的内容

; Xexpr.v3 is one of:
;  – Symbol
;  – String
;  – Number
;  – (cons Symbol (cons Attribute*.v3 [List-of Xexpr.v3]))
;  – (cons Symbol [List-of Xexpr.v3])
;
; Attribute*.v3 is [List-of Attribute.v3]
;
; Attribute.v3 is:
;   (list Symbol String)
; interpretation.: (list 'a "some text") represents a="some text"

; Any -> Boolean
; is the given value an Xexpr.v3
; effect display bad piece if x is not an Xexpr.v3
;; (define (xexpr? x) ...)

; String -> Xexpr.v3
; produces the first XML element in file f as an X-expression
;; (define (read-xexpr f) ...)

; String -> Xexpr.v3
; produces the first XML element in file f as an X-expression
; and all whitespace between embedded elements is eliminated
; assume the XML element may not contain any text as elements
;忽略所有的<>与</>之间的内容
;; (define (read-plain-xexpr f) ...)

; String -> Boolean
; #false, if this url returns a '404'; #true otherwise
;; (define (url-exists? u) ...)

;; (url-exists? "http://icetea.me")

; String -> [Maybe Xexpr.v3]
; produces the first XML element from URL u as an X-expression
; or #false if (not (url-exists? u))
; reads HTML as XML if possible
; effect signals an error in case of network problems
;; (define (read-xexpr/web u) ...)

(read-xexpr/web "http://www.v2ex.com")
;; (read-xexpr/web "http://www.baidu.com")
;; (read-xexpr/web "http://www.sina.com")
;; (read-xexpr/web "http://www.baidu.com/s?tn=baiduhome_pg&rsv_idx=2&wd=%E5%BC%A0%E6%AA%AC&cq=5f3e28ff2ec563ffc5de5e21ba735780&rsv_dl=0_right_recom_21106&srcid=20986&rt=%E7%9B%B8%E5%85%B3%E4%BA%BA%E7%89%A9&euri=a9fc06f336b34389915b9cad452764e9")


; String -> [Maybe Xexpr.v3]
; produces the first XML element from URL u as an X-expression
; and all whitespace between embedded elements is eliminated
; or #false if (not (url-exists? u))
; reads HTML as XML if possible
; effect signals an error in case of network problems
;; (define (read-plain-xexpr/web u) ...)

;; (read-plain-xexpr/web "http://www.baidu.com")

; Xexpr.v3 -> String
; renders the X-expression x as a string
;; (define (xexpr-as-string x) ...)

;; (xexpr? '(mak ((df " ")) (fjk k)))

;; (read-plain-xexpr/web
    ;; "http://www.ccs.neu.edu/home/matthias/HtDP2e/Files/machine-configuration.xml")

;; (read-xexpr/web "https://www.google.com/finance")

(define PREFIX "https://www.google.com/finance?q=")
(define SUFFIX "&btnG=Search")
(define SIZE 22)
(define SPACER (text "  " SIZE 'white))


;x xexpr
;s "string" 要寻找的字符串
;从xml中找到s
(define (get-almost x s)
  (local(
         ;先把内容拿出来
         (define content (xexpr-content x))
         (define (zuhe-meta c)
           (local(
                  (define (heihei a b)
                    (cond
                      [(empty? a) b]
                      [else (cons a b)]))
                  (define (judge i)
                    (local (
                            (define att (xexpr-attributes i))
                            )
                      (cond
                        [(string=? s (second (second att))) (second (first att))]
                        [else '()])))
                  (define (chuli item)
                    (cond
                      [(not (cons? item)) '()]
                      [(xexpr? item)
                       (cond
                         [(symbol=? 'meta (xexpr-name item) ) (judge item)]
                         [else (get-almost item s)])]
                      [else '()]))
                  (define (quchu f s)
                    (heihei (chuli f) s))
                  )
           (foldr quchu '() c))
         ))
    (zuhe-meta content)))

(define (get-xexpr x s)
  (local(
         (define almost-value (get-almost x s))
         (define (take-out av)
           (cond
             [(cons? av) (take-out (first av))]
             [(string? av) av]
             [else "出错了"]))
         )
    (take-out almost-value)))



(define (get x s)
  (local ((define result (get-xexpr x s)))
    (if (string? result)
        result
        (error (string-append "attribute not found: " s)))))

(define-struct data [price delta])
; StockWorld is
;    (make-data String String)
; price and delta specify the current price and how
; much it changed since the last update

; String -> StockWorld
; retrieves stock price and its change of the specified company
; every 15 seconds and displays together with available time stamp
(define (stock-alert company)
  (local ((define url (string-append PREFIX company SUFFIX))

          ; [StockWorld -> StockWorld]
          ; retrieves price and change from url
          (define (retrieve-stock-data __w)
            (local ((define x (read-xexpr/web url)))
              (make-data (get x "price") (get x "priceChange"))))

          ; StockWorld -> Image
          ; renders the stock market data as a single long line
          (define (render-stock-data w)
            (local ((define pt (text (data-price w) SIZE 'black))
                    (define dt (text (data-delta w) SIZE 'red)))
              (overlay (beside pt SPACER dt)
                       (rectangle 300 35 'solid 'white)))))
    ; – IN –
    (big-bang (retrieve-stock-data 'no-use)
      [on-tick retrieve-stock-data 5]
      [to-draw render-stock-data]
      [name company])))


;; (stock-alert "ford")
