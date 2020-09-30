#!/usr/bin/env ruby -W1
# encoding: UTF-8

require 'httparty'
require 'json'
require 'htmlentities'
require 'date'
require 'uri'

load 'lib/util.rb'


require 'optparse'

options ={
}

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} DISCOURSE_SITE USER_NAME"

  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end

optparse.parse!

options[:discourse_site] = ARGV[0]

@client = init_discourse (options)

banner_title="Welcome to the College Confidential beta!"

begin
  banner=@client.create_topic(
    skip_validations: true,
    title: banner_title,
    raw: File.read('banner.md')
  )
rescue DiscourseApi::UnprocessableEntity
  puts "Remove current banner"
end

begin
  @client.put("/t/#{banner['id']}/make-banner")
rescue DiscourseApi::UnauthenticatedError
  puts "curl -X PUT 'https://#{ARGV[0]}/t/#{banner['id']}/make-banner' -H" + '"Api-Key: $DISCOURSE_API" -H "Api-Username: ccadmin_jon"'
end
