require_relative 'wagon'

class PassengerWagon < Wagon
  def initialize(total_place)
    super(:passenger, total_place)
  end

  def take_place
    @used_place += 1 if free_place.positive?
  end
end