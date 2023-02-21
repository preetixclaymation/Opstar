<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="constant.jsp"%>

<%@page import="javax.naming.directory.Attributes"%>
<%@page import="javax.naming.directory.SearchResult"%>
<%@page import="javax.naming.NamingEnumeration"%>
<%@page import="javax.naming.directory.SearchControls"%>
<%@page import="javax.naming.directory.InitialDirContext"%>
<%@page import="javax.naming.directory.DirContext"%>
<%@page import="javax.naming.Context"%>
<%@page import="java.util.Hashtable"%>

<%
session.removeAttribute("email");
session.removeAttribute("name");
session.removeAttribute("firstName");
session.removeAttribute("lastName");
boolean loginError = false;
if("Log In".equals(request.getParameter("action"))) {
  if(true) { //remove this
    String email = request.getParameter("email").trim().toLowerCase();
    session.setAttribute("email", email);
    session.setAttribute("isAdmin", true);
    response.sendRedirect("index.jsp");
    return;
  }
    UserInfo user = authenticateUserAndGetInfo(request.getParameter("email"), request.getParameter("password"));
	if(user != null) {
	  String email = user.email.trim().toLowerCase();
	  session.setAttribute("email", email);
	  session.setAttribute("isAdmin", ADMIN_EMAILS.contains(email));
	    
	  session.setAttribute("name", user.name);
	  session.setAttribute("firstName", user.firstName);
	  session.setAttribute("lastName", user.lastName);
	  response.sendRedirect("index.jsp");
	  return;
	}
	loginError = true;
}

%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="OpStar Login">
    <title>OpStar | Login Page</title>

    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/vendors.css" rel="stylesheet">
    <link href="css/style-login.css" rel="stylesheet">
</head>

<body>


<div id="preloader">
    <div data-loader="circle-side"></div>
</div>

<div>
    <div class="row no-gutters row-height">
        <div class="col-lg-6 background-image">
            <div class="content-left-wrapper opacity-mask" >
                <img src="static/img/logo.svg" width="100%" height="100%">
            </div>
        </div>
        <div class="col-lg-6 d-flex flex-column content-right">
            <div class="container my-auto py-5">
                <div class="row">
                    <div class="col-lg-9 col-xl-7 mx-auto">
                        <h4 class="mb-3">Login</h4>
                        <%
                            if(loginError) {
                        %>
                        <h7 class="mb-3">Incorrect email address/password</h7>
                        <%
                            }
                        %>
                        <form class="input_style_1" method="post">
                            <div class="form-group">
                                <label for="email_address">Your Email Address (ex:Your.Name@wolterskluwer.com)</label>
                                <input type="email" name="email" required="required" id="email_address" class="form-control">
                            </div>
                            <div class="form-group">
                                <label for="password">Your Password</label>
                                <input type="password" name="password" required="required" id="password" class="form-control">
                            </div>
                            <button type="submit" name="action" value="Log In" class="btn_1 full-width">Login</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- COMMON SCRIPTS -->
<script src="js/common_scripts.js"></script>
<script src="js/common_func.js"></script>
</body>
</html>

<%!
final static String CONTEXT_FACTORY = "com.sun.jndi.ldap.LdapCtxFactory";
final static String[] requiredAttributes = {"cn", "userPrincipalName", "givenName", "sn"};


private static UserInfo authenticateUserAndGetInfo(String user, String password) {
  UserInfo userRes = null;
  try {
    Hashtable<String, String> env = new Hashtable<String, String>();
    env.put(Context.INITIAL_CONTEXT_FACTORY, CONTEXT_FACTORY);
    env.put(Context.PROVIDER_URL, LDAP_URI);
    env.put(Context.SECURITY_AUTHENTICATION, "simple");
    env.put(Context.SECURITY_PRINCIPAL, user);
    env.put(Context.SECURITY_CREDENTIALS, password);
    DirContext ctx = new InitialDirContext(env);
    String filter = "(sAMAccountName=" + user + ")"; // default for search filter username
    if (user.contains("@")) // if user name is a email then
    {
      filter = "(userPrincipalName=" + user + ")";
    }
    SearchControls ctrl = new SearchControls();
    ctrl.setSearchScope(SearchControls.SUBTREE_SCOPE);
    ctrl.setReturningAttributes(requiredAttributes);

    String[] ADSearchPaths = LDAP_SEARCH_PATHS.split(";");
    NamingEnumeration userInfo = null;
    int i = 0;
    do {
      userInfo = ctx.search(ADSearchPaths[i].trim(), filter, ctrl);
      i++;
    } while (!userInfo.hasMore() && i < ADSearchPaths.length);

    if (userInfo.hasMore()) {
      SearchResult UserDetails = (SearchResult) userInfo.next();
      Attributes userAttr = UserDetails.getAttributes();
      
      userRes = new UserInfo();
      userRes.email = userAttr.get("userPrincipalName").get(0).toString();
      userRes.name = userAttr.get("cn").get(0).toString();
      userRes.firstName = userAttr.get("givenName").get(0).toString();
      userRes.lastName = userAttr.get("sn").get(0).toString();
    } else {
      System.out.println("User " + user + " not found");
    }
    userInfo.close();
  } catch (Exception e) {
    System.out.println("User " + user + " not found");
    e.printStackTrace();
  }
  return userRes;
}

private static class UserInfo {
  String email;
  String name;
  String firstName;
  String lastName;
}
%>