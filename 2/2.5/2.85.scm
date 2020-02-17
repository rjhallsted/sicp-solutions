(load "2.83.scm")

(define (install-equ?)
    (define (rational-equ? a b)
        (and (= (numer a) (numer b))
             (= (denom a) (denom b))))
    (define (complex-equ? a b)
        (and (= (real-part a) (real-part b))
             (= (imag-part a) (imag-part b))))
    (put 'equ? '(real real) =)
    (put 'equ? '(rational rational) rational-equ?)
    (put 'equ? '(complex complex) complex-equ?)
    (put 'equ? '(integer integer) =)
    'done)
(install-equ?)

(define (are-equal? a b)
    (define (raise-to-roof x)
        (let ((proc (get 'raise (type-tag x))))
            (if proc
                (raise-to-roof (apply proc (contents x))
                x)))
    (if (eq? (type-tag a) (type-tag b))
        (equ? a b)
        (equ? (raise-to-roof a) (raise-to-roof b))))

(define (install-drop-package)
    (define (project-complex x)
        (real-part x))
    (define (project-real x)
        (make-rational 1 (/ 1 x)))
    (define (project-rational x)
        (round (numer x) (denom x)))
    
    (put 'project 'complex project-complex)
    (put 'project 'real project-real)
    (put 'project 'rational project-rational)
    'done)

(define (drop x)
    (let ((proc (get 'project (type-tag x))))
        (if proc
            (let ((dropped (apply proc (contents x)))
                (let ((raise-proc (get 'raise (type-tag dropped))))
                    (if (are-equal? dropped (apply raise-proc (contents dropped)))
                        (drop dropped)
                        x)))
            x)))

(install-drop-package)
(install-raise-package)

(define (apply-generic op . args)
    (define (count-raises x count)
        (let ((raise-proc (get 'raise (type-tag x))))
            (if raise-proc
                (count-raises (raise-proc (contents x)) (+ count 1))
                count)))
    (define (no-method-error)
        (error "No method for these types"
                (list op type-tags)))
    (define (simplied proc)
        (lambda (. args) (apply drop (apply proc args))))
    (let ((type-tags (map type-tag args)))
        (let ((proc (get op type-tags)))
            (if proc
                ((simplified proc) (map contents args)))
                (if (= (length args) 2)
                    (let (t1 (car type-tags))
                         (t2 (cadr type-tags))
                         (a1 (car args))
                         (a2 (cadr args))
                        (if (eq? t1 t2)
                            (let ((raise-proc (get 'raise t1)))
                                (if raise-proc
                                    (apply-generic op (raise-proc a1) (raise-proc a2))
                                    (no-method-error)))
                            (let ((r1 (count-raises a1 0))
                                (r2 (count-raises a2 0))
                                (raise1 (get 'raise t1))
                                (raise2 (get 'raise t2)))
                                (cond
                                    ((and (> r1 r2) raise1)
                                        (apply-generic op
                                                      (raise1 a1)
                                                      a2))
                                    ((and (< r1 r2) raise2)
                                        (apply-generic op
                                                       a1 
                                                       (raise2 a2)))
                                    (else
                                        (no-method-error))))))
                    (no-method-error))))))