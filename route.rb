require_relative 'validation'
require_relative 'instance_counter'

class Route
  include InstanceCounter
  include Validation
  attr_reader :stations

  def initialize(station_first, station_last)
    @stations = [station_first, station_last]
    validate!
    register_instance
  end

  def first_station
    @stations.first
  end

  def last_station
    @stations.last
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def remove_station(station)
    return unless station != @stations.first || station != @stations.last

    @stations.delete(station)
  end

  protected

  def validate(station)
    raise "Name station can't be nil !" if station.nil?
    raise "Object: #{station} - is not an instance of the Station class!" unless station.instance_of?(Station)
    raise "Name station can't be Empty !" if station.name.strip.empty?
  end

  def validate!
    validate(first_station)
    validate(last_station)
    return unless first_station.name == last_station.name

    raise "The route must have different stations! First: #{first_station.name}, last: #{last_station.name}"
  end
end