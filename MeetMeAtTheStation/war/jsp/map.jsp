<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="com.navitia.datastore.Utilisateur" %>
<%@ page import="com.navitia.datastore.Message" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//FR">
<html>
	<head>
		<title>MeetMeAtTheSation</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	
		<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
		
		<!-- Inclusion de l'API Google MAPS -->
		<script src="https://maps.googleapis.com/maps/api/js?v=3.exp"></script>
		
		
		<!-- Inclusion de jquery -->
		<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script> 
		<script src="http://code.jquery.com/ui/1.11.2/jquery-ui.js"></script>
		
		<!-- CSS -->
		<link rel="stylesheet" type="text/css" href="css/map.css">
		<link rel="stylesheet" type="text/css" href="css/partie1.css">
		<link rel="stylesheet" type="text/css" href="css/partie2.css">
	</head>

	<body onload="init()">
		<noscript>
			
		</noscript>
		<script type="text/javascript">
			var UTILISATEUR_PRENOM = "";
			var UTILISATEUR_NOM = "";
			var UTILISATEUR_PSEUDO = "";
			var UTILISATEUR_KEY = "";
			
			var metroTags = ["Pierre et Marie Curie", "Jussieu", "Place D'italie"];
		</script>
		<!-- ============================================================================= -->
		<!-- ================================== Partie 1 ================================= -->
		<!-- ============================================================================= -->
		<div id="partie1">
			<div id="bandeau">
				<center>
					<label>Meet me at the station Version 1</label>
					<div id="connexion">
						<input type="text" class="espacement" id="email" placeholder="Entrez votre Email" size="40" onKeyPress="if (event.keyCode == 13) connexion(null)">
						<input type="password" class="espacement" id="motdepasse" placeholder="Entrez votre mot de passe" size="25" onKeyPress="if (event.keyCode == 13) connexion(null)">
						<input type="submit" value="Connexion" size="20" classe="inscription" onclick="javascript:connexion(null)"><br/>
						<a class="" href="javascript:creationCompte()">Je veux cr&eacute;er un compte tout de suite!</a>
					</div>
				</center>
			</div>
			<center>
				<div id="centrage" class="centrage">
					<div id="menu">
						<div id="menuTitle" onclick="javascript:f(0, null)">
								<label>Menu</label>
						</div>
						<div id="menuItem" onclick="javascript:f(1, 'infoTrain')">
							<label>Recherche</label>
							<div id="infoTrain" style="display:none">
								<p/>
								<table id="tableRecherche">
									<tr>
										<td class="recherche"><label>Rechercher une station</label></td>
									</tr>
									<tr>
										<td class="tdRech">
											<div class="ui-widget">
												<input type="text" id="tags" onKeyPress="if (event.keyCode == 13) recherche()">
											</div>
										</td>
									</tr>
									<tr>
										<td class="tdRech">
											<input type="submit" value="rechercher" onclick="javascript:recherche()">
										</td>
									</tr>
									<tr>
										<td class="tdRech"><p/></td>
									</tr>
									<tr>
										<td id="tableResponceRecherche"></td>
									</tr>
								</table>
							</div>
						</div>
						<div id="menuItem" onclick="javascript:f(2, 'infoStation')">
							<label>Info Station</label>
							<div id="infoStation" style="display:none">
								<p/>
								<label>Ici Information sur les stations</label>
							</div>
						</div>
						<div id="menuItem" onclick="javascript:f(3, 'itineraire')">
							<label>Itinéraire</label>
							<div id="itineraire" style="display:none">
								<p/>
								<table>
									<tr>
										<td class="itineraire"><label>D&eacute;part:</label></td>
										<td><label id="lblDepart"><i>clique gauche sur une station</i></label></td>
									</tr>
									<tr>
										<td class="itineraire"><label>Arriv&eacute;e:</label></td>
										<td><label id="lblArrivee"><i>clique droit sur une station</i></label></td>
									</tr>
									<tr>
										<td colspan="2"><input type="submit" value="rechercher" onclick="javascript:calculate()"></td>
									</tr>
								</table>
							</div>
						</div>
					</div>
					<div id="panel"></div>
					<div id="map"></div>
				</div>
				<div id="centrageInscription" class="centrageInscription">
					<div id="Inscription">
						<table class="tableInscription" id="tableInscription">
							<tr>
								<td colspan="2" class="tdIns"><h1>Inscription</h1></td>
							</tr>
							<tr>
								<td colspan="2" class="tdIns"><label id="InscriptionErreur"></label></td>
							</tr>
							<tr>
								<td class="tdInscription"><label>Nom</label></td>
								<td class="tdIns"><input type="text" name="nom" id="nom" onKeyPress="if (event.keyCode == 13) inscription()"/></td>
							</tr>
							<tr>
								<td class="tdInscription"><label>Prenom</label></td>
								<td class="tdIns"><input type="text" name="prenom" id="prenom" onKeyPress="if (event.keyCode == 13) inscription()"/></td>
							</tr>
							<tr>
								<td class="tdInscription"><label>Pseudo pour le tchat</label></td>
								<td class="tdIns"><input type="text" name="pseudo" id="pseudoI" onKeyPress="if (event.keyCode == 13) inscription()"/></td>
							</tr>
							<tr>
								<td class="tdInscription"><label>Email</label></td>
								<td class="tdIns"><input type="text" name="email" id="emailI" onKeyPress="if (event.keyCode == 13) inscription()"/></td>
							</tr>
							<tr>
								<td class="tdInscription"><label>Mot de passe</label></td>
								<td class="tdIns"><input type="password" name="motDePasse" id="motDePasseI" onKeyPress="if (event.keyCode == 13) inscription()"/></td>
							</tr>
							<tr>
								<td class="tdInscription"><label>Confirmer le mot de passe</label></td>
								<td class="tdIns"><input type="password" name="motDePasseConfirme" id="motDePasseConfirme" onKeyPress="if (event.keyCode == 13) inscription()"/></td>
							</tr>
							<tr>
								<td class="tdIns"><p></p></td>
							</tr>
							<tr>
								<td colspan="2" class="tdIns"><input type="submit" value="Je m'inscrire!" onclick="javascript:inscription()"/></td>
							</tr>
							<tr>
								<td colspan="2" class="tdIns"><a href="javascript:annulerCompte()">Annuler</a></td>
							</tr>
						</table>
					</div>
				</div>
			</center>
		</div>
		
		<!-- ============================================================================= -->
		<!-- ================================== Partie 2 ================================= -->
		<!-- ============================================================================= -->
		<script type="text/javascript">
			// Paris: 48.85341007, 2.3488000
			// Londre: 51.505, -0.09
		
			var map;
			var panel;
			var direction;
			
			var menu = 0;
			
			var tchat = 0;
			var nbTchat = 6;	// A incrémenter lors de la création de chaque Tchat
		</script>
		
		<div id="partie2">
			<center>
				<div id="tchatContainer"></div>
			</center>
		</div>
	
		<script>
			$(function() {
				$( "#tags" ).autocomplete({source: metroTags});
			});
		</script>
		<script type="text/javascript">
			/* ========================================================================================= */
			/* ========================================= Main ========================================== */
			/* ========================================================================================= */
			function init() {
				$("#centrageInscription").fadeOut(0, function(){});
				
				initMap();
				
				ajaxGetLine("/line");
				ajaxGetStopArea("/stopArea");
				addMarker(48.81585, 2.37738, "Pierre et Marie Curie");
				addMarker(48.846071, 2.354794, "Jussieu");
				addMarker(48.831467, 2.355725, "Place D'italie");
				
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
			
			/* ========================================================================================= */
			/* ================== Ici Gestion de la connexion et l'inscription ========================= */
			/* ========================================================================================= */
			function connexion(id) {
				var email = document.getElementById("email").value;
				var motdepasse = document.getElementById("motdepasse").value;
				
				if ((email && motdepasse) || id) {
					//alert("Connexion\nEmail:" + email + "\nMot De Passe: " + motdepasse);
					ajaxGetConnexion("/inscription", email, motdepasse, id);
				} else {
					//alert("Email ou MotDePasse Vide!!");
				}
			}
			
			function deconnexion() {
				setCookie("MeetMeAtTheStation", "null");
				document.location.reload(true);
			}
			
			function inscription() {
				var nom = document.getElementById("nom").value;
				var prenom = document.getElementById("prenom").value;
				var pseudo = document.getElementById("pseudoI").value;
				var email = document.getElementById("emailI").value;
				var motDePasse = document.getElementById("motDePasseI").value;
				var motDePasseConfirme = document.getElementById("motDePasseConfirme").value;

				if (nom && prenom && pseudo && email && motDePasse && motDePasseConfirme) {
					if (motDePasse == motDePasseConfirme) {
						if (validateEmail(email)) {
							if (validateMotDePasse(motDePasse)) {
								//alert("inscription!!");
								ajaxPostInscription("/inscription", nom, prenom, pseudo,  email, motDePasse, motDePasseConfirme);
							} else {
								document.getElementById("InscriptionErreur").innerHTML = "Votre mot de passe doit au moins contenir cinq caract&egrave;res";
							}
						} else {
							document.getElementById("InscriptionErreur").innerHTML = "Email incorrect";
						}
					} else {
						//alert("inscription  raté");
						document.getElementById("InscriptionErreur").innerHTML = "La confirmation du mot de passe est incorrect";
					}
				} else {
					//alert("inscription  raté");
					document.getElementById("InscriptionErreur").innerHTML = "Tous les champs sont obligatoires";
				}
			}
			
			function validateEmail(email) { 
			    var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
			    return re.test(email);
			} 
			
			function validateMotDePasse(motDePasse) {
				if (motDePasse.length >= 5) {
					return true;
				}
				return false;
			}
			
			function creationCompte() {
				document.getElementById("email").value = "";
				document.getElementById("motdepasse").value = "";
				
				$(".centrage").fadeOut("fast",function(){});
				setTimeout(function() {$("#centrageInscription").fadeIn("fast",function(){});}, 1000);
				
			}
			function annulerCompte() {
				document.getElementById("nom").value = "";
				document.getElementById("prenom").value = "";
				document.getElementById("pseudoI").value = "";
				document.getElementById("emailI").value = "";
				document.getElementById("motDePasseI").value = "";
				document.getElementById("motDePasseConfirme").value = "";
				
				$(".centrageInscription").fadeOut("fast", function(){});
				setTimeout(function() {$("#centrage").fadeIn("fast",function(){});}, 1000);
			}
			
			function ajaxGetConnexion(url, email, motdepasse, id) {
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
							 document.getElementById("email").value = "";
							 document.getElementById("motdepasse").value = "";
						} else {
							//alert(xhr.responseText);
							var d = document.getElementById("connexion");
							annulerCompte();
							
							var obj = JSON.parse(xhr.responseText);
							UTILISATEUR_PRENOM = obj.utilisateur[0].prenom;
							UTILISATEUR_NOM = obj.utilisateur[0].nom;
							UTILISATEUR_PSEUDO = obj.utilisateur[0].pseudo;
							d.innerHTML = "<div id='bienvenue'><label>Bienvenue " + UTILISATEUR_PRENOM + " " + UTILISATEUR_NOM + 
							"</label></br><label id='bienvenuePseudo'>Ton pseudo pour les tchats:  <a href='#'>" + UTILISATEUR_PSEUDO + 
							"</a></label></br><a href='javascript:deconnexion()'>d&eacute;connexion</label></div>";
							
							setCookie("MeetMeAtTheStation", obj.utilisateur[0].id);
						}
					}
				}
				xhr.open('GET', url + "?email=" + email + "&motdepasse=" + motdepasse + "&id=" + id, true);
				xhr.send(null);
			}
			
			function ajaxPostInscription(url, nom, prenom, pseudo, email, motDePasse, motDePasseConfirme) {
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
						document.getElementById("InscriptionErreur").innerHTML = resp;
						
						if (resp.indexOf("vous êtes maintenant inscrit sur notre site") > -1) {
							document.getElementById("tableInscription").innerHTML = "<tr><td colspan='2' class='tdIns'><h1>Inscription</h1></td></tr><tr><td colspan='2' class='tdIns'><label>"+resp+"</label></td></tr>";
							setTimeout(function() {
								
								var s = "";
								s += "<tr><td colspan='2' class='tdIns'><h1>Inscription</h1></td></tr>";
								s += "<tr><td colspan='2' class='tdIns'><label id='InscriptionErreur'></label></td></tr>";
								s += "<tr><td class='tdInscription'><label>Nom</label></td><td class='tdIns'><input type='text' name='nom' id='nom' onKeyPress='if (event.keyCode == 13) inscription()'/></td></tr>";
								s += "<tr><td class='tdInscription'><label>Prenom</label></td><td class='tdIns'><input type='text' name='prenom' id='prenom' onKeyPress='if (event.keyCode == 13) inscription()'/></td></tr>";
								s += "<tr><td class='tdInscription'><label>Pseudo</label></td><td class='tdIns'><input type='text' name='pseudo' id='pseudoI' onKeyPress='if (event.keyCode == 13) inscription()'/></td></tr>";
								s += "<tr><td class='tdInscription'><label>Email</label></td><td class='tdIns'><input type='text' name='email' id='emailI' onKeyPress='if (event.keyCode == 13) inscription()'/></td></tr>";
								s += "<tr><td class='tdInscription'><label>Mot de passe</label></td><td class='tdIns'><input type='password' name='motDePasse' id='motDePasseI' onKeyPress='if (event.keyCode == 13) inscription()'/></td></tr>";
								s += "<tr><td class='tdInscription'><label>Confirmer le mot de passe</label></td><td class='tdIns'><input type='password' name='motDePasseConfirme' id='motDePasseConfirme' onKeyPress='if (event.keyCode == 13) inscription()'/></td></tr>";
								s += "<tr><td class='tdIns'><p></p></td></tr>";
								s += "<tr><td colspan='2' class='tdIns'><input type='submit' value='Je m inscrire!' onclick='javascript:inscription()'/></td></tr>";
								s += "<tr><td colspan='2' class='tdIns'><a href='javascript:annulerCompte()'>Annuler</a></td></tr>";
								document.getElementById("tableInscription").innerHTML = s;	
								
								$(".centrageInscription").fadeOut("fast", function(){});
								setTimeout(function() {$("#centrage").fadeIn("fast",function(){});}, 1000);				
							}, 2000);
						}
					}
				}
				xhr.open('POST', url, true);
				xhr.setRequestHeader("Content-type","application/x-www-form-urlencoded");
				xhr.send("nom=" + nom + "&prenom=" + prenom + "&pseudo=" + pseudo  + "&email=" + email + "&motDePasse=" + motDePasse + "&motDePasseConfirme=" + motDePasseConfirme);
			}
			
			function ajaxGetLine(url) {
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
							for (i=0; i<obj.lines.length; i++) {
								//alert(obj.lines[i].nom);
								container.innerHTML += "<div id='aTchatRoom' onclick='javascript:t("+(i+1)+")'>" +
								"<label>Tchat concernant la ligne "+obj.lines[i].code+" du metro</label>" +
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
								"<input type='text' size='100' id='saisi"+(i+1)+"' name='saisi' onKeyPress='if (event.keyCode == 13) envoyer()'>" +
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
								addMarker(coord[0], coord[1], obj.stopArea[i].nom);
							}
						}
					}
				}
				xhr.open('GET', url, true);
				xhr.send(null);
			}
			
			
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
			
			function addMarker(latitude, longitude, content) {
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
						
					} else if (menu == 3) { // itinéraire
						if (document.getElementById('lblDepart').innerHTML != content) {
							document.getElementById('lblArrivee').innerHTML = "";
							txt = document.createTextNode(content); 
							lbl = document.getElementById('lblArrivee');
							lbl.appendChild(txt);
						}
					}
				});
				google.maps.event.addListener(marker, 'mouseover', function() {infoWindow.open(map,marker);});
				google.maps.event.addListener(marker, 'mouseout', function() {infoWindow.close(map,marker);});
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
					    alert("calculate[origin]: " + origin);
					    alert("calculate[destination]: " + destination);
				    }
				} else {
				    alert("Vous devez selectionner un point de départ et un point d'arrivé.");
				}
			}
			
			
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
				document.getElementById("tableResponceRecherche").innerHTML = "<label class='recherche'>Nom de station introuvable</label>";
			}
			
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
			
		</script>
	</body>
</html>