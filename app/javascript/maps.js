let map;        // 地図インスタンス
let markers = []; // マーカー一覧

document.addEventListener("DOMContentLoaded", () => {
  const mapElement = document.getElementById("map");
  if (!mapElement) return;

  const apiKey = mapElement.dataset.googleMapsApiKey;
  const hotels = JSON.parse(mapElement.dataset.hotels || "[]");

  // マーカー削除
  function clearMarkers() {
    markers.forEach(marker => marker.setMap(null));
    markers = [];
  }

  // マーカー追加
  function addMarkers(hotels) {
    hotels.forEach((hotel, i) => {
      const lat = parseFloat(hotel.latitude);
      const lng = parseFloat(hotel.longitude);
      if (Number.isNaN(lat) || Number.isNaN(lng)) return;

      const marker = new google.maps.Marker({
        position: { lat, lng },
        map,
        title: hotel.name || `hotel-${i}`,
      });

      marker.addListener("click", () => {
        if (hotel.hotelNo) {
          window.location.href = `/maps/${hotel.hotelNo}/details`;
        }
      });

      markers.push(marker);
    });
  }

  // マーカーだけ更新（必要なら外部から呼べる）
  window.updateMarkers = function (newHotels) {
    clearMarkers();
    addMarkers(newHotels);
  };

  // 地図初期化
  window.initMap = function () {
    if (!map) {
      map = new google.maps.Map(mapElement, {
        center: { lat: 36.2048, lng: 138.2529 },
        zoom: 8,
      });
    }
    addMarkers(hotels);
  };

  // Google Maps API を 1 回だけロード
  if (!window.googleMapsLoaded) {
    window.googleMapsLoaded = true;

    const s = document.createElement("script");
    s.src = `https://maps.googleapis.com/maps/api/js?key=${encodeURIComponent(apiKey)}&callback=initMap`;
    s.async = true;
    s.defer = true;
    document.head.appendChild(s);
  } else {
    initMap();
  }
});
