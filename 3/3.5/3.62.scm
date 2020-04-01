(load "streams.scm")

(define (mul-series s1 s2)
    (cons-stream (* (stream-car s1) (stream-car s2))
                 (add-streams (scale-stream (stream-cdr s1) (stream-car s2))
                              (mul-series (stream-cdr s2) s1))))


(define (invert-unit-series s)
    (define inverted-series 
        (cons-stream 1 (scale-stream (mul-series (stream-cdr s)
                                                 inverted-series)
                                    (- 1))))
    inverted-series)

(define (div-series s1 s2)
    (if (= (stream-car s2) 0)
        (error "Denominator has 0 as a constant: DIV SERIES")
        (mul-series s1 (invert-unit-series s2))))

(define tangent-series (div-series sine-series cosine-series))

(display-first-x-of-stream tangent-series 10)