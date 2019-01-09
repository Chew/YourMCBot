module Help
  extend Discordrb::Commands::CommandContainer

  command(:help) do |event|
    event.channel.send_embed do |embed|
      embed.title = 'YourMCBot Commands'
      embed.colour = '36399A'

      embed.add_field(name: 'Basic Commands', value: [
        '`!help` - Find bot commands',
        '`!ping` - Ping the bot',
        '`!feedback` - Leave feedback about the bot'
      ].join("\n"), inline: false)

      embed.add_field(name: 'Admin Commands', value: [
        '`!coins [user]` - Find your coins!',
        '`!mixer [user]` - Find mixer stats for a user',
        '`!quote [id]` - Retrieve a quote from the Quotes list'
      ].join("\n"), inline: false)

      embed.add_field(name: 'Server Commands', value: [
        '`!membercount` - Find the member counts of the server.',
        '`!whois` - Find info about yourself.'
      ].join("\n"), inline: false)

      embed.add_field(name: 'Profile Commands', value: [
        '`!profile` - See your bot profile',
        '`!set mixer [name]` - Set your mixer name to use for `!coins` and more.'
      ].join("\n"), inline: false)
    end
  end

  command(:bug, aliases: %i[feedback suggestion error report], min_args: 1) do |event, *feedback|
    event.message.delete
    event.send_temporary_message(event.user.mention + ', Your feedback has been successfully recorded. Your message and username have been sent.', 5)

    feedback = feedback.join(' ')

    Bot.channel(423_127_606_880_370_688).send_embed("<@#{CONFIG['owner_id']}>") do |embed|
      embed.title = 'New Feedback!'
      embed.colour = '6166A8'
      embed.description = feedback.to_s
      embed.timestamp = Time.now

      embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: event.user.distinct.to_s, icon_url: event.user.avatar_url)

      embed.add_field(name: 'User ID', value: event.user.id.to_s, inline: true)
      if event.channel.pm?
        embed.add_field(name: 'Server', value: 'Sent from a PM', inline: true)
      else
        embed.add_field(name: 'Server', value: "Name: #{event.server.name}\nID: #{event.server.id}", inline: true)
      end
    end
    # Bot.user(CONFIG['owner_id']).pm(args.join(' '))
  end

  command(:ping, min_args: 0, max_args: 1) do |event, noedit|
    if noedit == 'noedit'
      event.respond "Pong! Time taken: #{((Time.now - event.timestamp) * 1000).to_i} milliseconds."
    else
      m = event.respond('Pinging...')
      m.edit "Pong!! Time taken: #{((Time.now - event.timestamp) * 1000).to_i} milliseconds."
    end
  end
end
