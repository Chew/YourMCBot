module Custom
  extend Discordrb::Commands::CommandContainer

  command(%i[yt youtube]) do |event|
    event.respond 'Subscribe to my YouTube channel: <http://youtube.com/YourMCAdmin>'
  end

  command(:whatisacoin) do |event|
    event.respond 'Admin coins can be earned by answering trivia questions correctly! At the end of each month the Coins are reset and the top players win prizes! You can see how many you have with !coins (soon)'
  end
end
