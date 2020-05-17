;The extra frame is due to the let. This won't ever make a difference in output because the ordering and value of the expressions remains the same.

;To remove the extra frame, rather than using a let, reorder the expressions so that all of the defines come before the other expressions.

(define (reorder-defines body)
    (append (body-defines body) (remove-defines body)))
(define (make-procedure parameters body env)
    (list 'procedure parameters (reorder-defines body) env))