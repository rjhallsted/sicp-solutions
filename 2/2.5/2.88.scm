(define (negate x)
    (mul-poly x (make-term 0 (- 1))))
(define (sub-poly L1 L2)
    (add-poly L1 (negate L2)))

(put 'sub '(polynomial polynomial)
        (lambda (p1 p2) (tag (sub-poly p1 p2))))