#!/usr/bin/env ruby -W1
# encoding: UTF-8

require 'httparty'
require 'json'
require 'htmlentities'
require 'date'

load 'lib/util.rb'


def update_discourse_category (child, parent)

  cat = get_discourse_category(child)
  parent_id = get_discourse_category(parent)['id']
  
  return if cat.nil?
  return if parent_id.nil?

  #pp cat
  
  response = @client.update_category(
    id: cat['id'],
    name: cat['name'],
    color: cat['color'],
    text_color: cat['text_color'],
    
    # Add parameter(s) you actually want to update below
    parent_category_id: parent_id, 
  )


end


@parent = nil
def transverse_category (cats, options)
  cats.each do | category |
    
    if category['depth'] <= options[:discourse_toplevel]
      @parent = category['name']
    else
      
      puts "#{category['name']} => #{@parent}"
      
      update_discourse_category(category['name'], @parent)
      sleep (2)
    end
    
    transverse_category(category['children'], options) 
  end
end


def get_categories (uri)

  response = HTTParty.get(uri)
  case response.code
    when 200
      return JSON.parse(response.body)

  end
end

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
cats = get_categories("https://#{options[:vanilla_site]}/api/v2/categories?maxDepth=#{ options[:vanilla_depth] }&archived=false&page=1&limit=100")




@client = init_discourse (options)
transverse_category(cats, options)




