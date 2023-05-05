module RitmTest

import ..FP, HTTP

nice_url = "https://jsonplaceholder.typicode.com/todos/1"
fail_url = "https://jsonplaceholder.typicode.com/todos/notfound"


test_urls = [
    "https://jsonplaceholder.typicode.com/todos/1",
    "https://jsonplaceholder.typicode.com/todos/2"
]

function request(url, success, failure)
    try
        response = HTTP.get(url)
        success(String(response.body))
    catch e
        failure(e)
    end
end

function download_url(url)
    FP.Future((resolve, reject) -> request(url, resolve, reject))
end

# test 1
function downloadUrls(urls::Vector{String})::Vector{FP.Future}
    download_url.(urls)
end

# test 2
# TODO types
# function collectErrors(fs: Array{Future{String}}): Future{Array{Tuple{Array{String}, 
function collectErrors(fs::Vector{FP.Future}) #::FP.Future{Tuple{Vector{String},Vector{Throwable}}}
    FP.collect(fs)
end

print_error(e) = println("ERROR: ", e)

fut_fail = downloadUrls([nice_url, fail_url])
fut_collected = collectErrors(fut_fail)
# FP.fork.(fut_fail, println, print_error)
# FP.fork(fut_collected, println, print_error)

res = FP.await(fut_collected)
println("RESULT: ", res)
end #module RitmTest