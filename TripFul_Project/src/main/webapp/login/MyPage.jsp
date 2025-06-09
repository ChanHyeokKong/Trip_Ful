<%@page import="java.time.LocalDate"%>
<%@page import="login.LoginDto"%>
<%@page import="login.LoginDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link
	href="https://fonts.googleapis.com/css2?family=Dongle&family=Gaegu&family=Hi+Melody&family=Nanum+Myeongjo&family=Nanum+Pen+Script&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/login/myPageDesign.css">
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<title>Insert title here</title>
</head>
<body>
<%
	String id = request.getParameter("id");
	String s_id = null;
	LoginDao dao = new LoginDao();
	LoginDto dto = dao.getOneMember(id);
	
	LocalDate now = LocalDate.now();
	String localeYear = now.toString().split("-")[0];
	int age = Integer.parseInt(localeYear) - Integer.parseInt(dto.getBirth().substring(0, 2))-1900;
	String age1 = age+"";
	age1 = age1.replaceAll("^1", "");
	age1 = age1.replaceAll("[1-9]$","0 대");
	
	if(session.getAttribute("id")!=null){
		s_id = (String)session.getAttribute("id");
	}
	
%>
	<aside class="side-bar">
		<section class="side-bar__icon-box">
			<section class="side-bar__icon-1">
				<div></div>
				<div></div>
				<div></div>
			</section>
		</section>
		<ul>
			<li><span><i class="fa-solid fa-earth-americas"></i>&nbsp;<%=dto.getName() %></span>
				<ul>
					<li><a href="#">내 정보</a></li>
					<li><a href="#">내 리뷰</a></li>
					<li><a href="#">위시리스트</a></li>
					<li><a href="#">내 코스</a></li>
				</ul></li>
		</ul>
	</aside>
	<div class="container mt-3">
		<div class="MyInfo">
			<h1>내 정보</h1>
			<ul>
				<li>이름 : <%=dto.getName() %></li>
				<li>연령대 : <%=age1 %> </li>
				<li>이메일 : <%=dto.getEmail() %></li>
				<li>아이디 : <%=id %></li>
			</ul>
			<div class="update-btn">
				<%
					if(id.equals(s_id)){
						%><button class="btn btn-info" onclick="location.href='http://localhost:8080/TripFul_Project/index.jsp?main=login/changeForm.jsp'">정보 수정</button><%
					}
				%>
				
			</div>
		</div>
		<div class="MyReview">
		<h1>내 리뷰</h1>
			
		</div>
		<div class="WishList">
		<h1>위시리스트</h1>
			<div class="places">
			
			</div>
		</div>
	</div>
</body>
</html>