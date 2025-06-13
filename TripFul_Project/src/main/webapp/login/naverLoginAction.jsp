<%@page import="login.SocialDto"%>
<%@page import="login.LoginDao"%>
<%@page import="login.LoginDto"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.net.URL"%>
<%@ page import="java.net.HttpURLConnection"%>
<%@ page import="java.io.BufferedReader"%>
<%@ page import="java.io.InputStreamReader"%>
<%@ page import="java.io.StringReader"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.parser.JSONParser"%>
<%@ page import="org.json.simple.JSONArray"%>

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<%
// --- 0. 초기 변수 설정 및 에러 메시지 초기화 ---
String code = request.getParameter("code");
String state = request.getParameter("state");
String redirect = request.getParameter("redirect");

String naverLoginErrorMessage = null;

// DB에 저장할 member 정보
String memberEmail = null;
String memberName = null;
String memberMobile = null; // 휴대폰 번호 (선택 사항)
String memberBirth = null; // 생년월일 (예: 05-30) (추가)
String memberBirthYear = null; // 출생년도 (추가)
String memberGender = null; // 성별 (선택 사항)
String memberProfileImage = null; // 프로필 이미지 URL (선택 사항)

// DB에 저장할 social_accounts 정보
String providerId = null; // Naver에서 제공하는 사용자 고유 ID
String accessToken = null;
String refreshToken = null; // Naver는 refresh_token도 제공합니다.

