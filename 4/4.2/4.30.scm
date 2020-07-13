;a) This works becuase display is a primitive function, so calling it will force the value of x.
;b) original: '(1 (2)) and '(1)
;    Cy's:    '(1 (2)) and '(1 (2))

;c) The side effects are still run. Cy's version just makes them more explicit. The final result is still the same, since it is eval'd.

;d) It's difficult to decide. Cy's method ensures side effects happen, but as a result, isn't really lazily-evaluated, since everything is forced nearly immediately.