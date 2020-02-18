(define (poly-equals-zero? x)
    (empty-termlist? x))
(put '=zero? 'polynomial poly-equals-zero?)