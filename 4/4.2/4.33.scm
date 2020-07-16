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
(define (x-unassigned len)
    (if (= len 0)
        '()
        (cons '*unassigned*
                (x-unassigned (- len 1)))))

;quote
(define (quoted? exp) (tagged-list? exp 'quote))
(define (text-of-quote exp env)
    (define (quote->cons exp)
        (if (null? exp)
            (quote-it '())
            (make-cons (quote-it (car exp))
                            (quote->cons (cdr exp)))))
    (let ((text (cadr exp)))    
        (if (pair? text)    
            (eval (quote->cons text) env)
            text)))


(define (quote-it x)
    (list 'quote x))
(define (make-cons a b)
    (list 'cons a b))

;assignment
(define (assignment? exp) (tagged-list? exp 'set!))
(define (assignment-variable exp) (cadr exp))
(define (assignment-value exp) (caddr exp))
(define (eval-assignment exp env)
    (set-variable-value! (assignment-variable exp)
                        (eval (assignment-value exp) env)
                        env)
    'ok)

;definition
(define (definition? exp) (tagged-list? exp 'define))
(define (definition-variable exp)
    (if (symbol? (cadr exp))
        (cadr exp)
        (caadr exp)))
(define (definition-value exp)
    (if (symbol? (cadr exp))
        (caddr exp)
        (make-lambda (cdadr exp)
                    (cddr exp))))
(define (eval-definition exp env)
    (define-variable! (definition-variable exp)
                        (eval (definition-value exp) env)
                        env)
    'ok)
(define (make-define name vars proc)
    (list 'define name vars proc))

;lambda
(define (lambda? exp) (tagged-list? exp 'lambda))
(define (lambda-parameters exp) (cadr exp))
(define (lambda-body exp) (cddr exp))
(define (eval-lambda exp env)
    (make-procedure (lambda-parameters exp)
                    (lambda-body exp)
                    env))
(define (make-lambda parameters body)
    (cons 'lambda (cons parameters body)))

;if
(define (if? exp) (tagged-list? exp 'if))
(define (if-predicate exp) (cadr exp))
(define (if-consequent exp) (caddr exp))
(define (if-alternative exp)
    (if (not (null? (cdddr exp)))
        (cadddr exp)
        'false))
(define (eval-if exp env)
    (if (true? (actual-value (if-predicate exp) env))
        (eval (if-consequent exp) env)
        (eval (if-alternative exp) env)))

(define (make-if predicate consequent alternative)
    (list 'if predicate consequent alternative))


;begin
(define (begin? exp) (tagged-list? exp 'begin))
(define (eval-begin exp env)
    (eval-sequence (cdr exp) env))
(define (make-begin seq) (cons 'begin seq))

;cond
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
(define (eval-cond exp env) (eval (cond->if exp) env))
    

;logical operators
(define (logical-clauses exp) (cdr exp))
(define (and? exp) (tagged-list? exp 'and))
(define (eval-and exp env)
    (let ((clauses (logical-clauses exp)))
        (let ((result (eval (first-exp clauses) env)))
            (if (not (true? result))
                false
                (if (last-exp? clauses)
                    result
                    (eval-and (rest-exps clauses) env))))))
(define (or? exp) (tagged-list? exp 'or))                
(define (eval-or exp env)
    (let ((clauses (logical-clauses exp)))
        (let ((result (eval (first-exp clauses) env)))
            (if (true? result)
                result
                (if (last-exp? clauses)
                    false
                    (eval-or (rest-exps clauses) env))))))

;let
(define (let? exp) (tagged-list? exp 'let))
(define (eval-let exp env) (eval (let->combination exp) env))
(define (let->combination exp)
    (let ((proc (make-lambda (let-variables exp)
                            (let-body exp))))
        (if (not (let-has-name? exp))
            (cons proc (let-vals exp))
            (make-begin
                (make-define (let-name exp)
                                    (let-variables exp)
                                    proc)
                (cons (let-name exp) (let-vals exp))))))
(define (let-has-name? exp) (not (pair? (cadr exp))))
(define (let-name exp) (cadr exp))
(define (let-assignments exp)
    (if (let-has-name? exp)
        (caddr exp)
        (cadr exp)))
(define (let-variables exp)
    (map (lambda (x) (car x)) (let-assignments exp)))
(define (let-vals exp)
    (map (lambda (x) (cadr x)) (let-assignments exp)))
(define (let-body exp)
    (if (let-has-name? exp)
        (cdddr exp)
        (cddr exp)))

(define (make-let bindings body)
    (cons 'let (cons bindings body)))

;let*
(define (let*? exp) (tagged-list? exp 'let*))
(define (eval-let* exp env) (eval (let*->nested-lets exp) env))
(define (let*->nested-lets exp)
    (define (nest-lets remaining-assignments)
        (if (no-assignments? remaining-assignments)
            (let-body exp)
            (list 'let
                (list (first-assignment remaining-assignments))
                (nest-lets (rest-assignments remaining-assignments)))))
    (nest-lets (let-assignments exp)))
(define (no-assignments? assignments) (null? assignments))
(define (first-assignment assignments) (car assignments))
(define (rest-assignments assignments) (cdr assignments))

;while
(define (while? exp) (tagged-list? exp 'while))
(define (eval-while exp env)
    (eval (transform-while (while-predicate exp) (while-proc exp))))
(define (transform-while predicate proc)
    (make-if predicate
        (make-begin (list proc
                            (transform-while predicate proc)))
        'false))
(define (while-predicate exp) (cadr exp))
(define (while-proc exp) (caddr exp))

;until
(define (until? exp) (tagged-list? exp 'until))
(define (eval-until exp env)
    (eval (transform-while (lambda () (not ((while-predicate exp))))
                            (while-proc exp))))

;for
(define (for? exp) (tagged-list? exp 'for))
(define (eval-for exp env)
    (eval (make-begin
                (for->sequence
                    (for-proc exp) 
                    (enumerate-interval (for-interval-start exp)
                                        (for-interval-end exp))))))
(define (for-proc exp) (cadddr exp))
(define (for-interval-start exp) (cadr exp))
(define (for-interval-end exp) (caddr exp))
(define (for->sequence proc interval)
    (if (null? interval)
        '()
        (cons
            (list proc (car interval))
            (for-sequence proc (cdr interval)))))


    
;letrec
(define (letrec? exp) (tagged-list? exp 'letrec))
(define (eval-letrec exp env) (eval (letrec->let exp) env))
(define (letrec->let exp)
    (make-let (pair-merge-lists (letrec-variables exp)
                                (x-unassigned (length (letrec-variables exp))))
                (append (make-letrec-sets (letrec-variables exp)
                                        (letrec-values exp))
                        (letrec-body exp))))
(define (letrec-variables exp)
    (map car (letrec-bindings exp)))
(define (letrec-values exp)
    (map cadr (letrec-bindings exp)))
(define (letrec-bindings exp) (cadr exp))
(define (letrec-body exp) (cddr exp))
(define (make-letrec-sets vars val-vars)
    (if (null? vars)
        '()
        (cons (list 'set! (car vars) (car val-vars))
                (make-letrec-sets (cdr vars) (cdr val-vars)))))

    
;procedure

(define (compound-procedure? p)
    (tagged-list? p 'procedure))
(define (procedure-parameters p) (cadr p))
(define (procedure-body p) (caddr p))
(define (procedure-environment p) (cadddr p))
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
    (map (lambda (exp) (definition-variable exp)) (body-defines body)))
(define (body-define-values body)
    (map (lambda (exp) (definition-value exp)) (body-defines body)))
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


;;general evaluation

(define apply-in-underlying-scheme apply)

(define (eval exp env)
    (cond ((self-evaluating? exp) exp)
        ((quoted? exp) (text-of-quote exp env))
        ((variable? exp) (lookup-variable-value exp env))
        ((assignment? exp) (eval-assignment exp env))
        ((definition? exp) (eval-definition exp env))
        ((lambda? exp) (eval-lambda exp env))
        ((if? exp) (eval-if exp env))
        ((begin? exp) (eval-begin exp env))
        ((cond? exp) (eval-cond exp env))
        ((and? exp) (eval-and exp env))
        ((or? exp) (eval-or exp env))
        ((let? exp) (eval-let exp env))
        ((let*? exp) (eval-let* exp env))
        ((letrec? exp) (eval-letrec exp env))
        ((while? exp) (eval-while exp env))
        ((until? exp) (eval-until exp env))
        ((for? exp) (eval-for exp env))
        ((application? exp)
            (apply (actual-value (operator exp) env)
                   (operands exp)
                   env))
        (else (error "Unkown expression type: EVAL" exp))))

(define (apply procedure arguments env)
    (cond ((primitive-procedure? procedure)
            (apply-primitive-procedure
                procedure
                (list-of-arg-values arguments env)))
        ((compound-procedure? procedure)
            (eval-sequence
                (procedure-body procedure)
                (extend-environment
                    (procedure-parameters procedure)
                    (list-of-delayed-args arguments env)
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
(define (list-of-arg-values exps env)
    (if (no-operands? exps)
        '()
        (cons (actual-value (first-operand exps) env)
            (list-of-arg-values (rest-operands exps) env))))
(define (list-of-delayed-args exps env)
    (if (no-operands? exps)
        '()
        (cons (delay-it (first-operand exps) env)
            (list-of-delayed-args (rest-operands exps) env))))

(define (tagged-list? x tag)
    (and (pair? x) (eq? (car x) tag)))

;thunks
(define (actual-value exp env)
    (force-it (eval exp env)))
(define (evaluated-thunk? obj)
    (tagged-list? obj 'evaluated-thunk))
(define (thunk-value evaluated-thunk)
    (cadr evaluated-thunk))
(define (force-it obj)
    (cond ((thunk? obj)
            (let ((result (actual-value (thunk-exp obj) (thunk-env obj))))
                (set-car! obj 'evaluated-thunk)
                (set-car! (cdr obj)
                            result) ;replace exp with its value
                (set-car! (cddr obj)
                            '())
                result)) ;forget unneeded env
        ((evaluated-thunk? obj) (thunk-value obj))
        (else obj)))
(define (delay-it exp env)
    (list 'thunk exp env))
(define (thunk? obj)
    (tagged-list? obj 'thunk))
(define (thunk-exp obj)
    (cadr obj))
(define (thunk-env obj)
    (caddr obj))

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


(define run-at-setup '(begin
    (define (cons x y) (lambda (m) (m x y)))
    (define (car z) (z (lambda (p q) p)))
    (define (cdr z) (z (lambda (p q) q)))

    (define (list-ref items n)
        (if (= n 0)
            (car items)
            (list-ref (cdr items) (- n 1))))
    (define (map proc items)
        (if (null? items)
            '()
            (cons (proc (car items))
                (map proc (cdr items)))))
    (define (scale-list items factor)
        (map (lambda (x) (* x factor)) items))
    (define (add-lists list1 list2)
        (cond ((null? list1) list2)
            ((null? list2) list1)
            (else
                (cons (+ (car list1) (car list2))
                    (add-lists (cdr list1) (cdr list2))))))))

(define (setup-environment)
    (let ((initial-env
                (extend-environment (primitive-procedure-names)
                                    (primitive-procedure-objects)
                                    the-empty-environment)))
        (define-variable! 'true true initial-env)
        (define-variable! 'false false initial-env)
        (eval run-at-setup initial-env)
        initial-env))

(define (primitive-procedure? proc)
    (tagged-list? proc 'primitive))
(define (primitive-implementation proc) (cadr proc))

(define primitive-procedures
    (list (list 'null? null?)
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

(define input-prompt ";;; L-eval input:")
(define output-prompt ";;; L-eval value:")
(define (driver-loop)
    (prompt-for-input input-prompt)
    (let ((input (read)))
        (let ((output (actual-value input the-global-environment)))
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