(load "streams.scm")

;a

(define (integrate-series series)
    (div-streams series integers))

;b

;deriv of sine is cosine
;deriv of cosine is negative sine
(define cosine-series (cons-stream 1 (integrate-series (scale-stream sine-series (- 1)))))
(define sine-series (cons-stream 0 (integrate-series cosine-series)))

(define (first-x-of-stream stream x)
    (if (> x 0)
        (cons-stream (stream-car stream)
            (first-x-of-stream (stream-cdr stream) (- x 1)))
        the-empty-stream))

(display-stream (first-x-of-stream cosine-series 10))