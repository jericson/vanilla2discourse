require "discourse_api"

def init_discourse (options)
  client = DiscourseApi::Client.new("https://#{options[:discourse_site]}/")
  client.api_key = ENV['DISCOURSE_API']
  abort("Missing Discourse API key. Populate the DISCOURSE_API environment variable.") unless client.api_key
  client.api_username = ENV['DISCOURSE_USER']
  abort("Missing Discourse API keyusername. Populate the DISCOURSE_USER environment variable.") unless client.api_username

  return client
end

def get_discourse_category (name)
  @site ||= @client.get("#{@client.host}/site.json")

  #pp response.response_body['categories']
  
  cat = @site.response_body['categories'].find {|e| e['name'] == name}

  #pp cat
  return cat
end  

def get_discourse_top_category (name)
  response = @client.categories
  #pp name


  cat = response.find {|e| e['name'] == name}
  
  if cat.nil?
    for c in response.find_all {|e| e['has_children'] == true}
      #pp c
      subs = @client.categories(parent_category_id: c["id"])
      cat = subs.find {|e| e['name'] == name}
    end
  end

  #pp cat
  return cat
end  
