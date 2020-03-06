(define (rand m)
    (let ((x random-init))
        (cond
            ((eq? m 'generate)
                (lambda ()
                    (set! x (rand-update x))
                    x))
            ((eq? m 'reset)
                (lambda (new-val)
                    (set! x new-val)
                    x))
            (else
                (error "Unknown method supplied for RAND" m)))))