(load "streams.scm")

(define (integral delayed-integrand initial-value dt)
    (define int
        (cons-stream
            initial-value
            (let ((integrand (force delayed-integrand)))
                (add-streams (scale-stream integrand dt) int))))
    int)

(define (general-solve-2nd f dt y0 dy0)
    (define dy (integral (delay ddy) dy0 dt))
    (define y (integral (delay dy) y0 dt))
    (define ddy
        (add-streams
            (scale-stream dy a)
            (scale-stream y b)))
    (define ddy (stream-map f dy y))
    y)