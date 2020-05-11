;;list ops
(define nil '())

(define (list-contains? item l)
  (if (null? l)
      #f
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


;;proc tables
(define (assoc key records)
    (cond ((null? records) false)
        ((equal? key (caar records)) (car records))
        (else (assoc key (cdr records)))))

(define (make-table)
    (let ((local-table (list '*table*)))
        (define (lookup key-1 key-2)
            (let ((subtable
                    (assoc key-1 (cdr local-table))))
                (if subtable
                    (let ((record
                            (assoc key-2 (cdr subtable))))
                        (if record (cdr record) false))
                    false)))
        (define (insert! key-1 key-2 value)
            (let ((subtable
                    (assoc key-1 (cdr local-table))))
                (if subtable
                    (let ((record
                            (assoc key-2 (cdr subtable))))
                        (if record
                            (set-cdr! record value)
                            (set-cdr! subtable
                                      (cons (cons key-2 value)
                                            (cdr subtable)))))
                    (set-cdr! local-table
                              (cons (list key-1 (cons key-2 value))
                                    (cdr local-table)))))
            'ok)
        (define (dispatch m)
            (cond ((eq? m 'lookup-proc) lookup)
                  ((eq? m 'insert-proc!) insert!)
                  (else (error "Unkown operation: TABLE" m))))
        dispatch))

(define operation-table (make-table))
(define get (operation-table 'lookup-proc))
(define put (operation-table 'insert-proc!))


(define (attach-tag type-tag contents)
    (if (number? contents)
        contents
        (cons type-tag contents)))
(define (contents datum)
    (if (number? datum)
        datum
        (if (pair? datum)
            (cdr datum)
            (error "Bad tagged datum: CONTENTS" datum))))
(define (type-tag datum)
    (if (number? datum)
        'scheme-number
        (if (pair? datum)
            (car datum)
            (error "Bad tagged datum: TYPE-TAG" datum))))