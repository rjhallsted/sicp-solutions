;Without the call to proc upon initilization, the initial state of the output wires will not reflect the current state of the input wires. They will all just be 0, which may not reflect what the system should be.

;In this particular case, the inverter will not be activated initially, meaning the output will be 0 instead of the correct 1.