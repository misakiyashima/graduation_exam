class CoordinateConverter
  R_MAJOR = 6378137.0 # 地球の赤道半径（メートル単位）
  SHIFT = Math::PI * R_MAJOR

  # Webメルカトル座標系 (EPSG:3857) -> WGS84座標系に変換
  def self.to_wgs84(dms_latitude, dms_longitude)
    latitude = dms_to_decimal(dms_latitude)
    longitude = dms_to_decimal(dms_longitude)
    { latitude: latitude, longitude: longitude }
  end

  private

  def self.dms_to_decimal(dms)
    d, m, s = dms.split(/[^\d\w]+/).map(&:to_f)
    d + (m / 60) + (s / 3600)
  end
end
