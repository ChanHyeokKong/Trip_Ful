<%@page import="review.ReportDao"%>
<%@page import="review.ReviewDto"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="review.ReviewDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="<%=request.getContextPath() %>/Review/carouselStyle.css">
<!-- 팡파레 cnd -->
<script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"></script>


<title>Insert title her</title>
<%
	
	//place_num 얻기
	String place_num=request.getParameter("place_num");	
	ReviewDao rdao=new ReviewDao();
	ReviewDto rdto=new ReviewDto();
	
	//System.out.println(place_num);
	//아이디, 로그인상태 세션값 받기
	String review_id=(String)session.getAttribute("id");
	
	String loginok=(String)session.getAttribute("loginok");
	
	//관광지 이름 얻기
	String place_name=rdao.getPlaceName(place_num);	
	
	//관광지 이름에 해당하는 리뷰리스트
	List<HashMap<String,String>> list=rdao.getPlaceList(place_name);
	
%>
<script type="text/javascript">
$(function() {
		loadReviews();
	   $("#modalBtn").click(function() {	  
		   
		// 폼 초기화 로직
			if(typeof resetModalForm=="function")
		   {
				resetModalForm();
		   }
		
		    
		if(<%=loginok!=null%>){
			openModal();
		}else{
			 swal.fire({
			        title: "로그인이 필요한 서비스입니다.", 
			        text: "로그인 페이지로 이동하시겠습니까?", 			        
			        confirmButtonColor: "#3085d6",
			        cancelButtonColor: "#d33",
			        confirmButtonText: "네, 이동하겠습니다",
			        cancelButtonText: "아니요",  
			        showCancelButton: true
			        })
			          .then((result) => {
			          if (result.value) {
			        	  const currentUrl = window.location.href;
				      	    // 로그인 페이지 주소 + redirect 파라미터로 현재 URL 전달
				      	    const loginUrl = 'index.jsp?main=login/login.jsp&redirect=' + encodeURIComponent(currentUrl);
				      	    location.href = loginUrl;
				      	    return;
			          }
			        })
		}
		 
	}); 	   
	   
	   $(document).on('change', '.sort', function() {
		    loadReviews(); // 정렬 변경 시 리뷰 새로 불러오기
		    $(this).siblings("i.bi").addClass("bi-check-circle-fill");
		    $(this).siblings("i.bi").removeClass("bi-check-circle");
		    $(this).parent(".radio-label").siblings().find("i.bi").addClass("bi-check-circle");
		});
	   
	   
});

