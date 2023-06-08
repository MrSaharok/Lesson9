class Wagon
  attr_reader :type, :number, :used_place, :total_place

  def initialize(wagon_type, total_place)
    @type = wagon_type
    @number = rand(100)
    @total_place = total_place
    @used_place = 0
  end

  def free_place
    total_place - used_place
  end

  def take_place
    raise 'Not implemented'
  end

  def list_free_place
    if :cargo
      puts "Free volume: #{free_place}/#{total_place}"
    else
      puts "Free seats: #{free_place}/#{total_place}"
    end
  end

  def list_taken_place
    if :cargo
      puts "Taken volume: #{used_place}/#{total_place}"
    else
      puts "Taken seats: #{used_place}/#{total_place}"
    end
  end
end