module MixerStats
  extend Discordrb::Commands::CommandContainer

  command(:mixer, max_args: 1) do |event, name = nil|
    namer = name || event.user.nickname || event.user.name

    begin
      mixerdata = JSON.parse(RestClient.get("https://mixer.com/api/v1/channels/#{namer}"))
    rescue RestClient::NotFound
      event.respond "Your nickname doesn't exist on Mixer! Please supply a username or change your nickname to match your mixer name!"
    end

    socialblade = RestClient.get("https://socialblade.com/mixer/user/#{namer}").body.split("\n")

    if socialblade.join('').include?("doesn't exist as a direct match to someone on the platform.") || socialblade.join('').include?('We require a minimum of 5 followers to get entered into our database.')
      folrank = 'Unknown'
      viewrank = 'Unknown'
      levelrank = 'Unknown'
    else
      folloc = socialblade.index { |s| s.include?('FOLLOWER RANK') } - 1
      viewloc = socialblade.index { |s| s.include?('VIEWS RANK') } - 1
      levelloc = socialblade.index { |s| s.include?('LEVEL RANK') } - 1

      folrank = socialblade[folloc][101..-1].delete('</p>')
      viewrank = socialblade[viewloc][101..-1].delete('</p>')
      levelrank = socialblade[levelloc][101..-1].delete('</p>')
    end

    streaming = if mixerdata['online'] == true
                  "**Currently Live!** Come watch: http://mixer.com/#{namer}"
                else
                  '**Currently Offline!**'
                end
    event.channel.send_embed do |e|
      e.title = "#{namer}'s Mixer Stats"
      e.thumbnail = { url: mixerdata['user']['avatarUrl'].to_s }

      e.add_field(name: 'Streaming Status', value: streaming, inline: false)
      if folrank != 'Unknown'
        e.add_field(name: "Followers - #{mixerdata['numFollowers']}", value: "Rank: #{folrank}", inline: true)
        e.add_field(name: "Total Views - #{mixerdata['viewersTotal']}", value: "Rank: #{viewrank}", inline: true)
        e.add_field(name: "Mixer Level - #{mixerdata['user']['level']}", value: "Rank: #{levelrank}", inline: true)
      else
        e.add_field(name: 'Followers', value: mixerdata['numFollowers'], inline: true)
        e.add_field(name: 'Total Views', value: mixerdata['viewersTotal'], inline: true)
        e.add_field(name: 'Total Views', value: mixerdata['user']['level'], inline: true)
      end

      e.add_field(name: 'Sparks', value: mixerdata['user']['sparks'], inline: true)
      e.add_field(name: 'Viewers Watching', value: mixerdata['viewersCurrent'], inline: true) if mixerdata['online'] == true

      e.footer = Discordrb::Webhooks::EmbedFooter.new(text: 'Rank Stats provided by my boi socialblade') if folrank != 'Unknown'

      e.color = '1FBAED'
    end
  end
end
