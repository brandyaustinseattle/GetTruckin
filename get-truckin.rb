require 'terminal-table'
require_relative 'truck-api'
require_relative 'truck'

class GetTruckin

  # Initialize GetTruckin with trucks (public) and time (private)
  def initialize
    @trucks = []
    # Convert local time to PST
    # This class can be used with similar API's also in PST
    @time = Time.now.getlocal('-08:00')
  end

  # Run the program - fetch food truck data, sort trucks by name, and display results using basic CLI pagination
  def run
    print_name
    print_truck
    print_intro
    get_trucks
    sort_trucks
    display_trucks
    print_closing
  end


  private

  # Get list of trucks that are open at the current day and time
  def get_trucks
    # Use TuckAPI class to call api using the given url
    api = TruckAPI.new('http://data.sfgov.org/resource/bbb8-hzi6.json')
    all_info = api.get_data

    all_info.each do |info|
      # Use Truck class to create an instance of truck
      truck = Truck.new(info)
      next if !truck.open_today?(@time)
      next if !truck.open_now?(@time)

      @trucks << truck
    end
  end

  # Sort trucks alphabetically
  def sort_trucks
    @trucks.sort!
  end

  # Display 10 trucks at a time
  # Ask user if they want to see more trucks until the user declines or there are no more trucks
  def display_trucks
    print_no_trucks if @trucks.length == 0
    until @trucks.empty?
      ten_trucks = @trucks.shift(10)
      print_table(ten_trucks)
      print_more? if @trucks.length > 0
    end
  end

  # Print formatted table of trucks
  def print_table(trucks)
    rows = trucks.map { |truck| [truck.applicant, truck.location]  }
    table = Terminal::Table.new(:title => "Open Food Trucks in San Francisco", :headings => ['Name', 'Address'], :rows => rows)

    puts table
  end

  # Ask user if they want to see more trucks
  # Repeat question if user responds w/ invalid input
  def print_more?
    loop do
      print "\nDO YOU WANT TO SEE MORE TRUCKS? (Y/N): "
      answer = gets.chomp
      if ["Y","y"].include?(answer)
        return true
      elsif ["N","n"].include?(answer)
        print_closing
        exit
      else
        print_invalid_input
      end
    end
  end

  def print_intro
    puts <<~HEREDOC
      \nWELCOME TO GET TRUCKIN' - YOUR #1 RESOURCE FOR FINDING A FOOD TRUCK WHERE YOU CAN CHOW DOWN FAST.\nBELOW IS A LIST OF ALL THE FOOD TRUCKS THAT ARE OPEN RIGHT NOW ALONG WITH THEIR ADDRESS. TO MAKE IT\nEASY, WE DISPLAY 10 TRUCKS AT A TIME SO PAGE ON THROUGH TO FIND ONE THAT HAS YOU READY TO CHOW DOWN.\n
    HEREDOC
  end

  def print_no_trucks
    puts "\nTHERE ARE NO TRUCKS OPEN RIGHT NOW. HOPE YOU COME BACK LATER."
    exit
  end

  def print_invalid_input
    puts "WHOOPS - THAT DOESN'T LOOK LIKE Y OR N."
  end

  def print_closing
    puts <<~HEREDOC
      \nTHANKS FOR CHECKING OUT GET TRUCKIN'! COME BACK NEXT TIME YOU NEED TO FIND A FOOD TRUCK WHERE YOU\nCAN CHOW DOWN FAST. HOPE YOU ENJOY YOUR MEAL."
    HEREDOC
  end

  def print_name
    puts <<~HEREDOC
                               _     _                   _    _
                              | |   | |                 | |  (_)
                     __ _  ___| |_  | |_ _ __ _   _  ___| | ___ _ __
                    / _` |/ _ \\ __| | __| '__| | | |/ __| |/ / | '_ \\
                   | (_| |  __/ |_  | |_| |  | |_| | (__|   <| | | | |
                    \\__, |\\___|\\__|  \\__|_|   \\__,_|\\___|_|\\_\\_|_| |_|
                     __/ |
                    |___/
    HEREDOC
  end

  def print_truck
    puts <<~HEREDOC

             o
             .----------------------------------......._____      |
             |______________________________________________`_,   |
             |  .--------------..--------------.  |.----------,\\  |
             |  |              ||              |  ||           \\\  |
             |  |              ||              |  ||            \\\ |
             |  |              ||              |  ||             \\\|_
             |  `--------------''--------------'  ||              \\\/ .---------.
             |____________________________________||_______________\\\_(_________)_
             | .---.                        .---. |                `%,------------~-.
             | |(O)|                        |(O)| |  __             |               |
            (| `---'                        `---' | (- \\            |                |)
            (|                                    |  ~~             |                |
             |                                    |                 |               |
             |       __,---,__                    |                `%,  __,---,__   |_
             =|______//       \\\___________________|_________________|__//       \\\__|_]
                     |   .-.   |                                         |   .-.   |
                     |   `-'   |                                         |   `-'   |
                      \\_     _/                                           \\_     _/
                        `---'                                               `---'
    HEREDOC
  end

end

### DRIVER CODE
# Initialize new instance of program
program = GetTruckin.new()

# Run program
program.run
