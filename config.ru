require "bundler/setup"
require "pry"
require "httparty"
require 'date'

Dir[File.join(__dir__, "/*.rb")].each do |file|
    require file
end
