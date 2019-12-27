(define (for-each proc items)
    (define (for-each-inner proc items)
       (proc (car items))
        (if (null? (cdr items))
            #t
            (for-each-inner proc (cdr items))))
    (if (null? items)
        #f
        (for-each-inner proc items)))
    


(for-each (lambda (x) (newline) (display x))
          (list 57 321 88))

(newline)


(for-each (lambda (x) (newline) (display x))
          '())

(newline)

(for-each (lambda (x) (newline) (display x))
          (list 5))

(newline)