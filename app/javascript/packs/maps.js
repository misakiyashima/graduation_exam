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

    const marker = new google.maps.Marker({
      position: { lat: lat, lng: lng },
      map: map,
      title: hotel.name
    });

    const infoWindow = new google.maps.InfoWindow({
      content: hotel.info_content
    });

    marker.addListener("click", () => {
      infoWindow.open(map, marker);
    });
  });
}
