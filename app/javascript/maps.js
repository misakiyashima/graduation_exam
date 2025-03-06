function initMap() {
  // 地図の初期設定
  const map = new google.maps.Map(document.getElementById("map"), {
    center: { lat: 35.6895, lng: 139.6917 }, // 東京の中心座標
    zoom: 8,
  });

  // Railsから埋め込まれた宿泊施設データを使用
  hotels.forEach(hotel => {
    const marker = new google.maps.Marker({
      position: {
        lat: parseFloat(hotel.latitude),
        lng: parseFloat(hotel.longitude),
      },
      map: map,
      title: hotel.name,
    });

    const infoWindow = new google.maps.InfoWindow({
      content: `<div>
                  <h3>${hotel.name}</h3>
                  <img src="${hotel.hotel_image_url}" alt="${hotel.name}" style="width:100px;height:auto;">
                  <p>${hotel.hotel_special}</p>
                  <a href="${hotel.hotel_information_url}" target="_blank">詳細を見る</a>
                </div>`,
    });

    marker.addListener("click", () => {
      infoWindow.open(map, marker);
    });
  });
}

// Google Maps APIを非同期で読み込む
const script = document.createElement('script');
script.src = `https://maps.googleapis.com/maps/api/js?key=${GOOGLE_MAPS_API_KEY}&callback=initMap`;
script.async = true;
script.defer = true;
document.head.appendChild(script);
