

(define (eval exp env)
    (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted? exp) (text-of-quotation exp))
        ((assignment? exp) (eval-assignment exp env))
        ((definition? exp) (eval-definition exp env))
        ((and? exp) (eval-and exp env))
        ((or? exp) (eval-or exp env))
        ((if? exp) (eval-if exp env))
        ((lambda? exp) (make-procedure (lambda-parameters exp)
                                        (lambda-body exp)
                                        env))
        ((begin? exp) (eval-sequence (begin-actions exp) env))
        ((cond? exp) (eval (cond->if exp) env))
        ((let? exp) (eval (let->combination exp) env))
        ((application? exp) (apply (eval (operator exp) env)
                                    (list-of-values (operands exp) env)))
        (else (error "Unkown expression type: EVAL" exp))))

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

(define (list-of-values exps env)
    (if (no-operands? exp)
        '()
        (cons (eval (first-operand exps) env)
            (list-of-values (rest-operands exps) env))))

(define (eval-if exp env)
    (if (true? (eval (if-predicate exp) env))
        (eval (if-consequent exp) env)
        (eval (if-alternative exp) env)))

(define (eval-sequence exps env)
    (cond ((last-exp? exps)
            (eval (first-exp exps) env))
        (else
            (eval (first-exp exps) env)
            (eval-sequence (rest-exps exps) env))))

(define (eval-assignment exp env)
    (set-variable-value! (assignment-variable exp)
                        (eval (assignment-variable exp) env)
                        env)
    'ok)

(define (eval-definition exp env)
    (define-variable! (definition-variable exp)
                        (eval (definition-value exp) env)
                        env)
    'ok)


(define (self-evaluating? exp)
    (cond ((number? exp) true)
        ((string? exp) true)
        (else false)))

(define (variable? exp)
    (symbol? exp))

(define (quoted? exp) (tagged-list? exp 'quote))
(define (text-of-quotation exp) (cadr exp))

(define (tagged-list? exp tag)
    (if (pair? exp)
        (eq? (car exp) tag)
        false))

(define (assignment? exp) (tagged-list? exp 'set!))
(define (assignment-variable exp) (cadr exp))
(define (assignment-value exp) (caddr exp))

(define (definition? exp) (tagged-list? exp 'define))
(define (definition-variable exp)
    (if (symbol? cadr exp)
        (cadr exp)
        (caadr exp)))
(define (definition-value exp)
    (if (symbol? cadr exp)
        (caddr exp)
        (make-lambda (cdadr exp)
                     (cddr exp))))

(define (lambda? exp) (tagged-list? exp 'lambda))
(define (lambda-parameters exp) (cadr exp))
(define (lambda-body exp) (cddr exp))

(define (make-lambda parameters body)
    (cons 'lambda (cons parameters body)))

(define (if? exp) (tagged-list? exp 'if))
(define (if-predicate exp) (cadr exp))
(define (if-consequent exp) (caddr exp))
(define (if-alternative exp)
    (if (not (null? (cdddr exp)))
        (cadddr exp)
        'false))

(define (make-if predicate consequent alternative)
    (list 'if predicate consequent alternative))

(define (begin? exp) (tagged-list? exp 'begin))
(define (begin-actions exp) (cdr exp))
(define (last-exp? seq) (null? (cdr seq)))
(define (first-exp seq) (car seq))
(define (rest-exps seq) (cdr seq))

(define (sequence->exp seq)
    (cond ((null? seq) seq)
        ((last-exp? seq) (first-exp seq))
        (else (make-begin seq))))
(define (make-begin seq) (cons 'begin seq))

(define (application? exp) (pair? exp))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))
(define (no-operands? ops) (null? ops))
(define (first-operand ops) (car ops))
(define (rest-operands ops) (cdr ops))

(define (cond? exp) (tagged-list? exp 'cond))
(define (cond-clauses exp) (cdr exp))
(define (cond-else-clause? clause)
    (eq? (cond-predicate clause) 'else))
(define (cond-predicate clause) (car clause))
(define (cond-actions clause) (cdr clause))
(define (cond->if exp) (expand-clauses (cond-clauses exp)))
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
                        (expand-clause first)
                        (expand-clauses rest))))))
(define (expand-clause clause)
    (if (eq? (car (cond-actions clause)) '=>)
        (make-procedure '()
                        ((cadr (cond-actions clause)) ((cond-predcate clause))))
        (sequence->exp (cond-actions clause))))


(define (and? exp) (tagged-list? exp 'and))
(define (and-clauses exp) (cdr exp))
(define (eval-and exp env)
    (eval-and-clauses (and-clauses exp) env))
(define (eval-and-clauses clauses env)
    (let ((result (eval (first-exp clauses) env)))
        (if (not (true? result))
            false
            (if (last-exp? clauses)
                result
                (eval-and-clauses (rest-exps clauses))))))

(define (or? exp) (tagged-list? exp 'or))
(define (or-clauses exp) (cdr exp))
(define (eval-or exp env)
    (eval-or-clauses (or-clauses exp) env))
(define (eval-or-clauses clauses env)
    (let ((result (eval (first-exp clauses) env)))
        (if (true? result)
            result
            (if (last-exp? clauses)
                false
                (eval-or-clauses (rest-exps clauses))))))

(define (let->combination exp)
    (cons (make-lambda (let-variables exp)
                       (let-body exp))
          (let-values exp)))
(define (let-variables exp)
    (map (lambda (x) (car x)) (cadr exp)))
(define (let-body exp)
    (cddr exp))
(define (let-values exp)
    (map (lambda (x) (cadr x)) (cadr exp)))