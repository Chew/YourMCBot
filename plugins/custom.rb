module Custom
  extend Discordrb::Commands::CommandContainer

  begin
    r = JSON.parse(RestClient.get("#{BASEURL}/commands",
                                  params: { authkey: CONFIG['api'] }))

    r['Commands'].each do |e|
      next if e['cmd'] == '!coins'

      command(e['cmd'][1..-1].downcase.to_sym) do |event|
        if e['text'].include?('(_api_')
          event.respond 'This command makes an API call. This bot doesn\'t support that at the moment.'
        elsif e['text'].include?('(_enterqueue_)')
          event.respond 'This command makes you enter a queue. This command only works on the Mixer page.'
        else
          event.respond e['text'].gsub('@(_user_)', event.user.mention)
        end
      end
      puts "Registered custom command #{e['cmd']}"
    end
  rescue RestClient::Unauthorized
    event.respond 'unable to retrieve commands, custom commands are a goner!'
  end
end
