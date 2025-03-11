window.initMap = function () {
  const map = new google.maps.Map(document.getElementById("map"), {
    center: { lat: 35.6895, lng: 139.6917 }, // 東京中心
    zoom: 8,
  });

  if (Array.isArray(hotels) && hotels.length > 0) {
    hotels.forEach(hotel => {
      if (hotel.latitude && hotel.longitude) {
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
      }
    });
  } else {
    console.error("No hotels data available.");
  }
};
