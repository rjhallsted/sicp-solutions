(define f
    (let ((inner 1))
        (lambda (x)
            (set! inner (- inner x))
            inner)))

(display (+ (f 1) (f 0))) (newline)

(define g
    (let ((inner 1))
        (lambda (x)
            (set! inner (- inner x))
            inner)))

(display (+ (g 0) (g 1))) (newline)