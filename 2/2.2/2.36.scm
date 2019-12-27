(load "list-ops.scm")

(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      nil
      (cons (accumulate op init (accumulate 
                                    (lambda (x y) (cons (car x) y))
                                    nil
                                    seqs))
            (accumulate-n op init (accumulate
                                    (lambda (x y) (cons (cdr x) y))
                                    nil
                                    seqs)))))

(define s (list (list 1 2 3) (list 4 5 6) (list 7 8 9) (list 10 11 12)))

(display (accumulate-n + 0 s)) (newline)
;(22 26 30)