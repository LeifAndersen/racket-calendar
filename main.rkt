#lang racket

(provide #%module-begin/calendar
         (struct-out event)
         get-events
         build-event
         add-event-to-calendar!)
(require "private/event.rkt"
         gregor
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

;; Build an event given strings for date and time
;; String String String String String -> Event
(define (build-event date start-time end-time name location)
  (event (try-parse-date date)
         (try-parse-time start-time)
         (try-parse-time end-time)
         name
         location))

;; Adds an event to an existing calendar module
;;   (Dynamically updates the file in the module,
;;    Does not reload any modules that may be requiring that module.)
;; Patth Event -> Void
(define (add-event-to-calendar! calendar
                                event)
    (with-output-to-file calendar
      #:exists 'append
      (λ ()
        (write (list (~t (event-date event) "E., MMM d, y")
                     (and (event-start-time event)
                          (~t (event-start-time event) "h:mm a"))
                     (and (event-end-time event)
                          (~t (event-end-time event) "h:mm a"))
                     (~a (event-name event))
                     (~a (event-location event))))
        (newline))))
