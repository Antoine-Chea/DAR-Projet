<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.navitia.datastore.Message" %>

<%
	List<Message> messages = (List<Message>) request.getAttribute("messages");
	for (int i=(messages.size()-1); i>=0; i--) {
%>
<tr>
	<td id="pseudo">[<%= messages.get(i).getDate()  %>]<a><%= messages.get(i).getPseudo() %>:</a></td>
	<td><%= messages.get(i).getMessage() %></td>
</tr>
<%
	}
%>