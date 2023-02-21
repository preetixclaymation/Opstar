<%@page import="java.sql.DatabaseMetaData"%>
<%@page import="java.sql.ResultSetMetaData"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="constant.jsp"%>

<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.StringJoiner"%>
<%@page import="java.util.Arrays"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>

<%
String email = (String) session.getAttribute("email");
if (email == null) {
  response.sendError(401, "not authorized");
  return;
}
  
String query = request.getParameter("query");
%>

<!DOCTYPE html>
<html lang="en" style="scroll-behavior: smooth;">

<head>
    <meta charset="UTF-8">
    <title>DB Query</title>
    <style>
        table, td, th {
		  border:1px solid;
		  border-collapse: collapse;
		  padding: 2px;
		}
    </style>
</head>

<body>
    <form action="" method="post">
        <textarea rows="10" cols="140" name="query"><%=query == null? "" : query %></textarea>
        <input style="margin-left: 10px;" type="reset" />
        <input style="margin-left: 10px;" type="submit" />
        
        <ul style="margin-left: 10px; display: inline-block; width: 200px; vertical-align: top; padding: 2px; border: 1px dotted;">
            <li style="font-size: 20px; font-weight: bold; text-decoration: underline; list-style: none; text-align: center; margin-bottom: 10px;">Tables</li>
<%
    try (Connection con = DriverManager.getConnection(DB_URL)) {
        DatabaseMetaData dbmd =  con.getMetaData();
        ResultSet rs = dbmd.getTables(null, null, null, new String[]{"TABLE"});
        while (rs.next()) {
%>        
            <li style="list-style: none;"><%=rs.getString("TABLE_NAME") %></li>
<%
        }
    }
%>            
        </ul>
    </form>
<%
if(query == null || query.trim().isEmpty()) {
  return;
}
try (Connection con = DriverManager.getConnection(DB_URL);
    Statement stmt = con.createStatement()) {

  boolean res = stmt.execute(query);
  if(!res) {
%>
    <p><%=stmt.getUpdateCount() %> rows updated.</p>
<%    
  } else {
  ResultSet rs = stmt.getResultSet();
  ResultSetMetaData rsmd = rs.getMetaData();
%>
    <table border="1">
        
 <%
           int colCount = rsmd.getColumnCount();
           String[] columns = new String[colCount];
           for (int i = 0; i < colCount; i++) {
             columns[i] = rsmd.getColumnName(i+1);
           }
%>
        <tr>
<%           
           for(String column : columns) {
%>
                <th><%=column %></th>
<%            
           }
%>
        </tr>
<%
           while(rs.next()) {
%>       
        <tr>
<%
              for(String column : columns) {
%>
                   <td><%=rs.getString(column) %></td>
<%            
              }   
%>
        </tr>
<%
           }
%>        
    </table>  
<%   
  }
}
%>   
   
    
</body>
</html>
<%!
private final static String DB_URL = "jdbc:h2:file:" + DB_FILE;
%>