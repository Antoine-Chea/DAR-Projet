<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.navitia.datastore.StopArea" %>

<%
	List<StopArea> stopArea = (List<StopArea>) request.getAttribute("stopArea");
%>
{ "stopArea" : [ 
<% for (int i=0; i<stopArea.size(); i++) {  %>
      { "nom":"<%= stopArea.get(i).getName() %>", "coord":"<%= stopArea.get(i).getCoord() %>", "linesCode":"<%= stopArea.get(i).getLinesCode() %>", "nextDeparture":"<%= stopArea.get(i).getNextDeparture() %>"}
   <% if(i !=  stopArea.size() -1) {   %>
         ,
   <% } %>
<% } %>
]}