function loadReviews() {
	var place_num="<%=place_num%>";
	var review_id="<%=review_id%>";
	var loginok="<%=loginok%>";
	var sort = $(".sort:checked").val(); // 선택된 정렬 방식
	
	//console.log(place_num);
	$.ajax({
		type:"post",
		dataType:"json",
		url:"Review/insertApi.jsp",
		data:{"place_num":place_num,"sort":sort},
		success:function(res){
			 var carouselItemsHtml = ""; // 각 카드를 직접 여기에 넣음
	            var reviews = res.reviews; // 리뷰 리스트
	            var totCnt=0;
                var totStar = 0;
                var starCounts = { "5": 0, "4": 0, "3": 0, "2": 0, "1": 0 }; // 각 별점별 개수 저장
	            
	            if (reviews && reviews.length > 0) { // 리뷰 데이터가 있는지 확인
	            	var totCnt = reviews.length;
	            	
	                
	                
	                reviews.forEach(function(r){	                   

	                    // 각 리뷰마다 카드생성	       
	                    

	                    var reviewCard = "";
	                    reviewCard += "<div class='item'>"; // Owl Carousel의 'item' 클래스
	                    reviewCard += "<div class='card h-100 p-3'>";
	                    reviewCard += "<div class='review-header d-flex justify-content-between align-items-center mb-2'>";
	                    if(r.read =="DB" && r.read !== "")
                    	{
	                    reviewCard += "<a class='r_author' href='<%= request.getContextPath() %>/index.jsp?main=login/MyPage.jsp?id="+r.author+"'>" + r.author + "</a>";
                    	}
	                    else{
	                    	reviewCard += "<b >" + r.author + "</b>";
	                    }
	                    reviewCard += "<div class='categorydate'>";
	                    reviewCard += "<span class='review_writeday'>" + r.date + "</span>&nbsp;&nbsp;";
	                    if(r.read!="Google")
	                    	{
	                    reviewCard += "<i class='bi bi-three-dots-vertical review_category' review_id='"+r.author+"'></i>";	
                    	
	                    reviewCard += "<div class='dropdown-menu'>";

	                    //console.log(r.author, review_id);
	                    				if(r.author == review_id || loginok=="admin" && r.read=="DB")
	                    					{
	                    					reviewCard += "<button type='button' class='delete-btn' review_id='" + r.author + "' review_idx='"+r.review_idx+"'>삭제</button>";               			        
	                    			        
	                    			        if(r.author == review_id){
	                    			        	reviewCard += "<button type='button' class='updateModal' review_idx='"+r.review_idx+"'>수정</button>";
	                    			        }	                    			        

	                    				}else if(r.author!=review_id && r.read=="DB"){	                    					
	                    					reviewCard += "<button type='button' class='report' review_idx='"+r.review_idx+"' loginok='"+loginok+"'>신고</button>"
	                    				}
	                    reviewCard += "</div>";//카테고리 끝
	                    	}
	                    reviewCard += "</div></div>"; //날짜 리뷰헤더 끝        
	                    reviewCard += "<div class='star_rating2 mb-2'>";
	                    reviewCard += "<span>" + r.rating + "</span>&nbsp;&nbsp;";
						reviewCard += "<input type='hidden' id='rating' name='rating' value='"+r.rating+"'>"
						
						
	                    // 별점 아이콘 생성
	                    for (var i = 0; i < Number(r.rating); i++) {

	                        reviewCard += "<span class='rating on' rating='"+r.rating+"'></span>";

	                    }
	                    for (var i = 0; i < (5 - Number(r.rating)); i++) {
	                        reviewCard += "<span class='rating off'></span>"; // 비활성 별
	                    }
	                    reviewCard += "</div>";
						
	                    
	                    
	                    var photos = [];
	                    if (r.photo1 && r.photo1 !== "null" && r.photo1 !== "") 
	                    	photos.push(r.photo1);
	                    if (r.photo2 && r.photo2 !== "null" && r.photo2 !== "") 
	                    	photos.push(r.photo2);
	                    if (r.photo3 && r.photo3 !== "null" && r.photo3 !== "") 
	                    	photos.push(r.photo3);
	                    reviewCard += "<div class='img-con mb-2'>";
	                    if (photos.length > 0) {
	                        photos.forEach(function(photoUrl) {
	                        	//console.log("photoUrl: "+photoUrl);
	                           
	                            reviewCard += "<img src='save/" + photoUrl + "' class='photo' photo='"+photoUrl+"'>";
	                            
	                        });
	                    }
	                    reviewCard +="</div>";

	                    // 리뷰 텍스트
	                    reviewCard += "<p class='card-text'>" + r.text.replaceAll("\n", "<br>") + "</p>";
	                    if(r.read !=="DB" && r.read !== "")
                    	{
                    	reviewCard += "<div class='googlechk mb-2'>";
                    	reviewCard += "<span class='googlereview'>"+r.read+"</span>";
                    	reviewCard += "</div>";                    	
                    	}else{	
                    		var like=Number(r.likeCheck);
                    		if(like==0){
                    			reviewCard += "<div class='liked'><i class='bi bi-heart likedicon' review_idx="+r.review_idx+" loginok="+loginok+"></i>&nbsp;";
                    		}else{
                    			reviewCard += "<div class='liked'><i class='bi bi-heart-fill likedicon' review_idx="+r.review_idx+" style='color:red' loginok="+loginok+"></i>&nbsp;";
                    		}
                    			reviewCard += "<span class='likedcnt'>"+r.likeCnt+"</span></div>";
                    	}
	                    
	                    
	                    reviewCard += "</div>"; // .card 끝
	                    reviewCard += "</div>"; // .item 끝
						
	                    carouselItemsHtml += reviewCard;
	                    
	                    // 별점 통계 계산
	                    totStar += parseFloat(r.rating);
	                    starCounts[parseFloat(r.rating)]++; // 해당 별점 개수 증가
	                });
	              
	            } else {
	                // 리뷰가 없을 경우 대체 메시지
	                carouselItemsHtml = "";
	                carouselItemsHtml += "<div class='item'>";
	                carouselItemsHtml += "    <div class='card p-3 m-2 text-center'>";
	                carouselItemsHtml += "        <p>아직 등록된 리뷰가 없습니다.</p>";
	                carouselItemsHtml += "    </div>";
	                carouselItemsHtml += "</div>";
	            }	           
	            // ⭐⭐⭐ 여기부터 별점 통계 진행 바 업데이트 로직 ⭐⭐⭐
                var avgRating = totCnt > 0 ? (totStar / totCnt).toFixed(1) : 0.0;
                $("#avgRating").text(avgRating);
                $("#totReview").text(totCnt);

                for (let i = 5; i >= 1; i--) {
                    var percentage = totCnt > 0 ? (starCounts[i] / totCnt * 100).toFixed(1) : 0.0;
                    $('.progress-bar.' + getStarClass(i)).css('width', percentage + '%');
                    $('.progress-bar.' + getStarClass(i)).closest('.rating-row').find('.rating-percentage').text(percentage + "% ("+starCounts[i]+")");
                }
				
	        	 // 기존 캐러셀 파괴 및 새 HTML 삽입 후 Owl Carousel 초기화
	            var owl = $('#reviewCarousel');
	            if (owl.data('owl.carousel')) { // Owl Carousel이 이미 초기화되어 있다면
	                owl.owlCarousel('destroy'); // 파괴	
	                 
	            }
	            owl.html(carouselItemsHtml); // HTML 내용 업데이트

	            // Owl Carousel 초기화
	            owl.owlCarousel({
	                loop: false, // 마지막에서 처음으로 돌아가지 않음 (원한다면 true로 변경)
	                margin: 10,
	                nav: false, // 이전/다음 버튼 표시
	                dots: false, // 점(인디케이터) 표시
	                responsive: { // 반응형 설정
	                    0: { // 0px 이상
	                        items: 1, // 1개씩 보여줌
	                        slideBy: 1 // 1개씩 슬라이드
	                    },
	                    768: { // 768px 이상 (태블릿)
	                        items: 2, // 2개씩 보여줌
	                        slideBy: 1 // 1개씩 슬라이드
	                    },
	                    992: { // 992px 이상 (데스크탑)
	                        items: 3, // 3개씩 보여줌
	                        slideBy: 1 // 1개씩 슬라이드
	                    }
	                }
	            });
	            
	            
	    },	    error: function(xhr, status, error) {
	        console.error("AJAX 실패:", status, error);
	        console.log("응답 텍스트:", xhr.responseText);
	        alert("리뷰 데이터를 불러오는 중 오류가 발생했습니다.");
	  	    // ⭐ 오류 시에도 통계 초기화 ⭐
            $('#avgRating').text('0.0');
            $('#totReview').text('0');
            for (let i = 5; i >= 1; i--) {
                $('.progress-bar.' + getStarClass(i)).css('width', '0%');
                $('.progress-bar.' + getStarClass(i)).closest('.rating-row').find('.rating-percentage').text('0%');
            }
	    }   
	});	
}   
//별점 클래스명을 반환하는 헬퍼 함수
function getStarClass(star) {
    switch (star) {
        case 5: return 'five-star';
        case 4: return 'four-star';
        case 3: return 'three-star';
        case 2: return 'two-star';
        case 1: return 'one-star';
        default: return '';
    }

}

