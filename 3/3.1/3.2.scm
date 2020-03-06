(define (make-monitored f)
    (let ((call-count 0))
        (lambda (x)
            (cond ((eq? x 'how-many-calls?) call-count)
                ((eq? x 'reset-count)
                    (begin (set! call-count 0)
                           0))
                (else
                    (begin (set! call-count (+ call-count 1))
                           (f x)))))))

(define s (make-monitored sqrt))
(s 100)
(display (s 'how-many-calls?)) (newline)
(display (s 'reset-count)) (newline)