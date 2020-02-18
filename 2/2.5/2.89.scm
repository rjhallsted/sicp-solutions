(define (the-empty-termlist) '())
(define (first-term term-list) term-list)
(define (rest-terms term-list) (cdr term-list))
(define (empty-termlist? term-list) (null? term-list))
(define (make-term order coeff)
    (if (= 0 order)
        (the-empty-termlist)
        (cons coeff (make-term (- order 1) 0))))
(define (order term) (length term))
(define (coeff term) (car term))
(define (adjoin-term term term-list)
    (if (=zero? (coeff term))
        term-list
        (cons (coeff term) term-list)))