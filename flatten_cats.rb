#!/usr/bin/env ruby -W1
# encoding: UTF-8

require 'httparty'
require 'json'
require 'htmlentities'
require 'date'

load "lib/util.rb"

def flatten_discourse_category (child)

  cat = get_discourse_category(child)

  response = @client.update_category(
    id: cat['id'],
    name: cat['name'],
    color: cat['color'],
    text_color: cat['text_color'],
    
    # Add parameter(s) you actually want to update below
    parent_category_id: "",
  )
end

options = {}
options[:discourse_site] = ARGV[0]
 
@client = init_discourse(options)

#for c in @client.categories() do
site ||= @client.get("#{@client.host}/site.json")

site.response_body['categories'].each do |c|
  if c['has_children']

    for s in @client.categories(parent_category_id: c['id']) do
      pp s['name']

      flatten_discourse_category(s['name'])
      sleep (2)
    end
  end
end


