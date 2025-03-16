// Google Mapsの初期化関数
function initMap() {
  const map = new google.maps.Map(document.getElementById('map'), {
    center: { lat: 35.6895, lng: 139.6917 }, // 東京の中心座標
    zoom: 8
  });

  // マーカーを地図に追加
  hotels.forEach(hotel => {
    console.log('Hotel Data:', hotel); // ホテルデータのデバッグ用ログ

    const lat = parseFloat(hotel.latitude);
    const lng = parseFloat(hotel.longitude);

    if (isNaN(lat) || isNaN(lng)) {
      console.error(`Invalid coordinates for hotel: ${hotel.name}`);
      return;
    }

    console.log(`Creating marker for: ${hotel.name} at lat=${lat}, lng=${lng}`);

    const marker = new google.maps.Marker({
      position: { lat: lat, lng: lng },
      map: map,
      title: hotel.name,
      icon: {
        url: "https://maps.google.com/mapfiles/kml/shapes/lodging.png",
        scaledSize: new google.maps.Size(32, 32) // アイコンのサイズを大きく設定
      }
    });

    const infoWindow = new google.maps.InfoWindow({
      content: hotel.info_content
    });

    marker.addListener("click", () => {
      infoWindow.open(map, marker);
    });
  });
}

// Google Maps APIの読み込み
const script = document.createElement('script');
script.src = `https://maps.googleapis.com/maps/api/js?key=${GOOGLE_MAPS_API_KEY}&callback=initMap`;
script.async = true;
script.defer = true;
document.body.appendChild(script);
