require 'sinatra'
require 'net/http'
require 'ruby_query'
require 'nokogiri'
require 'open-uri'
require 'json'

class Vote
	def initialize(mainPoint, comment, postedBy, like)
		@mainPoint = mainPoint
		@comment = comment
		@postedBy = postedBy
		@like = like
	end
	
	def to_s
		data = '{
			"postedBy": "' + @postedBy + '",
			"mainPoint": "' + @mainPoint + '",
			"comment": "' + @comment + '",
			"like": "' + @like + '"
		}'
	end
end

class Opinion

	def initialize(title, askedBy, yes, no, votes)
		@title = title
		@askedBy = askedBy
		@yes = yes
		@no = no
		@votes = votes
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
	
	def setVotes(comments)
		@votes = comments
	end
	
	def to_s
		data = '{
			"title": "' + @title + '",
			"askedBy": "' + @askedBy + '",
			"yes": "' + @yes + '",
			"no": "' + @no + '",
			"oppinions": [' + @votes.join(',') + ']
		}'
	end
end
get '/' do
	if params['url'].nil? || params['url'].empty? || params['url'] == ''
		'empty response'
	elsif !params['url'].include?('http://www.debate.org/opinions')
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
			votes = Array.new();
			doc.css('#yes-arguments>ul>li.hasData').each do |li|
				mainPoint = li.css('h2').first.text
				comment = li.css('p').first.text
				postedBy = li.css('div.qt>cite>a').text
				like = 'Yes'
				vote = Vote.new(mainPoint, comment, postedBy, like)
				votes.push(vote);
			end
			
			doc.css('#no-arguments>ul>li.hasData').each do |li|
				mainPoint = li.css('h2').first.text
				comment = li.css('p').first.text
				postedBy = li.css('div.qt>cite>a').text
				like = 'No'
				vote = Vote.new(mainPoint, comment, postedBy, like)
				votes.push(vote);
			end
			
			op = Opinion.new(title, askedBy, yes, no, votes)
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