module FP

import HTTP, JSON, Base

export Future, of, map, chain, fork

struct Future
    executor::Function
end

of(value) = Future(resolve -> resolve(value))

chain(fut, fn) = Future(
    (resolve, reject) -> fork(
        fut,
        value -> fork(fn(value), resolve, reject),
        error -> reject(error)
    )
)

map(fut, fn) = chain(fut, value -> of(fn(value)))

fork(fut, success, failure) = begin
    fut.executor(success, failure)
    return fut
end

end