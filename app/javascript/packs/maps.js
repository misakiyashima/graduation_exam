// 地図の初期化関数をグローバルスコープに設定
window.initMap = function () {
  // 地図の初期設定
  const map = new google.maps.Map(document.getElementById("map"), {
    center: { lat: 35.6895, lng: 139.6917 }, // 東京
    zoom: 8,
  });

  // 宿泊施設データを地図に表示
  if (Array.isArray(hotels) && hotels.length > 0) {
    hotels.forEach(hotel => {
      // 緯度経度の存在を確認
      if (!hotel.latitude || !hotel.longitude) {
        console.error(`Missing coordinates for hotel: ${hotel.name}`);
        return;
      }

      // マーカーの追加
      const marker = new google.maps.Marker({
        position: {
          lat: parseFloat(hotel.latitude),
          lng: parseFloat(hotel.longitude),
        },
        map: map,
        title: hotel.name,
      });

      // 情報ウィンドウの設定
      const infoWindow = new google.maps.InfoWindow({
        content: `<div>
                    <h3>${hotel.name}</h3>
                    <img src="${hotel.hotel_image_url}" alt="${hotel.name}" style="width:100px;height:auto;">
                    <p>${hotel.hotel_special}</p>
                    <a href="${hotel.hotel_information_url}" target="_blank">詳細を見る</a>
                  </div>`,
      });

      // クリックイベントで情報ウィンドウを表示
      marker.addListener("click", () => {
        infoWindow.open(map, marker);
      });
    });
  } else {
    console.error("No hotels data available or invalid data format.");
  }
};
