require 'sinatra'
require 'net/http'
require 'ruby_query'

class Opinion
	
	def setTitle(title)
		@title = title
	end
	
	def setYes(yes_p)
		@yes = yes_p
	end
	
	def setNo(no_p)
		@no = no_p
	end
	
	def to_s
		print ('Title: ' + @title + '\n' +  @yes + ' \n' + @no)
	end
end
get '/' do
	res = Net::HTTP.get_response(URI(params['url']))
	
	op = Opinion.new()
	op.setYes(RubyQuery::Query.query(res.body, 'span.yes-text', 'text'))
	op.setNo(RubyQuery::Query.query(res.body, 'span.no-text', 'text'))
	op.setTitle(RubyQuery::Query.query(res.body, 'div#col-wi span.q-title', 'text'))
	op.to_s
	
end