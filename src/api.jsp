<%@page import="java.util.Iterator"%>
<%@page import="com.google.gson.GsonBuilder"%>
<%@page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.StringJoiner"%>
<%@page import="java.util.Arrays"%>
<%@include file="constant.jsp"%>

<%@page import="com.google.gson.Gson"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.io.*"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>

<%
Response<?> res = null;
String email = (String) session.getAttribute("email");
if (email == null) {
  res = new Response<>();
  res.status = 401;
  res.message = "User logged out";
} else {
    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
	String movieId = request.getParameter("movieId");
	String action = request.getParameter("action");
	if ("like".equals(action)) {
	
	  boolean vote = Boolean.parseBoolean(request.getParameter("vote"));
	  res = like(email, vote, movieId);
	} else if ("dislike".equals(action)) {
	  
	  boolean vote = Boolean.parseBoolean(request.getParameter("vote"));
	  res = dislike(email, vote, movieId);
	} else if ("addcomment".equals(action)) {
	  
	  String comment = request.getParameter("comment");
	  res = addComment(email, comment, movieId);
	} else if ("deletecomment".equals(action)) {
	  
	  long id = Long.parseLong(request.getParameter("id"));
	  res = deleteComment(email, id);
	} else if ("getcounts".equals(action)) {
	  
	  String[] movieIds = request.getParameterValues("movieIds");
	  res = getCounts(email, movieIds);
	} else if ("getcomments".equals(action)) {
      
      res = getComments(email, movieId);
    } else if ("getconfig".equals(action)) {
      
      res = getConfig(email, application);
    } else if ("addconfig".equals(action)) {
      
      String type = request.getParameter("type");
      String text = request.getParameter("text");
      Part cover = request.getPart("cover");
      Part content = request.getPart("content");
      Part logo = request.getPart("logo");
      Part real = request.getPart("real");
      res = addConfig(isAdmin, email, application, type, text, cover, content, logo, real);
    } else if ("deleteconfig".equals(action)) {
      
      res = deleteConfig(isAdmin, email, application, movieId);
    } 
}

if(res != null) {
  if (res.status == 200) {
    out.print(gson.toJson(res));
  } else {
    response.sendError(res.status, gson.toJson(res));
  }
} else {
  response.sendError(500, "Please revisit action param, seems not matching to any pre-defined values");
}

%>


<%!
private final static String DB_URL = "jdbc:h2:file:" + DB_FILE;
private final static Gson gson = new Gson();

static {
  validateDBTables();
}

private Response<Map<String, CountData>> getCounts(String email, String[] movieIds) {
  Response<Map<String, CountData>> res = new Response<>();
  try {
    Map<String, CountData> movieIdVsCount = likeDislikeCount(email, movieIds);
    Map<String, CountData> movieIdVsCount1 = commentCount(email, movieIds);
    
    movieIdVsCount.forEach((k, v) -> {
      CountData cd = movieIdVsCount1.remove(k);
      if(cd != null) {
        v.comment = cd.comment;
        v.commented = cd.commented;
      }
    });
    movieIdVsCount.putAll(movieIdVsCount1);
    
    res.status = 200;
    res.message = "Success";
    res.data = movieIdVsCount;
  } catch (Exception e) {
    e.printStackTrace();
    res.status = 500;
    res.message = e.toString();
  }
  return res;
}

