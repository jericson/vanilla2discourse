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

site = JSON.load(File.open "site.json")
cats = JSON.load(File.open "categories.json")
#data = JSON.load(open "https://#{options[:discourse_site]}/categories.json")



#c = site['category_list']['categories'][0]

cats['category_list']['categories'].each do |c|
  d_cat = get_discourse_category(c['name'])
  if d_cat.nil?
    n_cat = c.slice('name', 'color', 'text_color', 'slug', 'position', 'description', 'description_text')
    response = @client.create_category(n_cat.transform_keys(&:to_sym))
  end
end

site['categories'].sort_by {|k| k['position']}.each do |c|
  n_cat = c.slice('name', 'color',
                  'text_color', 'slug', 'position', 'description', 'description_text',
                  'read_restricted', 'permission')

  
  d_cat = get_discourse_category(c['name'])
  if d_cat.nil?
    #pp n_cat
  else
    n_cat['id'] = d_cat['id']


    puts c['name']
    unless c['parent_category_id'].nil?
      parent = cats['category_list']['categories'].find{|hash| hash['id'] == c['parent_category_id']}
      puts "=> #{parent['name']}"
      begin
        n_cat['parent_category_id'] = get_discourse_category(parent['name'])['id']
      rescue NoMethodError
        pp parent
      end
    end

    #pp n_cat
    
    response = @client.update_category(n_cat.transform_keys(&:to_sym))
    sleep(1)
    pp response
  end
end


