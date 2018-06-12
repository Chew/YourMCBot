module Custom
  extend Discordrb::Commands::CommandContainer

  command(%i[yt youtube]) do |event|
    event.message.delete
    event.respond event.user.mention + ', Subscribe to my YouTube channel: <http://youtube.com/YourMCAdmin>'
  end

  command(:twitter) do |event|
    event.message.delete
    event.respond event.user.mention + ', Follow YourMCAdmin on Twitter - <https://twitter.com/YourMCAdmin>'
  end

  command(:whatisacoin) do |event|
    event.message.delete
    event.respond event.user.mention + ', Admin coins can be earned by answering trivia questions correctly! At the end of each month the Coins are reset and the top players win prizes! You can see how many you have with !coins (soon)'
  end

  command(:tsk) do |event|
    event.message.delete
    event.respond event.user.mention + ', TSK TSK TSK!'
  end

  command(:triggered) do |event|
    event.message.delete
    event.respond "#{event.server.members.sample.name} is triggered!"
  end
end
