;It is a safe change to make. As protected-balance and protected-withdraw are serialized procedures in the same, only one of them can run at a time, so there is no need to create a new serialized procedure with every call.

;Though what happens if you make calls to the same serialized procedure in parralell? Does it depend on the implementation of the serializer? Is it possible for the same serialized function, if called twice concurrently, to interleave itself?