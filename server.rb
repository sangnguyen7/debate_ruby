require 'sinatra'
require 'net/http'
require 'ruby_query'
require 'nokogiri'
require 'open-uri'

class Vote
	def initialize(mainPoint, comment, postedBy, like)
		@mainPoint = mainPoint
		@comment = comment
		@postedBy = postedBy
		@like = like
	end
	
	def to_json
		data = '{
			"mainPoint": "#{@mainPoint}"
		}'
	end
end

class Opinion

	def initialize(title, askedBy, yes, no)
		@title = title
		@askedBy = askedBy
		@yes = yes
		@no = no
	end
	
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
		data = '{
			"title": "' + @title + '",
			"askedBy": "' + @askedBy + '",
			"yes": "' + @yes + '",
			"no": "' + @no + '"
		}'
	end
end
get '/' do
	if params['url'].nil? || params['url'].empty? || params['url'] == ''
		'empty response'
	elseif !params['url'].include?('http://www.debate.org/opinions')
		'Bad Request'
	else
		begin 
			doc = Nokogiri::HTML(open(params['url']))
			#res = Net::HTTP.get_response(URI(params['url']))
			doc
			title = doc.css('div#col-wi span.q-title').text#RubyQuery::Query.query(res.body, 'div#col-wi span.q-title', 'text')
			askedBy = doc.css('div#col-wi div.r-contain div.tags>a').text #RubyQuery::Query.query(res.body, 'div#col-wi div.r-contain div.tags>a', 'text')
			yes = doc.css('span.yes-text').text #RubyQuery::Query.query(res.body, 'span.yes-text', 'text')
			no = doc.css('span.no-text').text#RubyQuery::Query.query(res.body, 'span.no-text', 'text')
			op = Opinion.new(title, askedBy, yes, no)
			op.to_s
		rescue OpenURI::HTTPError => ex
			if ex.message == '404 Not Found'
				'URL is not found'
			else
				'Bad Request'
			end
		end
	end
	
	#RubyQuery::Query.query(res.body, 'div#yes-arguments>ul>li>p', 'text')
	
end