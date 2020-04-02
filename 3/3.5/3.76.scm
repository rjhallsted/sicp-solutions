(define (average x y)
    (/ (+ x y) 2))
(define (stream-cadr s)
    (stream-car (stream-cdr s)))
(define (smooth s)
    (let ((avg (average (stream-car s) (stream-cadr s))))
        (cons-stream avg
                     (smooth (stream-cdr s)))))

(define (make-zero-crossings input-stream)
    (define (crossings input-stream last-value)
        (cons-stream
            (sign-change-detector (stream-car input-stream) last-value)
            (make-zero-crossings (stream-cdr input-stream) 
                                 (stream-car input-stream))))
    (crossings (smooth input-stream) 0))