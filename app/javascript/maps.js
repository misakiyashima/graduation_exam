document.addEventListener("DOMContentLoaded", () => {
  const mapElement = document.getElementById("map");
  if (!mapElement) return;

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

  // 初期化
  if (!map) {
    map = new google.maps.Map(mapElement, {
      center: { lat: 36.2048, lng: 138.2529 },
      zoom: 8,
    });
  }

  addMarkers(hotels);
});

