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
  :user_count => 1,
  :role => 0,
}

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} VANILLA_SITE DISCOURSE_SITE"

  opts.on("-u", "--user_count N", "Number of users") do |d|
    options[:user_count] = d.to_i
  end
  
  opts.on("-r", "--role N", "Filter by Vanilla roleID") do |d|
    options[:role] = d.to_i
  end

  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end

optparse.parse!



options[:vanilla_site] = ARGV[0]
options[:discourse_site] = ARGV[1]

max_rows = 500

n = (options[:user_count]/max_rows).ceil()+1

@client = init_discourse (options)

for i in 1..n do

  uri = "https://#{options[:vanilla_site]}/api/v2/users"

  if i < n
    limit=max_rows 
  else
    limit=options[:user_count]%max_rows
  end
    
  query = {
    "page" => i,
    "limit" => limit,
    "sort" => "-dateLastActive",
    "expand" => "all",
    "roleID" => options[:role],
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
  


  for u in users
    puts u['banned']
    pp u['rank']
    puts u['name']
    puts u['photoUrl']

    begin
      user=@client.user(URI.escape(u['name']))
    rescue DiscourseApi::NotFoundError
      puts u['name']
    end

    unless user.nil?
      level_map = {
        "New Member"        => 0,
        "Junior Member"     => 1,
        "Member"            => 2,
        "Senior Member"     => 3,
        "Forum Champion"    => 3,
        "Super Moderator"   => 3,
        "Editor"            => 3,
        "Community Manager" => 3,
        "Administrator"     => 3,
        "Student Voice"     => 2,
      }
      #pp u

      next if u['rank'].nil?
      raise "No mapping for #{u['rank']['name']}" if level_map[u['rank']['name']].nil?
      
      @client.update_trust_level(user['id'], { level: level_map[u['rank']['name']]})

      if u['rank']['name'] == 'Super Moderator'
        puts "Making #{ u['name']} a moderator!"
        @client.grant_moderation(user['id'])
      end
      
      unless u['photoUrl'].match?("/uploads/defaultavatar/") and u['banned']
        begin
        puts @client.update_avatar(u['name'].gsub(/ /,'_'), url: u['photoUrl'])
        rescue DiscourseApi::NotFoundError => error
          puts error.response.body['errors'].first
        end
      end  
    end
    sleep 2
  end
end


