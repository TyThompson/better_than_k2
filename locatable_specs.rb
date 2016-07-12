require "rspec"

module Locatable
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

  skip "can find list of closest" do
    s = Station.closest_to 10, -34, count: 2

    expect(s.count).to eq 2
    expect(s.last.latitude).to eq -36
  end
end
