/* ========================================================================================= */
/* ================================= Ici Gestion du tchat ================================== */
/* ========================================================================================= */
var interval = null;

function closeAllTchat() {
	if (interval != null) {clearInterval(interval);}
	
	for (i=1; i<=nbTchat; i++) {
		var d = document.getElementById("tchat" + i);
		d.setAttribute("style", "display:none");
	}
}

function t(value) {
	if (value == 0) {
		closeAllTchat();
		tchat = 0;
	} else {
		if (value != tchat) {
			closeAllTchat();
			tchat = parseInt(value);
			
			var d = document.getElementById("tchat" + value);
			d.setAttribute("style", null);

			if (UTILISATEUR_PSEUDO != "") {
				document.getElementById("table" + value).innerHTML = "<tr><td><center>Chargement du tchat, veuillez patienter s'il vous pla&icirc;t</center></td></tr>";
				interval = setInterval(function(){ajaxGet("/tchat", tchat);}, 2000);
			}
		}
	}
} 

function envoyer() {
	var txt = document.getElementById("saisi" + tchat).value;
	
	if (txt != "") {
		if (UTILISATEUR_PSEUDO != "") {
			ajaxPost("/tchat", tchat);
		}
	}
}

function ajaxGet(url, numTchat) {
	var xhr = null;
	
	if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
		xhr=new XMLHttpRequest();
  	}
	else {// code for IE6, IE5
		xhr=new ActiveXObject("Microsoft.XMLHTTP");
  	}
	
	xhr.onreadystatechange = function () {
		if (xhr.readyState==4 && xhr.status==200) {
			var table = document.getElementById("table" + numTchat);
			table.innerHTML = xhr.responseText;
		}
	}
	xhr.open('GET', url + "?tchat=" + numTchat, true);
	xhr.send(null);
}

function ajaxPost(url, numTchat) {
	var xhr = null;
	
	if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
		xhr=new XMLHttpRequest();
  	}
	else {// code for IE6, IE5
		xhr=new ActiveXObject("Microsoft.XMLHTTP");
  	}
	
	xhr.onreadystatechange = function () {
		if (xhr.readyState==4 && xhr.status==200) {
			var table = document.getElementById("table" + numTchat);
			table.innerHTML = xhr.responseText;
			document.getElementById("saisi" + numTchat).value = "";
		}
	}
	xhr.open('POST', url, true);
	xhr.setRequestHeader("Content-type","application/x-www-form-urlencoded");
	var d = document.getElementById("saisi" + numTchat);
	xhr.send("tchat=" + numTchat + "&pseudo=" + UTILISATEUR_PSEUDO + "&message=" + d.value);
}