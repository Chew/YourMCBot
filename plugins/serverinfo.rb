module ServerInfo
  extend Discordrb::Commands::CommandContainer

  command(:membercount) do |event|
    online = 0
    idle = 0
    dnd = 0
    offline = 0

    user = 0
    bot = 0

    event.server.members.each do |e|
      if e.online?
        online += 1
      elsif e.idle?
        idle += 1
      elsif e.offline?
        offline += 1
      else
        dnd += 1
      end

      if e.bot_account?
        bot += 1
      else
        user += 1
      end
    end

    event.channel.send_embed do |embed|
      embed.add_field(name: 'Members', value: [
        "Total - #{event.server.members.count}",
        "Users - #{user}",
        "Bots - #{bot}"
      ].join("\n"), inline: true)
      embed.add_field(name: 'Status', value: [
        "Online - #{online}",
        "Idle - #{idle}",
        "DND - #{dnd}",
        "Offline - #{offline}"
      ].join("\n"), inline: true)
    end
  end
end
