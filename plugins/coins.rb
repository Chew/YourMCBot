module Coins
  extend Discordrb::Commands::CommandContainer

  command(:coins, max_args: 1) do |event, name = nil|
    begin
      mixerid = JSON.parse(RestClient.get("https://mixer.com/api/v1/channels/#{name || event.user.nickname || event.user.name}"))['userId']
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
      embed.description = "You have #{r['points']} points!"

      embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "Coins for #{name || event.user.nickname || event.user.name}", url: "http://mixer.com/#{event.user.nickname || event.user.name}", icon_url: "https://cdn.discordapp.com/emojis/426074434743566348.png?v=1")
    end
  end
end
