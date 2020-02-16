(load "../2.2/list-ops.scm")

(define (list-eq? x)
    (cond 
        ((null? x)
            #t)
        ((null? (cdr x))
            #t)
        ((eq? (car x) (cadr x))
            (list-eq? (cdr x)))
        (else
            #f)))

(define (apply-generic op . args)
    (define (apply-coercions args coercions)
        (if (or (null? args) (null? coercions))
            '()
            (cons ((car coercions) (car args))
                  (apply-coercions (cdr args) (cdr coercions)))))
    (define (try-with-coercion type-tags types-to-try)
        (if (null? types-to-try)
            (error "No method for these types"
                    (list op type-tags))
            (let ((new-types (map (lambda (x) (car types-to-try)) type-tags)))
                (let ((proc (get op new-types)))
                    (if proc
                        (apply proc (map contents
                                         (apply-coercions args
                                                          (map (lambda (t1) (get-coercion t1 (car types-to-try))) type-tags))))
                        (try-with-coercion type-tags (cdr types-to-try)))))))
    (let ((type-tags (map type-tag args)))
        (let ((proc (get op type-tags)))
            (if (proc)
                (apply proc (map contents args))
                (if (list-eq? type-tags)
                    (error "No method for these types"
                        (list op type-tags))
                    (try-with-coercion type-tags type-tags))))))

;;Coercing all of the arguments directly to a specific type would not work in all situations. In the graph shown in Figure 2.26, some types could be feasibly coerced to others, but not directly. It is feasible that all of the arguments could be indirectly coerced into the same type, but not always directly.
