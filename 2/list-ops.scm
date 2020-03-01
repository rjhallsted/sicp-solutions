(define nil '())

(define (list-contains? item l)
  (if (null? l)
      #t
    (if (equal? item (car l))
        #t
        (list-contains? item (cdr l)))))

(define (remove-duplicates l)
    (accumulate (lambda (item processed)
                    (if (list-contains? item processed)
                        (cons item processed)
                        processed))
                '()
                l))

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

(define (filter predicate sequence)
    (cond ((null? sequence) nil)
        ((predicate (car sequence))
          (cons (car sequence)
                (filter predicate (cdr sequence))))
        (else (filter predicate (cdr sequence)))))