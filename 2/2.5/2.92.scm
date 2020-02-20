;;need a way to coerce second poly to the same order of the first
;; (y)x + (x)y --> (y)x + (y)x
;;need a way to swap the variables at one level of the poly
;;;;with this, you can sort variables as necessary

;;apply communitiity. Multiply the variable and its order by each subterm of
;;the coefficient.
;;the outer variable and its order become the coefficient of each subterm of the
;;original coefficient.
;;^ do that to each term

;;if the terms have the same variables, that works.

;;Assume the order of the first polynomial. Any additional variables remain in the order they were found at bottom of the 'variable stack'

;;first you have to get the order of the variable stack.
;;Order is determined first by depth, and then by term order.

(load "../2.2/list-ops.scm")

(define (variable-order p)
    (define (variable-order-inner p)
        (let ((coeff-polys 
                (map (lambda (x) (coeff x))
                    (fitler (lambda (x) (not (number? (coeff x))))
                            (terms p)))))
            (accumulate (lambda (item processed)
                            (if (list-contains item processed)
                                (cons item processed)
                                processed))
                        '()
                        (append (map (lambda (x) (variable x)) terms-with-poly-coeffs)
                                (map variable-order-inner coeff-polys))))
    (cons (variable p) (variable-order-inner p)))

(define (install-sparce-polynomials)
    (define (adjoin-term term term-list)
        (if (=zero? (coeff term))
            term-list
            (cons term term-list)))
    (define (empty-termlist? p)
        (null? p))
    (define (first-term term-list) (car term-list))
    (define (rest-terms term-list) (cdr term-list))
    ;;interface
    (define (tag x) (attach-tag 'sparse x))
    (put 'adjoin-term '(term sparse) (lambda (t tl) (tag (adjoin-term t tl))))
    (put 'first-term 'sparse first-term)
    (put 'rest-terms 'sparse (lambda (p) (tag (rest-terms p))))
    'done)

(define (install-dense-polynomials) ;;working here
    (define (adjoin-term term term-list)
        (if (=zero? (coeff term))
            term-list
            (let ((diff (- (order term) (order (first-term term-list)) 1)))
                (append (list (coeff term)
                                (map (lambda (x) 0) (enumerate 0 diff))
                                term-list)))))
    (define (empty-termlist? p)
        (null? p))
    (define (first-term term-list)
        (make-term (length term-list) (car term-list)))
    (define (rest-terms term-list) (cdr term-list))
    ;;interface
    (define (tag x) (attach-tag 'dense x))
    (put 'adjoin-term '(term dense) (lambda t tl) (tag (adjoin-term t tl)))
    (put 'first-term 'dense first-term)
    (put 'rest-terms 'dense (lambda (p) (tag (rest-terms p))))
    'done)

(define (install-polynomial-package)
    (define (make-poly variable term-list)
        (cons variable term-list))
    (define (variable p) (car p))
    (define (term-list p) (cdr p))
    (define (variable? x) (symbol? x))
    (define (same-variable? v1 v2)
        (and (variable? v1) (variable? v2) (eq? v1 v2)))
    (define (coerce-to-type p term-type)
        (if (empty-termlist? p)
            p
            ((get 'adjoin-term ''(term 'term-type)) (make-term (order (first-term p)) (coeff (first-term p)))
                            (coerce-to-type (rest-terms p) term-type))))
    (define (sparce->dense p)
        (coerce-to-type p 'dense))
    (define (dense->sparce p)
        (coerce-to-type p 'sparse))
    (define (add-poly p1 p2)
        (if (same-variable? (variable p1) (variable p2))
            (make-poly (variable p1)
                    (add-terms (term-list p1) (term-list p2)))
            (error "Polys not in same var: ADD-POLY" 
                    (list p1 p2))))
    (define (add-terms L1 L2)
        (cond ((empty-termlist? L1) L2)
            ((empty-termlist? L2) L1)
            (else
                (let ((t1 (first-term L1))
                      (t2 (first-term L2)))
                    (cond ((> (order t1) (order t2))
                            (adjoin-term t1
                                        (add-terms (rest-terms L1) L2)))
                        ((< (order t1) (order t2))
                            (adjoin-term t2
                                        (add-terms L1 (rest-terms L2))))
                        (else
                            (adjoin-term
                                (make-term (order t1)
                                           (add (coeff t1) (coeff t2)))
                                (add-terms (rest-terms L1) (rest-terms L2)))))))))
    (define (mul-poly p1 p2)
        (if (same-variable? (variable p1) (variable p2))
            (make-poly (variable p1)
                    (mul-terms (term-list p1) (term-list p2)))
            (error "Polys not in same var: MUL-POLY"
                (list p1 p2))))
    (define (mul-terms L1 L2)
        (if (empty-termlist? L1)
            (the-empty-termlist)
            (add-terms (mul-term-by-all-terms (first-term L1) L2)
                        (mul-terms (rest-terms L1) L2))))
    (define (mul-term-by-all-terms t1 L)
        (if (empty-termlist? L)
            (the-empty-termlist)
            (let ((t2 (first-term L)))
                (adjoin-term
                    (make-term (+ (order t1) (order t2))
                                (mul (coeff t1) (coeff t2)))
                    (mul-term-by-all-terms t1 (rest-terms L))))))
    (define (sub-poly L1 L2)
        (add-poly L1 (negate L2)))
    (define (poly-equals-zero? p)
        (empty-termlist? p))
    (define (negate x)
        (mul-poly x (make-term 0 (- 1))))
    (define (make-term order coeff) (list order coeff))
    (define (order term) (car term))
    (define (coeff term) (cadr term))
    (define (the-empty-termlist) '())
    ;; interface to rest of the system
    (install-sparce-polynomials)
    (install-dense-polynomials)
    (define (tag p) (attach-tag 'polynomial p))
    (put 'add-poly '(sparse dense)
        (lambda (p1 p2) (add-poly p1 (dense->sparse p2))))
    (put 'add-poly '(dense sparse)
        (lambda (p1 p2) (add-poly p1 (sparse->dense p2))))
    (put 'add-poly '(sparse sparse) add-poly)
    (put 'add-poly '(dense dense) add-poly)
    (put 'mul-poly '(sparse dense)
        (lambda (p1 p2) (mul-poly p1 (dense->sparse p2))))
    (put 'mul-poly '(dense sparse)
        (lambda (p1 p2) (mul-poly p1 (sparse->dense p2))))
    (put 'mul-poly '(sparse sparse) mul-poly)
    (put 'mul-poly '(dense dense) mul-poly)
    (put 'add '(polynomial polynomial)
        (lambda (p1 p2) (tag (add-poly p1 p2))))
    (put 'mul '(polynomial polynomial)
        (lambda (p1 p2) (tag (mul-poly p1 p2))))
    (put 'sub '(polynomial polynomial)
        (lambda (p1 p2) (tag (sub-poly p1 p2))))
    (put 'make 'polynomial
        (lambda (var terms) (tag (make-poly var terms))))
    (put 'make 'term
        (lambda (order coeff) (attach-tag 'term (make-term order-coeff))))
    (put '=zero? 'polynomial poly-equals-zero?)
    'done)
(define (make-term order coeff) ((get 'make 'term) order coeff))
(define (make-polynomial var terms)
    ((get 'make 'polynomial) var terms))