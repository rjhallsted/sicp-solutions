(load "2.38.scm")

(define l (list 1 2 3 4 5))

(define (reverse sequence)
  (fold-right (lambda (x y) (append y (list x))) nil sequence))

(display (reverse l)) (newline)

(define (reverse sequence)
  (fold-left (lambda (x y) (cons y x)) nil sequence))

(display (reverse l)) (newline)