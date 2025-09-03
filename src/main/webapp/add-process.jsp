<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");

    String name = request.getParameter("name");
    String message = request.getParameter("message");

    String jdbcUrl = "jdbc:mariadb://localhost:3307/jsp_db?characterEncoding=UTF-8";
    String dbUser = "root";
    String dbPassword = "mariadb";

    Connection conn = null;
    PreparedStatement pstmt = null;

    if (name == null || name.trim().isEmpty() || message == null || message.trim().isEmpty()) {
        response.getWriter().println("<script>alert('이름과 메시지를 모두 입력해주세요.'); history.back();</script>");
        return;
    }

    try {
        Class.forName("org.mariadb.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);

        String sql = "INSERT INTO guestbook (name, message) VALUES (?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, name);
        pstmt.setString(2, message);

        pstmt.executeUpdate();

        response.sendRedirect("guestbook.jsp");

    } catch (Exception e) {
        e.printStackTrace();
        response.getWriter().println("데이터베이스 오류가 발생했습니다.");
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%>