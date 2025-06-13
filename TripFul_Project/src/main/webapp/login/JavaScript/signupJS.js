/**
 * 
 */

function chkSignUp() {
	if ($(".sign-up-htm").children().find("label").hasClass("error")) {
		//console.log("에러 클래스 있음");
		return false;
	}
	else {
		//console.log("에러 클래스 못찾음");
		return true;
	}
}

function chkSignIn() {
	if ($(".sign-in-html").children().find("label").hasClass("error")) {
		return false;
	}
	else {
		return true;
	}
}

function googleSign(finalUrl) {
    const clientId = ""; // 클라이언트 ID
    
    // ★ 수정: redirect_uri는 구글에 등록된 주소 그대로, 파라미터 없이 깨끗하게 유지합니다.
    const redirectUri = 'http://localhost:8080/TripFul_Project/login/googleLoginAction.jsp';
    
    // Google OAuth 2.0 엔드포인트. email과 profile, birthday 정보 요청
    const scope = 'https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/user.birthday.read';
    
    // ★ 수정: state 파라미터에 최종 목적지(finalUrl)를 담습니다.
    const authUrl = `https://accounts.google.com/o/oauth2/v2/auth?scope=${scope}&access_type=offline&include_granted_scopes=true&response_type=code&state=${encodeURIComponent(finalUrl)}&redirect_uri=${encodeURIComponent(redirectUri)}&client_id=${clientId}`;

    // 새 팝업 창으로 구글 로그인 페이지 띄우기
    window.open(authUrl, "googleLoginPop", "width=500, height=700, top=200, left=700, scrollbars=yes");
}

function naverSign(apiURL) {
	window.open(apiURL, "NaverLogin", "width=500, height=800, top=200, left=700, resizable=no, scrollbars=no");
}

// 최종 목적지 주소를 인자로 받습니다.
function kakaoSign(finalUrl) {
	const kakaoRestApiKey = "e"; // 카카오 REST API 키
	
	// ★★★ 수정: redirect_uri는 카카오에 등록된 주소 그대로, 깨끗하게 유지합니다.
	const redirectUri = 'http://localhost:8080/TripFul_Project/login/kakaoLoginAction.jsp';

	// 인가 코드 요청 URL을 직접 생성
	// ★★★ 수정: 최종 목적지(finalUrl)는 state 파라미터에 담아서 보냅니다.
	const authUrl = `https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=${kakaoRestApiKey}&redirect_uri=${encodeURIComponent(redirectUri)}&state=${encodeURIComponent(finalUrl)}`;

	// 새 팝업 창으로 카카오 로그인 페이지 띄우기
	window.open(authUrl, "kakaoLoginPop", "width=500, height=800, top=200, left=700, scrollbars=yes");
}



$("#id").keyup(function() {
	//ajax를 통한 비동기 방식으로 중복 처리
	var inputId = $("#id");
	$.ajax({
		type: "get",
		url: "./login/checkDuplication.jsp",
		data: { "id": inputId.val() },
		dataType: "html",
		success: function(res) {
			if (res.trim() == 1) {
				inputId.siblings(".label").text("아이디      중복된 아이디입니다.");
				inputId.siblings(".label").addClass("error");
				console.log(res.trim());
			}
			else if (res.trim() == 2) {
				inputId.siblings(".label").text("아이디      6글자 이상 16글자 이하의 아이디를 입력하세요.");
				inputId.siblings(".label").addClass("error");
				console.log(res.trim());
			}
			else if (res.trim() == 3) {
				inputId.siblings(".label").text("아이디      사용불가능한 문자가 포함 되었습니다.");
				inputId.siblings(".label").addClass("error");
				//console.log(res.trim());
			}
			else if (res.trim() == 4) {
				inputId.siblings(".label").text("아이디      영문과 숫자가 모두 포함되어야 합니다.");
				inputId.siblings(".label").addClass("error");
				//console.log(res.trim());
			}
			/*else if (res.trim() == 5) {
				// 이전 아이디와 동일 아이디
				inputId.siblings(".label").text("아이디      영문과 숫자가 모두 포함되어야 합니다.");
				inputId.siblings(".label").addClass("error");
				
			}*/
			else {
				inputId.siblings(".label").text("아이디      사용가능한 아이디입니다.");
				inputId.siblings(".label").removeClass("error");
				//console.log(res.trim());
			}
		}
	})
})

