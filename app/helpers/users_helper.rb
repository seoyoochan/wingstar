module UsersHelper
  def age(person)
    now = Date.today
    if person.date_of_birth.blank?
     nil
    else
      now.year - person.date_of_birth.year - (now.strftime('%m%d') < person.date_of_birth.strftime('%m%d') ? 1 : 0)
    end
  end

  def online?
    updated_at > 1.minutes.ago
  end

  def setup_location(user)
    user.location ||= Location.new
    @location = user.location
  end

  def setup_birthday(user)

  end
end