(load "list-ops.scm")
(define fold-right accumulate)

(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest)
        result
        (iter (op result (car rest))
              (cdr rest))))
  (iter initial sequence))

;(fold-right / 1 (list 1 2 3))
;3/2

;(fold-left / 1 (list 1 2 3))
;3/2

;(fold-right list nil (list 1 2 3))
;(1 (2 (3 ())))

;(fold-left list nil (list 1 2 3))
;(((() 1) 2) 3)

;op needs to be commutative, like addition and multiplication
;(display (fold-right + 0 (list 1 2 3 4 5))) (newline)
;(display (fold-left + 0 (list 1 2 3 4 5))) (newline)

;(newline)

;(display (fold-right * 1 (list 1 2 3 4 5))) (newline)
;(display (fold-left * 1 (list 1 2 3 4 5))) (newline)