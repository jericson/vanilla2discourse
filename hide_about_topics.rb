#!/usr/bin/env ruby -W1
# encoding: UTF-8

require 'httparty'
require 'json'
require 'htmlentities'
require 'date'

load "lib/util.rb"


options = {}
options[:discourse_site] = ARGV[0]
 
@client = init_discourse(options)

for i in 1 .. 100
  topics = @client.get("/topics/created-by/system?page=#{i}")['response_body']
  pp topics

  break if topics['topic_list']['topics'].nil?

  #pp topics['topic_list']['topics']

  topics['topic_list']['topics'].each do |t|
    if t['title'].match /About the .* category/
      if t['excerpt'].nil? and t['visible'] == true
        puts t['title']
        
        params = { status: 'visible', enabled: false }
        @client.update_topic_status(t['id'], params)
        sleep 1
      end
    end
  end
  sleep 1
end
