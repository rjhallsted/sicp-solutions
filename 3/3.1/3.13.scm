(define (make-cycle x)
    (set-cdr! (last-pair x) x)
    x)
(define z (make-cycle (list 'a 'b 'c)))

;z -> | a | * |
;       ^   |
;       | | b | * |
;       |       |
;       |     | c | * |
;       |           |
;       ------------

;;(last-pair z) will recurse forever, since the cdr will never be null. It will be ('b 'c ...), '('c 'a 'b ...), etc. forever