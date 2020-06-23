(load "evaluation.scm")
(define new-eval eval)
(define new-env the-global-environment)

(load "original-eval.scm")
(define old-eval eval)
(define old-env the-global-environment)

(define test
    '((define (mul x y) (* x y))
    (define (do-times fn result x times)
        (if (= times 0)
            result
            (fn result x)))
    (do-times mul 1 5 100)))

(display "old:") (newline)
(define t (get-universal-time))
(display (old-eval test old-env)) (newline)
(display (- (get-universal-time) t)) (newline) (newline)

(display "new:") (newline)
(define t (get-universal-time))
(display (new-eval test new-env)) (newline)
(display (- (get-universal-time) t)) (newline) (newline)