module RitmTest

import ..FP, HTTP

test_url = "https://jsonplaceholder.typicode.com/todos/1"

test_urls = [
    "https://jsonplaceholder.typicode.com/todos/1",
    "https://jsonplaceholder.typicode.com/todos/2"
]

# test 1
function downloadUrls(urls::Vector{String})::Vector{FP.Future}
    FP.of.(HTTP.get.(urls))
end

# test 2
# function collectErrors(fs::Vector{Future{String}})::Future{Tuple{Vector{String},Vector{Throwable}}}
#     #
# end
FP.fork.(downloadUrls(test_urls), println)

end #module RitmTest