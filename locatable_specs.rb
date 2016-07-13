require "rspec"
require "haversine"
require "pry"


module Locatable
  def Locatable.included station
    station.extend Locatable::ClassMethods
  end

  module ClassMethods
    def closest_to(lat, long, opts={})
      station_vector = {}
      self.all.each do |station|
        station_vector[station] = (Haversine.distance(station.latitude, station.longitude, lat, long).to_miles)
      end
      station_vector =  station_vector.sort_by{ |k,v| v}
      # turns into array
      if opts[:count] && opts[:count] > 1
        stations = []
        station_vector[0...opts[:count]].each {|v| stations << v[0]}
        stations
      else
        station_vector[0][0]
      end
    end
  end

  def distance_to(lat, long)
    distance = Haversine.distance(self.latitude, self.longitude, lat, long)
    distance.to_miles
  end
end



class Station
  attr_reader :latitude, :longitude

  include Locatable

  def initialize lat, long
    @latitude, @longitude = lat, long
  end

  def self.all
    [
      Station.new(12, -36),
      Station.new(10, -33),
      Station.new(77,  45)
    ]
  end
end

describe Locatable do
  it "can find distances" do
    s = Station.new 10, -33

    expect(s.distance_to 10, -33).to eq 0
    expect(s.distance_to 10, -34).to be < 10000 # ??
  end

  it "can find closest stations" do
    s = Station.closest_to 10, -34

    expect(s.latitude ).to eq  10
    expect(s.longitude).to eq -33
  end

  it "can find list of closest" do
    s = Station.closest_to 10, -34, count: 2

    expect(s.count).to eq 2
    expect(s.last.longitude).to eq -36
  end
end
