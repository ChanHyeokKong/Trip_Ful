<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.security.SecureRandom" %>
<%@ page import="java.math.BigInteger" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name ="google-signin-client_id" content="562446626383-a9laei72kvuogmlo252evitktevt7i81.apps.googleusercontent.com">
<link
	href="https://fonts.googleapis.com/css2?family=Dongle&family=Nanum+Brush+Script&family=Nanum+Myeongjo&family=Nanum+Pen+Script&display=swap"
	rel="stylesheet">
<link href="<%=request.getContextPath()%>/login/loginStyle.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<%
// JavaScript 키를 JSP 변수에 저장 (예시)
String kakaoJavascriptKey = "";

%>
<script>
  // JSP 변수를 JavaScript 코드에 삽입
  Kakao.init('<%= kakaoJavascriptKey %>');
  
</script>

<title>Insert title here</title>
<%
String login = request.getParameter("login");
String redirect = request.getParameter("redirect");
String id = null;
String clientId = "";//네이버 애플리케이션 클라이언트 아이디값";
String redirectURI = URLEncoder.encode("http://localhost:8080/TripFul_Project/login/naverLoginAction.jsp?redirect="+redirect, "UTF-8");
SecureRandom random = new SecureRandom();
String state = new BigInteger(130, random).toString();
String apiURL = "https://nid.naver.com/oauth2.0/authorize?response_type=code"
     + "&client_id=" + clientId
     + "&redirect_uri=" + redirectURI
     + "&state=" + state;
session.setAttribute("state", state);
if (session.getAttribute("id") != null) {
	id = (String) session.getAttribute("id");
}


%>
<script>
		$(function() {
			// JSP에서 받은 login 값 자바스크립트 변수에 저장
			const loginFail = "<%=login%>";

			// 실패 값이 "1"이면 알림 출력
			if (loginFail === "1") {
				alert("아이디 또는 비밀번호를 다시 확인해주세요");
			}
			
			<%
			if (session.getAttribute("rememberId")!=null) {
			%>
				$("#check").prop("checked",true);
				$("#user").val('<%=id%>');
<%}%>
	});
</script>
<body>
	<div class="login-wrap">
		<div class="login-html">
			<input id="tab-1" type="radio" name="tab" class="sign-in" checked><label
				for="tab-1" class="tab">Sign In</label> <input id="tab-2"
				type="radio" name="tab" class="sign-up"><label for="tab-2"
				class="tab">Sign Up</label>
			<div class="login-form">

				<%
				//로그인 페이지
				%>
				<div class="sign-in-htm">
					<form action="<%=request.getContextPath() %>/login/loginAction.jsp" method="post"
						onsubmit="return chkSignIn()">
						<input type="hidden" name="redirect" value="<%=redirect%>">
						<div class="group">
							<label for="user" class="label">아이디</label> <input id="user"
								type="text" class="input" name="user">
						</div>
						<div class="group">
							<label for="pass" class="label">비밀번호</label> <input id="pass"
								type="password" class="input" data-type="password" name="pass">
						</div>
						<div class="group">
							<input id="check" type="checkbox" class="check" name="check">
							<label for="check"><span class="icon"></span> 아이디 기억</label>
						</div>
						<div class="group">
							<input type="submit" class="button" value="Sign In">
						</div>
						<div class="hr"></div>
						<div class="foot-lnk">
							<a href="index.jsp?main=./login/forgotPw.jsp">Forgot
								Password?</a>
						</div>
						<div class="social_login">
							<img src="./login/social_img/google.png" onclick="googleSign('<%=redirect%>')"> <img
								src="./login/social_img/kakao.png" onclick="kakaoSign('<%=redirect%>')"> <img
								src="./login/social_img/naver.png" onclick="naverSign('<%=apiURL%>')">
						</div>
					</form>
				</div>

				<%
				//회원가입 페이지
				%>
				<div class="sign-up-htm">
					<form action="./login/signupAction.jsp"
						method="post" onsubmit="return chkSignUp()">
						<div class="group">
							<label for="user" class="label">이름</label> <input name="name"
								type="text" class="input" required="required" id="name">
						</div>
						<div class="group">
							<label for="user" class="label">아이디</label> <input name="id"
								type="text" class="input" required="required" id="id">
						</div>

						<div class="group">
							<label for="pass" class="label">비밀번호</label> <input name="pw"
								type="password" class="input" data-type="password"
								required="required" id="pw">
						</div>
						<div class="group">
							<label for="pass" class="label">이메일</label> <input name="email"
								type="email" class="input" required="required">
						</div>
						<div class="group">
							<label for="pass" class="label">생년월일</label> <input name="birth"
								type="text" class="input" required="required" id="birth">
						</div>
						<br>
						<div class="group">
							<input type="submit" class="button" value="Sign Up">
						</div>
						<div class="social_signin">
							<img src="./login/social_img/google.png" onclick="googleSign('<%=redirect%>')"> <img
								src="./login/social_img/kakao.png" onclick="kakaoSign('<%=redirect%>')"> <img
								src="./login/social_img/naver.png" onclick="naverSign('<%=apiURL%>')">
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
<script src="./login/JavaScript/signupJS.js"></script>
</html>