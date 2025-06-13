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
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.parser.JSONParser"%>
<%@ page import="org.json.simple.JSONArray"%>

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<%
// --- 0. 초기 변수 설정 및 에러 메시지 초기화 ---
String code = request.getParameter("code"); // 카카오 인증 서버로부터 받은 인가 코드
String kakaoLoginErrorMessage = null;
// ★★★ 수정: 'redirect' 대신 'state' 파라미터를 받습니다.
String state = request.getParameter("state");
//LoginDao dao = new LoginDao();

// ★★★ 추가: state 값이 없거나 비어있을 경우를 대비한 기본 URL 설정
String finalRedirectUrl = (state != null && !state.isEmpty()) ? state : "../index.jsp";

// DB에 저장할 member 정보
String memberEmail = null;
String memberName = null;
String memberBirthYYMMDD = null;
String memberBirthYear = null;
String memberBirth = null;

// DB에 저장할 social_accounts 정보
String providerId = null;
String accessToken = null;
String refreshToken = null;

// 1. code 파라미터 유효성 검증
if (code == null || code.isEmpty()) {
	kakaoLoginErrorMessage = "카카오 로그인 인증 과정에서 필요한 정보(code)가 누락되었습니다.";
} else {
	// --- 2. 카카오 클라이언트 정보 설정 ---
	String clientId = "";

	// 3. 콜백 URL (카카오 개발자 센터에 등록된 URL과 일치해야 함)
	// ★★★ 중요: 토큰 요청 시 보내는 redirect_uri는 파라미터가 없는 깨끗한 버전이어야 합니다.
	String currentCallbackUrl = "http://localhost:8080/TripFul_Project/login/kakaoLoginAction.jsp";
	String encodedRedirectURI = URLEncoder.encode(currentCallbackUrl, "UTF-8");

	// --- 4. 액세스 토큰 요청 API 호출 ---
	String tokenApiURL = "https://kauth.kakao.com/oauth/token";

	try {
	    URL token_url = new URL(tokenApiURL);
	    HttpURLConnection con = (HttpURLConnection) token_url.openConnection();
	    con.setRequestMethod("POST");
	    con.setDoOutput(true);

	    String postParams = "grant_type=authorization_code" + "&client_id=" + clientId + "&redirect_uri="
	    + encodedRedirectURI + "&code=" + code;

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
	        refreshToken = (String) tokenResponseJson.get("refresh_token");

	        if (accessToken != null && !accessToken.isEmpty()) {
	            String profileApiURL = "https://kapi.kakao.com/v2/user/me";
	            URL profile_url = new URL(profileApiURL);
	            HttpURLConnection profile_con = (HttpURLConnection) profile_url.openConnection();
	            profile_con.setRequestMethod("GET");
	            profile_con.setRequestProperty("Authorization", "Bearer " + accessToken);
	            profile_con.setRequestProperty("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");

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

	                // ★★★ NullPointerException 방어 코드 시작 ★★★
	                providerId = String.valueOf(profileJsonResponse.get("id"));

	                JSONObject kakaoAccount = (JSONObject) profileJsonResponse.get("kakao_account");
	                
	                // kakao_account 객체가 있는지 먼저 확인
	                if (kakaoAccount != null) {
	                    
	                    // 이름(실명) 정보가 있는지 확인하고 가져오기
	                    if (kakaoAccount.get("has_name") != null && (Boolean)kakaoAccount.get("has_name")) {
	                        memberName = (String) kakaoAccount.get("name");
	                    }

	                    // 이메일 정보가 있는지 확인하고 가져오기
	                    if (kakaoAccount.get("has_email") != null && (Boolean)kakaoAccount.get("has_email")) {
	                        memberEmail = (String) kakaoAccount.get("email");
	                    }
	                    
	                    // 생년월일 정보가 있는지 확인하고 가져오기
	                    if (kakaoAccount.get("has_birthday") != null && (Boolean)kakaoAccount.get("has_birthday")) {
	                        memberBirth = (String) kakaoAccount.get("birthday");
	                    }
	                    if (kakaoAccount.get("has_birthyear") != null && (Boolean)kakaoAccount.get("has_birthyear")) {
	                        memberBirthYear = (String) kakaoAccount.get("birthyear");
	                    }
	                    
	                    if (memberBirthYear != null && memberBirth != null) {
	                        if (memberBirthYear.length() >= 2) {
	                            memberBirthYYMMDD = memberBirthYear.substring(2) + memberBirth;
	                        }
	                    }
	                }
	                // ★★★ NullPointerException 방어 코드 끝 ★★★

	                if (providerId != null && !providerId.isEmpty()) {
	                    // --- DB 연동 로직 (이하 동일) ---
	                    LoginDao dao = new LoginDao();
	                    if (dao.getMemberIdx("kakao", providerId) == null) {
	                        // 신규 회원 처리
	                        SocialDto s_dto = new SocialDto();
	                        s_dto.setSocial_provider("kakao");
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
	                        LoginDto dto = dao.getOneMember(dao.getIdwithIdx(dao.getMemberIdx("kakao", providerId)));
	                        if (dto.getAdmin() == 1) {
	                            session.setAttribute("loginok", "admin");
	                        } else {
	                            session.setAttribute("loginok", "user");
	                        }
	                        session.setAttribute("social", "kakao");
	                        session.setAttribute("id", dto.getId());
	%>
	<script>
	    if(<%= dto.getAdmin() %> === 1){
	        window.opener.document.location.href = "../index.jsp?main=page/adminMain.jsp";
	    } else {
	        window.opener.document.location.href = "<%= finalRedirectUrl %>";
	    }
	    window.close();
	</script>
	<%
	                        return;
	                    }
	                } else {
	                    kakaoLoginErrorMessage = "카카오 사용자 고유 ID를 얻을 수 없습니다.";
	                }
	            } else {
	                kakaoLoginErrorMessage = "카카오 프로필 정보 요청 실패 (응답 코드: " + profileResponseCode + "): " + profileRes.toString();
	            }
	        } else {
	            kakaoLoginErrorMessage = "액세스 토큰을 얻는 데 실패했습니다. 응답: " + res.toString();
	        }
	    } else {
	        kakaoLoginErrorMessage = "토큰 요청 실패 (응답 코드: " + responseCode + "): " + res.toString();
	    }
	} catch (Exception e) {
	    // 에러 발생 시 에러 메시지를 구체적으로 설정하고, 서버 로그에 에러 내용을 출력합니다.
	    kakaoLoginErrorMessage = "JSP 처리 중 예외 발생: " + e.getMessage();
	    e.printStackTrace();
	}
	}

%>