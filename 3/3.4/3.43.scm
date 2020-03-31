;;exchange 10,20,30
;;start ex1
;;diff(a,b) = 10
;;start ex2
;;diff(a,c) = 20
;;withdraw(c, 20) (c = 10)
;;deposit(a, 20) (a = 30)
;;end ex2
;;withdraw(b, 10) (b = 10)
;;deposit(a, 10) (a = 40)
;;end ex1

;;final values = 40, 10, 10

;;Staring sum = 30 + 20 + 10 = 60
;;final sum = 40 + 10 + 10 = 60

;;if individual accounts are not serialized:

;;start ex1
;;diff(a,b) = 10
;;start ex2
;;diff(a,c) = 20
;;withdraw(c, 20) (c = 10)
;;start deposit1(a, 20)
    ;;withdraw(b, 10) (b = 10)
    ;;start deposit2(a, 10)
        ;(deposit1)new-balance = 10 + 20
        ;(deposit2)new-balance = 10 + 10
        ;(deposit1)set balance 30 (a = 30)
    ;;end deposit1
    ;;end ex1
    ;(deposit 2)set balance 20 (a = 20)
;;end deposit2
;;end ex1

;final values = 20, 10, 10
;final sum = 20 + 10 + 10 = 40 
;40 != 60

