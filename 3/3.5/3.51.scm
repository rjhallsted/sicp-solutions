(load "streams.scm")
(define (display-line x)
    (display x)
    (newline))


(define (show x)
    (display-line x)
    x)


(define x
    (stream-map show
                (stream-enumerate-interval 0 10)))
(stream-ref x 5)
(stream-ref x 7)


;0 1 2 3 4 5 6 7