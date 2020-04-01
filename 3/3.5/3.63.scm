;;By not retaining the define, each call to sqrt-stream produces a new copy of the procedure, meaning all of the redundant computation has to be performed. Using define makes it so that calls to sqrt stream call that procedure itself.

;If delay used only (lambda () ⟨exp⟩), without the optimization provided by memo-proc, either version of sqrt-stream would be fine, as they'd have the same level of efficiency.
