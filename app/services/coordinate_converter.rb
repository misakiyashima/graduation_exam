class CoordinateConverter
  def self.to_wgs84(latitude, longitude)
    {
      latitude: correct_coordinate(latitude, 90),
      longitude: correct_coordinate(longitude, 180)
    }
  end

  def self.correct_coordinate(coordinate, max_value)
    while coordinate.abs > max_value
      coordinate /= 10
    end
    coordinate
  end
end
