(load "streams.scm")

(define (sign-change-detector new last)
    (cond ((and (< new 0) (>= last 0)) (- 1))
        ((and (> new 0) (< last 0)) 1)
        (else 0)))

(define (list->stream l)
    (if (null? l)
        the-empty-stream
        (cons-stream (car l)
                     (list->stream (cdr l)))))


(define sense-data (list->stream (list 0 1 (- 1) 1 (- 1) 1 1 (- 1) 1)))

(define zero-crossings
    (stream-map sign-change-detector
                (stream-cdr sense-data)
                sense-data))

(display-stream zero-crossings)