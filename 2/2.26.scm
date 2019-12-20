(define x (list 1 2 3))
(define y (list 4 5 6))


(append x y)
;prints (1 2 3 4 5 6)
(display (append x y)) (newline)

(cons x y)
;prints ((1 2 3) 4 5 6)
(display (cons x y)) (newline)

(list x y)
;prints ((1 2 3) (4 5 6))
(display (list x y)) (newline)