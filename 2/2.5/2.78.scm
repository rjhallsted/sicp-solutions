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
    (if (number? contents)
        contents
        (cons type-tag contents)))
(define (contents datum)
    (if (number? datum)
        datum
        (if (pair? datum)
            (cdr datum))
            (error "Bad tagged datum: CONTENTS" datum)))
(define (type-tag datum)
    (if (number? datum)
        'scheme-number
        (if (pair? datum)
            (car datum))
            (error "Bad tagged datum: TYPE-TAG" datum)))