(define (make-mobile left right)
    (list left right))

(define (make-branch length structure)
    (list length structure))

(define (left-branch mobile)
    (car mobile))

(define (right-branch mobile)
    (cadr mobile))

(define (branch-length branch)
    (car branch))

(define (branch-structure branch)
    (cadr branch))


(define (total-weight mobile)
    (cond
        ((not (pair? mobile))
            mobile)
        (else 
            (+ (total-weight (branch-structure (left-branch mobile)))
                (total-weight (branch-structure (right-branch mobile)))))))


(define (torque branch)
    (* (branch-length branch)
        (total-weight (branch-structure branch))))
(define (balanced? mobile)
    (if (not (pair? mobile))
        #t
        (and (= (torque (left-branch mobile))
                (torque (right-branch mobile)))
            (and (balanced? (branch-structure (left-branch mobile)))
                (balanced? (branch-structure (right-branch mobile)))))))
    

(define a (make-branch 2 1))
(define b (make-mobile a a))
(define c (make-branch 2 b))
(define d (make-mobile a c))
(define e (make-mobile a a))
(define f (make-mobile c c))

(define off-balance (make-mobile a c))
(define g (make-mobile (make-branch 1 off-balance) (make-branch 1 off-balance)))


(display (balanced? d)) (newline)
(display (balanced? e)) (newline)
(display (balanced? f)) (newline)
(display (balanced? g)) (newline)

(newline)

;changed representations for question d
(define (make-mobile left right)
  (cons left right))
(define (make-branch length structure)
  (cons length structure))

;functions that need to change as a result
(define (right-branch mobile)
    (cdr mobile))
(define (branch-structure branch)
    (cdr branch))



(define a (make-branch 2 1))
(define b (make-mobile a a))
(define c (make-branch 2 b))
(define d (make-mobile a c))
(define e (make-mobile a a))
(define f (make-mobile c c))

(define off-balance (make-mobile a c))
(define g (make-mobile (make-branch 1 off-balance) (make-branch 1 off-balance)))


(display (balanced? d)) (newline)
(display (balanced? e)) (newline)
(display (balanced? f)) (newline)
(display (balanced? g)) (newline)