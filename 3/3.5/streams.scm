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
