/* ========================================================================================= */
/* =============================== Ici Gestion de la carte ================================= */
/* ========================================================================================= */
function initMap(){
	var latLng = new google.maps.LatLng(48.85341007, 2.3488000);
	var myOptions = {
	  zoom      : 12,
	  center    : latLng,
	  mapTypeId : google.maps.MapTypeId.ROADMAP, // HYBRID, ROADMAP, SATELLITE, TERRAIN
	  maxZoom   : 20
	};
	
	map = new google.maps.Map(document.getElementById('map'), myOptions);
	
	var styleArray =	[{
							featureType: "transit",
							elementType: "labels",
							stylers: [{ visibility: "off" }]
	                	}];

    map.setOptions({styles: styleArray});
	
	var transitLayer = new google.maps.TransitLayer();
	transitLayer.setMap(map);
	
	direction = new google.maps.DirectionsRenderer({
	    map   : map, 
	    panel : panel 
	});
}

function addMarker(latitude, longitude, content, type) {
	var latLng = new google.maps.LatLng(latitude, longitude);

	var marker = new google.maps.Marker({
	    position : latLng,
	    map      : map,
	    title    : "Paris",
	    icon     : "../img/Metro.png"
	});
	
	var contentMarker = content;
	  
	var infoWindow = new google.maps.InfoWindow({	
	    content  : contentMarker,
	    position : latLng
	});

	google.maps.event.addListener(marker, 'click', function() {
		if (menu == 1) { // info trains
			
		} else if (menu == 2) { // info station
			station = content;
			ajaxGetInfoStation("/stopArea", latitude + "/" + longitude);
		} else if (menu == 3) { // itinéraire
			if (document.getElementById('lblArrivee').innerHTML != content) {
				document.getElementById('lblDepart').innerHTML = "";
				txt = document.createTextNode(content); 
				lbl = document.getElementById('lblDepart');
				lbl.appendChild(txt);
			}
		}
	});
	google.maps.event.addListener(marker, 'rightclick', function() {
		if (menu == 1) { // info trains
			
		} else if (menu == 2) { // info station
			station = content;
		} else if (menu == 3) { // itinéraire
			if (document.getElementById('lblDepart').innerHTML != content) {
				document.getElementById('lblArrivee').innerHTML = "";
				txt = document.createTextNode(content); 
				lbl = document.getElementById('lblArrivee');
				lbl.appendChild(txt);
			}
		}
	});
	
	if (type == "1") {
		google.maps.event.addListener(marker, 'mouseover', function() {infoWindow.open(map,marker);});
		google.maps.event.addListener(marker, 'mouseout', function() {infoWindow.close(map,marker);});
	} else {
		infoWindow.open(map,marker);
		map.panTo(marker.position);
		map.setZoom(15);
		setTimeout(function() {marker.setMap(null);}, 5000);
		google.maps.event.addListener(marker, 'mouseout', function() {marker.setMap(null);});
	}
}

function calculate(){
	if (document.getElementById('lblDepart').innerHTML != "<i>clique gauche sur une station</i>" 
			&& document.getElementById('lblArrivee').innerHTML != "<i>clique droit sur une station</i>") {
		origin      = "Metro " + document.getElementById('lblDepart').innerHTML; // Le point départ
	    destination = "Metro " + document.getElementById('lblArrivee').innerHTML // Le point d'arrivé
	    if(origin && destination){
	        var request = {
	            origin      : origin,
	            destination : destination,
	            travelMode  : google.maps.DirectionsTravelMode.TRANSIT
	        }
	        var directionsService = new google.maps.DirectionsService();
	        directionsService.route(request, function(response, status){
	            if(status == google.maps.DirectionsStatus.OK){
	                direction.setDirections(response);
	            }
	        });
	    } else {
		    //alert("calculate[origin]: " + origin);
		    //alert("calculate[destination]: " + destination);
	    }
	} else {
	    //alert("Vous devez selectionner un point de départ et un point d'arrivé.");
	}
}

function reinit() {
 	direction.setMap(null);
 	direction = new google.maps.DirectionsRenderer({
 	    map   : map, 
 	    panel : panel 
 	});
 	map.setZoom(12);
	 
}

function ajaxGetInfoStation(url, coord) {
	var xhr = null;
	
	if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
		xhr=new XMLHttpRequest();
  	}
	else {// code for IE6, IE5
		xhr=new ActiveXObject("Microsoft.XMLHTTP");
  	}
	
	xhr.onreadystatechange = function () {
		if (xhr.readyState==4 && xhr.status==200) {
			var resp = xhr.responseText;
			
			if (resp == "") {
				//alert("Reponse vide");
			} else {
				//alert(xhr.responseText);

				var obj = JSON.parse(xhr.responseText);
				var s = obj.stopArea[0].nextDeparture;
				var ss = s.substring(1, s.length-2);
				var sss = ss.split(", ");
				sss.sort(); 
				var txt = "<p/><table><tr><td colspan='2'>Station: "+station+"</td></tr><tr><td>Direction</td><td>Heure</td><tr></tr>"; 
				station = "";
				for (var i=0; i<sss.length; i++) {
					var nD = sss[i].split("/");
					var d = nD[2];
					var t = "";
					if (d[14] == null) {t = d[9] + d[10] + ":" + d[11] + d[12] + ":" + d[13] + "0"}
					else {t = d[9] + d[10] + ":" + d[11] + d[12] + ":" + d[13] + d[14]}
					txt += "<tr id='trInfoStation'><td><a>[M"+nD[0]+"]</a>"+nD[1]+"</td><td>"+t+"</td></tr>";
				}
				var t = "";
				if (d[14] == null) {t = d[9] + d[10] + ":" + d[11] + d[12] + ":" + d[13] + "0"}
				else {t = d[9] + d[10] + ":" + d[11] + d[12] + ":" + d[13] + d[14]}
				txt += "</table>"; 
				document.getElementById("infoStation").innerHTML = txt;
			}
		}
	}
	xhr.open('GET', url + "?coord=" + coord, true);
	xhr.send(null);
}