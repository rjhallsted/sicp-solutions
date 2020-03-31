;;options:
;;101
;;121
;;110
;;11
;;100

(define x 10)
(define s (make-serializer))
    (parallel-execute
        (lambda () (set! x ((s (lambda () (* x x))))))
        (s (lambda () (set! x (+ x 1)))))

;(set x (s (* x x)))
;(s (set x (+ x 1)))

;; (s (* x x) (set x (+ x 1)))

;; x = (* 10 10), x = (+ 100 1) ;101
;; x = (+ 10 1), x = (* 11 11) ;121
;; (* 10 10), x = (+ 10 1), x = 100 ;100

;;resulting options are 101, 121, 100