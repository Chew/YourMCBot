class BotUser
  def initialize(id)
    @id = id
    @helper = DbGeek.new
    result = @helper.getuser(id)
    result.each do |row|
      @results = row
    end
  end

  def exists?
    !@results.nil?
  end

  def userid
    @results['userid']
  end

  def mixer
    @results['mixer']
  end

  def mixer=(updated)
    @helper.updateuser(@id, 'mixer', updated)
  end
end
