module FollowAge
  extend Discordrb::Commands::CommandContainer

  command(:followage, max_args: 1) do |event, *namearg|
    name = namearg.join(' ') unless namearg.length.zero?
    user = BotUser.new(event.user.id)
    if user.exists? && namearg.length.zero?
      profile = user
      name = profile.mixer
    elsif namearg.length.zero?
      name = event.user.display_name
    end

    r = JSON.parse(RestClient.get("https://mixer.com/api/v1/channels/21655/follow?where=username:eq:#{name}&noCount=true"))

    if r.length.zero?
      event.channel.send_embed do |embed|
        embed.colour = 'ff0000'
        embed.title = 'An error occured'
        embed.description = "That user doesn't exist or isn't following YourMCAdmin! Convince them to!"
      end
      return
    end

    creation = Time.parse(r[0]['followed']['createdAt'])

    t = Time.now - creation
    mm, ss = t.divmod(60)
    hh, mm = mm.divmod(60)
    dd, hh = hh.divmod(24)
    yy, dd = dd.divmod(365)
    years = format('%d years, ', yy) if yy != 0
    days = format('%d days, ', dd) if dd != 0
    hours = format('%d hours, ', hh) if hh != 0
    mins = format('%d minutes, ', mm) if mm != 0
    secs = format('%d seconds', ss)

    event.channel.send_embed do |embed|
      embed.colour = 0xd084
      embed.add_field(name: 'Started Following', value: creation.strftime('%a, %b %d, %Y at %l:%M:%S %p'), inline: false)

      embed.add_field(name: 'Time ago', value: "#{years}#{days}#{hours}#{mins}#{secs}", inline: false)

      embed.title = "Follow Age for #{name}"
    end
  end
end
