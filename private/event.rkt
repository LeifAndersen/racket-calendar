#lang racket

(provide (all-defined-out))
(require gregor
         gregor/time)

(struct event (date
               start-time
               end-time
               name
               location)
  #:transparent)

(define date-parse-strings
  '("LLLL d, y"))

(define time-parse-strings
  '("ha"
    "h a"
    "h:mma"
    "h:mm a"))

(define (try-parse-date date)
  (define (try-parse-date* date pat)
    (with-handlers ([exn:gregor:parse? (λ (x) #f)])
      (parse-date date pat)))
  (ormap (curry try-parse-date* date) date-parse-strings))

(define (try-parse-time time)
  (define (try-parse-time* time pat)
    (with-handlers ([exn:gregor:parse? (λ (x) #f)])
      (parse-time time pat)))
  (and time
       (ormap (curry try-parse-time* time) time-parse-strings)))

(define (get-events cal [day (today)] [end-day (today)])
  (when (equal? day 'tomorrow)
    (set! day (+days (today) 1))
    (set! end-day (+days (today) 1)))
  (when (equal? day 'week)
    (set! day (today))
    (set! end-day (+days (today) 7)))
  (when (equal? day 'month)
    (set! day (today))
    (set! end-day (+months (today) 1)))
  (when (equal? day 'year)
    (set! day (today))
    (set! end-day (+years (today) 1)))
  (filter (λ (x) (and (date<=? day (event-date x))
                      (date>=? end-day (event-date x))))
          cal))
