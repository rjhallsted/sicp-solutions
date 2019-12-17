;Turns out I'm way off. (And I'm pretty sure floating-point numbers would be close
;enough for most purposes here) The problem comes from how we've gone about doing
;interval arithmetic, and the fact that the same rules don't apply to it as normal arithmetic.

;see http://community.schemewiki.org/?sicp-ex-2.14-2.15-2.16 for a helpful explanation

;-------PREVIOUS ANSWER----------
;Equivalent algebraic expressions produce different results in
;computing due to how non-integers are stored. Floating-point numbers
;only carry a certain amount of precision. Rounding values during calculations
;(to fit within the available amount of precision) causes the stored value to
;drift from the arithmetically correct answer.
;
;To devise a system devoid of this problem, you would have to somehow
;avoid using floating point values.
