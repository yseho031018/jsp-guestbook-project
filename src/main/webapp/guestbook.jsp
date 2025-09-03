<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%!
    public static class GuestbookEntry {
        private int id;
        private String name;
        private String message;
        private String createdAt;

        public GuestbookEntry(int id, String name, String message, String createdAt) {
            this.id = id;
            this.name = name;
            this.message = message;
            this.createdAt = createdAt;
        }

        public int getId() { return id; }
        public String getName() { return name; }
        public String getMessage() { return message; }
        public String getCreatedAt() { return createdAt; }
    }
%>
<%
    String jdbcUrl = "jdbc:mariadb://localhost:3307/jsp_db?characterEncoding=UTF-8";
    String dbUser = "root";
    String dbPassword = "mariadb";

    List<GuestbookEntry> entries = new ArrayList<>();
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("org.mariadb.jdbc.Driver");

        conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);

        stmt = conn.createStatement();

        String sql = "SELECT id, name, message, created_at FROM guestbook ORDER BY id DESC";
        rs = stmt.executeQuery(sql);

        while (rs.next()) {
            int id = rs.getInt("id");
            String name = rs.getString("name");
            String message = rs.getString("message");
            String createdAt = rs.getTimestamp("created_at").toString();
            entries.add(new GuestbookEntry(id, name, message, createdAt));
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>JSP 방명록</title>
    <style>
        body { font-family: sans-serif; }
        .container {
            width: 800px;
            margin: 50px auto;
        }
        .form-box, .list-box {
            border: 1px solid #ccc;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        input[type=text], textarea {
            width: 100%;
            padding: 8px;
            box-sizing: border-box;
            margin-bottom: 10px;
        }
        textarea {
            height: 100px;
            resize: vertical;
        }
        input[type=submit] {
            padding: 10px 15px;
            background-color: #007bff;
            color: white;
            border: none;
            cursor: pointer;
        }
        .entry {
            border-bottom: 1px solid #eee;
            padding: 15px 0;
        }
        .entry:last-child {border-bottom: none; }
        .entry-info {
            font-size: 14px;
            color: #888;
        }
        .entry-info strong { color: #333; }
    </style>
</head>
<body>
<div class="container">
    <h1>JSP 방명록</h1>

    <div class="form-box">
        <h2>새 글 남기기</h2>
        <form action="add-process.jsp" method="post">
            <p><input type="text" name="name" placeholder="이름" required></p>
            <p><textarea name="message" placeholder="메시지를 입력하세요..." required></textarea></p>
            <p><input type="submit" value="글 남기기"></p>
        </form>
    </div>

    <div class="list-box">
        <h2>방명록 목록</h2>
        <% if (entries.isEmpty()) { %>
        <p>작성된 글이 없습니다.</p>
        <% } else { %>
        <% for (GuestbookEntry entry : entries) { %>
        <div class="entry">
            <p><%= entry.getMessage().replace("\n", "<br>") %></p>
            <p class="entry-info">
                <strong><%= entry.getName() %></strong> | <%= entry.getCreatedAt() %>
            </p>
        </div>
        <% } %>
        <% } %>
    </div>
</div>
</body>
</html>