private Map<String, CountData> likeDislikeCount(String email, String[] movieIds) throws Exception {
  Map<String, CountData> movieIdVsCount = new HashMap<>();
  
  StringBuilder sb = new StringBuilder();
  Arrays.stream(movieIds).forEach(m -> sb.append("?,"));
  sb.setLength(sb.length() -1);
  
  String query = "select username, movieid, upvote from user_vote where movieid in (" + sb + ")";
  try (Connection con = DriverManager.getConnection(DB_URL);
      PreparedStatement stmt = con.prepareStatement(query)) {
    for(int i = 0; i< movieIds.length; i++) {
      stmt.setString(i+1, movieIds[i]);
    }

    ResultSet rs = stmt.executeQuery();
    while (rs.next()) {
      String movieId = rs.getString("movieid");
      CountData cd = movieIdVsCount.get(movieId);
      if(cd == null) {
        cd = new CountData();
        movieIdVsCount.put(movieId, cd);
      }
      if(rs.getBoolean("upvote")) {
        cd.like++;
      } else {
        cd.dislike++;
      }
      if(email.equals(rs.getString("username"))) {
        if(rs.getBoolean("upvote")) {
          cd.liked = true;
        } else {
          cd.disliked = true;
        }
        cd.liked = rs.getBoolean("upvote");
      }
    }
  }
  return movieIdVsCount;
}

private Map<String, CountData> commentCount(String email, String[] movieIds) throws Exception {
  Map<String, CountData> movieIdVsCount = new HashMap<>();
  
  StringBuilder sb = new StringBuilder();
  Arrays.stream(movieIds).forEach(m -> sb.append("?,"));
  sb.setLength(sb.length() -1);
  
  String query = "select username, movieid from user_comment where movieid in (" + sb + ")";
  try (Connection con = DriverManager.getConnection(DB_URL);
      PreparedStatement stmt = con.prepareStatement(query)) {
    for(int i = 0; i< movieIds.length; i++) {
      stmt.setString(i+1, movieIds[i]);
    }

    ResultSet rs = stmt.executeQuery();
    while (rs.next()) {
      String movieId = rs.getString("movieid");
      CountData cd = movieIdVsCount.get(movieId);
      if(cd == null) {
        cd = new CountData();
        movieIdVsCount.put(movieId, cd);
      }
      cd.comment++;
      if(email.equals(rs.getString("username"))) {
        cd.commented = true;
      }
    }
  }
  return movieIdVsCount;
}


private Response<Integer> like(String email, boolean vote, String movieId) {
  Response<Integer> res = new Response<>();

  String query = "select * from user_vote where username = ? and movieid = ?";
  try (Connection con = DriverManager.getConnection(DB_URL);
      PreparedStatement stmt = con.prepareStatement(query)) {
    stmt.setString(1, email);
    stmt.setString(2, movieId);

    ResultSet rs = stmt.executeQuery();

    int action = 0;
    if (rs.next()) {
      boolean upvote = rs.getBoolean("upvote");
      if(upvote && !vote) { //one liked earlier but wants to undo-like
        deleteVote(con, rs.getLong("id")); //delete this record
        action = -1;
      } else if(upvote && vote) { //one liked earlier but wants to like again
        //do nothing, enter already there
      } else if(!upvote && !vote) { //one disliked earlier but wants to undo-like
        //ignore, not a valid case
      } else if(!upvote && vote) { //one disliked earlier but wants to like
        action = 2;
        updateVote(con, rs.getLong("id"), true);//update record upvote = true
      }
    } else {
      if(!vote) { //one not liked/disliked ever but wants to undo-like
      	//ignore, not a valid case
      } else { // one liked
        action = 1;
        addVote(con, email, true, movieId); //insert this record upvote = true;
      }
    }
    con.commit();
    res.data = action;
    res.status = 200;
    res.message = "Success";
  } catch (Exception e) {
    e.printStackTrace();
    res.status = 500;
    res.message = e.toString();
  }
  return res;
}

