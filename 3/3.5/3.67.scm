(load "streams.scm")

(define (pairs s t)
    (cons-stream
        (list (stream-car s) (stream-car t))
        (interleave
            (stream-map (lambda (x) (list (stream-car s) x)) (stream-cdr t))
            (interleave
                (pairs (stream-cdr s) (stream-cdr t))
                (stream-map (lambda (x) (list x (stream-car s))) (stream-cdr t))))))


(display-first-x-of-stream (pairs integers integers) 50)