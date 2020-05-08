(define (install-eval-types)
    (define (eval-sequence exps env)
        (cond ((last-exp? exps)
                (eval (first-exp exps) env))
            (else
                (eval (first-exp exps) env)
                (eval-sequence (rest-exps exps) env))))
    (define (last-exp? seq) (null? (cdr seq)))
    (define (first-exp seq) (car seq))
    (define (rest-exps seq) (cdr seq))
    
    (define (sequence->exp seq)
        (cond ((null? seq) seq)
            ((last-exp? seq) (first-exp seq))
            (else (make-begin seq))))
    (define (make-begin seq) (cons 'begin seq))
    (define (make-lambda parameters body)
        (cons 'lambda (cons parameters body)))
    (define (make-if predicate consequent alternative)
        (list 'if predicate consequent alternative))

    ;quote
    (define (text-of-quote ops env)
        ops)

    ;assignment
    (define (assignment-variable ops) (car ops))
    (define (assignment-value ops) (cadr ops))
    (define (eval-assignment ops env)
        (set-variable-value! (assignment-variable ops)
                            (eval (assignment-variable ops) env)
                            env)
        'ok)

    ;definition
    (define (definition-variable ops)
        (if (symbol? car ops)
            (car ops)
            (cadr ops)))
    (define (definition-value ops)
        (if (symbol? car ops)
            (cadr ops)
            (make-lambda (cdar ops)
                        (cdr ops))))
    (define (eval-definition ops env)
        (define-variable! (definition-variable ops)
                            (eval (definition-value ops) env)
                            env)
        'ok)

    ;lambda
    (define (lambda-parameters ops) (car ops))
    (define (lambda-body ops) (cdr ops))
    (define (eval-lambda ops env)
        (make-procedure (lambda-parameters ops)
                        (lambda-body ops)
                        env))

    ;if
    (define (if-predicate ops) (car ops))
    (define (if-consequent ops) (cadr ops))
    (define (if-alternative ops)
        (if (not (null? (cddr ops)))
            (caddr ops)
            'false))
    (define (eval-if ops env)
        (if (true? (eval (if-predicate ops) env))
            (eval (if-consequent ops) env)
            (eval (if-alternative ops) env)))

    ;begin
    (define (eval-begin ops env)
        (eval-sequence ops env))

    ;cond
    (define (cond-clauses ops) ops)
    (define (cond-else-clause? clause)
        (eq? (cond-predicate clause) 'else))
    (define (cond-predicate clause) (car clause))
    (define (cond-actions clause) (cdr clause))
    (define (cond->if ops) (expand-clauses (cond-clauses ops)))
    (define (expand-clauses clauses)
        (if (null? clauses)
            'false
            (let ((first (car clauses)
                (rest (cdr clauses))))
                (if (cond-else-clause? first)
                    (if (null? rest)
                        (sequence->exp (cond-actions first))
                        (error "ELSE clause isn't last. COND->IF"
                            clauses))
                    (make-if (cond-predicate first)
                            (sequence->exp (cond-actions first))
                            (expand-clauses rest))))))
    (define (eval-cond ops env) (eval (cond->if ops) env))

    ;;install procedures
    (put 'eval 'quote text-of-quote)
    (put 'eval 'set! eval-assignment)
    (put 'eval 'define eval-definition)
    (put 'eval 'lambda eval-lambda)
    (put 'eval 'if eval-if)
    (put 'eval 'begin eval-begin)
    (put 'eval 'cond eval-cond)
    'ok)

(install-eval-types)
(define (eval exp env)
    (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        (else
            (let ((op (get 'eval (operator exp))))
                (cond (op (op (operands exp) env))
                    ((application? exp)
                        (apply (eval (operator exp) env)
                                (list-of-values (operands exp) env)))
                    (else (error "Unkown expression type: EVAL" exp)))))))

(define (apply procedure arguments)
    (cond ((primitive-procedure? procedure)
            (apply-primitive-procedure procedure arguments))
        ((compound-procedure? procedure)
            (eval-sequence
                (procedure-body procedure)
                (extend-environment
                    (procedure-parameters procedure)
                    arguments
                    (procedure-environment procedure))))
        (else
            (error "Unkown procedure type: APPLY" procedure))))


(define (self-evaluating? exp)
    (cond ((number? exp) true)
        ((string? exp) true)
        (else false)))

(define (variable? exp)
    (symbol? exp))

(define (application? exp) (pair? exp))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))
(define (no-operands? ops) (null? ops))
(define (first-operand ops) (car ops))
(define (rest-operands ops) (cdr ops))
(define (list-of-values exps env)
    (if (no-operands? exp)
        '()
        (cons (eval (first-operand exps) env)
            (list-of-values (rest-operands exps) env))))

