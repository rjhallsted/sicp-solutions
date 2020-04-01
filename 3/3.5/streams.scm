(define (stream-enumerate-interval low high)
    (if (> low high)
        the-empty-stream
        (cons-stream low
                     (stream-enumerate-interval (+ low 1) high))))

(define (display-line x)
    (display x)
    (newline))

(define (stream-for-each proc s)
    (if (stream-null? s)
        'done
        (begin (proc (stream-car s))
                (stream-for-each proc (stream-cdr s)))))

(define (display-stream s) (stream-for-each display-line s))

(define (add-streams s1 s2) (stream-map + s1 s2))
(define (sub-streams s1 s2) (stream-map - s1 s2))
(define (mul-streams s1 s2) (stream-map * s1 s2))
(define (div-streams s1 s2) (stream-map / s1 s2))

(define (scale-stream stream factor)
    (stream-map (lambda (x) (* x factor))
                stream))

(define integers
    (cons-stream 1 (add-streams ones integers)))
(define ones
    (cons-stream 1 ones))


(define (first-x-of-stream stream x)
    (if (> x 0)
        (cons-stream (stream-car stream)
            (first-x-of-stream (stream-cdr stream) (- x 1)))
        the-empty-stream))

(define (display-first-x-of-stream s x)
    (display-stream (first-x-of-stream s x)))

(define (integrate-series series)
    (div-streams series integers))

(define cosine-series (cons-stream 1 (integrate-series (scale-stream sine-series (- 1)))))
(define sine-series (cons-stream 0 (integrate-series cosine-series)))


(define (mul-series s1 s2)
    (cons-stream (* (stream-car s1) (stream-car s2))
                 (add-streams (scale-stream (stream-cdr s1) (stream-car s2))
                              (mul-series (stream-cdr s2) s1))))
