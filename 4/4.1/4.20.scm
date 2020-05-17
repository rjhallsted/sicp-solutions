(load "../../core-func.scm")

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
;logic
(define (true? x) (not (false? x)))
(define (false? x) (eq? x false))

(define (pair-merge-lists l1 l2)
    (if (null? l1)
        '()
        (cons (list (car l1) (car l2))
              (pair-merge-lists (cdr l1) (cdr l2)))))

;makes (defined in install-eval-types)
(define make-begin (get 'make 'begin))
(define make-lambda (get 'make 'lambda))
(define make-if (get 'make 'if))
(define make-procedure (get 'make 'procedure))
(define make-let (get 'make 'let))

(define (install-eval-types)
    (define (x-unassigned len)
        (if (= len 0)
            '()
            (cons '*unassigned*
                  (x-unassigned (- len 1)))))

    ;quote
    (define (text-of-quote ops env) (car ops))

    ;assignment
    (define (assignment-variable ops) (car ops))
    (define (assignment-value ops) (cadr ops))
    (define (eval-assignment ops env)
        (set-variable-value! (assignment-variable ops)
                            (eval (assignment-value ops) env)
                            env)
        'ok)

    ;definition
    (define (definition-variable ops)
        (if (symbol? (car ops))
            (car ops)
            (caar ops)))
    (define (definition-value ops)
        (if (symbol? (car ops))
            (cadr ops)
            (make-lambda (cdar ops)
                        (cdr ops))))
    (define (eval-definition ops env)
        (define-variable! (definition-variable ops)
                            (eval (definition-value ops) env)
                            env)
        'ok)
    (define (make-define name vars proc)
        (list 'define name vars proc))

    ;lambda
    (define (lambda-parameters ops) (car ops))
    (define (lambda-body ops) (cdr ops))
    (define (eval-lambda ops env)
        (make-procedure (lambda-parameters ops)
                        (lambda-body ops)
                        env))
    
    (define (make-lambda parameters body)
        (cons 'lambda (cons parameters body)))

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

    (define (make-if predicate consequent alternative)
        (list 'if predicate consequent alternative))


    ;begin
    (define (eval-begin ops env)
        (eval-sequence ops env))
    (define (make-begin seq) (cons 'begin seq))

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
            (let ((first (first-exp clauses)) (rest (rest-exps clauses)))
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
    (define (eval-cond ops env) (eval (cond->if ops) env))
    

    ;logical operators
    (define (eval-and clauses env)
        (let ((result (eval (first-exp clauses) env)))
            (if (not (true? result))
                false
                (if (last-exp? clauses)
                    result
                    (eval-and (rest-exps clauses) env)))))
    (define (eval-or clauses env)
        (let ((result (eval (first-exp clauses) env)))
            (if (true? result)
                result
                (if (last-exp? clauses)
                    false
                    (eval-or (rest-exps clauses) env)))))

    ;let
    (define (eval-let ops env) (eval (let->combination ops) env))
    (define (let->combination ops)
        (let ((proc (make-lambda (let-variables ops)
                                (let-body ops))))
            (if (not (let-has-name? ops))
                (cons proc (let-values ops))
                (make-begin
                    (make-define (let-name ops)
                                       (let-variables ops)
                                       proc)
                    (cons (let-name ops) (let-values ops))))))
    (define (let-has-name? ops) (not (pair? (car ops))))
    (define (let-name ops) (car ops))
    (define (let-assignments ops)
        (if (let-has-name? ops)
            (cadr ops)
            (car ops)))
    (define (let-variables ops)
        (map (lambda (x) (car x)) (let-assignments ops)))
    (define (let-values ops)
        (map (lambda (x) (cadr x)) (let-assignments ops)))
    (define (let-body ops)
        (if (let-has-name? ops)
            (cddr ops)
            (cdr ops)))

    (define (make-let bindings body)
        (cons 'let (cons bindings body)))

    ;let*
    (define (eval-let* ops env) (eval (let*->nested-lets ops) env))
    (define (let*->nested-lets ops)
        (define (nest-lets remaining-assignments)
            (if (no-assignments? remaining-assignments)
                (let-body ops)
                (list 'let
                    (list (first-assignment remaining-assignments))
                    (nest-lets (rest-assignments remaining-assignments)))))
        (nest-lets (let-assignments ops)))
    (define (no-assignments? assignments) (null? assignments))
    (define (first-assignment assignments) (car assignments))
    (define (rest-assignments assignments) (cdr assignments))

    ;while
    (define (eval-while ops env)
        (eval (transform-while (while-predicate ops) (while-proc ops))))
    (define (transform-while predicate proc)
        (make-if predicate
            (make-begin (list proc
                              (transform-while predicate proc)))
            'false))
    (define (while-predicate ops) (car ops))
    (define (while-proc ops) (cadr ops))

    ;until
    (define (eval-until ops env)
        (eval (transform-while (lambda () (not ((while-predicate ops))))
                               (while-proc ops))))

    ;for
    (define (eval-for ops env)
        (eval (make-begin
                    (for->sequence
                        (for-proc ops) 
                        (enumerate-interval (for-interval-start ops)
                                            (for-interval-end ops))))))
    (define (for-proc ops) (caddr ops))
    (define (for-interval-start ops) (car ops))
    (define (for-interval-end ops) (cadr ops))
    (define (for->sequence proc interval)
        (if (null? interval)
            '()
            (cons
                (list proc (car interval))
                (for-sequence proc (cdr interval)))))


    ;procedure (the accessors must live outside of this package because they are used as part of apply)
    (define (make-procedure parameters body env)
        (if (has-defines? body)
            (list 'procedure parameters (scan-out-defines body) env)
            (list 'procedure parameters body env)))
    (define (has-defines? body)
        (> (length (body-defines body)) 0))
    (define (scan-out-defines body)
        (define (join-vars-and-values vars vals)
            (cond ((< (length vars) (length vals))
                    (error "Too many values supplied: SCAN-OUT-DEFINES" vars vals))
                ((> (length vars) (length vals))
                    (error "Too many variables supplied: SCAN-OUT-DEFINES" vars vals))
                (else
                    (pair-merge-lists vars vals))))
        (let ((vars (body-define-variables body))
              (vals (body-define-values body)))
            (list (make-let (join-vars-and-values
                                vars
                                (x-unassigned (length vals)))
                            (append (make-sets vars vals)
                                    (remove-defines body))))))
    (define (body-define-variables body)
        (map (lambda (exp) (definition-variable (operands exp))) (body-defines body)))
    (define (body-define-values body)
        (map (lambda (exp) (definition-value (operands exp))) (body-defines body)))
    (define (definition? exp)
        (tagged-list? exp 'define))
    (define (body-defines body)
        (filter definition? body))
    (define (make-sets vars vals)
        (cond ((< (length vars) (length vals))
                (error "Too many values supplied: MAKE-SETS" vars vals))
            ((> (length vars) (length vals))
                (error "Too many variables supplied: MAKE-SETS" vars vals))
            (else
                (map (lambda (x) (cons 'set! x)) (pair-merge-lists vars vals)))))
    (define (remove-defines body)
        (filter (lambda (exp) (not (definition? exp))) body))

    
    ;letrec
    (define (eval-letrec ops env) (eval (letrec->let ops) env))
    (define (letrec->let ops)
        (make-let (pair-merge-lists (letrec-variables ops)
                                    (x-unassigned (length (letrec-variables ops))))
                  (append (make-letrec-sets (letrec-variables ops)
                                            (letrec-values ops))
                          (letrec-body ops))))
    (define (letrec-variables ops)
        (map car (letrec-bindings ops)))
    (define (letrec-values ops)
        (map cadr (letrec-bindings ops)))
    (define (letrec-bindings ops) (car ops))
    (define (letrec-body ops) (cdr ops))
    (define (make-letrec-sets vars val-vars)
        (if (null? vars)
            '()
            (cons (list 'set! (car vars) (car val-vars))
                  (make-letrec-sets (cdr vars) (cdr val-vars)))))
    

    ;;install procedures
    (put 'eval 'quote text-of-quote)
    (put 'eval 'set! eval-assignment)
    (put 'eval 'define eval-definition)
    (put 'eval 'lambda eval-lambda)
    (put 'eval 'if eval-if)
    (put 'eval 'begin eval-begin)
    (put 'eval 'cond eval-cond)
    (put 'eval 'and eval-and)
    (put 'eval 'or eval-or)
    (put 'eval 'let eval-let)
    (put 'eval 'let* eval-let*)
    (put 'eval 'while eval-while)
    (put 'eval 'until eval-until)
    (put 'eval 'for eval-for)
    (put 'eval 'letrec eval-letrec)

    (put 'make 'begin make-begin)
    (put 'make 'lambda make-lambda)
    (put 'make 'if make-if)
    (put 'make 'procedure make-procedure)
    (put 'make 'let make-let)
    'ok)


(define apply-in-underlying-scheme apply)

(install-eval-types)
(define (eval exp env)
    (display "eval:") (newline)
    (display exp) (newline)
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
    (if (no-operands? exps)
        '()
        (cons (eval (first-operand exps) env)
            (list-of-values (rest-operands exps) env))))

(define (compound-procedure? p)
    (tagged-list? p 'procedure))
(define (procedure-parameters p) (cadr p))
(define (procedure-body p) (caddr p))
(define (procedure-environment p) (cadddr p))

(define (tagged-list? x tag)
    (and (pair? x) (eq? (car x) tag)))


;environment
(define (enclosing-environment env) (cdr env))
(define (first-frame env) (car env))
(define the-empty-environment '())

(define (make-frame variables values)
    (cons 'frame
        (pair-merge-lists variables values)))
(define (frame-bindings frame) (cdr frame))
(define (first-binding bindings) (car bindings))
(define (rest-bindings bindings) (cdr bindings))
(define (frame-variables frame) (map binding-variable (frame-bindings frame)))
(define (frame-values frame) (map binding-value (frame-bindings frame)))
(define (binding-variable binding) (car binding))
(define (binding-value binding) (cadr binding))
(define (set-binding-value! binding value)
    (set-car! (cdr binding) value))
(define (add-binding-to-frame! var val frame)
    (set-cdr! frame (cons (list var val) (cdr frame))))
(define (extend-environment vars vals base-env)
    (if (= (length vars) (length vals))
        (cons (make-frame vars vals) base-env)
        (if (< (length vars) (length vals))
            (error "Too many arguments supplied" vars vals)
            (error "Too few arguments supplied" vars vals))))


(define (make-generic-scanner null-proc eq-proc test-against)
    (define (scan bindings)
        (cond ((null? bindings) (null-proc))
            ((eq? test-against (binding-variable (first-binding bindings)))
                (eq-proc bindings))
            (else (scan (rest-bindings bindings)))))
    (lambda (frame) (scan (frame-bindings frame))))

(define (make-scanner null-proc eq-proc test-against)
    (make-generic-scanner
        null-proc
        (lambda (bindings)
            (eq-proc (first-binding bindings)))
        test-against))

(define (make-scanner-and-remove null-proc test-against)
    (make-generic-scanner
        null-proc
        (lambda (bindings)
            (set-car! bindings (rest-bindings frame)))
        test-against))

(define (check-env-then-scan scan env error-proc)
    (if (eq? env the-empty-environment)
        (error-proc)
        (scan (first-frame env))))

(define (lookup-variable-value var env)
    (define (env-loop env)
        (let ((scan (make-scanner
                        (lambda () (env-loop (enclosing-environment env)))
                        (lambda (binding) (binding-value binding))
                        var)))
            (check-env-then-scan
                    scan
                    env
                    (lambda () (error "Unbound variable:" var)))))
    (let ((value (env-loop env)))
        (if (eq? value '*unassigned*)
            (error "Unassigned variable:" var)
            value)))

(define (set-variable-value! var val env)
    (define (env-loop env)
        (let ((scan (make-scanner
                        (lambda () (env-loop (enclosing-environment env)))
                        (lambda (binding) (set-binding-value! binding val))
                        var)))
            (check-env-then-scan
                    scan
                    env
                    (lambda () (error "Unbound variable: SET!" var)))))
    (env-loop env))

(define (define-variable! var val env)
    (let ((scan (make-scanner
                    (lambda () (add-binding-to-frame! var val (first-frame env)))
                    (lambda (binding) (set-binding-value! binding val))
                    var)))
        (check-env-then-scan
                scan
                env
                (lambda () (error "Failed to define variable" var)))))

(define (make-unbound! var env)
    (define (already-unbound)
        (error "Variable is already unbound: UNBIND" var))
    (let ((scan (make-scanner-and-remove
                    already-unbound
                    var)))
        (check-env-then-scan
            scan
            env
            already-unbound)))

(define (setup-environment)
    (let ((initial-env
                (extend-environment (primitive-procedure-names)
                                    (primitive-procedure-objects)
                                    the-empty-environment)))
        (define-variable! 'true true initial-env)
        (define-variable! 'false false initial-env)
        initial-env))

(define (primitive-procedure? proc)
    (tagged-list? proc 'primitive))
(define (primitive-implementation proc) (cadr proc))

(define primitive-procedures
    (list (list 'car car)
          (list 'cdr cdr)
          (list 'cons cons)
          (list 'null? null?)
          (list '+ +)
          (list '- -)
          (list '/ /)
          (list '* *)
          (list '> >)
          (list '< <)
          (list '= =)
          (list '<= <=)
          (list '>= >=)
          (list '*unassigned* '*unassigned*)
          ))
(define (primitive-procedure-names)
    (map car primitive-procedures))
(define (primitive-procedure-objects)
    (map (lambda (proc) (list 'primitive (cadr proc)))
         primitive-procedures))

(define (apply-primitive-procedure proc args)
    (apply-in-underlying-scheme (primitive-implementation proc)
                                args))

(define input-prompt ";;; M-eval input:")
(define output-prompt ";;; M-eval value:")
(define (driver-loop)
    (prompt-for-input input-prompt)
    (let ((input (read)))
        (let ((output (eval input the-global-environment)))
            (announce-output output-prompt)
            (user-print output)))
    (driver-loop))
(define (prompt-for-input string)
    (newline)
    (newline)
    (display string) (newline))
(define (announce-output string)
    (newline)
    (display string) (newline))
(define (user-print object)
    (if (compound-procedure? object)
        (display (list 'compound-procedure
                        (procedure-parameters object)
                        (procedure-body object)
                        '<procedure-env>))
        (display object)))


(define the-global-environment (setup-environment))
(driver-loop)


;b) Louis's reasoning is loose because, you'd have to do something akin to what the transformed letrec is. In a traditional let, the variables are defined in terms of the outer environment, and used in the inner environment. Because of letrecs transformation, the variables are defined in terms of the inner environment. Having the variables be defined in terms of the inner environment is crucial for them to have access to each other, so that they are bound by the time they need access to one another.

; Basically, for recursive definitions to work, the <fact-body> needs access to the bounded <fact>, which:
;(let ((<fact> <fact-body>))) 
; does not provide, while
;(let ((<fact> '*unassigned*))
;    (set! <fact> <fact-body>))
;and
;(let ()
;    (define <fact> <fact-body>))
;do allow for.