</script>
</head>

<body id="review_body">

	<!-- 모달 버튼 -->
<div class="review_container">
	<div class="input-group" >
	<div class="rating-summary">
    <h4>별점 통계</h4>
    <div class="rating-row">
        <span class="rating-label">5점</span>
        <div class="progress-bar-container">
            <div class="progress-bar five-star" style="width: 0%;"></div>
        </div>
        <span class="rating-percentage">0%</span>
    </div>
    <div class="rating-row">
        <span class="rating-label">4점</span>
        <div class="progress-bar-container">
            <div class="progress-bar four-star" style="width: 0%;"></div>
        </div>
        <span class="rating-percentage">0%</span>
    </div>
    <div class="rating-row">
        <span class="rating-label">3점</span>
        <div class="progress-bar-container">
            <div class="progress-bar three-star" style="width: 0%;"></div>
        </div>
        <span class="rating-percentage">0%</span>
    </div>
    <div class="rating-row">
        <span class="rating-label">2점</span>
        <div class="progress-bar-container">
            <div class="progress-bar two-star" style="width: 0%;"></div>
        </div>
        <span class="rating-percentage">0%</span>
    </div>
    <div class="rating-row">
        <span class="rating-label">1점</span>
        <div class="progress-bar-container">
            <div class="progress-bar one-star" style="width: 0%;"></div>
        </div>
        <span class="rating-percentage">0%</span>
    </div>
    <div class="overall-rating">
        <strong>평균 별점: <span id="avgRating">0.0</span></strong> (<span id="totReview">0</span>개 리뷰)
    </div>
