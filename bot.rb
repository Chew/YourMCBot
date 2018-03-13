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

puts 'Bot is ready!'
bot.run
