;;;old definitions
(define (type-tag datum)
    (if (pair? datum)
        (car datum)
        (error "Bad tagged datum: TYPE-TAG" datum)))
(define (contents datum)
    (if (pair? datum)
        (cdr datum)
        (error "Bad tagged datum: CONTENTS" datum)))
(define (attach-tag type-tag contents)
    (cons type-tag contents))

;;;;new definitions
(define (attach-tag type-tag contents)
    (if (number? (car contents))
        contents
        (cons type-tag contents)))
(define (contents datum)
    (if (pair? datum)
        (if (number? (car datum))
            datum
            (cdr datum))
        (error "Bad tagged datum: CONTENTS" datum)))
(define (type-tag datum)
    (if (pair? datum)
        (if (number? (car datum))
            'scheme-number
            (car datum))
        (error "Bad tagged datum: TYPE-TAG" datum)))