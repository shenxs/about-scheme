#lang racket
(require
  2htdp/batch-io
  2htdp/universe
  2htdp/image
  "25-XML.rkt")

(define company "ford")
(define PREFIX "https://www.google.com/finance?q=")
(define SUFFIX "&btnG=Search")

(define url (string-append PREFIX company SUFFIX))

(define x (read-xexpr/web url) )

