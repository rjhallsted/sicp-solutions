;With explicit dispatch, every procedure has to be modified with a new type is added. When a new operation
; is added, nothing else need change, as long as the new operation accounts for all of the existing types.

;When using data-directed style, no existing code needs to be modified when a new type is added. When a new
; operation is added, every type package must be updated to include a procedure to do that operation for
; that type.

;When using message passing, each operation has to be updated when a new type is added. However, nothing
;needs to be done to existing code when a new operation is added.

;In a system where new types are often added, using a data-directed style is ideal.

;In a system where new operations are often added, using a message passing style is ideal.

