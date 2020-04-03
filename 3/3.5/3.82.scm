(load "streams.scm")

(define (monte-carlo experiment-stream passed failed)
    (define (next passed failed)
        (cons-stream
            (/ passed (+ passed failed))
            (monte-carlo
                (stream-cdr experiment-stream) passed failed)))
    (if (stream-car experiment-stream)
        (next (+ passed 1) failed)
        (next passed (+ failed 1))))

(define (random-in-range low high)
    (let ((range (- high low)))
        (+ low (random range))))

(define (estimate-integral P x1 x2 y1 y2)
    (define (experiment-stream)
        (cons-stream
            (P (random-in-range x1 x2) (random-in-range y1 y2))
            (experiment-stream)))
    (let ((rect-area (* (- x2 x1) (- y2 y1))))
        (scale-stream (monte-carlo (experiment-stream) 0 0) rect-area)))

(define (in-unit-circle? x y)
    (<= (+ (square x) (square y)) 1))

(define integral-estimate
    (estimate-integral in-unit-circle? (- 1.0) 1.0 (- 1.0) 1.0))

(display (stream-ref integral-estimate 100000)) ;3.14528