(load "2.8.scm")

(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
        (p2 (* (lower-bound x) (upper-bound y)))
        (p3 (* (upper-bound x) (lower-bound y)))
        (p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))



(define (test-sign a)
    (lambda (x)
        (cond ((eqv? a +)
                (and (>= (lower-bound x) 0) (>= (upper-bound x) 0)))
            ((eqv? a -)
                (and (< (lower-bound x) 0) (< (upper-bound x) 0)))
            (else ;spans zero
                (and (< (lower-bound x) 0) (>= (upper-bound x) 0))))))

(define (test-signs a b)
    (lambda (x y)
        (and ((test-sign a) x) ((test-sign b) y))))

(define (mul-interval x y)
    (let ((p1 (* (lower-bound x) (lower-bound y)))
            (p2 (* (lower-bound x) (upper-bound y)))
            (p3 (* (upper-bound x) (lower-bound y)))
            (p4 (* (upper-bound x) (upper-bound y))))
        (cond (((test-signs + +) x y)
                (make-interval p1 p4))
            (((test-signs - -) x y)
                (make-interval p4 p1))
            (((test-signs 0 +) x y)
                (make-interval p2 p4))
            (((test-signs + 0) x y)
                (make-interval p3 p4))
            (((test-signs - +) x y)
                (make-interval p2 p3))
            (((test-signs + -) x y)
                (make-interval p3 p2))
            (((test-signs 0 0) x y)
                (make-interval (min p2 p3) p4))
            (((test-signs 0 -) x y)
                (make-interval p3 p1))
            (else   ;only condition left would be (test-signs - 0)
                (make-interval p2 p1)))))

(define below-zero (make-interval (- 3) (- 1)))
(define above-zero (make-interval 1 2))
(define spans-zero (make-interval (- 1) 5))

(print-interval (mul-interval above-zero above-zero))
(print-interval (mul-interval below-zero below-zero))
(print-interval (mul-interval spans-zero above-zero))
(print-interval (mul-interval above-zero spans-zero))
(print-interval (mul-interval below-zero above-zero))
(print-interval (mul-interval above-zero below-zero))
(print-interval (mul-interval spans-zero spans-zero))
(print-interval (mul-interval spans-zero below-zero))
(print-interval (mul-interval below-zero spans-zero))




(newline)