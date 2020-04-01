
(define (stream-limit s tolerance)
    (define (compare item stream)
        (cond ((stream-null? stream)
                (error "End of stream. No items within tolerance"))
            ((< (abs (- item (stream-car stream)))
                tolerance)
                (stream-car stream))
            (else
                (compare (stream-car stream) (stream-cdr stream)))))
    (compare (stream-car s) (stream-cdr s)))