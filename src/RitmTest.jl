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
# function collectErrors(fs::Vector{Future{String}})::Future{Tuple{Vector{String},Vector{Throwable}}}
#     #
# end

print_error(e) = println("ERROR: ", e)

fut_fail = downloadUrls([nice_url, fail_url])
FP.fork.(fut_fail, println, print_error)

end #module RitmTest