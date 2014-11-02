/* ========================================================================================= */
/* ================================= Ici Gestion du Menu =================================== */
/* ========================================================================================= */
function closeAllMenu() {
	var d = document.getElementById("infoTrain");
	d.setAttribute("style", "display:none");
	document.getElementById("tags").value = "";
	document.getElementById("tableResponceRecherche").innerHTML = "";

	var d = document.getElementById("infoStation");
	d.setAttribute("style", "display:none");
	station = "";
	document.getElementById("infoStation").innerHTML = "<p/><label>Cliquez sur une station de la carte</label>";

	var d = document.getElementById("itineraire");
	d.setAttribute("style", "display:none");
}

function f(value, id) {
	if (value == 0) {
		closeAllMenu();
		menu = 0;
	} else {
		if (value != menu) {
			closeAllMenu();
			menu = parseInt(value);
			
			var d = document.getElementById(id);
			d.setAttribute("style", null);
		}
	}
	
}

function recherche() {
	var r = document.getElementById("tags").value;
	var trouver = false;
	
	for (var i=0; i<metroTags.length; i++) {
		if(metroTags[i] == r) {
			trouver = true;
			break;
		}
	}
	
	if (trouver) {
		var coords = metroCoords[i];
		var coord = metroCoords[i].split("/");
		addMarker(coord[0], coord[1], r, "2");
	} else {
		document.getElementById("tableResponceRecherche").innerHTML = "<label class='recherche'>Nom de station introuvable</label>";
	}
}
