#lang info
(define collection "calendar")
(define deps '("base"
               "rackunit-lib"
               "gregor-lib"))
(define build-deps '("scribble-lib" "racket-doc"))
(define scribblings '(("scribblings/calendar.scrbl" ())))
(define pkg-desc "Description Here")
(define version "0.0")
(define pkg-authors '(leif))
