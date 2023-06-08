require_relative 'wagon'

class CargoWagon < Wagon
  def initialize(total_place)
    super(:cargo, total_place)
  end

  def take_place(volume)
    @used_place += volume if (@used_place + volume) <= @total_place
  end
end