private Response<Integer> dislike(String email, boolean vote, String movieId) {
  Response<Integer> res = new Response<>();

  String query = "select * from user_vote where username = ? and movieid = ?";
  try (Connection con = DriverManager.getConnection(DB_URL);
      PreparedStatement stmt = con.prepareStatement(query)) {
    stmt.setString(1, email);
    stmt.setString(2, movieId);

    ResultSet rs = stmt.executeQuery();
    int action = 0;
    if (rs.next()) {
      boolean upvote = rs.getBoolean("upvote");
      if(!upvote && !vote) { //one disliked earlier but wants to undo-dislike
        deleteVote(con, rs.getLong("id"));//delete this record
        action = -1;
      } else if(!upvote && vote) { //one disliked earlier but wants to dislike again
        //do nothing, enter already there
      } else if(upvote && !vote) { //one liked earlier but wants to undo-dislike
        //ignore, not a valid case
      } else if(upvote && vote) { //one liked earlier but wants to dislike
        updateVote(con, rs.getLong("id"), false); //update record upvote = false
        action = 2;
      }
    } else {
      if(!vote) { //one not disliked/liked ever but wants to undo-dislike
      	//ignore, not a valid case
      } else { // one disliked
        addVote(con, email, false, movieId);//insert this record upvote = false;
        action = 1;
      }
    }
    res.data = action;
    res.status = 200;
    res.message = "Success";
  } catch (Exception e) {
    e.printStackTrace();
    res.status = 500;
    res.message = e.toString();
  }
  return res;
}

private Response<?> addComment(String email, String comment, String movieId) {
  Response<?> res = new Response<>();
  String query = "insert into user_comment(username, movieid, comment, created, updated) values (?, ?, ?, ?, ?)";
  try (Connection con = DriverManager.getConnection(DB_URL);
      PreparedStatement stmt = con.prepareStatement(query)) {
    
    Timestamp curTime = new Timestamp(System.currentTimeMillis());
    
    stmt.setString(1, email);
    stmt.setString(2, movieId);
    stmt.setString(3, comment);
    stmt.setTimestamp(4, curTime);
    stmt.setTimestamp(5, curTime);
    
    stmt.executeUpdate();

    res.status = 200;
    res.message = "Success";
  } catch (Exception e) {
    e.printStackTrace();
    res.status = 500;
    res.message = e.toString();
  }
  return res;
}

private Response<List<CommentData>> getComments(String email, String movieId) throws Exception {
  Response<List<CommentData>> res = new Response<>();
  
  String query = "select id, username, movieid, comment, created from user_comment where movieid = ? order by created desc";
  try (Connection con = DriverManager.getConnection(DB_URL);
      PreparedStatement stmt = con.prepareStatement(query)) {
      stmt.setString(1, movieId);

      List<CommentData> comments = new ArrayList<>();
      ResultSet rs = stmt.executeQuery();
      while (rs.next()) {
        CommentData cd = new CommentData();
        cd.id = rs.getInt("id");
        cd.username = rs.getString("username");
        cd.movieid = rs.getString("movieid");
        cd.comment = rs.getString("comment");
        cd.created = rs.getTimestamp("created");
        if(email.equals(cd.username)) {
          cd.owner = true;
        }
        comments.add(cd);
      }
      res.data = comments;
      res.status = 200;
      res.message = "Success";
  } catch (Exception e) {
    e.printStackTrace();
    res.status = 500;
    res.message = e.toString();
  }
  return res;
}


private Response<?> deleteComment(String email, long id) {
  Response<?> res = new Response<>();
  String query = "select * from user_vote where id= ? and username = ?";
  try (Connection con = DriverManager.getConnection(DB_URL);
      PreparedStatement stmt = con.prepareStatement(query)) {
    stmt.setLong(1, id);
    stmt.setString(2, email);

    ResultSet rs = stmt.executeQuery();
    if (!rs.next()) {
      res.status = 200;
      res.message = "Comment not found for user: " + email + " and id: " + id;
    }
  } catch(Exception e) {
    res.status = 500;
    res.message = e.toString();
    e.printStackTrace();
  }
  
  query = "delete from user_comment where id = ?";
  try (Connection con = DriverManager.getConnection(DB_URL);
      PreparedStatement stmt = con.prepareStatement(query)) {
    
    stmt.setLong(1, id);
    
    stmt.executeUpdate();

    res.status = 200;
    res.message = "Success";
  } catch (Exception e) {
    e.printStackTrace();
    res.status = 500;
    res.message = e.toString();
  }
  return res;
}

