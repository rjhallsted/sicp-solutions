;(list 'a 'b 'c)
;; (a b c)

;(list (list 'george))
;; ((george))
;(cdr '((x1 x2) (y1 y2)))
;; ((y1 y2))

;(cadr '((x1 x2) (y1 y2)))
;; (y1 y2)
;(pair? (car '(a short list)))
;; #f
;(memq 'red '((red shoes) (blue socks)))
;; #f

;(memq 'red '(red shoes blue socks)
;; (red shoes blue socks)

(display (list 'a 'b 'c)) (newline)
;; (a b c)

(display (list (list 'george))) (newline)
;; ((george))
(display (cdr '((x1 x2) (y1 y2)))) (newline)
;; (y1 y2)

(display (cadr '((x1 x2) (y1 y2)))) (newline)
;; y1
(display (pair? (car '(a short list)))) (newline)
;; #f
(display (memq 'red '((red shoes) (blue socks)))) (newline)
;; #f

(display (memq 'red '(red shoes blue socks))) (newline)
;; (red shoes blue socks)