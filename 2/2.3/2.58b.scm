(load "../2.2/list-ops.scm")

(define (=number? exp num)
    (and (number? exp) (= exp num)))

(define (variable? x) (symbol? x))

(define (same-variable? v1 v2)
    (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (make-sum a1 a2)
    (cond ((sum? a2) (append (list a1 '+) (cdr a2)))
        ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) (+ a1 a2))
        (else (list a1 '+ a2))))

(define (sum? x)
    (and (pair? x) (eq? (cadr x) '+)))

(define (addend s) (car s))
(define (augend s) (caddr s))
(define (augend s)
    (if (pair? (cdddr s))
        (cddr s)
        (caddr s)))


(define (make-product m1 m2)
    (cond  ((product? m1) (append (list m2 '*) (cdr m1)))
        ((product? m2) (append (list m1 '*) (cdr m2)))
        ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list m1 '* m2))))

(define (product? x)
    (and (pair? x) (eq? (cadr x) '*)))

(define (multiplier p) (car p))

(define (multiplicand p)
    (if (pair? (cdddr p))
        (cddr p)
        (caddr p)))

(define (exponentiation? x)
    (and (pair? x) (eq? (car x) '**)))

(define (base ex) (cadr ex))

(define (exponent ex) (caddr ex))

(define (make-exponentiation base power)
    (list '** base power))

(define (deriv exp var)
    (cond ((number? exp) 0)
        ((variable? exp)
            (if (same-variable? exp var) 1 0))
        ((sum? exp)
            (make-sum (deriv (addend exp) var)
                    (deriv (augend exp) var)))
        ((product? exp)
            (make-sum
                (make-product (multiplier exp)
                                (deriv (multiplicand exp) var))
                (make-product (deriv (multiplier exp) var)
                                (multiplicand exp))))
        ((exponentiation? exp)
            (make-product (make-product (exponent exp)
                                        (make-exponentiation (base exp)
                                                        (- (exponent exp) 1)))
                        (deriv (base exp) var)))
        (else
            (error "unknown expression type -- DERIV" exp))))


(display (deriv '(x + 3 * (x + y + 2)) 'x)) (newline)