<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.navitia.datastore.Utilisateur" %>

<%
	Utilisateur utilisateur = (Utilisateur) request.getAttribute("utilisateur");

%>
{ "utilisateur" : [ 
{ "prenom":"<%= utilisateur.getPrenom() %>", "nom":"<%= utilisateur.getNom() %>", "pseudo":"<%= utilisateur.getPseudo() %>", "id":"<%= utilisateur.getId() %>"}
]}