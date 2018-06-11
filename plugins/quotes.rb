module Quotes
  extend Discordrb::Commands::CommandContainer

  command(:quote, min_args: 0, max_args: 1) do |event, num = -1|
    quotes = RestClient.get("#{BASEURL}/showquotes",
                       params: { chanid: CHANID },
                       :'Content-Type' => :json)

    puts quotes

  end
end
