;Turns out I'm way off. (And I'm pretty sure floating-point numbers would be close
;enough for most purposes here) The problem comes from how we've gone about doing
;interval arithmetic, and the fact that the same rules don't apply to it as normal arithmetic.

;see http://community.schemewiki.org/?sicp-ex-2.14-2.15-2.16 for a helpful explanation

;-------PREVIOUS ANSWER----------

;Eva Lu Ator is correct. By not repeating uncertain qualities,
;the precision errors due to floating point calculations is lessened.