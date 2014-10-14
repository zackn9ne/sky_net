# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
def get_from_reddit
  response = JSON.load( RestClient.get('xhttp://www.reddit.com/r/bitcoin/.json') )

  response['data']['children'].map do |child|
    story = {
        title:  child['data']['title'].first
    }
  end
end

def get_from(url)
  response = JSON.load( RestClient.get url )
  puts response.class

  puts response['new'].class # reads as Hash, Array, now you know you have to loop thorough all  the arrays'! damn, you need a loop here... take a deep breath...

  response['new'].each do | parse_title |
    puts "*!*!*!*!*!**!title!*!**!*!*!**!"
    puts parse_title['title']
    puts "*!*!*!*!*!**!title!*!**!*!*!**!"
    puts "article content================"
    puts parse_title['image']
    puts parse_title['content']['plain']
    puts "end article content================"
  end

end
get_from( "mashable.com/stories.json" )