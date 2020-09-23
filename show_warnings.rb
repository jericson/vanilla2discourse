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
options[:username] = ARGV[1]


@client = init_discourse (options)

puts options[:username] + "'s warnings:"
puts "<ol>"

for m in @client.private_messages(options[:username])
  next unless m["is_warning"]
  puts "<li>"
  puts m['created_at'] + " &mdash;"
  puts m['last_poster_username'] + " &mdash;" 
  puts "<a href='https://#{options[:discourse_site]}/t/#{m['slug']}/#{m['id']}'>#{m['title']}</a>"
  puts "</li>"
end

puts "</ol>"