$("#pw").keyup(function() {
	if ($(this).val() == "") {
		$(this).siblings(".label").text("비밀번호");
		$(this).siblings(".label").removeClass("error");
	}
	else if ($(this).val().includes('!') || $(this).val().includes('@') || $(this).val().includes('#') || $(this).val().includes('$') ||
		$(this).val().includes('!') || $(this).val().includes('%') || $(this).val().includes('^') || $(this).val().includes('&')) {
		if ($(this).val().length >= 8 && $(this).val().length <= 16) {
			$(this).siblings(".label").text("비밀번호");
			$(this).siblings(".label").removeClass("error");
		}
		else {
			$(this).siblings(".label").text("비밀번호      8자리 이상 16자리 이하여야 합니다.");
			$(this).siblings(".label").addClass("error");
		}
	}
	else {
		$(this).siblings(".label").text("비밀번호      특수문자를 입력해주세요");
		$(this).siblings(".label").addClass("error");
	}
})
$("#birth").keyup(function() {
	if (isNaN($(this).val())) {
		$(this).siblings(".label").text("생년월일      숫자로만 입력해주세요.");
		$(this).siblings(".label").addClass("error");
	}
	else if ($(this).val().length != 6 && $(this).val() == "") {
		$(this).siblings(".label").text("생년월일     6자리 YYMMDD형태로 입력해주세요.");
		$(this).siblings(".label").addClass("error");
	}
	else {
		var year = $(this).val().substring(0, 2);
		var month = $(this).val().substring(2, 4);
		var day = $(this).val().substring(4, 6);

		if (Number(month) > 12 || Number(month) <= 0) {
			$(this).siblings(".label").text("생년월일     6자리 YYMMDD형태로 입력해주세요.");
			$(this).siblings(".label").addClass("error");
		}
		else if (Number(day) > 31 || Number(day) <= 0) {
			$(this).siblings(".label").text("생년월일     6자리 YYMMDD형태로 입력해주세요.");
			$(this).siblings(".label").addClass("error");
		}
		else if (Number(day) < 10 && !day.startsWith("0")) {
			$(this).siblings(".label").text("생년월일     6자리 YYMMDD형태로 입력해주세요.");
			$(this).siblings(".label").addClass("error");
		}
		else {
			$(this).siblings(".label").text("생년월일");
			$(this).siblings(".label").removeClass("error");
		}
	}
})

$("#currpw").keyup(function() {
	//ajax를 통한 비동기 방식으로 중복 처리
	var inputCurrPw = $("#currpw");

	$.ajax({
		type: "get",
		url: "./login/PwDuplicate.jsp",
		data: { "currpw": inputCurrPw.val() },
		dataType: "html",
		success: function(res) {
			if (res.trim() == 1) {
				inputCurrPw.siblings(".label").text("현재 비밀번호");
				inputCurrPw.siblings(".label").removeClass("error");
				console.log(res.trim());
			}
			else {
				inputCurrPw.siblings(".label").text("현재 비밀번호      비밀번호가 틀립니다.");
				inputCurrPw.siblings(".label").addClass("error");
				//console.log(res.trim());
			}
		}
	})
})

$("#newpw").keyup(function() {
	var inputCurrPw = $("#newpw");

	$.ajax({
		type: "get",
		url: "./login/PwDuplicate.jsp",
		data: { "currpw": inputCurrPw.val(),
			"id":$("#id").val()
		 },
		dataType: "html",
		success: function(res) {
			if (res.trim() == 1) {
				inputCurrPw.siblings(".label").text("새 비밀번호  현재와 동일한 비밀번호는 사용할 수 없습니다.");
				inputCurrPw.siblings(".label").addClass("error");
				console.log(res.trim());
			}
			else {
				if (inputCurrPw.val() == "") {
					inputCurrPw.siblings(".label").text("새 비밀번호");
					inputCurrPw.siblings(".label").removeClass("error");
				}
				else if (inputCurrPw.val().includes('!') || inputCurrPw.val().includes('@') || inputCurrPw.val().includes('#') ||
					inputCurrPw.val().includes('$') || inputCurrPw.val().includes('!') || inputCurrPw.val().includes('%') ||
					inputCurrPw.val().includes('^') || inputCurrPw.val().includes('&')) {

					if (inputCurrPw.val().length >= 8 && inputCurrPw.val().length <= 16) {
						inputCurrPw.siblings(".label").text("새 비밀번호");
						inputCurrPw.siblings(".label").removeClass("error");
					}

					else {
						inputCurrPw.siblings(".label").text("새 비밀번호      8자리 이상 16자리 이하여야 합니다.");
						inputCurrPw.siblings(".label").addClass("error");
					}
				}
				else {
					inputCurrPw.siblings(".label").text("새 비밀번호      특수문자를 입력해주세요");
					inputCurrPw.siblings(".label").addClass("error");
				}
				
			}
		}
	})
})

$("#renewpw").keyup(function(){
	if($(this).val() != $("#newpw").val()){
		$(this).siblings(".label").text("비밀번호를 다시 확인하세요");
		$(this).siblings(".label").addClass("error");
	}
	else{
		$(this).siblings(".label").text("비밀번호가 일치합니다.");
				$(this).siblings(".label").removeClass("error");
	}
})
