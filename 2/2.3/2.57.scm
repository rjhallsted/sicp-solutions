(load "differentiation.scm")

(define (deriv-reduce proc number-proc init exp)
    (if (pair? exp)
        (let ((number-value (accumulate number-proc init (filter number? exp))))
            (append 
                (accumulate cons '() (filter (lambda (x) 
                                                (not (number? x)))
                                            exp))
                (if (= number-value 0) '() (list number-value))))
        exp))

(define (make-sum a b)
    (define (make-sum-inner a1 a2)
        (cond ((sum? a2) (append (list '+ a1) (cdr a2)))
            ((=number? a1 0) a2)
            ((=number? a2 0) a1)
            ((and (number? a1) (number? a2)) (+ a1 a2))
            (else (list '+ a1 a2))))
    ;clean up by adding all numbers together
    (deriv-reduce '+ + 0 (make-sum-inner a b)))
;    (make-sum-inner a b))

(define (make-product a b)
    (define (make-product-inner m1 m2)
        (cond  ((product? m1) (append (list '* m2) (cdr m1)))
            ((product? m2) (append (list '* m1) (cdr m2)))
            ((or (=number? m1 0) (=number? m2 0)) 0)
            ((=number? m1 1) m2)
            ((=number? m2 1) m1)
            ((and (number? m1) (number? m2)) (* m1 m2))
            (else (list '* m1 m2))))
    (deriv-reduce '* * 1 (make-product-inner a b)))

(define (augend s)
    ;; (display s) (newline)
    (if (pair? (cdddr s))
        (make-sum (caddr s) (augend (append (list '+) (cddr s))))
        (caddr s)))

(define (multiplicand p)
    (if (pair? (cdddr p))
        (make-product (caddr p) (multiplicand (append (list '*) (cddr p))))
        (caddr p)))


(display (deriv '(* (* 2 x) (* 3 x)) 'x)) (newline)
(display (deriv '(+ (* 3 x) x) 'x)) (newline)
(display (deriv '(+ (+ (* 3 x) x) x) 'x)) (newline)