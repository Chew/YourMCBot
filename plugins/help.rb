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

  command(%i[bug feedback suggestion error report], min_args: 1) do |event, *feedback|
    event.message.delete
    event.send_temporary_message(event.user.mention + ', Your feedback has been successfully recorded. Your message and username have been sent.', 5)

    feedback = feedback.join(' ')

    Bot.channel(423127606880370688).send_embed("<@#{CONFIG['owner_id']}>") do |embed|
      embed.title = 'New Feedback!'
      embed.colour = '6166A8'
      embed.description = feedback.to_s
      embed.timestamp = Time.now

      begin
        RestClient.get("https://cdn.discordapp.com/avatars/#{event.user.id}/#{event.user.avatar_id}.gif?size=1024")
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: event.user.distinct.to_s, icon_url: "https://cdn.discordapp.com/avatars/#{event.user.id}/#{event.user.avatar_id}.gif?size=1024")
      rescue RestClient::UnsupportedMediaType
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: event.user.distinct.to_s, icon_url: "https://cdn.discordapp.com/avatars/#{event.user.id}/#{event.user.avatar_id}.webp?size=1024")
      end

      embed.add_field(name: 'User ID', value: event.user.id.to_s, inline: true)
      if event.channel.pm?
        embed.add_field(name: 'Server', value: 'Sent from a PM', inline: true)
      else
        embed.add_field(name: 'Server', value: "Name: #{event.server.name}\n#{event.server.id}", inline: true)
      end
    end
    # Bot.user(CONFIG['owner_id']).pm(args.join(' '))
  end
end
