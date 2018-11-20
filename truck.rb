class Truck
  include Comparable

  # Initialize truck with info returned from API
  def initialize(info)
    @info = info
  end

  # Determine if the truck is open on the current day of the week
  def open_today?(time)
    open_day = @info["dayofweekstr"]
    current_day = time.strftime("%A")

    open_day == current_day
  end

  # Compare trucks by applicant name
  def <=>(truck)
    applicant <=> truck.applicant
  end

  # Determine if the truck is open at the given time
  def open_now?(now)
    # Possible to make purchase right when the truck opens
    # Not possible to do so right when it closes
    start_time = get_time_object(now, @info["start24"])
    end_time = get_time_object(now, @info["end24"])

    return start_time <= now && now < end_time
  end

  # Return applicant (name) for the truck
  def applicant
    @info["applicant"]
  end

  # Return location for the truck
  def location
    @info["location"]
  end

  # Get time object for the current day with a given hour and min
  # Used to calculate the start and end time for trucks that are open on the current day
  def get_time_object(now, time)
    hour, min = [time[0..1].to_i, time[3..4].to_i]

    Time.new(now.year, now.month, now.day, hour, min, 00, "-08:00")
  end

end
