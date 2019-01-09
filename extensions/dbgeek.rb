class DbGeek
  def initialize; end

  def newuser(id, username)
    DB.query("INSERT INTO `yourmcbot_data` (`userid`, `mixer`) VALUES ('#{id}', '#{username}')")
  end

  def getuser(id)
    DB.query("SELECT * FROM `yourmcbot_data` WHERE `userid` = #{id.to_i}")
  end

  def updateuser(id, item, value)
    DB.query("UPDATE `yourmcbot_data` SET `#{item}` = '#{value}' WHERE `yourmcbot_data`.`userid` = #{id.to_i}")
  end
end
