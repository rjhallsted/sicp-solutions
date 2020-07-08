;Any program that would otherwise run the same computation multiple times, such as a recursive factorial calculator or prime-number finder.


(define (square x) (* x x))
;;; L-Eval input:
(square (id 10))
;;; L-Eval value: 
⟨response⟩
;;; L-Eval input:
count
;;; L-Eval value:
⟨response⟩

;With memoization:
100
1

;Without memoization:
100
2 ;This is two, because without memoization, (id 10) would be run twice, incrementing count twice.