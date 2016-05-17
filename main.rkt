#lang racket

(provide #%module-begin/calendar
         (struct-out event)
         get-events
         build-event)
(require "private/event.rkt"
         (for-syntax racket/syntax
                     syntax/parse))

(define-syntax (#%module-begin/calendar stx)
  (syntax-parse stx
    [(_ events ...)
     #'(#%module-begin
         (provide cal)
         (require gregor
                  gregor/time)
         (define cal*
           (for/list ([d (in-list '(events ...))])
             (event (try-parse-date (first d))
                    (try-parse-time (second d))
                    (try-parse-time (third d))
                    (fourth d)
                    (fifth d))))
         (define cal
           (sort cal* (λ (x y) (if (date=? (event-date x)
                                           (event-date y))
                                   (and (event-start-time x)
                                        (event-start-time y)
                                        (time<? (event-start-time x)
                                                (event-start-time y)))
                                   (date<? (event-date x)
                                           (event-date y)))))))]))

(define (build-event date start-time end-time name location)
  (event (try-parse-date date)
         (try-parse-time start-time)
         (try-parse-time end-time)
         name
         location))
