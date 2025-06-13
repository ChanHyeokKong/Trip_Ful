<%@page import="login.SocialDto"%>
<%@page import="login.LoginDao"%>
<%@page import="login.LoginDto"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.net.URL"%>
<%@ page import="java.net.HttpURLConnection"%>
<%@ page import="java.io.BufferedReader"%>
<%@ page import="java.io.InputStreamReader"%>
<%@ page import="java.io.BufferedWriter"%>
<%@ page import="java.io.OutputStreamWriter"%>
<%@ page import="java.io.StringReader"%>
<%@ page import="java.util.Base64"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="org.json.simple.parser.JSONParser"%>

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<%
// --- 0. 초기 변수 설정 ---
String code = request.getParameter("code");
String googleLoginErrorMessage = null;
// ★ 수정: 'redirect' 대신 'state' 파라미터를 받습니다.
String state = request.getParameter("state");

// ★ 추가: state 값이 없거나 비어있을 경우를 대비한 기본 URL 설정
String finalRedirectUrl = (state != null && !state.isEmpty()) ? state : "../index.jsp";

// DB에 저장할 member 정보
String memberEmail = null;
String memberName = null;
String memberBirthYYMMDD = null;

// DB에 저장할 social_accounts 정보
String providerId = null;
String accessToken = null;
String idToken = null;

