<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Tripful - 관광지 정보</title>
    <link rel="stylesheet" href="css/boardListStyle.css">
    <link rel="stylesheet" href="css/noticeStyle.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="css/style.css">
    <script src="js/modal.js" defer></script>
</head>
<body>

<%@ include file="layout/header.jsp" %>

<%
    String mainPage = "page/TripFul_main.jsp";
    if (request.getParameter("main") != null) {
        mainPage = request.getParameter("main");
    }
    
 	// sub 파라미터가 있으면 request attribute로 넘김
    String sub = request.getParameter("sub");
    if (sub != null && !sub.isEmpty()) {
        request.setAttribute("sub", sub);
    }
%>

<div class="container-fluid my-5">
    <jsp:include page="<%= mainPage %>" />
</div>

<%@ include file="layout/footer.jsp" %>
<%@ include file="layout/regionModal.jsp" %>

</body>
</html>
