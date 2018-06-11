module MixerStats
  extend Discordrb::Commands::CommandContainer

  command(:mixer) do |event|
    mixerdata = JSON.parse(RestClient.get('https://mixer.com/api/v1/channels/yourmcadmin'))
    streaming = if mixerdata['online'] == true
                  '**Currently Live!** Come watch: http://mixer.com/yourmcadmin'
                else
                  '**Currently Offline!**'
                end
    event.channel.send_embed do |e|
      e.title = 'YourMCAdmin\'s Mixer Stats'
      e.thumbnail = { url: 'https://uploads.mixer.com/avatar/93g5yofk-25259.jpg'.to_s }

      e.add_field(name: 'Streaming Status', value: streaming, inline: false)
      e.add_field(name: 'Followers', value: mixerdata['numFollowers'], inline: true)
      e.add_field(name: 'Total Views', value: mixerdata['viewersTotal'], inline: true)
      e.add_field(name: 'Viewers Watching', value: mixerdata['viewersCurrent'], inline: true)

      e.color = '1FBAED'
    end
  end
end
