/* ========================================================================================= */
/* ========================================= Main ========================================== */
/* ========================================================================================= */

var UTILISATEUR_PRENOM = "";
var UTILISATEUR_NOM = "";
var UTILISATEUR_PSEUDO = "";
var UTILISATEUR_KEY = "";

var metroTags = [];
var metroCoords = [];

var map;
var panel;
var direction;

var menu = 0;
var tchat = 0;
var nbTchat = 6;	// A incrémenter lors de la création de chaque Tchat
			
function init() {
	$("#centrageInscription").fadeOut(0, function(){});
	
	initMap();
	
	ajaxGetLine("/line");
	ajaxGetStopArea("/stopArea");
	
	var cookie = getCookie("MeetMeAtTheStation");
	if (cookie != null) {
		connexion(cookie);
	}
}

function setCookie(sName, sValue) {
    var today = new Date()//, expires = new Date();
    
    //expires.setTime(today.getTime() + (365*24*60*60*1000));
    document.cookie = sName + "=" + encodeURIComponent(sValue); // + ";expires=" + expires.toGMTString();
}

function getCookie(sName) {
    var oRegex = new RegExp("(?:; )?" + sName + "=([^;]*);?");
 
        if (oRegex.test(document.cookie)) {
                return decodeURIComponent(RegExp["$1"]);
    } else {
            return null;
    }
}



function ajaxGetLine(url) {
	//alert("ajaxGetLine");
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
				var container = document.getElementById("tchatContainer");
				container.innerHTML = "<div id='tchatTitle'  onclick='javascript:t(0)'><label>Tchat Room</label></div>";
				nbTchat = obj.lines.length;
				var codes = [];
				for (i=0; i<obj.lines.length; i++) {
					//alert(obj.lines[i].nom);
					codes.push(obj.lines[i].code);
					container.innerHTML += "<div id='aTchatRoom' onclick='javascript:t("+(i+1)+")'>" +
					"<label>Ligne "+obj.lines[i].code+"</label>" +
					"<div id='tchat"+(i+1)+"' class='tchat' style='display:none'>" +
					"<p></p>" +
					"<div id='discussion'>" +
					"<table id='table"+(i+1)+"'>" +
					"<tr>" +
					"<td><center>Vous devez &ecirc;tre connect&eacute; pour utiliser le tchat</center></td>" +
					"</tr>" +
					"</table>" +
					"</div>" +
					"<div id='saisi'>" +
					"<input type='text' size='80' id='saisi"+(i+1)+"' name='saisi' onKeyPress='if (event.keyCode == 13) envoyer()'>" +
					"<input type='submit' value='Envoyer' onclick='javascript:envoyer()'>" +
					"</div>" +
					"</div>" +
					"</div>";
				}
			}
		}
	}
	xhr.open('GET', url, true);
	xhr.send(null);
}

function ajaxGetStopArea(url) {
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
				
				for (i=0; i<obj.stopArea.length; i++) {
					var coord = obj.stopArea[i].coord.split("/");
					addMarker(coord[0], coord[1], obj.stopArea[i].nom, "1");
					metroTags.push(obj.stopArea[i].nom);
					metroCoords.push(coord[0]+"/"+coord[1]);
				}
			}
		}
	}
	xhr.open('GET', url, true);
	xhr.send(null);
}


$(function() {
	$( "#tags" ).autocomplete({source: metroTags});
});