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
			
			if (resp.indexOf("site") > -1) {
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
					s += "<tr><td colspan='2' class='tdIns'><input type='submit' value='Je m inscris !' onclick='javascript:inscription()'/></td></tr>";
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