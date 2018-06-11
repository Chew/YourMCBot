module Quotes
  extend Discordrb::Commands::CommandContainer

  command(:quote, min_args: 0, max_args: 1) do |event, num = -1|
    quotes = JSON.parse(RestClient.get("#{BASEURL}/showquotes",
                                       params: { chanid: CHANID },
                                       :'Content-Type' => :json))

    quote = quotes[num.to_i]['quote']
    spots = quote.split(' - ')
    qu = spots[0]
    author = spots[1].delete('@')
    date = spots[2].split(' ')[0]
    game = spots[2].split(' ')[1].delete('(').delete(')')

    event.channel.send_embed do |embed|
      embed.colour = 0xd084
      embed.description = qu.to_s

      embed.timestamp = Time.new(date)

      embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "Quote from #{author}", url: "http://mixer.com/#{author}")
      embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "Game: #{game}")
    end
  end
end
