document.addEventListener("turbo:load", () => {
  const mapElement = document.getElementById("map");
  if (!mapElement) return;

  const apiKey = mapElement.dataset.googleMapsApiKey;
  const hotels = JSON.parse(mapElement.dataset.hotels || "[]");

  window.initMap = function () {
    const map = new google.maps.Map(mapElement, {
      center: { lat: 36.2048, lng: 138.2529 },
      zoom: 8,
    });

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
    });
  };

  if (![...document.scripts].some(s => s.src.includes("maps.googleapis.com"))) {
    const s = document.createElement("script");
    s.src = `https://maps.googleapis.com/maps/api/js?key=${encodeURIComponent(apiKey)}&callback=initMap`;
    s.async = true;
    s.defer = true;
    document.head.appendChild(s);
  }
});

