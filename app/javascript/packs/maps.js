document.addEventListener("DOMContentLoaded", function () {
  const GOOGLE_MAPS_API_KEY = "<%= ENV['GOOGLE_MAPS_API_KEY'] %>";

  // Google Maps APIのスクリプトをロード
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
    zoom: 10
  });

  hotels.forEach((hotel) => {
    const lat = parseFloat(hotel.latitude);
    const lng = parseFloat(hotel.longitude);

    if (isNaN(lat) || isNaN(lng)) {
      console.error(`Invalid coordinates for hotel: ${hotel.name}`);
      return;
    }

    const marker = new google.maps.Marker({
      position: { lat: lat, lng: lng },
      map: map,
      title: hotel.name,
    });

    console.log(`Marker created for: ${hotel.name}`);

    // マーカークリックイベントでリンクに遷移
    marker.addListener('click', () => {
      // Railsのルートにリダイレクト
      window.location.href = `/hotels/${hotel.hotelNo}`;
    });
  });
}
