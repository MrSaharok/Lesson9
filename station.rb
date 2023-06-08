require_relative 'instance_counter'
require_relative 'validation'
require_relative 'accessors'

class Station
  include InstanceCounter
  include Validation
  include Accessors
  attr_reader :name, :trains

  NAME_STATION = /^[a-z\d]{4}/i.freeze

  @@stations = []

  validate :name, :presence
  validate :name, :format, NAME_STATION
  validate :atr, :type, Station

  def initialize(name)
    @name = name
    @trains = []
    validate!
    @@stations << self
    register_instance
  end

  def to_s
    @name
  end

  def each_train(&block)
    trains.each(&block)
  end

  def add_train(train)
    trains << train
  end

  def trains_type(type)
    trains.select { |train| train.type == type }
  end

  def send_train(train)
    trains.delete(train)
  end

  def self.all
    @@stations
  end

  def validate!
    errors = []

    errors << "Name station can't be nil!" if name !~ NAME_STATION

    raise errors.join('.') unless errors.empty?
  end
end