require 'discordrb'
require 'rest-client'
require 'json'
require 'yaml'
require 'nokogiri'
require 'open-uri'
puts 'All dependencies loaded'

CONFIG = YAML.load_file('config.yaml')
puts 'Config loaded from file'

BASEURL = 'https://api.scottybot.net/api'.freeze

Bot = Discordrb::Commands::CommandBot.new token: CONFIG['token'], client_id: CONFIG['client_id'], prefix: ["<@#{CONFIG['client_id']}> ", '!']

puts 'Initial Startup complete, loading all commands...'

Dir["#{File.dirname(__FILE__)}/plugins/*.rb"].each { |file| require file }

Dir["#{File.dirname(__FILE__)}/plugins/*.rb"].each do |wow|
  bob = File.readlines(wow) { |line| line.split.map(&:to_s).join }
  command = bob[0][7..bob[0].length]
  command.delete!("\n")
  command = Object.const_get(command)
  Bot.include! command
  puts "Plugin #{command} successfully loaded!"
end

puts 'Done loading plugins! Finalizing start-up'

Starttime = Time.now

bot.ready do |event|
  event.bot.game = 'on LegitLand, of course'
end

# bot.message(includes: 'discord.gg') do |event|
#  message = event.message.to_s
#  if message.include?('discord.gg') && CONFIG['deletelinks']
#    event.message.delete
#    event.respond "#{event.user.mention}, discord link postings are disabled!"
#  end
# end

# bot.message(includes: '') do |event|
#  message = event.message.to_s
#  swears = File.readlines('swears.txt') { |line| line.split.map(&:to_s).join }
#  swears = swears[0]
#  swears.delete!("\n")
#  swears = swears.split(',')
#  swears.each do |swear|
#    next unless message.include?(swear)
#    event.message.delete
#    event.respond "#{event.user.mention}, please do not swear!"
#    bot.channel(channid).send_embed do |e|
#      e.title = 'Someone just swore!'
#
#      e.add_field(name: 'Invoker', value: event.user.mention, inline: false)
#      e.add_field(name: 'Swear', value: swear, inline: false)
#      e.add_field(name: 'Message', value: message, inline: false)
#
#      e.color = 'FF0000'
#    end
#  end
# end

puts 'Bot is ready!'
bot.run
