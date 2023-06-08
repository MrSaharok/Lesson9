require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'

class Main
  def initialize
    @stations = []
    @routes = []
    @trains = []
  end

  def start
    loop do
      show_menu
      choice = gets.chomp.to_i
      run(choice)
    end
  end

  private

  def show_menu
    puts "
          Station:
          (1)Create a station
          (2)list of stations and list of trains at the station
          Route:
          (3)Create a route
          (4)Add/delete station in route
          (5)Set route to the train
          Train:
          (6)Create trains
          (7)Add/remove wagons to the train
          (8)Move the train along the route
          (9)Take a seat or volume in the wagon
          (10)list of wagons at the train
          (11)Exit!"
  end

  def run(r)
    case r
    when 1
      create_station
    when 2
      list_all_trains
    when 3
      create_route
    when 4
      edit_route
    when 5
      assign_route_train
    when 6
      create_train
    when 7
      edit_wagons
    when 8
      move_train
    when 9
      take_seat_volume
    when 10
      list_all_wagons
    when 11
      :exit
    else
      show_menu
    end
  end

  def select_from_array(array)
    return if array.empty?

    array.each.with_index(1) do |element, index|
      puts "#{element} (#{index})"
    end
    array[gets.chomp.to_i - 1]
  end

  def create_station
    puts 'Please enter the name of the station:'
    station_name = gets.chomp
    @stations << Station.new(station_name)
    puts "Station: #{station_name} created!"
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def list_all_trains
    @stations.each do |station|
      puts "Station name: #{station.name}"
      station.each_train do |train|
        puts "Train number: #{train.number}, type: #{train.type}, count wagons: #{train.wagons.size}"
      end
    end
  end

  def list_all_wagons
    @trains.each do |train|
      puts "Train number: #{train.number}, type: #{train.type}"
      train.each_wagon do |wagon|
        puts "Wagon number: #{wagon.number}, type: #{wagon.type}, #{wagon.free}, #{wagon.taken}"
      end
    end
  end

  def create_route
    if @stations.size < 2
      puts 'Need more stations'
    else
      puts 'Select first station:'
      first_station = select_from_array(@stations)
      puts 'Select last station:'
      stations = @stations.reject { |element| element == first_station }
      last_station = select_from_array(stations)
      @routes << Route.new(first_station, last_station)
      puts "New route was created. See all available: #{@routes}"
    end
  end

  def edit_route
    if @routes.empty?
      puts 'There are no routes to edit'
    else
      puts 'Select route to edit: '
      select_route = select_from_array(@routes)
      puts 'Select action: add station(1), remove station(2)'

      action = gets.chomp.to_i
      case action
      when 1
        select_route.add_station(select_from_array(@stations))
        puts 'Add station'
      when 2
        select_route.remove_station(select_from_array(@stations))
        puts 'Remove station'
      end
    end
  end

  def assign_route_train
    if @trains.empty?
      puts 'There are no trains to set the route.'
    elsif @routes.empty?
      puts 'There are no routes to assign.'
    else
      puts 'Choose train to assign the route: '
      select_train = select_from_array(@trains)
      puts "Choose route to assign #{select_train}"
      select_route = select_from_array(@routes)
      select_train.assign_route(select_route)
      puts "Train #{select_train} have #{select_route}."
    end
  end

  def create_train
    puts 'Please enter number train in format XXX-XX or XXXXX:'
    train_number = gets.chomp
    puts 'Choose the type of train (1)Cargo or (2)Passenger'
    type = gets.chomp.to_i
    @trains << CargoTrain.new(train_number) if type == 1
    @trains << PassengerTrain.new(train_number) if type == 2
    raise 'Error! Please enter 1 or 2.' unless (1..2).cover?(type)

    puts "Train: #{train_number} created!"
  rescue StandardError => e
    puts e.message
    retry
  end

  def created_wagon
    puts 'Choose the type of wagon (1)Cargo or (2)Passenger'

    type = gets.chomp.to_i
    case type
    when 1
      puts 'Please enter the volume of the wagon:'
      total_place = gets.chomp.to_i
      puts "Cargo wagon with volume: #{total_place} created"
      CargoWagon.new(total_place)
    when 2
      puts 'Please enter seats in the wagon:'
      total_place = gets.chomp.to_i
      puts "Passenger wagon with seats: #{total_place} created"
      PassengerWagon.new(total_place)
    end
  end

  def edit_wagons
    puts 'No train' if @trains.empty?
    puts 'Choose train:'
    select_train = select_from_array(@trains)
    puts 'Select an action: add wagon(1),remove wagon(2)'

    action = gets.chomp.to_i
    case action
    when 1
      new_wagon = created_wagon
      select_train.add_wagon(new_wagon)
      puts "To the train #{select_train} attached wagons: #{new_wagon}"
    when 2
      puts 'Select a carriage for uncoupled: '
      select_wagon = select_from_array(select_train.wagons)
      select_train.remove_wagons(select_wagon)
      puts "In the train #{select_train} uncoupled wagons"
    end
  end

  def move_train
    return if @trains.empty?

    puts 'Select train: '
    select_train = select_from_array(@trains)
    puts "Select action for #{select_train}: move to forward(1) or to backward(2)"

    action = gets.chomp.to_i
    case action
    when 1
      select_train.move_forward
    when 2
      select_train.move_backward
    else
      'Entered option was not found.'
    end
  end

  def select_wagon(wagons = [])
    @trains.each do |train|
      wagons += train.wagons
    end
    wagons
  end

  def take_seat_volume
    puts 'Select wagons: '
    wagon = select_from_array(select_wagon)
    if wagon.type.eql?(:cargo)
      puts 'Select volume: '
      volume = gets.chomp.to_i
      wagon.take_place(volume)
    else
      wagon.take_place
    end
    wagon.list_free_place
    wagon.list_taken_place
  end
end

go = Main.new
go.start