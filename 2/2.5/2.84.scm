(load "2.83.scm")

;;to figure out if some type is higher than another, count how many times it can be raised.

(define (apply-generic op . args)
    (define (count-raises x count)
        (let ((raise-proc (get 'raise (type-tag x))))
            (if raise-proc
                (count-raises (raise-proc x) (+ count 1))
                count)))
    (define (no-method-error)
        (error "No method for these types"
                (list op type-tags)))
    (let ((type-tags (map type-tag args)))
        (let ((proc (get op type-tags)))
            (if proc
                (apply proc (map contents args))
                (if (= (length args) 2)
                    (let (t1 (car type-tags))
                         (t2 (cadr type-tags))
                         (a1 (car args))
                         (a2 (cadr args))
                        (if (eq? t1 t2)
                            (let ((raise-proc (get 'raise t1)))
                                (if raise-proc
                                    (apply-generic op (raise-proc a1) (raise-proc a2))
                                    (no-method-error)))
                            (let ((r1 (count-raises a1 0))
                                (r2 (count-raises a2 0))
                                (raise1 (get 'raise t1))
                                (raise2 (get 'raise t2)))
                                (cond
                                    ((and (> r1 r2) raise1)
                                        (apply-generic op
                                                      (raise1 a1)
                                                      a2))
                                    ((and (< r1 r2) raise2)
                                        (apply-generic op
                                                       a1 
                                                       (raise2 a2)))
                                    (else
                                        (no-method-error))))))
                    (no-method-error))))))