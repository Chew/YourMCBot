module Profile
  extend Discordrb::Commands::CommandContainer

  command(:profile, min_args: 0, max_args: 1) do |event, user|
    if user.nil?
      dbuser = BotUser.new(event.user.id)
      unless dbuser.exists?
        DBHelper.newuser(event.user.id, event.user.display_name)
        dbuser = BotUser.new(event.user.id)
      end
      nametouse = event.user.distinct
    else
      id = if user.include?('<')
             event.bot.parse_mention(user).id
           else
             user
           end
      dbuser = BotUser.new(id)
      unless dbuser.exists?
        event.channel.send_embed do |embed|
          embed.title = 'Error while getting that user\'s profile'
          embed.colour = 'E6286E'
          embed.description = 'That user doesn\'t appear to have a profile! :('
        end
        break
      end
      nametouse = event.bot.user(id).distinct
    end

    event.channel.send_embed do |embed|
      embed.title = "YourMCBot Profile for #{nametouse}"
      embed.colour = '36399A'

      # embed.description = '[Manage your Profile Online!](https://api.chew.pro/hqbot)'

      embed.add_field(name: 'Mixer Username', value: dbuser.mixer, inline: true)

      embed.footer = { text: 'Change with: !set [type] [option]' }
    end
  end

  command(:set, min_args: 2) do |event, type, *setting|
    setting = setting.join(' ')
    dbuser = BotUser.new(event.user.id)
    unless dbuser.exists?
      DBHelper.newuser(event.user.id, event.server.member(event.user.id).display_name)
      dbuser = BotUser.new(event.user.id)
    end
    case type.downcase
    when 'mixer'
      dbuser.mixer = setting
    else
      event.respond ':-1: Unable to set: Invalid type!'
      break
    end
    event.respond ":+1: Successfully set `#{type}` to `#{setting}`"
  end
end
