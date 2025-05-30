<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="review.ReviewDao"%>
<%@page import="review.ReviewDto"%>
<%@page import="place.PlaceDto"%>
<%@page import="place.PlaceDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<title>Insert title here</title>
<%
	request.setCharacterEncoding("utf-8");

	String num=request.getParameter("place_num");

	PlaceDao dao=new PlaceDao();
	
	PlaceDto dto=dao.getPlaceData(num);
	
	String [] img=dto.getPlace_img().split(",");
	
	ReviewDao rdao=new ReviewDao();
	
	double star=rdao.getAverageRatingByPlace(num);
	
	List<ReviewDto> list=dao.selectReview(num);	
	
	String loginok=(String)session.getAttribute("loginok");
	
%>
<style type="text/css">
body {
    font-family: 'Arial', sans-serif;
    margin: 0;
    background-color: #f5f5f5;
}

.container {
    max-width: 1000px;
    margin: 0 auto;
    padding: 20px;
    background-color: white;
}

.place-title {
    font-size: 32px;
    margin-bottom: 20px;
    border-bottom: 2px solid #ccc;
    padding-bottom: 10px;
}

.main-section {
    display: flex;
    gap: 20px;
    margin-bottom: 40px;
    align-items: flex-start;
    min-height: 320px;
}

.carousel {
    width: 500px;
    flex-shrink: 0;
}

.carousel-inner img {
    width: 500px;
    height: 500px;
    object-fit: cover;
    border-radius: 10px;
}

.image-box img {
    width: 400px;
    height: auto;
    border-radius: 10px;
}

.info-box {
    flex: 1;
}

.description {
    font-size: 16px;
    margin-bottom: 15px;
}

.category, .location {
    font-size: 14px;
    color: #666;
}

.review-section h2 {
    font-size: 24px;
    margin-bottom: 20px;
}

.review-card {
    background-color: #f9f9f9;
    padding: 15px;
    border-radius: 10px;
    margin-bottom: 15px;
    box-shadow: 0 2px 5px rgba(0,0,0,0.1);
}

.review-header {
    display: flex;
    justify-content: space-between;
    margin-bottom: 8px;
}

.review-user {
    font-weight: bold;
}

.review-date {
    font-size: 12px;
    color: #999;
}

.category-views {
    font-size: 14px;
    color: #666;
}
</style>
</head>
<script>
$(function(){
	
	$("#like").click(function(){
		
		var num=$("#num").val()
		
		$.ajax({
			
			type:"get",
			url:"place/likeAction.jsp",
			dataType:"json",
			data:{"place_num":num},
			success:function(res){
				
				var like=res.place_like;
				
				$("#likecount").text(like);
				
			}
		})
		
	})
})

  function initMap() {
    const map = new google.maps.Map(document.getElementById("map"), {
      zoom: 15,
      center: { lat: 37.5665, lng: 126.9780 }, // 초기값 (서울)
    });

    const placeId = "<%=dto.getPlace_code() %>"; // 예시 Place ID

    const request = {
      placeId: placeId,
      fields: ["name", "geometry"], // geometry에 위도/경도 포함
    };

    const service = new google.maps.places.PlacesService(map);
    service.getDetails(request, (place, status) => {
      if (status === google.maps.places.PlacesServiceStatus.OK) {
        const location = place.geometry.location;
        map.setCenter(location);
        new google.maps.Marker({
          map: map,
          position: location
        });
      } else {
        console.error("Place ID lookup failed:", status);
      }
    });
  } 
</script>

<script
  src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDpVlcErlSTHrCz7Y4h3_VM8FTMkm9eXAc&libraries=places&callback=initMap"
  async defer></script>
<body>
<div class="container">
        <h1 class="place-title" align="center"><%=dto.getPlace_name() %></h1>
        <div class="category-views d-flex justify-content-between align-items-center mb-2">
    	<p class="category m-0">카테고리: <%=dto.getPlace_tag() %></p>
   	 	<p class="views m-0">조회수: <%=dto.getPlace_count() %></p>
   	 	<p class="views m-0">별점: <%=star==-1.0?"없음":star%></p>
   	 	<input type="hidden" id="num" value="<%=dto.getPlace_num()%>">
<!-- 좋아요 아이콘과 텍스트 묶기 -->
<div class="d-flex align-items-center gap-1">
  <img alt="좋아요" src="./image/places/white_heart.png" style="width: 25px; height: 25px;" id="like">
  <span>좋아요: <span id="likecount"><%=dto.getPlace_like() %></span></span>
</div>
		</div>
        <div class="main-section">
           <!-- Carousel -->
<div id="demo" class="carousel slide" data-bs-ride="carousel">

  <!-- Indicators/dots -->
<div class="carousel-indicators">
  <% for (int i = 0; i < img.length; i++) { %>
    <button type="button" data-bs-target="#demo" data-bs-slide-to="<%=i%>" class="<%= (i == 0 ? "active" : "") %>"></button>
  <% } %>
</div>
  
  <!-- The slideshow/carousel -->
  <div class="carousel-inner">
  <%
  	for(int i=0;i<img.length;i++){
  %>
    <div class="carousel-item <%= (i == 0 ? "active" : "") %>">
      <img src="./<%=img[i] %>" alt="Los Angeles" class="d-block" style="width:500px;">
    </div>
   
    <%} 
    %>
  </div>
  
  <!-- Left and right controls/icons -->
  <button class="carousel-control-prev" type="button" data-bs-target="#demo" data-bs-slide="prev">
    <span class="carousel-control-prev-icon"></span>
  </button>
  <button class="carousel-control-next" type="button" data-bs-target="#demo" data-bs-slide="next">
    <span class="carousel-control-next-icon"></span>
  </button>
</div>
            <div class="info-box">
                <p class="description"></p>
                <p class="location">위치: </p>
                <div id="map" style="width: 100%; height: 400px;"></div>
                <p class="address">주소:<%=dto.getPlace_addr() %>
            </div>
        </div>

		<div>
				<%=dto.getPlace_content() %>
		</div>
		
<div class="review-section">
  <h2>방문자 리뷰</h2>


  <div class="review-card">
    <jsp:include page="../Review/reviewList.jsp?place_num=<%=num %>"/>
  </div>
	
</div>
    </div>
</body>
</html>