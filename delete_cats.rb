#!/usr/bin/env ruby -W1
# encoding: UTF-8

require 'httparty'
require 'json'
require 'htmlentities'
require 'date'

load "lib/util.rb"

def delete_discourse_category (name)

  pp name
  cat = get_discourse_category(name)
  pp cat
  return if cat.nil?
  
  puts @client.delete_category(cat['id'])
end

options = {}
options[:discourse_site] = ARGV[0]
 
@client = init_discourse(options)

#pp @client.categories(parent_category_id: 10).find {|e| e['name'] == 'B'}

for c in [*('A' .. 'W'), 'X-Y-Z', 'College Admissions and Search']
  begin
    delete_discourse_category(c)
  rescue DiscourseApi::UnauthenticatedError => error
    puts "#{c} not deleted becuase it has topics under it."
  end
  sleep (2)
end


