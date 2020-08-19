#!/usr/bin/env ruby -W1
# encoding: UTF-8

require 'httparty'
require 'json'
require 'htmlentities'
require 'date'

load "lib/util.rb"


def alpha_discourse_category (cat, p)

  #cat = get_discourse_category(child)

  #pp cat
  
  response = @client.update_category(
    id: cat['id'],
    name: cat['name'],
    color: cat['color'],
    text_color: cat['text_color'],
    parent_category_id: cat['parent_category_id'],
    
    # Add parameter(s) you actually want to update below
    position: p
  )
end

options = {}
options[:discourse_site] = ARGV[0]
 
@client = init_discourse(options)

# Make sure the category order matters.
@client.site_setting_update(name: 'fixed_category_positions', value: true)

for c in @client.categories() do

  if c['has_children']

    pp "#{c['name']}|#{c['position']}"
    # TODO: Make this an option.
    next unless c['name'] == 'Colleges and Universities'

    p = c['position']*100
    
    # Not sure how to make the gsub an option.
    for s in @client.categories(parent_category_id: c['id']).sort_by{ |t| t['name'].gsub(/^University of /, '') } do

      p+=1
      pp "          #{s['name']}|#{s['position']}|#{p}"

      alpha_discourse_category(s, p)
      sleep (2)
    end
  end
end


