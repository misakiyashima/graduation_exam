class CoordinateConverter
  def self.to_wgs84(lat_seconds, lng_seconds)
    # 秒 → 度への変換
    lat_deg = lat_seconds / 3600.0
    lng_deg = lng_seconds / 3600.0

    # 度単位のデータをそのまま返す
    {
      latitude: lat_deg,
      longitude: lng_deg
    }
  end
end
