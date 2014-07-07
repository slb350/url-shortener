require 'rubygems'
require 'sinatra'
require 'redis'
require 'base64'
require 'digest/md5'

redis = Redis.new

helpers do
  include Rack::Utils
  alias_method :h, :escape_html

  def shorten(url)
      Base64.urlsafe_encode64([Digest::MD5.hexdigest(url).to_i(16)].pack("N")).sub(/==\n?$/, '')
  end

  def smart_add_url_protocol
    unless self.url[/^http[s]?:\/\//]
      self.url = 'http://' + self.url
    end
  end

end

get '/' do
  erb :index
end

post '/' do
    @hostname = request.env["HTTP_REFERER"]
    if params[:url] and not params[:url].empty?
        @shortcode = shorten params[:url]
        redis.setnx "links:#{@shortcode}", params[:url]
    end
    erb :index
end

get '/:shortcode' do
  @url = redis.get "links:#{params[:shortcode]}"
  if !@url.match(/^http[s]?:\/\//)
      @url = "http://#{@url}"
  end
  redirect @url || '/'
end
