<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.navitia.datastore.Utilisateur" %>

<%
	String code = (String)request.getAttribute("code");

	if (code.equals("0")) {
		Utilisateur utilisateur = (Utilisateur) request.getAttribute("utilisateur");
%>
<%=	utilisateur.getPrenom() %> <%=	utilisateur.getNom() %><br/> vous êtes maintenant inscrit sur notre site
<%
	} else if (code.equals("1")) {
%>
Tous les champs sont obligatoires
<%
	} else if (code.equals("2")) {
%>
La confirmation du mot de passe est incorrect
<%
	} else if (code.equals("3")) {
%>
Email incorrect
<%
	} else if (code.equals("4")) {
%>
Cette email est déjà utilisé
<%
	} else if (code.equals("5")) {
%>
Ce pseudo est déjà utilisé
<%
	} else {
%>
Erreur
<%
	}
%>