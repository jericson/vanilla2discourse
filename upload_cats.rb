#!/usr/bin/env ruby -W1
# encoding: UTF-8

require 'httparty'
require 'json'
require 'htmlentities'
require 'date'
require 'open-uri'

load "lib/util.rb"



options = {}
options[:discourse_site] = ARGV[0]
 
@client = init_discourse(options)


data = JSON.load(File.open "categories.json")
#data = JSON.load(open "https://#{options[:discourse_site]}/categories.json")



c = data['category_list']['categories'][0]
#pp c



data['category_list']['categories'].each do |c|
  response = @client.update_category(c.transform_keys(&:to_sym))
  pp response
end


