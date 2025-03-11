class CoordinateConverter
  R_MAJOR = 6378137.0 # 地球の赤道半径（メートル単位）
  SHIFT = Math::PI * R_MAJOR

  # Webメルカトル座標系 (EPSG:3857) -> WGS84座標系に変換
  def self.to_wgs84(x, y)
    lon = (x / SHIFT) * 180.0
    lat = (y / SHIFT) * 180.0
    lat = 180.0 / Math::PI * (2.0 * Math.atan(Math.exp(lat * Math::PI / 180.0)) - Math::PI / 2.0)
    { latitude: lat, longitude: lon }
  end
end
