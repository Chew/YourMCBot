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

    e.add_field(name: 'YouTube Stats', value: "Subs: #{subs} / 100,000 (#{100_000 - subs} to go!)", inline: false)
    e.add_field(name: 'Mixer Stats', value: "Followers: #{follows} / 10,000 (#{10_000 - follows} to go!)", inline: false)

    e.color = '00FF00'
  end
end

bot.command(:mixer) do |event|
  mixerdata = JSON.parse(RestClient.get('https://mixer.com/api/v1/channels/yourmcadmin'))
  streaming = if mixerdata['online'] == true
                '**Currently Live!** Come watch: http://mixer.com/yourmcadmin'
              else
                '**Currently Offline!**'
              end
  bot.channel(event.channel.id.to_s).send_embed do |e|
    e.title = 'YourMCAdmin\'s Mixer Stats'
    e.thumbnail = { url: 'https://uploads.mixer.com/avatar/93g5yofk-25259.jpg'.to_s }

    e.add_field(name: 'Streaming Status', value: streaming, inline: false)
    e.add_field(name: 'Followers', value: mixerdata['numFollowers'], inline: false)
    e.add_field(name: 'Total Views', value: mixerdata['viewersTotal'], inline: false)

    e.color = '1FBAED'
  end
end

bot.message(includes: 'discord.gg') do |event|
  message = event.message.to_s
  if message.include?('discord.gg') && CONFIG['deletelinks']
    event.message.delete
    event.respond "#{event.user.mention}, discord link postings are disabled!"
  end
end

bot.message(includes: '') do |event|
  message = event.message.to_s
  swears = File.readlines('swears.txt') { |line| line.split.map(&:to_s).join }
  swears = swears[0]
  swears.delete!("\n")
  swears = swears.split(',')
  swears.each do |swear|
    if message.include?(swear)
      event.message.delete
      event.respond "#{event.user.mention}, please do not swear!"
    end
  end
end

puts 'Bot is ready!'
bot.run
