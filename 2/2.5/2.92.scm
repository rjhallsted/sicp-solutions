(load "../list-ops.scm")
(load "../proc-tables.scm")
(load "generic-arithmetic.scm")

(define (display-these . args)
    (define (display-these-inner args)
        (if (null? args)
            (newline)
            (let ()
                (display (car args)) (display " ")
                (display-these-inner (cdr args)))))
    (display-these-inner args))

(define (install-sparce-polynomials)
    (define (make-term-list term-list)
        term-list)
    (define (adjoin-term term term-list)
        (if (=zero? (coeff term))
            term-list
            (cons (make-term (order term) (coeff term))
                  term-list)))
    (define (empty-termlist? p)
        (null? p))
    (define (first-term term-list) (car term-list))
    (define (rest-terms term-list) (cdr term-list))
    (define (the-empty-termlist)
        ((get 'the-empty-termlist 'sparse)))
    ;;interface
    (define (tag x) (attach-tag 'sparse x))
    (define (coeff x) ((get 'coeff '(term)) x))
    (define (order x) ((get 'order '(term)) x))
    (put 'adjoin-term '(term sparse) (lambda (t tl) (tag (adjoin-term t tl))))
    (put 'first-term '(sparse) first-term)
    (put 'rest-terms '(sparse) (lambda (p) (tag (rest-terms p))))
    (put 'make 'sparse (lambda (x) (tag (make-term-list x))))
    (put 'empty-termlist? '(sparse) empty-termlist?)
    (put 'the-empty-termlist 'sparse (lambda () (tag '())))
    'done)

(define (install-dense-polynomials)
    (define (make-term-list terms)
        (if (null? terms)
            (the-empty-termlist)
            (adjoin-term (car terms)
                        (make-term-list (cdr terms)))))
    (define (adjoin-the-terms term term-list)
        (define (append-zeroes term order-of-next-item term-list)
            (append (list (coeff term))
                    (map (lambda (x) 0) (enumerate-interval (+ order-of-next-item 1) (- (order term) 1)))
                    term-list))
        (if (=zero? (coeff term))
            term-list
            (if (empty-termlist? term-list)
                (append-zeroes term (- 1) (contents (the-empty-termlist)))
                (append-zeroes term (order (first-term term-list)) term-list))))
    (define (empty-termlist? p)
        (or (null? p) (empty-dense-list? p)))
    (define (empty-dense-list? l)
        (and (same-variable? 'dense (car l))
             (null? (cdr l))))
    (define (first-term term-list)
        (contents (interface-first-term term-list)))
    (define (rest-terms term-list) (cdr term-list))
    (define (the-empty-termlist)
        ((get 'the-empty-termlist 'dense)))
    (define (adjoin-term term term-list)
        (apply-generic 'adjoin-term term term-list))
    ;;interface
    (define (interface-first-term term-list)
        (make-term (- (length term-list) 1) (car term-list)))
    (define (coeff term)
        ((get 'coeff '(term)) term))
    (define (order term)
        ((get 'order '(term)) term))
    (define (tag x) (attach-tag 'dense x))
    (put 'adjoin-term '(term dense) (lambda (t tl) (tag (adjoin-the-terms t tl))))
    (put 'first-term '(dense) interface-first-term)
    (put 'rest-terms '(dense) (lambda (p) (tag (rest-terms p))))
    (put 'make 'dense make-term-list)
    (put 'empty-termlist? '(dense) empty-termlist?)
    (put 'the-empty-termlist 'dense (lambda () (tag '())))
    'done)

(define (install-polynomial-package)
    (define (term-list->pure-terms term-list)
        (if (empty-termlist? term-list)
            '()
            (cons (first-term term-list)
                    (term-list->pure-terms (rest-terms term-list)))))
    (define (term-filter proc term-list)
        (filter proc (term-list->pure-terms term-list)))
    (define (polynomial? x)
        (same-variable? 'polynomial (type-tag x)))
    (define (swap-term-innards term term-var)
        (map (lambda (inner)
                (make-term (order inner)
                           (make-polynomial term-var (list (make-term (order term) (coeff inner))))))
            (term-list->pure-terms (term-list (contents (coeff term))))))
    (define (convert-to-term orig-var terms)
        (if (null? terms)
            (make-term 0 0)
            (make-term 0 (make-polynomial orig-var terms))))
    (define (sort-terms terms)
        (define (is-sorted terms)
            (cond ((or (null? terms) (null? (cdr terms))) #t)
                ((< (order (car terms)) (order (cadr terms)))
                    #f)
                (else (is-sorted (cdr terms)))))
        (define (swap-terms terms)
            (cons (cadr terms)
                (cons (car terms)
                    (cddr terms))))
        (if (is-sorted terms)
            terms
            (if (< (order (car terms)) (order (cadr terms)))
                (sort-terms (swap-terms terms))
                (sort-terms (cons (car terms) (sort-terms (cdr terms)))))))
    (define (coerce-poly-to-var p var)
        (if (same-variable? var (variable p))
            p
            (let ((swappable (term-filter (lambda (x) 
                                            (and (polynomial? (coeff x))
                                                (same-variable? var (variable (contents (coeff x))))))
                                        (term-list p))))
                (contents
                    (make-polynomial var
                                (sort-terms (append (flatmap (lambda (term) (swap-term-innards term (variable p)))
                                                            swappable)
                                        (list (convert-to-term (variable p)
                                                                (term-filter (lambda (x) (not (list-contains? x swappable))) (term-list p)))))))))))
    (define (make-poly variable term-list)
        (cons variable term-list))
    (define (variable p) (car p))
    (define (term-list p) (cdr p))
    (define (coerce-to-type p  term-type)
        (cond ((same-variable? (type-tag p) term-type)
                p)
           ((empty-termlist? p)
                (the-empty-termlist term-type))
            (else
                (let ((first (first-term p)))
                    (adjoin-term (make-term (order first) (coeff first))
                                 (coerce-to-type (rest-terms p)
                                                 term-type))))))
    (define (add-poly p1 p2)
        (if (same-variable? (variable p1) (variable p2))
            (make-poly (variable p1)
                       (add-terms (term-list p1)
                                  (coerce-to-type (term-list p2)
                                                  (type-tag (term-list p1)))))
            (add-poly p1 (coerce-poly-to-var p2 (variable p1)))))
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
                       (mul-terms (term-list p1)
                                  (coerce-to-type (term-list p2)
                                                  (type-tag (term-list p1)))))
            (mul-poly p1 (coerce-poly-to-var p2 (variable p1)))))
    (define (mul-terms L1 L2)
        (if (empty-termlist? L1)
            (the-empty-termlist (type-tag L1))
            (add-terms (mul-term-by-all-terms (first-term L1) L2)
                       (mul-terms (rest-terms L1) L2))))
    (define (mul-term-by-all-terms t1 L)
        (if (empty-termlist? L)
            (the-empty-termlist (type-tag L))
            (let ((t2 (first-term L)))
                (adjoin-term
                    (make-term (+ (order t1) (order t2))
                                (mul (coeff t1) (coeff t2)))
                    (mul-term-by-all-terms t1 (rest-terms L))))))
    (define (div-poly p1 p2)
        (if (same-variable? (variable p1) (variable p2))
            (let ((result (div-terms (term-list p1) 
                                     (coerce-to-type (term-list p2)
                                                     (type-tag (term-list p1))))))
                (list (make-poly (variable p1) (car result))
                      (make-poly (variable p1) (cadr result))))
            (div-poly p1 (coerce-poly-to-var p2 (variable p1)))))
    (define (div-terms L1 L2)
        (if (empty-termlist? L1)
            (list (the-empty-termlist (type-tag L1))
                  (the-empty-termlist (type-tag L1)))
            (let ((t1 (first-term L1))
                 (t2 (first-term L2)))
                (if (> (order t2) (order t1))
                    (list (the-empty-termlist (type-tag L1)) L1)
                    (let ((new-c (div (coeff t1) (coeff t2)))
                         (new-o (- (order t1) (order t2))))
                        (let ((rest-of-result
                                (div-terms
                                    (sub-terms L1
                                               (mul-term-by-all-terms (make-term new-o new-c) L2))
                                    (rest-terms L2))))
                            (list (adjoin-term (make-term new-o new-c)
                                               (car rest-of-result))
                                  (cadr rest-of-result))))))))
    (define (sub-poly p1 p2)
        (if (same-variable? (variable p1) (variable p2))
            (make-poly (variable p1)
                       (sub-terms (term-list p1)
                                  (coerce-to-type (term-list p2)
                                                  (type-tag (term-list p1)))))
            (sub-poly p1 (coerce-poly-to-var p2 (variable p1)))))
    (define (sub-terms L1 L2)
        (add-terms L1 (negate L2)))
    (define (poly-equals-zero? p)
        (empty-termlist? (term-list p)))
    (define (negate l)
        (mul-term-by-all-terms (make-term 0 (- 1)) l))
    (define (make-a-term order coeff) (list order coeff))
    (define (term-order term) (car term))
    (define (term-coeff term) (cadr term))
    (define (empty-termlist? terms)
        (apply-generic 'empty-termlist? terms))
    (define (the-empty-termlist list-type)
        ((get 'the-empty-termlist list-type)))
    (define (first-term terms)
        (apply-generic 'first-term terms))
    (define (rest-terms terms)
        (apply-generic 'rest-terms terms))
    (define (adjoin-term term term-list)
        (apply-generic 'adjoin-term term term-list))
    (define (order term)
        (apply-generic 'order term))
    (define (coeff term)
        (apply-generic 'coeff term))
    (define (make-term-list terms)
        ((get 'make 'sparse) terms))
    (define (scheme-number->polynomial number variable)
        (make-polynomial variable (list (make-term 0 number))))
    ;; interface to rest of the system
    (install-sparce-polynomials)
    (install-dense-polynomials)
    (define (tag p) (attach-tag 'polynomial p))
    (put 'add '(polynomial polynomial)
        (lambda (p1 p2) (tag (add-poly p1 p2))))
    (put 'add '(scheme-number polynomial)
        (lambda (x p) (add (scheme-number->polynomial x (variable p))
                            (tag p))))
    (put 'add '(polynomial scheme-number)
        (lambda (p x) (add (scheme-number->polynomial x (variable p))
                            (tag p))))
    (put 'mul '(polynomial polynomial)
        (lambda (p1 p2) (tag (mul-poly p1 p2))))
    (put 'mul '(scheme-number polynomial)
        (lambda (x p) (mul (scheme-number->polynomial x (variable p))
                            (tag p))))
    (put 'mul '(polynomial scheme-number)
        (lambda (p x) (mul (scheme-number->polynomial x (variable p))
                            (tag p))))
    (put 'sub '(polynomial polynomial)
        (lambda (p1 p2) (tag (sub-poly p1 p2))))
    (put 'sub '(scheme-number polynomial)
        (lambda (x p) (sub (scheme-number->polynomial x (variable p))
                            (tag p))))
    (put 'sub '(polynomial scheme-number)
        (lambda (p x) (sub (scheme-number->polynomial x (variable p))
                            (tag p))))
    (put 'div '(polynomial polynomial)
        (lambda (p1 p2) (map tag (div-poly p1 p2))))
    (put 'div '(scheme-number polynomial)
        (lambda (x p) (div (scheme-number->polynomial x (variable p))
                            (tag p))))
    (put 'div '(polynomial scheme-number)
        (lambda (p x) (div (scheme-number->polynomial x (variable p))
                            (tag p))))
    (put 'make 'term
        (lambda (order coeff) (attach-tag 'term (make-a-term order coeff))))
    (put 'make 'polynomial
        (lambda (var terms) (tag (make-poly var terms))))
    (put '=zero? '(polynomial) poly-equals-zero?)
    (put 'order '(term) term-order)
    (put 'coeff '(term) term-coeff)
    'done)
(define (make-term order coeff) ((get 'make 'term) order coeff))
(define (make-dense-polynomial variable term-list)
    ((get 'make 'polynomial) variable
                             ((get 'make 'dense) term-list)))
(define (make-sparse-polynomial variable term-list)
    ((get 'make 'polynomial) variable
                             ((get 'make 'sparse) term-list)))
(define (make-polynomial variable term-list)
    (make-sparse-polynomial variable term-list))

(install-polynomial-package)

(define p1 (make-polynomial 'x (list (make-term 2 (make-polynomial 'y (list (make-term 3 1) (make-term 1 4))))
                                     (make-term 1 (make-polynomial 'y (list (make-term 2 2)))))))
(define p2 (make-polynomial 'y (list (make-term 2 (make-polynomial 'x (list (make-term 3 1) (make-term 1 4))))
                                     (make-term 1 (make-polynomial 'x (list (make-term 2 2)))))))

;; (display p1) (newline)
;; (display p2) (newline)
(display (add p1 p2)) (newline)
(display (sub p1 p2)) (newline)
(display (mul p1 p2)) (newline)
(display (div p1 p2)) (newline)