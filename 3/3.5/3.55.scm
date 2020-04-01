(load "streams.scm")

(define (partial-sums s)
    (cons-stream (stream-car s) (add-streams (partial-sums s) (stream-cdr s))))

(define p (partial-sums integers))

(display (stream-ref p 5)) (newline)
