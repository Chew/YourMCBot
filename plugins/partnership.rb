module Mixer
  extend Discordrb::Commands::CommandContainer

  command(:partnership) do |event|
    subs = JSON.parse(RestClient.get("https://www.googleapis.com/youtube/v3/channels?part=statistics&forUsername=yourmcadmin&key=#{CONFIG['google']}"))['items'][0]['statistics']['subscriberCount'].to_i
    follows = JSON.parse(RestClient.get('https://mixer.com/api/v1/channels/yourmcadmin'))['numFollowers'].to_i
    bot.channel(event.channel.id.to_s).send_embed do |e|
      e.title = 'YourMCAdmin\'s Road to Partnership'

      e.add_field(name: 'YouTube Stats', value: "Subs: #{subs} / 100,000 (#{100_000 - subs} to go!)", inline: false)
      e.add_field(name: 'Mixer Stats', value: "Followers: #{follows} / 10,000 (#{10_000 - follows} to go!)", inline: false)

      e.color = '00FF00'
    end
  end
end