</div>
	<div class="review-form-wrapper">
	<button id="modalBtn"><i class="bi bi-pencil-square"></i>&nbsp;리뷰 작성</button>	
		<div class="radio_sort">
			<label class="radio-label">
				<input type="radio" class="sort" name="sort" value="latest" checked="checked">
				<i class="bi bi-check-circle-fill"></i>&nbsp;최신순
			</label>
			<label class="radio-label" >
				<input type="radio" class="sort" name="sort" value="likes">
				<i class="bi bi-check-circle"></i>&nbsp;좋아요순
			</label>			
			<label class="radio-label">
				<input type="radio" class="sort" name="sort" value="rating">
				<i class="bi bi-check-circle"></i>&nbsp;별점순
			</label>			
		</div>
	</div>
	</div>
	<div class="container mt-3">
			
			<div id="reviewCarousel" class="owl-carousel owl-theme">  
								
			</div>			
		
	</div>
</div>
	







	<!-- 모달 창 -->
	<div id="myModal" class="modal">
		<form id="modalform" class="modalfrm" enctype="multipart/form-data">			
			<div align="center" class="modal-head">
				<input type="hidden" name="place_num" value="<%=place_num%>">
				<input type="hidden" name="review_idx" value="">		
				
				
				
				<h4><%=place_name %></h4>
				<br>
			</div>
			<div class="modal-content">
				<table>
					<tr>						
						<td class="review_id">
						<input type="hidden" name="review_id" value="<%=review_id%>">
						<b><%=review_id %></b><br> <br>
						</td>
					</tr>
					<tr>
						<td class="input-group">
						<input type="hidden" name="review_star" id="review_star" value="0">
							<div class="star_rating">
								​​<span class="star" value="1"> </span> 
								<span class="star" value="2"> </span> ​​
								<span class="star" value="3"> </span> ​​
								<span class="star" value="4"> </span> ​​ 
								<span class="star" value="5"> </span>
							</div></td>
					</tr>
					<tr>
						<td><textarea class="review_content" name="review_content"
							 placeholder="이곳에 다녀온 경험을 자세히 공유해 주세요." required="required"></textarea></td>
					</tr>
					<tr>
						<td>
							<div class="upload-btns">
								<div id="show1"  class="img-con">
									<label class="btn-upload">
										<i class="bi bi-camera-fill camera"></i>
										<input type="file" name="review_img1" id="file1" class="review_img">
									</label>
									<input type="hidden" name="delete_img1" value="false" class="delete_img">
								</div>
								<div id="show2" class="img-con" >
									<label class="btn-upload">
										<i class="bi bi-camera-fill camera"></i>
										<input type="file" name="review_img2" id="file2" class="review_img">
									</label>
									<input type="hidden" name="delete_img2" value="false" class="delete_img">
								</div>
								<div id="show3"class="img-con" >
									<label class="btn-upload">
										<i class="bi bi-camera-fill camera"></i>
										<input type="file" name="review_img3" id="file3" class="review_img">										
									</label>
									<input type="hidden" name="delete_img3" value="false" class="delete_img">	
								</div>
							</div>
							<br><br>
						</td>
					</tr>

				</table>
			</div>
			<div class="modal-foot">														
				<button type="button" id="btn-write" class="">게시</button>
				<button type="button" class="close" id="closeBtn">취소</button>
				
			</div>
		</form>
	</div>	

</body>

</html>
