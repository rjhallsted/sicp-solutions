(load "streams.scm")

(define (invert-unit-series s)
    (define inverted-series 
        (cons-stream 1 (scale-stream (mul-series (stream-cdr s)
                                                 inverted-series)
                                    (- 1))))
    inverted-series)

(define inverted-cosine (invert-unit-series cosine-series))
(display-first-x-of-stream (mul-series cosine-series inverted-cosine) 10)
