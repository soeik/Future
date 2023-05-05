module FP

import HTTP, JSON, Base

export Future, of, map, chain, fork, collect, await

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

function collect(fs::Vector{Future}) # TODO ::Future{Tuple{Any,Any}}
    results = []
    errors = []
    success(res) = push!(results, res)
    failure(e) = push!(errors, e.status) ## TODO mapError
    function executor(resolve, reject)
        for i = eachindex(fs)
            fut = fs[i]
            FP.fork(fut, success, failure)
        end
        resolve([results, errors])
    end
    FP.Future(executor)
end

function await(fut::Future)
    function unwrap()
        result = nothing
        fork(fut, res -> result = res, e -> result = e)
        return result
    end
    task = @async unwrap()
    return fetch(task)
end

end