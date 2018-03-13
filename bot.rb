require 'discordrb'
require 'rest-client'
require 'json'
require 'yaml'
require 'nokogiri'
require 'open-uri'
puts 'All dependencies loaded'

CONFIG = YAML.load_file('config.yaml')
puts 'Config loaded from file'

bot = Discordrb::Commands::CommandBot.new token: CONFIG['token'], client_id: CONFIG['client_id'], prefix: ["<@#{CONFIG['client_id']}> ", '!']

puts 'Initial Startup complete, loading all commands...'

Starttime = Time.now

bot.ready do |event|
  event.bot.game = 'on DieHard, of course'
end

bot.command(:partnership) do |event|
  subs = JSON.parse(RestClient.get("https://www.googleapis.com/youtube/v3/channels?part=statistics&forUsername=yourmcadmin&key=#{CONFIG['google']}"))['items'][0]['statistics']['subscriberCount'].to_i
  follows = JSON.parse(RestClient.get('https://mixer.com/api/v1/channels/yourmcadmin'))['numFollowers'].to_i
  bot.channel(event.channel.id.to_s).send_embed do |e|
    e.title = 'YourMCAdmin\'s Road to Partnership'

    e.description = ['Youtube Stats', "Subs: #{subs} / 100,000 (#{100_000 - subs} to go!)", '', 'Mixer Stats:', "Followers: #{follows} / 10,000 (#{10_000 - follows} to go!)"].join("\n")
    e.color = '00FF00'
  end
end

puts 'Bot is ready!'
bot.run
