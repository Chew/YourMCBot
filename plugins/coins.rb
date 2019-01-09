module Coins
  extend Discordrb::Commands::CommandContainer

  command(:coins, max_args: 1) do |event, *namearg|
    name = namearg.join(' ') unless namearg.length.zero?
    user = BotUser.new(event.user.id)
    if user.exists? && namearg.length.zero?
      profile = user
      name = profile.mixer
    elsif namearg.length.zero?
      name = event.user.display_name
    end

    begin
      mixerid = JSON.parse(RestClient.get("https://mixer.com/api/v1/channels/#{name}"))['userId']
    rescue RestClient::NotFound
      event.respond "Your nickname doesn't exist on Mixer! Please supply a username or change your nickname to match your mixer name!"
    end

    begin
      r = JSON.parse(RestClient.get("#{BASEURL}/points",
                                    params: { userid: mixerid, authkey: CONFIG['api'] }))
    rescue RestClient::Unauthorized
      event.respond "JUST WHO DO YOU THINK I AM? Sorry, you're Unauthorized."
      break
    end

    event.channel.send_embed do |embed|
      embed.colour = 0xd084
      embed.description = if namearg.length.zero?
                            "You have #{r['points']} AdminCoins!"
                          else
                            "#{name} has #{r['points']} AdminCoins!"
                          end

      embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "AdminCoins for #{name}", url: "http://mixer.com/#{name}", icon_url: 'https://cdn.discordapp.com/emojis/426074434743566348.png?v=1')
    end
  end
end
