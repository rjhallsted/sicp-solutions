;When serialized exchange is called, it's calls to withdraw and deposit call serialized procedures, which are then serialized.

;So what happens when you serialize an already serialized procedure?

;Unecessary levels of serialization are added. This causes problems because exchange and the withdraw, deposit procedures have been serialized by the same serializer.

;Which leads to this problem: Because exchange is running, the calls to deposit and withdraw on an account cannot run until it is finished. However, exchange will not finish until it has those values. Meaning the program gets stuck/freezes.