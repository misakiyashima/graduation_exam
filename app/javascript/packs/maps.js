document.addEventListener("DOMContentLoaded", function() {
  const script = document.createElement('script');
  script.src = `https://maps.googleapis.com/maps/api/js?key=${GOOGLE_MAPS_API_KEY}&callback=initMap`;
  script.async = true;
  script.defer = true;
  document.body.appendChild(script);
  console.log("Google Maps script added");
});

function initMap() {
  const mapElement = document.getElementById('map');
  if (!mapElement) {
    console.error("Map element not found");
    return;
  }

  const map = new google.maps.Map(mapElement, {
    center: { lat: 36.2048, lng: 138.2529 }, // 日本の中心座標
    zoom: 5
  });

  hotels.forEach((hotel) => {
  const lat = parseFloat(hotel.latitude);
  const lng = parseFloat(hotel.longitude);
  console.log(`Hotel: ${hotel.name}, Lat: ${lat}, Lng: ${lng}`); // 緯度経度のログ

  // 範囲外チェック
  if (isNaN(lat) || isNaN(lng) || lat < 24 || lat > 46 || lng < 122 || lng > 153) {
    console.error(`Invalid or out-of-range coordinates for hotel: ${hotel.name}`);
    return;
  }

  // マーカー作成の確認
  const marker = new google.maps.Marker({
    position: { lat: lat, lng: lng },
    map: map,
    title: hotel.name,
  });
  console.log(`Marker created for: ${hotel.name}`);
});

}
