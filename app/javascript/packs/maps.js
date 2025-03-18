function initMap() {
  const map = new google.maps.Map(document.getElementById('map'), {
    center: { lat: 36.2048, lng: 138.2529 }, // 日本の中心座標
    zoom: 5 // より広いズーム設定
  });

  const testHotels = [
    {
      name: "テストホテル 東京",
      latitude: 35.6895,
      longitude: 139.6917,
      info_content: "<h3>テストホテル 東京</h3><p>サンプルデータ</p>"
    },
    {
      name: "テストホテル 大阪",
      latitude: 34.6937,
      longitude: 135.5022,
      info_content: "<h3>テストホテル 大阪</h3><p>サンプルデータ</p>"
    }
  ];

  const allHotels = hotels.concat(testHotels);

  allHotels.forEach(hotel => {
    const lat = parseFloat(hotel.latitude);
    const lng = parseFloat(hotel.longitude);

    console.log(`Coordinates for ${hotel.name}: lat=${lat}, lng=${lng}`);

    if (lat < 24 || lat > 46 || lng < 122 || lng > 153) {
      console.error(`Coordinates out of range for hotel: ${hotel.name}`);
      return;
    }

    const marker = new google.maps.Marker({
      position: { lat: lat, lng: lng },
      map: map,
      title: hotel.name,
      icon: {
        url: "https://maps.google.com/mapfiles/ms/icons/blue-dot.png",
        scaledSize: new google.maps.Size(40, 40) // サイズを調整
      }
    });

    console.log(`Marker created for: ${hotel.name}`);
  });
}

document.addEventListener("DOMContentLoaded", function() {
  const script = document.createElement('script');
  script.src = `https://maps.googleapis.com/maps/api/js?key=${GOOGLE_MAPS_API_KEY}&callback=initMap`;
  script.async = true;
  script.defer = true;
  document.body.appendChild(script);
  console.log("Google Maps script added");
});
