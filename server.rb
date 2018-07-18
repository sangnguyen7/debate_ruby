require 'sinatra'
require 'net/http'
require 'ruby_query'

get '/' do
	res = Net::HTTP.get_response(URI(params['url']))
	RubyQuery::Query.query(res.body, 'span.yes-text', 'text');
end