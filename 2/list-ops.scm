(define nil '())

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

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

(define (enumerate-interval low high)
  (if (> low high)
      nil
      (cons low (enumerate-interval (+ low 1) high))))

(define (enumerate-tree tree)
  (cond ((null? tree) nil)
        ((not (pair? tree)) (list tree))
        (else (append (enumerate-tree (car tree))
                      (enumerate-tree (cdr tree))))))

(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))