// 1. code 파라미터 유효성 검증
if (code == null || code.isEmpty()) {
	googleLoginErrorMessage = "구글 로그인 인증 과정에서 필요한 정보(code)가 누락되었습니다.";
} else {
	// --- 2. 구글 클라이언트 정보 설정 ---
	String clientId = ""; //구글 클라이언트 아이디
	String clientSecret = ""; // ★★★ 보안에 매우 중요하므로 실제로는 외부 파일에서 관리하는 것이 좋습니다 ★★★

	// 3. 콜백 URL
	String redirectURI = "http://localhost:8080/TripFul_Project/login/googleLoginAction.jsp";

	// --- 4. 액세스 토큰 요청 API 호출 ---
	String tokenApiURL = "https://oauth2.googleapis.com/token";

	try {
		URL token_url = new URL(tokenApiURL);
		HttpURLConnection con = (HttpURLConnection) token_url.openConnection();
		con.setRequestMethod("POST");
		con.setDoOutput(true);

		String postParams = "grant_type=authorization_code" + "&client_id=" + clientId + "&client_secret=" + clientSecret
				+ "&redirect_uri=" + URLEncoder.encode(redirectURI, "UTF-8") + "&code=" + code;

		BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(con.getOutputStream()));
		bw.write(postParams);
		bw.flush();
		bw.close();

		int responseCode = con.getResponseCode();
		BufferedReader br;

		if (responseCode == 200) {
			br = new BufferedReader(new InputStreamReader(con.getInputStream()));
		} else {
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
			idToken = (String) tokenResponseJson.get("id_token");

			if (idToken != null && !idToken.isEmpty()) {
				String[] jwtParts = idToken.split("\\.");
				if (jwtParts.length > 1) {
					String payloadJson = new String(Base64.getUrlDecoder().decode(jwtParts[1]), "UTF-8");
					JSONObject payload = (JSONObject) parser.parse(new StringReader(payloadJson));

					providerId = (String) payload.get("sub");
					memberEmail = (String) payload.get("email");
					
					// People API 호출하여 이름, 생년월일 정보 가져오기
					String peopleApiURL = "https://people.googleapis.com/v1/people/me?personFields=birthdays,names";
					URL people_url = new URL(peopleApiURL);
					HttpURLConnection people_con = (HttpURLConnection) people_url.openConnection();
					people_con.setRequestMethod("GET");
					people_con.setRequestProperty("Authorization", "Bearer " + accessToken);

					int peopleResponseCode = people_con.getResponseCode();
					if (peopleResponseCode == 200) {
						BufferedReader people_br = new BufferedReader(new InputStreamReader(people_con.getInputStream()));
						StringBuilder people_res = new StringBuilder();
						String people_inputLine;
						while ((people_inputLine = people_br.readLine()) != null) {
							people_res.append(people_inputLine);
						}
						people_br.close();

						JSONObject peopleJson = (JSONObject) parser.parse(new StringReader(people_res.toString()));
						
						// 이름(names) 정보 파싱 (Null-safe)
						if (peopleJson.containsKey("names")) {
							JSONArray names = (JSONArray) peopleJson.get("names");
							if (names != null && !names.isEmpty()) {
								JSONObject nameInfo = (JSONObject) names.get(0);
								memberName = (String) nameInfo.get("displayName");
							}
						}

						// 생년월일(birthdays) 정보 파싱 (Null-safe)
						if(peopleJson.containsKey("birthdays")) {
							JSONArray birthdays = (JSONArray) peopleJson.get("birthdays");
							if (birthdays != null && !birthdays.isEmpty()) {
								JSONObject birthdayInfo = (JSONObject) birthdays.get(0);
								if(birthdayInfo.containsKey("date")){
									JSONObject date = (JSONObject) birthdayInfo.get("date");
									Number yearNum = (Number) date.get("year");
									Number monthNum = (Number) date.get("month");
									Number dayNum = (Number) date.get("day");

									if (yearNum != null && monthNum != null && dayNum != null) {
										String year = String.valueOf(yearNum.intValue()).substring(2);
										String month = String.format("%02d", monthNum.intValue());
										String day = String.format("%02d", dayNum.intValue());
										memberBirthYYMMDD = year + month + day;
									}
								}
							}
						}
					}
					people_con.disconnect();

					// --- DB 연동 로직 ---
					LoginDao dao = new LoginDao();
					if (dao.getMemberIdx("google", providerId) == null) {
						// 신규 회원 처리
						SocialDto s_dto = new SocialDto();
						s_dto.setSocial_provider("google");
						s_dto.setSocial_provider_key(providerId);
						session.setAttribute("social", s_dto);
	%>
	<script>
		$(opener.document).find("#tab-2").prop("checked", true);
		$(opener.document).find("input[name='name']").val("<%=memberName != null ? memberName : ""%>").prop("readonly", true);
		$(opener.document).find("input[name='email']").val("<%=memberEmail != null ? memberEmail : ""%>").prop("readonly", true);
		$(opener.document).find("input[name='birth']").val("<%=memberBirthYYMMDD != null ? memberBirthYYMMDD : ""%>").prop("readonly", true);
		window.close();
	</script>
	<%
						return;
					} else {
						// 기존 회원 처리
						LoginDto dto = dao.getOneMember(dao.getIdwithIdx(dao.getMemberIdx("google", providerId)));
						if (dto.getAdmin() == 1) {
							session.setAttribute("loginok", "admin");
						} else {
							session.setAttribute("loginok", "user");
						}
						session.setAttribute("social", "google");
						session.setAttribute("id", dto.getId());
	%>
	<script>
        // ★ 수정: 관리자와 일반 사용자를 구분하여 state 값으로 받은 finalRedirectUrl 변수를 사용합니다.
		if (<%= dto.getAdmin() %> === 1) {
			window.opener.document.location.href = "../index.jsp?main=page/adminMain.jsp";
		} else {
			<%if(finalRedirectUrl.equals("null")){
				finalRedirectUrl = request.getContextPath()+"/index.jsp";
			
			}%>
			window.opener.document.location.href = "<%= finalRedirectUrl %>";
		}
		window.close();
	</script>
	<%
						return;
					}
				} else {
					googleLoginErrorMessage = "ID 토큰이 유효하지 않습니다.";
				}
			} else {
				googleLoginErrorMessage = "ID 토큰을 얻는 데 실패했습니다.";
			}
		} else {
			googleLoginErrorMessage = "토큰 요청 실패 (응답 코드: " + responseCode + "): " + res.toString();
		}
	} catch (Exception e) {
		googleLoginErrorMessage = "구글 로그인 처리 중 예외 발생: " + e.toString();
		e.printStackTrace();
	}
}

// 에러 처리
if (googleLoginErrorMessage != null) {
%>
<script>
	alert('구글 로그인 오류: <%= googleLoginErrorMessage.replace("'", "\\'") %>');
	window.close();
</script>
<%
}
%>