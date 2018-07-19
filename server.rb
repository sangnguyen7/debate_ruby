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
	doc = Nokogiri::HTML(open(params['url']))
	#res = Net::HTTP.get_response(URI(params['url']))
	
	title = doc.css('div#col-wi span.q-title')#RubyQuery::Query.query(res.body, 'div#col-wi span.q-title', 'text')
	#askedBy =  RubyQuery::Query.query(res.body, 'div#col-wi div.r-contain div.tags>a', 'text')
	#yes = RubyQuery::Query.query(res.body, 'span.yes-text', 'text')
	#no = RubyQuery::Query.query(res.body, 'span.no-text', 'text')
	op = Opinion.new(title, "", "", "")
	op.to_s
	
	#RubyQuery::Query.query(res.body, 'div#yes-arguments>ul>li>p', 'text')
	
end