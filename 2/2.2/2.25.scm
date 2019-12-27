;pick seven from the following lists

(define a (list 1 3 (list 5 7) 9))
(display (car (cdr (car (cdr (cdr a))))))
(newline)

(define b (list (list 7)))
(display (car (car b)))
(newline)

(define c (list 1 (list 2 (list 3 (list 4 (list 5 (list 6 7)))))))
(display (car (cdr (car (cdr (car (cdr (car (cdr (car (cdr (car (cdr c)))))))))))))
(newline)