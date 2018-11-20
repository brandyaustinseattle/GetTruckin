require 'json'
require 'net/http'

class TruckAPI

  # Initialize truck-api with corresponding url
  def initialize(url)
    @url = url
  end

  # Get data by making call to API with url fron initialize
  def get_data
    parsed_url = URI.parse(@url)
    req = Net::HTTP::Get.new(parsed_url.to_s)
    res = Net::HTTP.start(parsed_url.host, parsed_url.port) {|http| http.request(req)}
    return JSON.parse(res.body)
  end

end
