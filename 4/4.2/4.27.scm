(define w (id (id 10)))
;;; L-Eval input:
count
;;; L-Eval value:
1 ;as part of defining w, (id (id 10)) is evaluated. id is a compuound procedure, so the procedure body is evaluated in terms of delayed arguments. At this point, id is a thunk. Since the procedure body is another call to id, id becomes an evaluated hunk (in which the result is determined in terms of delayed arguments). Since count is not an argument to id, it gets incrementted.
;;; L-Eval input:
w
;;; L-Eval value:
10 ;id returns what it is given, so w is 10.
;;; L-Eval input:
count
;;; L-Eval value:
2