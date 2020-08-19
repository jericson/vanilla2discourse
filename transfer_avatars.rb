#!/usr/bin/env ruby -W1
# encoding: UTF-8

require 'httparty'
require 'json'
require 'htmlentities'
require 'date'

load 'lib/util.rb'


require 'optparse'

options ={
  :vanilla_depth => 100,
  :discourse_toplevel => 1,
}

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} VANILLA_SITE DISCOURSE_SITE"

  opts.on("-d", "--vanilla_depth N", "Depth of search in Vanilla") do |d|
    options[:vanilla_depth] = d
  end

  opts.on("-t", "--discourse_toplevel N", "Toplevel category") do |d|
    options[:discourse_toplevel] = d.to_i
  end
  
  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end

optparse.parse!



options[:vanilla_site] = ARGV[0]
options[:discourse_site] = ARGV[1]

for i in 1..30 do

  uri = "https://#{options[:vanilla_site]}/api/v2/users"

  query = {
    "page" => i,
    "limit" => 500,
    "sort" => "-dateLastActive"
  }
  headers = {
    "Authorization" => "Bearer #{ENV['VANILLA_API']}"
  }

  response = HTTParty.get(uri, :headers => headers, :query => query)
  case response.code
  when 200
    users = JSON.parse(response.body)

  else
    pp response
  end

  @client = init_discourse (options)
  


  for u in users
    unless u['photoUrl'].match?("/uploads/defaultavatar/")
      puts u['name']
      puts u['photoUrl']
      begin
        puts @client.update_avatar(u['name'].gsub(/ /,'_'), url: u['photoUrl'])
      rescue DiscourseApi::NotFoundError => error
        puts error.response.body['errors'].first
      end
      sleep 2
    end  
  end
end



