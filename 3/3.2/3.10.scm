(define (make-withdraw initial-amount)
    (let ((balance initial-amount))
        (lambda (amount)
            (if (>= balance amount)
                (begin (set! balance (- balance amount))
                       balance)
                "Insufficient funds"))))

(define W1 (make-withdraw 100))
(W1 50)
(define W2 (make-withdraw 100))

;;make-withdraw

;;W1 -> initial-amount: 100
;;      ((lambda (balance)
;;          (lambda (amount)
;;              (if (>= balance amount)
;;                  (begin (set! balance (- balance amount))
;;                         balance)
;;                  "Insufficient funds")))) initial-amount)
;;      E1 -> balance: 100
;;(W1 100) -> amount: 50
;;         -> (lambda (amount)
;;                  (if (>= balance amount)
;;                      (begin (set! balance (- balance amount))
;;                              balance)
;;                  "Insufficient funds")))
;;     E1 -> balance: 100
    ;;     E1a -> amount: 40
    ;;           (if (>= balance amount)
    ;;              (begin (set! balance (- balance amount))
    ;;                      balance)
    ;;              "Insufficient funds")
;;     E1 -> balance: 60
;;60
;;W2 -> initial-amount: 100
;;      ((lambda (balance)
;;          (lambda (amount)
;;              (if (>= balance amount)
;;                  (begin (set! balance (- balance amount))
;;                         balance)
;;                  "Insufficient funds")))) initial-amount)
;;      E2 -> balance: 100

;;The two methods are functionally the same. The only difference is that here there is an
;;explicit step to frame the balance, whereas in the other version of make-withdraw, it was implicit.
;;Handling that is probably an implementation detail.