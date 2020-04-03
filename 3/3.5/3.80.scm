(load "streams.scm")

(define (RLC R L C dt)
    (lambda (vC0 iL0)
        (define iL (integral (delay diL) iL0 dt))
        (define vC (integral (delay dvC) vC0 dt))
        (define dvC (scale-stream iL (- (/ 1 C))))
        (define diL
            (add-streams
                (scale-stream iL (- (/ R L)))
                (scale-stream vC (/ 1 L))))
        (cons vC iL)))

(define rlc ((RLC 1 1 0.2 0.1) 10 0))
(define vc (car rlc))
(define il (cdr rlc))

(display "vc") (newline)
(display-first-x-of-stream vc 5)
(newline)
(display "il") (newline)
(display-first-x-of-stream il 5)