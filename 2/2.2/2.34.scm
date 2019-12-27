(load "list-ops.scm")

(define (horner-eval x coefficient-sequence)
  (accumulate (lambda (this-coeff higher-terms) (+ (* higher-terms x) this-coeff))
              0
              coefficient-sequence))

(display (horner-eval 2 (list 1 3 0 5 0 1))) (newline)
(display ((lambda (x)
        (+ 1 (* 3 x) (* 5 (expt x 3)) (expt x 5))) 2)) (newline)