private void addVote(Connection con, String email, boolean upvote, String movieId) throws Exception {
  String query = "insert into user_vote(username, movieid, upvote, created, updated) values (?, ?, ?, ?, ?)";
  try (PreparedStatement stmt = con.prepareStatement(query)) {
    
    Timestamp curTime = new Timestamp(System.currentTimeMillis());
    
    stmt.setString(1, email);
    stmt.setString(2, movieId);
    stmt.setBoolean(3, upvote);
    stmt.setTimestamp(4, curTime);
    stmt.setTimestamp(5, curTime);
    stmt.executeUpdate();

  }
}

private void updateVote(Connection con, long id, boolean upvote) throws Exception{
  String query = "update user_vote set upvote = ?, updated = ? where id = ?";
  try (PreparedStatement stmt = con.prepareStatement(query)) {
    
    Timestamp curTime = new Timestamp(System.currentTimeMillis());
    
    stmt.setBoolean(1, upvote);
    stmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
    stmt.setLong(3, id);
    stmt.executeUpdate();
  }
}

private void deleteVote(Connection con, long id) throws Exception {
  String query = "delete from user_vote where id = ?";
  try (PreparedStatement stmt = con.prepareStatement(query)) {
    
    stmt.setLong(1, id);
    stmt.executeUpdate();
  }
}

private Response<List<Config>> getConfig(String email, ServletContext application) throws Exception {
  Response<List<Config>> res = new Response<>();
  
  try  {
      res.data = readConfig(application);
      res.status = 200;
      res.message = "Success";
  } catch (Exception e) {
    e.printStackTrace();
    res.status = 500;
    res.message = e.toString();
  }
  return res;
}

private Response<Boolean> addConfig(Boolean isAdmin, String email, ServletContext application, String type, String text, 
    Part coverPart, Part contentPart, Part logoPart, Part realPart) throws Exception {
  Response<Boolean> res = new Response<>();
  try  {
	  if (!Boolean.TRUE.equals(isAdmin)) {
	    res.status = 403;
	    return res;
	  }  
	  String cover = coverPart.getSubmittedFileName();
      String content = contentPart.getSubmittedFileName();
      String logo = logoPart.getSubmittedFileName();
      String real = realPart.getSubmittedFileName();
      
      List<Config> config = readConfig(application);
      String movieIdToAdd = getMovieId(type, cover, real);
      for(Config conf : config) {
        if (movieIdToAdd.equals(getMovieId(conf.type, conf.cover, conf.real))) {
          res.data = false;
          res.status = 200;
          res.message = "Configuration already exists for <type, cover, real>- <"+ type +", "+ cover +", " + real + ">";
          return res;
        }
      }
      String basePath = application.getRealPath("/");
      saveFile(basePath + "/cards/cover/" + cover, coverPart.getInputStream());
      saveFile(basePath + "/cards/content/" + content, contentPart.getInputStream());
      saveFile(basePath + "/cards/logo/" + logo, logoPart.getInputStream());
      saveFile(basePath + "/cards/real/" + real, realPart.getInputStream());
      
      Config c = new Config();
      c.type = type;
      c.text = text;
      c.cover = cover;
      c.content = content;
      c.logo = logo;
      c.real = real;
      config.add(0, c);
      
      String filePath = basePath + "/config.json";
      String json = new GsonBuilder().setPrettyPrinting().create().toJson(config);
      try (FileWriter fw = new FileWriter(filePath)) {
        fw.write(json);
      }
    
      res.data = true;
      res.status = 200;
      res.message = "Success";
  } catch (Exception e) {
    e.printStackTrace();
    res.status = 500;
    res.message = e.toString();
  }
  return res;
}

