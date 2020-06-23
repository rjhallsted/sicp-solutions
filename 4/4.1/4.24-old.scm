(load "original-eval.scm")

(define test
    '(begin
        (define (mul x y) (* x y))
    (define (do-times fn result x times)
        (if (= times 0)
            result
            (do-times fn (fn result x) x (- times 1))))
    (do-times (lambda (x y) (do-times mul 1 5 100))
            1 1 100)))

(display (eval test the-global-environment)) (newline)