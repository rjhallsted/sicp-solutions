(define (analyze-sequence exps)
    (define (execute-sequence procs env)
        (cond ((null? (cdr procs))
                ((car procs) env))
            (else
                ((car procs) env)
                 (execute-sequence (cdr procs) env))))
    (let ((procs (map analyze exps)))
        (if (null? procs)
            (error "Empty sequence: ANALYZE"))
            (lambda (env)
                (execute-sequence procs env))))

(define (analyze-sequence exps)
    (define (sequentially proc1 proc2)
        (lambda (env) (proc1 env) (proc2 env)))
    (define (loop first-proc rest-procs)
        (if (null? rest-procs)
            first-proc
            (loop (sequentially first-proc (car rest-procs))
                  (cdr rest-procs))))
    (let ((procs (map analyze exps)))
        (if (null? procs) (error "empty sequence: ANALYZE"))
        (loop (car procs) (cdr procs))))


;one expressions
(lambda (env) (execute-sequence procs env))) ;Alyssa's
'(proc) ;book's

;two expressions
(lambda (env)   ;Alyssa's
    (execute-sequence procs env))


(lambda (env)   ;book's
    (proc1 env)
    (proc2 env))

;three expressions
(lambda (env)   ;Alyssa's
    (execute-sequence procs env))

(lambda (env)   ;book's
    ((lambda (env)
        (proc1 env) 
        (proc2 env)) env)
    (proc3 env))

;Alyssa's version returns a call to execute-sequence, so that the unrolling of the sequence happens in evaluation.
;The books version returns a sequence of lambdas, already unrolled and ready to go.

