;With applicative order, this will run forever. The arguments to unless are evaluated first, which means the inner call to factorial is always evaluated. Unless and factorial will recurse endlessly and never resolve on the initial call to unless.

;This definition will work in a normal-order language.