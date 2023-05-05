module FP

import HTTP, JSON, Base

export Future, of, map, chain, fork

struct Future
    executor::Function
end

of(value) = Future(resolve -> resolve(value))

chain(fut, fn) = Future(
    resolve -> fork(fut, value -> fork(fn(value), resolve)
    ))

map(fut, fn) = chain(fut, value -> of(fn(value)))

fork(fut, success) = begin
    fut.executor(success)
    return fut
end

end