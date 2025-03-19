class CoordinateConverter
  # Tokyo Datum (秒単位) を WGS84 (度単位) に変換
  def self.to_wgs84(lat_seconds, lng_seconds)
    # 入力値の検証
    raise ArgumentError, 'Invalid latitude or longitude' if lat_seconds.nil? || lng_seconds.nil?

    # 秒 → 度への変換
    lat_deg = lat_seconds / 3600.0
    lng_deg = lng_seconds / 3600.0

    # 度単位のデータを返却
    {
      latitude: lat_deg,
      longitude: lng_deg
    }
  end
end