// 1. code와 state 파라미터 유효성 검증
if (code == null || state == null) {
	naverLoginErrorMessage = "Naver 로그인 인증 과정에서 필요한 정보(code 또는 state)가 누락되었습니다.";
} else if (request.getParameter("error") != null) {
	naverLoginErrorMessage = "네이버 로그인 오류: " + request.getParameter("error_description");
} else {
	// --- 2. Naver 클라이언트 정보 설정 (보안상 JSP에 하드코딩하는 것은 권장되지 않음) ---
	String clientId = ""; // ★★★ 실제 Naver 클라이언트 아이디로 변경하세요. ★★★
	String clientSecret = ""; // ★★★ 실제 Naver 클라이언트 시크릿으로 변경하세요. ★★★

	// 3. 콜백 URL (Naver 개발자 센터에 등록된 URL과 일치해야 함)
	String currentCallbackUrl = "http://localhost:8080/TripFul_Project/login/naverLoginAction.jsp";
	String encodedRedirectURI = URLEncoder.encode(currentCallbackUrl, "UTF-8");

	// --- 4. 액세스 토큰 요청 API 호출 ---
	String tokenApiURL = "https://nid.naver.com/oauth2.0/token?grant_type=authorization_code" + "&client_id=" + clientId
	+ "&client_secret=" + clientSecret + "&redirect_uri=" + encodedRedirectURI + "&code=" + code + "&state="
	+ state;

	try {
		URL token_url = new URL(tokenApiURL);
		HttpURLConnection con = (HttpURLConnection) token_url.openConnection();
		con.setRequestMethod("GET");
		int responseCode = con.getResponseCode();
		BufferedReader br;

		if (responseCode == 200) { // 정상 호출
	br = new BufferedReader(new InputStreamReader(con.getInputStream()));
		} else { // 에러 발생
	br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
		}
		StringBuilder res = new StringBuilder();
		String inputLine;
		while ((inputLine = br.readLine()) != null) {
	res.append(inputLine);
		}
		br.close();
		con.disconnect();

		if (responseCode == 200) {
	JSONParser parser = new JSONParser();
	JSONObject tokenResponseJson = (JSONObject) parser.parse(new StringReader(res.toString()));

	accessToken = (String) tokenResponseJson.get("access_token");
	refreshToken = (String) tokenResponseJson.get("refresh_token");

	if (accessToken != null && !accessToken.isEmpty()) {
		// --- 5. 사용자 프로필 조회 API 호출 ---
		String profileApiURL = "https://openapi.naver.com/v1/nid/me";
		URL profile_url = new URL(profileApiURL);
		HttpURLConnection profile_con = (HttpURLConnection) profile_url.openConnection();
		profile_con.setRequestMethod("GET");
		profile_con.setRequestProperty("Authorization", "Bearer " + accessToken);

		int profileResponseCode = profile_con.getResponseCode();
		BufferedReader profile_br;

		if (profileResponseCode == 200) {
			profile_br = new BufferedReader(new InputStreamReader(profile_con.getInputStream()));
		} else {
			profile_br = new BufferedReader(new InputStreamReader(profile_con.getErrorStream()));
		}

		StringBuilder profileRes = new StringBuilder();
		String profileInputLine;
		while ((profileInputLine = profile_br.readLine()) != null) {
			profileRes.append(profileInputLine);
		}
		profile_br.close();
		profile_con.disconnect();

		if (profileResponseCode == 200) {
			JSONObject profileJsonResponse = (JSONObject) parser.parse(new StringReader(profileRes.toString()));
			JSONObject naverUserProfile = (JSONObject) profileJsonResponse.get("response");

			if (naverUserProfile != null) {
				// --- DB의 member 테이블에 저장할 정보 추출 ---
				memberEmail = (String) naverUserProfile.get("email");
				memberName = (String) naverUserProfile.get("name");

				// *** 생년월일(birthday) 및 출생년도(birthyear) 추출 추가 ***
				memberBirth = (String) naverUserProfile.get("birthday"); // 예: "05-30"
				memberBirthYear = (String) naverUserProfile.get("birthyear"); // 예: "1990"

				// --- DB의 social_accounts 테이블에 저장할 정보 추출 ---
				providerId = String.valueOf(naverUserProfile.get("id")); // Naver 고유 ID는 Number로 올 수 있어 String.valueOf() 사용

				// -------------------------------------------------------------
				// --- 6. 추출된 정보를 바탕으로 DB 연동 로직 (가장 중요한 부분) ---
				// -------------------------------------------------------------
				// 이 부분에 DB 연동 로직을 작성합니다.
				// 예: member 테이블에 신규 회원 추가, 기존 회원 소셜 계정 연결 등
				// 세션에 로그인 정보 저장 후 메인 페이지로 리디렉션
				LoginDao dao = new LoginDao();
				if (dao.getMemberIdx("naver", providerId) == null) {
					memberBirth = memberBirth.replaceAll("-", "");
					memberBirthYear = memberBirthYear.substring(2);
					SocialDto s_dto = new SocialDto();
					s_dto.setSocial_provider("naver");
					s_dto.setSocial_provider_key(providerId);
					session.setAttribute("social", s_dto);
%>
<script>
	$(opener.document).find("#tab-2").prop("checked",true);
	$(opener.document).find("input[name='name']").val("<%=memberName%>").prop("readonly", true);
	$(opener.document).find("input[name='email']").val("<%=memberEmail%>").prop("readonly", true);
	$(opener.document).find("input[name='birth']").val("<%=memberBirthYear + memberBirth%>").prop("readonly", true);
	window.close();
</script>
<%
//session.setAttribute("loginok", "user");

//session.setAttribute("id", dto.getId());
//response.sendRedirect("../index.jsp");
return;
} else {
LoginDto dto = dao.getOneMember(dao.getIdwithIdx(dao.getMemberIdx("naver", providerId)));
if(dto.getAdmin()==1){
	System.out.println(dto.getAdmin());
	session.setAttribute("loginok", "admin");
	session.setAttribute("social", "naver");
	session.setAttribute("id", dto.getId());
	%>

	<script>
		window.opener.document.location.href = "../index.jsp?main=page/adminMain.jsp";
		window.close();
	</script>

	<%
}
else{
	System.out.println(dto.getAdmin());
	session.setAttribute("loginok", "user");
	session.setAttribute("social", "naver");
	session.setAttribute("id", dto.getId());
	%>

	<script>
		window.opener.document.location.href = "<%=redirect%>";
		window.close();
	</script>

	<%
}


return;
}

} else {
naverLoginErrorMessage = "네이버 프로필 정보가 응답에 포함되지 않았습니다.";
}
} else {
naverLoginErrorMessage = "프로필 정보 요청 실패 (응답 코드: " + profileResponseCode + "): " + profileRes.toString();
}
} else {
naverLoginErrorMessage = "액세스 토큰을 얻는 데 실패했습니다. 응답: " + res.toString();
}
} else {
naverLoginErrorMessage = "토큰 요청 실패 (응답 코드: " + responseCode + "): " + res.toString();
}
} catch (Exception pe) {
naverLoginErrorMessage = "JSON 파싱 오류: " + pe.getMessage() + ". 응답: " + pe.toString();
pe.printStackTrace();
naverLoginErrorMessage = "네이버 로그인 처리 중 예외 발생: " + pe.toString();
pe.printStackTrace();
}
}
%>
