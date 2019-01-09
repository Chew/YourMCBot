module UserInfo
  extend Discordrb::Commands::CommandContainer

  command(:whois, max_args: 1) do |event, mention|
    if !mention.nil?
      if mention.include?('@')
        userid = event.bot.parse_mention(mention.to_s).id.to_i
        user = event.server.member(userid)
      elsif mention.include?('#')
        tag = mention.split('#')
        name = tag[0]
        disc = tag[1]
        mem = event.server.members.index { |e| e.name == name && e.discriminator == disc }
        user = event.server.members[mem]
      elsif mention.to_i != 0
        user = event.server.member(mention)
      end
    else
      user = event.user
    end

    begin
      event.channel.send_embed do |embed|
        embed.author = { name: user.distinct, icon_url: user.avatar_url }

        embed.description = user.mention

        embed.thumbnail = { url: user.avatar_url }

        case user.status.to_s
        when 'online'
          status = 'Online'
          embed.color = '43B581'
        when 'idle'
          status = 'Idle'
          embed.color = 'FAA61A'
        when 'dnd'
          status = 'Do Not Disturb'
          embed.color = 'F04747'
        when 'offline'
          status = 'Offline'
          embed.color = '747F8D'
        else
          status = user.status
          embed.color = '747F8D'
        end

        embed.add_field(name: 'Status', value: status, inline: true)

        members = event.server.members
        members = members.sort_by(&:joined_at)

        orr = members.index { |e| e.id == user.id } + 1

        embed.add_field(name: 'Joined at', value: user.joined_at.strftime('%a, %b %d, %Y at %l:%M:%S %p'), inline: true)

        embed.add_field(name: 'Join Position', value: orr, inline: true)

        embed.add_field(name: 'Created Account', value: user.creation_time.strftime('%a, %b %d, %Y at %l:%M:%S %p'), inline: true)

        roles = []

        user.roles.each do |role|
          roles.push role.mention
        end

        if roles.length.zero?
          embed.add_field(name: 'Roles - [0]', value: 'No Roles', inline: true)
        elsif roles.length < 20
          embed.add_field(name: "Roles - [#{roles.length}]", value: roles.join(' '), inline: true)
        else
          embed.add_field(name: "Roles - [#{roles.length}]", value: "#{roles[0..24].join(' ')} ... and #{roles.length - 25} more...", inline: true)
        end

        embed.footer = { text: "ID: #{user.id}" }
      end
    end
  end
end
