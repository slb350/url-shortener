path = File.expand_path("../", __FILE__)

require 'rubygems'
require 'sinatra'
require 'redis'
require "#{path}/app"

run Sinatra::Application
