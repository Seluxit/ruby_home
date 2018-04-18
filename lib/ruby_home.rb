require_relative 'ruby_home/version'
require_relative 'ruby_home/broadcast'
require_relative 'ruby_home/identifier_cache'
require_relative 'ruby_home/hap/server'
Dir[File.dirname(__FILE__) + '/ruby_home/factories/*.rb'].each { |file| require file }

module RubyHome; end
