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

(define (partial-sums s)
    (cons-stream (stream-car s) (add-streams (partial-sums s) (stream-cdr s))))


(define (interleave s1 s2)
    (if (stream-null? s1)
        s2
        (cons-stream (stream-car s1)
                     (interleave s2 (stream-cdr s1)))))

(define (merge-weighted s1 s2 weight)
    (cond ((stream-null? s1) s2)
        ((stream-null? s2) s1)
        (else
            (let ((s1car (stream-car s1))
                  (s2car (stream-car s2)))
                (cond ((< (weight s1car) (weight s2car))
                        (cons-stream s1car
                                     (merge-weighted (stream-cdr s1) s2 weight)))
                    ((> (weight s1car) (weight s2car))
                        (cons-stream s2car
                                     (merge-weighted s1 (stream-cdr s2) weight)))
                    (else
                        (cons-stream s1car
                                     (merge-weighted (stream-cdr s1)
                                                     s2 ;retain the other item
                                                     weight))))))))

(define (weighted-pairs s t weight)
    (cons-stream
        (list (stream-car s) (stream-car t))
        (merge-weighted
            (stream-map (lambda (x) (list (stream-car s) x)) (stream-cdr t))
            (weighted-pairs (stream-cdr s) (stream-cdr t) weight)
            weight)))
