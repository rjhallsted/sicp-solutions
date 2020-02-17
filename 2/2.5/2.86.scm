;;You would have to add generic trigonometry operations. Also, the equality checks for complex numbers would have to be more general.

;;Both the rectangular and polar packages would need to be modified to more generically handle numbers.
    ;;Well, not really. If you make the trigonometery operations generic, and swap those used in the packages to the generic ones, the rest can remain the same.
    ;;You would need a generic version of:
        ;;sqrt
        ;;square
        ;;atan
        ;;cos
        ;;sin

(load "2.83.scm")

(define (install-generic-square-root)
    (define (square-root-rat x)
        (make-rational (square-root (numer x))
                        (square-root (denom x))))
    (put 'square-root 'rational square-root-rat)
    (put 'square-root 'real sqrt)
    (put 'square-root 'integer sqrt)
    'done)

(define (install-generic-square-it)
    (define (square-it-rat x)
        (mul x x))
    (put 'square-it 'rational square-it-rat)
    (put 'square-it 'real square)
    (put 'square-it 'integer square)
    'done)

(define (install-generic-atangent)
    (define (atangent-rat x)
        (atangent (raise-to 'real x)))
    (put 'atangent 'rational atangent-rat)
    (put 'atangent 'real atan)
    (put 'atangent 'integer atan)
    'done)

(define (install-generic-cosine)
    (define (cosine-rat x)
        (cosine (raise-to 'real x)))
    (put 'cosine 'rational cosine-rat)
    (put 'cosine 'real cos)
    (put 'cosine 'integer cos)
    'done)

(define (install-generic-sine)
    (define (sine-rat x)
        (sine (raise-to 'real x)))
    (put 'sine 'rational sine-rat)
    (put 'sine 'real sin)
    (put 'sine 'integer sin)
    'done)

(define (install-generic-maths)
    (install-generic-square-root)
    (install-generic-square-it)
    (install-generic-atangent)
    (install-generic-cosine)
    (install-generic-sine)
    'done)

(define (install-rectangular-package)
    ;; internal procedures
    (define (real-part z) (car z))
    (define (imag-part z) (cdr z))
    (define (make-from-real-imag x y) (cons x y))
    (define (magnitude z)
        (square-root (+ (square-it (real-part z))
                        (square-it (imag-part z)))))
    (define (angle z)
        (atangent (imag-part z) (real-part z)))
    (define (make-from-mag-ang r a) 
        (cons (* r (cosine a)) (* r (sine a))))
    ;; interface to the rest of the system
    (define (tag x) (attach-tag 'rectangular x))
    (put 'real-part '(rectangular) real-part)
    (put 'imag-part '(rectangular) imag-part)
    (put 'magnitude '(rectangular) magnitude)
    (put 'angle '(rectangular) angle)
    (put 'make-from-real-imag 'rectangular 
        (lambda (x y) (tag (make-from-real-imag x y))))
    (put 'make-from-mag-ang 'rectangular 
        (lambda (r a) (tag (make-from-mag-ang r a))))
    'done)

(define (install-polar-package)
    ;; internal procedures
    (define (magnitude z) (car z))
    (define (angle z) (cdr z))
    (define (make-from-mag-ang r a) (cons r a))
    (define (real-part z)
        (* (magnitude z) (cosine (angle z))))
    (define (imag-part z)
        (* (magnitude z) (sine (angle z))))
    (define (make-from-real-imag x y) 
        (cons (square-root (+ (square-it x) (square-it y)))
                            (atangent y x)))
    ;; interface to the rest of the system
    (define (tag x) (attach-tag 'polar x))
    (put 'real-part '(polar) real-part)
    (put 'imag-part '(polar) imag-part)
    (put 'magnitude '(polar) magnitude)
    (put 'angle '(polar) angle)
    (put 'make-from-real-imag 'polar
        (lambda (x y) (tag (make-from-real-imag x y))))
    (put 'make-from-mag-ang 'polar 
        (lambda (r a) (tag (make-from-mag-ang r a))))
    'done)

(define (install-equ?)
    (define (rational-equ? a b)
        (and (= (numer a) (numer b))
             (= (denom a) (denom b))))
    (define (complex-equ? a b)
        (and (equ? (real-part a) (real-part b))
             (equ? (imag-part a) (imag-part b))))
    (put 'equ? '(real real) =)
    (put 'equ? '(rational rational) rational-equ?)
    (put 'equ? '(complex complex) complex-equ?)
    (put 'equ? '(integer integer) =)
    'done)
(install-equ?)