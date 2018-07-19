ENV['RACK_ENV'] = 'test'

require './server'
require 'test/unit'
require 'rack/test'

class HelloWorldTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_it_get
    get '/'
    assert last_response.ok?
    assert_equal 'empty response', last_response.body
  end

 def test_it_get_an_opinion
    get '/', :url => 'http://www.debate.org/opinions/can-the-laws-keep-up-with-today-s-internet-technology'
    assert last_response.body.include?('"askedBy": "BigBlackDaddy"')
	assert last_response.body.include?('"title": "Can the laws keep up with today’s internet technology?"')
 end
 
 def test_it_with_bad_request
	get '/', :url => 'http://www.debate.org/debates/Is-the-Bible-against-womens-rights/1/'
	assert last_response.ok?
	assert last_response.body.include?('Bad Request')
 end
end