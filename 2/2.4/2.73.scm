(define (deriv exp var)
   (cond ((number? exp) 0)
         ((variable? exp) (if (same-variable? exp var) 1 0))
         (else ((get 'deriv (operator exp)) (operands exp)
                                            var))))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))

;a) We made the deriv procedure additive, by using the table structure discussed prior. variable? and same-variable? aren't functionally part of the data-directed dispatch. Their functionality is external to the dispatch. Also, number? is a scheme primitive.

;b) 
(define (install-deriv-sum-package)
    ;; internal procedures
    (define (sum-deriv exp var)
        (make-sum (deriv (addend exp) var)
                    (deriv (augend exp) var)))
    (define (make-sum a1 a2)
        (cond ((=number? a1 0) a2)
            ((=number? a2 0) a1)
            ((and (number? a1) (number? a2)) (+ a1 a2))
            (else (list '+ a1 a2))))
    (define (addend s) (car s))
    (define (augend s) (caddr s))
    (define (=number? exp num)
        (and (number? exp) (= exp num)))
    ;; interface to the rest of the system
    (put 'deriv '+ (lambda (exp var) (sum-deriv exp var)))
    (put 'make '+ (lambda (a1 a2) (make-sum a1 a2)))
    'done)

;Note that this is dependent on the deriv-sum package
(define (install-deriv-product-package)
    ;; internal procedures
    (define (product-deriv exp var)
        ((get 'make '+)
            (make-product (multiplier exp)
                        (deriv (multiplicand exp) var))
            (make-product (deriv (multiplier exp) var)
                        (multiplicand exp))))
    (define (make-product m1 m2)
        (cond ((or (=number? m1 0) (=number? m2 0)) 0)
            ((=number? m1 1) m2)
            ((=number? m2 1) m1)
            ((and (number? m1) (number? m2)) (* m1 m2))
            (else (list '* m1 m2))))
    (define (multilplier s) (car s))
    (define (multiplicand s) (caddr s))
    (define (=number? exp num)
        (and (number? exp) (= exp num)))
    ;; interface to the rest of the system
    (put 'deriv '* (lambda (exp var) (product-deriv exp var)))
    (put 'make '* (lambda (m1 m2) (make-product m1 m2)))
    'done)

;c)

;Note that this is dependent on the deriv-product package
(define (install-deriv-exponent-package)
    ;; internal procedures
    (define (exponent-deriv exp var)
        (let ((make-product (get 'make '*)))
            (make-product (make-product (exponent exp)
                                        (make-exponentiation (base exp)
                                                            (- (exponent exp) 1)))
                            (deriv (base exp) var))))
    (define (base ex) (cadr ex))
    (define (exponent ex) (caddr ex))
    (define (make-exponentiation base power)
        (list '** base power))
    ;; interface to the rest of the system
    (put 'deriv '** (lambda (exp var) (exponent-deriv exp var)))
    (put 'make '** (lambda (m1 m2) (make-exponentiation m1 m2)))
    'done)

;d) We would only need to adjust the uses of get, and swap the order of the first two arguments
; in the uses of put. 