private Response<Boolean> deleteConfig(Boolean isAdmin, String email, ServletContext application, String movieIdToDelete) throws Exception {
  Response<Boolean> res = new Response<>();
  try  {
      if (!Boolean.TRUE.equals(isAdmin)) {
        res.status = 403;
        return res;
      }
      boolean deleted = false;
      List<Config> config = readConfig(application);
      for (Iterator<Config> iter = config.iterator(); iter.hasNext(); ) {
        Config conf = iter.next();
        if (movieIdToDelete.equals(getMovieId(conf.type, conf.cover, conf.real))) {
          iter.remove();
          deleted = true;
          break;
        }
      }
      if (deleted) {
	      String filePath = application.getRealPath("/") + "/config.json";
	      String json = new GsonBuilder().setPrettyPrinting().create().toJson(config);
	      try (FileWriter fw = new FileWriter(filePath)) {
	        fw.write(json);
	      }
      }
      res.data = deleted;
      res.status = 200;
      res.message = "Success";
  } catch (Exception e) {
    e.printStackTrace();
    res.status = 500;
    res.message = e.toString();
  }
  return res;
}

private List<Config> readConfig(ServletContext application) throws Exception {
  try (InputStream inputStream = new FileInputStream(application.getRealPath("/") + "/config.json")) {
	  //InputStream inputStream = this.getClass().getResourceAsStream("config.json");
	  ByteArrayOutputStream out = new ByteArrayOutputStream();
	  byte[] chunk = new byte[1024];
	  int n = -1;
	  while ((n = inputStream.read(chunk)) != -1) {
	    out.write(chunk, 0, n);
	  }
	  String json = out.toString();
	  if(json.trim().isEmpty()) {
	    return new ArrayList<>();
	  }
	  return new ArrayList<>( Arrays.asList(new Gson().fromJson(json, Config[].class)) );
  }
}

private void saveFile(String path, InputStream in) throws Exception {
  try (OutputStream out = new FileOutputStream(path)) {
    byte[] chunk = new byte[1024];
    int n = -1;
    while ((n = in.read(chunk)) != -1) {
      out.write(chunk, 0, n);
    }
  }
}

private String getMovieId(String type, String cover, String real) {
  return type + "__" + cover + "__" + real;
}

private static void validateDBTables() {
  try {
    Class.forName("org.h2.Driver");
  } catch (Exception e) {
    e.printStackTrace();
  }
  
  try (Connection con = DriverManager.getConnection(DB_URL);
      Statement stm = con.createStatement();
      ResultSet rs = stm.executeQuery("SELECT count(1) from user_vote")) {
    rs.next();
  } catch (Exception ex) {
    ex.printStackTrace();
    createTables();
  }
}

private static void createTables() {
  String sql =
      "create table user_vote ("+
          "id long auto_increment,"+
          "username varchar(1024) not null,"+
          "movieid varchar(2024) not null,"+
          "upvote boolean not null,"+
          "created timestamp not null,"+
          "updated timestamp not null,"+
          "primary key (id),"+
          "unique key user_vote_ui1 (username, movieid)"+      
      ")";

  try (Connection con = DriverManager.getConnection(DB_URL); Statement stm = con.createStatement()) {

    stm.executeUpdate(sql);

  } catch (Exception e) {
    e.printStackTrace();
  }
  
    sql =
      "create table user_comment ("+
          "id long auto_increment,"+
          "username varchar(1024) not null,"+
          "movieid varchar(2024) not null,"+
          "comment text not null,"+
          "created timestamp not null,"+
          "updated timestamp not null,"+
          "primary key (id)"+
      ")";
  
  try (Connection con = DriverManager.getConnection(DB_URL); Statement stm = con.createStatement()) {

    stm.executeUpdate(sql);

  } catch (Exception e) {
    e.printStackTrace();
  }
}

private static class Response<T> {
  int status;
  String message;
  T data;
}

private static class CountData {
  int like;
  int dislike;
  int comment;
  Boolean liked;
  Boolean disliked;
  Boolean commented;
}

private static class CommentData {
  int id;
  String username;
  String movieid;
  String comment;
  Boolean owner;
  Date created;
}

private static class Config {
  String type;
  String text;
  String cover;
  String content;
  String logo;
  String real;
}

%>