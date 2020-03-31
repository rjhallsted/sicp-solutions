;by numbering the resources, you ensure that if lower-number resources are always accessed first
;so that once the first operation is running, the second cannot begin, because both operations get the resources in the same order, meaning 2 has to wait on the first resource until 1 is finished, rather than getting the second resource and waiting for access to the first.

(define (serialized-exchange account1 account2)
    (let ((serializer1 (account1 'serializer))
         (serializer2 (account2 'serializer))
         (num1 (account1 'number))
         (num2 (account2 'number)))
        (if (num1 < num2)
            ((serializer1 (serializer2 exchange)) account1 account2)
            ((serializer2 (serializer1 exchange)) account2 account1))))

(define (make-account-and-serializer balance account-number)
    (define (withdraw amount)
        (if (>= balance amount)
            (begin (set! balance (- balance amount))
                balance)
            "Insufficient funds"))
    (define (deposit amount)
        (set! balance (+ balance amount))
        balance)
    (let ((balance-serializer (make-serializer)))
        (define (dispatch m)
            (cond ((eq? m 'withdraw) withdraw)
                ((eq? m 'deposit) deposit)
                ((eq? m 'balance) balance)
                ((eq? m 'serializer) balance-serializer)
                ((eq? m 'number) account-number)
                (else (error "Unknown request: MAKE-ACCOUNT" m))))
        dispatch))