;left->right
(define (list-of-values exps env)
    (if (no-operands? exp)
        '()
        (let ((first (eval (first-operand exps) env))
             (rest (list-of-values (rest-operands exps) env)))
            (cons first rest))))

;right->left
(define (list-of-values exps env)
    (if (no-operands? exp)
        '()
        (let ((rest (list-of-values (rest-operands exps) env))
             (first (eval (first-operand exps) env)))
            (cons first rest))))