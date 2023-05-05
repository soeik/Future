import ..FP, HTTP

nice_url = "https://jsonplaceholder.typicode.com/todos/1"
fail_url = "https://jsonplaceholder.typicode.com/todos/notfound"

function request(url, success, failure)
    try
        response = HTTP.get(url)
        success(String(response.body))
    catch e
        failure(e.status)
    end
end

function download_url(url)
    FP.Future((resolve, reject) -> request(url, resolve, reject))
end

# Test task 1
function downloadUrls(urls::Vector{String})::Vector{FP.Future}
    download_url.(urls)
end

# Test task 2
function collectErrors(fs::Vector{FP.Future}) ## ::FP.Future{Any}
    FP.collect(fs)
end

print_error(e) = println("ERROR: ", e)

future = downloadUrls([nice_url, fail_url]) |> collectErrors

res = FP.await(future)
println("RESULT: ", res)


