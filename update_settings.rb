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

settings = {
  'fixed_category_positions' => true,
  'min_post_length' => 3,
  'min topic title length' => 10,
  'enable names' => false,
  'tos url' => 'https://www.collegeconfidential.com/policies/terms-of-service',
  'privacy policy url' => 'https://www.collegeconfidential.com/policies/privacy/',
  'top menu' => 'categories|latest|new|unread|bookmarks',
  'sso overrides username' => 'false',
  'username change period' => 0,
  'categories topics' => 0,
  'share quote visibility' => 'all',
  'category style' => 'none',
  'email editable' => false,
  'allow uncategorized topics' => false,
  'restrict letter avatar colors' => '006699',
  'allowed iframes' => 'https://www.youtube.com',
  'default other external links in new tab' => true,
  
}

settings.each_pair() do |setting, value|
  @client.site_setting_update(name: setting.gsub(/ /, '_'), value: value)
end
