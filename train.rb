require_relative 'station'
require_relative 'route'
require_relative 'validation'
require_relative 'instance_counter'
require_relative 'name_company'
require_relative 'accessors'

class Train
  include NameCompany
  include InstanceCounter
  include Validation
  include Accessors
  attr_reader :number, :type, :wagons, :routes, :speed, :current_station_index

  NUMBER_FORMAT = /^[a-z\d]{3}-?[a-z\d]{2}$/i.freeze

  @@trains = {}

  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT
  validate :number, :type, String


  def initialize(number)
    @number = number
    @type = type
    validate!
    @wagons = []
    @speed = 0
    @current_station_index = 0
    @@trains[number] = self
    register_instance
  end

  def to_s
    @number
  end

  def each_wagon(&block)
    wagons.each(&block)
  end

  def speed_up(speed)
    @speed += speed if speed <= 0
  end

  def stop
    @speed = 0
  end

  def relevant_wagon?(wagon)
    wagon.type == @type
  end

  def add_wagon(wagon)
    @wagons << wagon
  end

  def remove_wagons(wagon)
    return unless @speed.nonzero?

    @wagons.delete(wagon)
  end

  def assign_route(routes)
    @routes = routes
    @current_station_index = 0
    @routes.stations[@current_station_index].add_train(self)
  end

  def current_station
    @routes.stations[@current_station_index]
  end

  def next_station
    @routes.stations[@current_station_index + 1]
  end

  def previous_station
    @routes.stations[@current_station_index - 1]
  end

  def move_forward
    current_station.send_train(self)
    @current_station_index += 1
    current_station.add_train(self)
    puts "Train: #{self} is current station: #{current_station}"
  end

  def move_backward
    current_station.send_train(self)
    @current_station_index -= 1
    current_station.add_train(self)
    puts "Train: #{self} is current station: #{current_station}"
  end

  def self.find(number)
    @@trains[number]
  end

  protected

  def validate!
    errors = []

    errors << 'The valid number must be of the form: XXX-XX or XXXXX' if number !~ NUMBER_FORMAT

    raise errors.join('.') unless errors.empty?
  end
end