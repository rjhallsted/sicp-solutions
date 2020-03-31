(define x 10)
(parallel-execute
    (lambda () (set! x (* x x)))
    (lambda () (set! x (* x x x))))

;all possible values of x
;(* 10 10), (* 100 100 100) = 1,000,000
;(* 100 100 100), (* 1,000,000 1,000,000) = 1,000,000,000,000
;(* 10 1,000) = 10,000
    ;(* 10 10 10)
;(* 10 10)
    ;(* 10 10 100) = 10,000
;(* 10 10)
    ;(* 10 100 100) = 100,000
;(* 10 1,000) =10,000
    ;(* 10 10 10)
;(* 1,000 1,000) = 1,000,000
    ;(* 10 10 10)

;;options are:
;1 million
;1 trillion
;10 thousand
;100 thousand

(define x 10)
(define s (make-serializer))
(parallel-execute
    (s (lambda () (set! x (* x x))))
    (s (lambda () (set! x (* x x x)))))

;(* 10 10)
    ;(* 100 100 100) = 1,000,000
;(* 10 10 10)
;   (* 1000 1000) = 1,000,000

;;Only option is 1 million
