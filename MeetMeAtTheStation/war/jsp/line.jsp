<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.navitia.datastore.Line" %>

<%
	List<Line> lines = (List<Line>) request.getAttribute("lines");
%>
{ "lines" : [ 
<% for (int i=0; i<lines.size(); i++) {  %>
       {"code":"<%= lines.get(i).getCode() %>", "nom":"<%= lines.get(i).getName() %>"}
       <% if(i != lines.size() -1) { %>
            ,
       <% }   %>
<% }   %>
]}