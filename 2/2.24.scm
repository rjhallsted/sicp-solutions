(list 1 (list 2 (list 3 4)))

;printed
;(1 (2 (3 4)))

;box-and-pointer
;[*|*] -> [*|*] -> [*|*] -> [*,nil]
; |        |        |        |
; 1        2        3        4

;tree
;           *
;          / \
;         1   *
;            / \
;           2   *
;              / \
;             3   4
