(load "streams.scm")

(define (rand-update x)
    (+ x 12))
(define random-init 60)

(define (rand-generator commands)
    (define (start-stream-with x commands)
        (cons-stream x (next commands x)))
    (define (next commands last-val)
        (let ((m (stream-car commands)))
            (cond ((eq? m 'generate)
                    (start-stream-with (rand-update last-val) (stream-cdr commands)))
                ((and (pair? m) (eq? (car m) 'reset))
                    (start-stream-with (cdr m) (stream-cdr commands)))
                (else
                    (error "Uknown method supplied for RAND" m)))))
    (next commands random-init))

(define commands 
    (cons-stream
        (cons 'reset 12)
        (cons-stream
            'generate
            (cons-stream
                'generate
                commands))))

(display-first-x-of-stream (rand-generator commands) 10)