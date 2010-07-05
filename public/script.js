var map;
var newyork = new google.maps.LatLng(40.69847032728747, -73.9514422416687);

function success(position) {
  var s = document.querySelector('#status');

  if (s.className == 'success') {
    // not sure why we're hitting this twice in FF, I think it's to do with a cached result coming back
    return;
  }

  s.innerHTML = "found you!";
  s.className = 'success';

  var latlng = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
  map.setCenter(latlng);
  map.setZoom(15);
}

function error() {
  var s = document.querySelector('#status');

  if (s.className == 'fail') {
    return;
  }

  s.innerHTML = 'Please find yourself!';
  s.className = 'fail';

  map.setCenter(newyork);
}

$(document).ready(function(){
  var myOptions = {
    zoom: 6,
    mapTypeControl: false,
    navigationControlOptions: {style: google.maps.NavigationControlStyle.SMALL},
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  map = new google.maps.Map(document.getElementById("mapcanvas"), myOptions);

  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(success, error);
  } else {
    error();
  }
});
