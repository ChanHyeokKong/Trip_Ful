<%@page import="review.ReviewDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<%
  	String loginok=(String)session.getAttribute("loginok");	
	ReviewDao rdao=new ReviewDao();

  %>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>관광지 선택 페이지</title>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link
    rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    integrity="sha512-pV3hRu9Ai27skZPw9E6oTkfR6CTNKv8p4WyMWlP7JjC1kZlyFlzM2t1y1LmB1mD9H9/HEPVN+7W4M+6EGBMRMw=="
    crossorigin="anonymous"
    referrerpolicy="no-referrer"
  />
    <style>
        header {
            background-color: transparent;
            color: #212529;
            text-align: center;
            padding: 2rem 1rem 1rem;
            margin-bottom: 1.5rem;
        }

        header h1 {
            margin: 0;
            font-size: 2rem;
            font-weight: 600;
        }

        .container {
            padding: 2rem;
            max-width: 1000px;
            margin-top: -100px; !important;
        }

        .selection-buttons,
        .continent-row,
        .country-button-row {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            align-items: center;
            gap: 1rem;
            margin-top: 2rem;
            margin-bottom: 2rem;
            text-align: center;
        }

        .selection-buttons button,
        .country-button-row button {
            padding: 0.75rem 1.5rem;
            background-color: #fff;
            border: 2px solid #2196f3;
            color: #2196f3;
            cursor: pointer;
            border-radius: 0.5rem;
            transition: all 0.3s ease;
        }

        .selection-buttons button:hover,
        .country-button-row button:hover {
            background-color: #2196f3;
            color: white;
        }

        .country-button-row button.active {
            background-color: #1976d2;
            color: white;
            font-weight: 500;
        }

        .sort-dropdown {
            padding: 0.75rem 1.5rem;
            border: 2px solid #2196f3;
            border-radius: 0.5rem;
            font-size: 1rem;
            color: #2196f3;
            background-color: #fff;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .sort-dropdown:focus {
            outline: none;
            border-color: #2196f3;
            box-shadow: 0 0 0 2px rgba(33, 150, 243, 0.2);
        }

        /*.sort-dropdown:hover {*/
        /*    background-color: #2196f3;*/
        /*    color: #fff;*/
        /*}*/

        .places {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1rem;
            max-width: 1500px;
            margin: 0 auto;
        }

        .place-card {
            width: 300px;
            border: 1px solid #ddd;
            border-radius: 0.5rem;
            overflow: hidden;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            height: 270px;
            background: #fff;
        }

        .image-wrapper {
            height: 210px;
            overflow: hidden;
        }

        .image-wrapper img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
            transition: transform 0.3s ease;
        }

        .place-card:hover .image-wrapper img {
            transform: scale(0.95);
        }

        .text-container {
            padding: 0 3px 3px 3px !important;
        }

        .caption {
            font-weight: 600;
            font-size: 1.1rem;
            margin: 8px 10px 6px;
            text-align: center;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            color: #333;
        }

        .rating {
            font-size: 0.7rem;
            color: #f39c12;
            margin: 2px 0;
            text-align: center;
        }

        .text-area {
            background-color: #f9f9f9;
            padding: 8px 10px;
            border-top: 1px solid #ddd;
            border-radius: 0 0 0.5rem 0.5rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            font-size: 0.85rem;
            color: #555;
        }

        .info-item {
            display: flex;
            align-items: center;
            gap: 4px;
            white-space: nowrap;
        }

        .info-item.rating {
            color: #f39c12;
            font-weight: 700;
        }

        .info-item.no-rating {
            color: #bbb;
            font-style: italic;
        }

        .info-item.views {
            color: #3498db;
        }

        .info-item.likes {
            color: #e74c3c;
        }

        .text-area .icon {
            font-size: 0.5em;
            margin-right: 3px;
        }

        .top-button-row {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .allshow {
            margin: 10px 10px;
        }

        #selection-area h4 {
            text-align: center;
            color: #333;
            font-weight: 500;
            margin: 2rem 0 1rem;
        }
    </style>

</head>
<body>

  <header style="margin-top: -50px; margin-bottom: 70px;">
    <h1>관광지 선택</h1>
  </header>

<div class="container">
  <div class="selection-buttons" id="global-controls">
    <!-- 🔽 정렬 드롭다운 추가 -->
    <select id="sortSelect" class="sort-dropdown">
      <option value="views">조회순</option>
      <option value="rating">별점순</option>
      <option value="likes">좋아요순</option>
    </select>
  <%
  	if("admin".equals(loginok)){
  %>
  	<button type="button" onclick="location.href='place/insertPlace.jsp'">관광지 추가</button>
  
  <% }
  %>
  </div>

  <div id="selection-area" class="text-center">
    <h4>지도를 클릭하여 대륙을 선택하세요.</h4>
</div>

<div class="lb-xlarge-show lb-mid-pad lb-none-v-margin lb-grid" style="padding-top:0px;"> 
    <div class="lb-row lb-row-max-large lb-snap"> 
        <div class="lb-col lb-tiny-24 lb-mid-24"> 
            <div id="aws-world-map" class="m-map-dark m-gi-map">
                <svg class="m-gi-map-svg"  xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1280 710" preserveAspectRatio="xMidYMid meet" role="img" focusable="false" aria-labelledby="m-gi-asset-title-aws-element-b7ba4e20-ac1f-45cd-97c4-09c619e1bf87">
                    <title id="m-gi-asset-title-aws-element-b7ba4e20-ac1f-45cd-97c4-09c619e1bf87">World Map</title>
                    <style>
                        /* 기본 지도 스타일 */
                        .m-gi-map-svg .m-gi-map-area {
                            fill: #b0bec5; /* 부드러운 블루그레이 */
                            cursor: pointer;
                            transition: fill 0.3s ease, stroke 0.3s ease;
                        }

                        /* 호버 및 포커스 */
                        .m-gi-map-svg .m-gi-map-area:hover,
                        .m-gi-map-svg .m-gi-map-area:focus {
                            fill: #90a4ae; /* 살짝 진한 그레이블루 */
                            stroke: #ffffff;
                            stroke-width: 2.5px;
                            paint-order: stroke;
                            filter: drop-shadow(0 0 4px rgba(0, 0, 0, 0.15));
                            outline: none;
                        }

                        /* 선택된 대륙 */
                        .m-gi-map-svg .m-gi-map-area.selected-continent {
                            fill: #1e88e5; /* 진한 블루 (명확하게 강조) */
                            stroke: #ffffff;
                            stroke-width: 3px;
                            filter: drop-shadow(0 0 6px rgba(30, 136, 229, 0.5));
                        }
                    </style>

                    <rect fill="transparent" x="0" y="0" width="100%" height="100%"></rect>
                    <path class="m-gi-map-area" data-id="na" data-continent-name="namerica" d="M427 385l-1-1 1 1zm0 1h-1 1zm-48-21v-1h-1v1h1zm-2-2l1 1v-3h-1v2h-1 1zm13 6l-1 1h1v-1zm-10-13l-2-1 2 1v2s0 1 0 0l1-1-1-1zm9 12l1 1-1-1zm-3-1l1 1v-1l-1-1v1zm-4-7h-1l2 1-1-1zm2 6h1-1zm-4-5h-1 1zm5 2v1h1l-1-1s0-1 0 0zm-9-7h-1l1 1 2-1h-2zm17 14h1-2 1zm0 2zm-2 2h1l1-1-1 1h-1zm42 24h1-1zM225 261h-1v2h1v1l-1-1v1l1-1v-2zm188 35v-1h-1l1 1zm-172-18l-1-1 1 1zm-5-4v-1 1zm-12-13h-1c0 1 1 1 0 0h1zm187 33l1 1-1-1zm21-4v-1c0-1 0 0 0 0h-1v-1h-1v1c0 1 0 0 0 0l-1 1s-1 0 0 0v-1h1v-1l1-2v-1c-2 0-2 2-3 3l-1 2 2 1h1l2-1zm-7-2h1-3l-2-1h-1v-2l-1 1v1l1 1 2 1v-1h1v1h1l1-1zm-184-10c-1 0 0 1 0 0 0 1 0 0 0 0zm-3-3l1 1c0-1-1-2-2-1h1zm189 2l-2-1-2-1-2-1h-3l2 1 1 1 1 1h5zm-191-4h-1l1 1v-1zm2 7h3v-1l-2-2s-3-1-2-2l-1-1-2-2h-3c-1-1-3-2-4-1v1h1v1h2v1h1l1 1s0 1 0 0l-1-1v1l1 1h2l-1 1h1l1 1 2-1-1 2 2 1zm216 3h-2l1-1v-1l-1 1-1 1h-1l1-1h-1l1-1 1-1h1v-1h-1c0 1 0 0 0 0l-1 1h-1l1-1h-2l2-1v-1h-2v-1h-1l-1 1h-1v-1c0 1 0 0 0 0h-2v-1l1-1h-2v-1 1l-2 1c1 0 0 0 0 0l1-1v-1l1-1 1-1 1-2h-1l1-1 1-1-1 1h-2l-1 1-1 1v1h-1l-1 2-1 2 1 1h-2l1 1v1l-1-1-1 1v1h-1v1h2l-2 1-1 1 1 1h8l1-1s0 1 0 0v2h2v-1h2l-1 1-1 1-2 1h1l2-1v-1l2-1-1 1 1-1 1-1v4l1-1v2h2v-2l1-2zm-227-15v-1 1zm-9-3zm8-1l1-1-1 1zm140-2l3 1h1l-1-1-2-1-1 1zm-148 3h-1l1-1c-1 0 0 0 0 0h-1v-1h-1l-1-1h1v-1h-2v1h1c-1 1 0 1 1 1l1 2h1zm4-4l-1-1h-1l1 1h1zm-2-3v-1l-1 1h1zm-6 3h1l1-2v-2l-1 1v1h-1c-1 0 0 0 0 0l1-1-1-1h-2v1l1 2 1 1h-1 1zm5-6l-1 1 1-1zm156-7l-1-1-1 2v-2 2l-1 1 1-1-1 1h1l1-1v1l1-1v-1zm0 1l1-1-1 1zm-1-26l-1-2-2 1v2l1 1 2-2zm-8-4l-1-1h-2v1h-1l-1 1-1 1 1 1h1l1-1 2-1 1-1zm12-1l1-1-1-1h-2l2 2zm2-3c0 1 1 2 2 1l-2-1zm-1-1v-1s-2 1 0 1zm-8 1v-1h-1l-1-1h-3l1-1-1-2h-2l-1-1-2-1h-2l-1-2-1 1-1-1v-2h-1l-2 3v5l-1 1-2 2h4c1 0 0 3 2 3l2-1 1-1 1-1v-1l1-1h2l1 1 1 1h1l3 1 1-1h1zm-10-11l-2-1h-1l1 1v1h2c-1 0-1 0 0 0h1s-2 0-1-1zm27-9h3l1-1-1-1h-3v2zm-4-3h-2l-1 1v4h3c2 0 3-1 2-3v-2h-2zm-9 0h-1v1l1-1zm12-1l-1-1v1l1 1v-1zm-12-3l-1 1 2-1v-1l-1 1zm7-2h-2v1c1 1 2-1 2-1zm-6 0l1-1v-1l-1 1-1 1h1zm-3-2h-4l1 1h1v1l1-1s2 0 1-1zm-50 3l-2-2h-2l-2-1v2l-1-1v1l-1 1-2 1v1h4v1h1l2 1h2l1-1h1l2-1h-1l-2-2zm112 83l1-1h1l2-1h2l1-1 2-1 1-1-1-1h1-2l1-1v-1l1-1-1-1-1-1h-1l-2 1-1-1h1l-1-2h-1l-1 1h-1l-2 1-2 1-1 1v-1h1l-1-1h1l2-1h2v-1h1l1-1h1l1-1h-2v-1h-1v1l-1-1c-1 0-1-2-2-1l-1 1h-1l2-1h-4 1v-3l-1 1v-1h-2v-1h-1c-1-1 0-1 1-1h-2l1-1h-1l-2-1h2l1 1 1-1v-1h-1l-1-1c1-1-1-1-2-1l2-1v-1h-1l-1-1h-1l-1 1 2-2h-3 1l1-1v-1h-1v-1h-2 2l-1-1h-1l1-1-1-1h-1v-1h-1v-1h-1v2s-2-1-2 1l2 1-1-1v1h-1l1 1h-1v1h-1v2l-1-2-1 2h-2l-1 1v-1l-1 1v-1c-1-1-1 0-1 1l-1 1h-1l2-1v-2l-1-1h-2l-1 1h-1v-1h1l1-1h-1l1-1h-1v-3h-3l3-1v-4 1h-1l-1-1h-3l-1-1c-2 0 0-1 0-1l-1-1-1 1v-1l-1-1-1 1 1-1-1-1-1-1h-2l-2 1h-4 1l-3-1-3-1c-1 1-2 1-2 3l2 2v1l-1 1-1 1h2l-1 1 1 1v2h1v1h-1l1 1-1-1-1 1v1s1 0 0 0v1l-1 1-1 1 1 1 3 2c2 1 2 4 2 6l-1 3-2 2-3 2h-2l-1 1v1l1 1 1 1c-1 0 0 0 0 0v4h1v4l-1 1 1 1h-3v1l1 2-2-2h-3l1-1-1-1-1-1-1-1h-1l1-1h-1v-1l-1-1v-4l-1-1 1-1v-3h-2l-3-1-2 1-1-1-1 1v-1h-1l-2-1-2-1-2-1-2-2-2-1-3-1-2-1h-3l-2 1h-2l1-2-1-3-1-1v-1h-3l-1-1h-1v-7h1v-1l1-1v-2c1 0 0 0 0 0h1v-1l1-1h1l-1-1h1c-1 0 0 0 0 0v-1h1l-1-1h1l1 1v-1c-1 0-1 0 0 0v-1h1v-1c-1 0 0 0 0 0h2l2-1 1-1-2-1h-1l-1-1-2 1 1-1-2-1h-2v-1l2 1h3l1 1h4v-1h1l-1-1h2l1 1v-1c1 1 3 0 4-1l3-4-4-1h-3l-1-2-3-1s-2 0-1 1l-2-1h6l1 1h1l1 1h1l1 1h2l2-2s3-2 1-2l-1-1v-1s-1 0 0 0h3l2 1 1 1v-1l2 1v-2l-1-1h-1v-1h-1v-1l2 1v1h1v1l1 1 1-1h2l1-2h2l1-2-1-2-1-1v-2l-1 1v-1c-1 0 0 0 0 0l-1-1h2l2-1-2-1 2-1-1-1h-2v-1h-2l2-1h-2l-3-1h-5v1l1 2 1 1-1 1h1l-1 1-1-1v2l-1 2-2 2v1l-1 1-1 1-1-1-2-2v-3c1 1 1 0 1-1l-1-2-1-1-2-1-2 2v2l-1 1-1-1v-2l-1-1-1-1 1-1h-2l1-1h-5l3-2h-2v-1h3l-1-1s0 1 0 0c-1 0 0 0 0 0l-1-1-1-1-1-1v-1l-1-2-2-1v-1h-1l-1-1h-2l-1 1-1 2h1v1l-1-1-1 1h-1v3h2v1h-1l-1 2 1 1 1 1h1l2 1h1l1 1h2l-1 1v-1l-1 1v1l-1 1h2s0-1 0 0l1 1-1 1-1 1-2 1h-1l-1 2v1l1 2-1 1h-2c0 1 2 1 1 2l-1-2v-1 1h2v-1h-1v-1h-1l-1-1 1-1v-1l1-2-2 1h-1l1-1h-1l-1-1h-2l-1 1h-1v1l1 1h3l-1 1c-1 1-2-1-3-1l-1-1 1 1-1 1h-2l-3-1-2 1h-3l-2-1-1-1h-3a2 2 0 0 1-1 0l-1-1h-1l-1-1v-1l-1-1-4 1h-3l-1 2v1h2v-1h2l1-1 1 1v-1l1-1 1 1h-1l-1 1c0 1 0 0 0 0l-1 1h-3v2l1 1v2h1s-1 0 0 0v1h-2l2 3-2-2-2-2h1v1h1v-3l-1-1v1l1 1h-2v-1h-1c0 1 0 0 0 0-1-2-2-1-3-1v-1h-1l-2 1-1-1-2 1h-8l-1-1h-2 1v-1l1-1h3l-1-1-1-1-3-1-2-1v1h-3l-3-1-2-1h-2l-3-1-3-2h-4l-1 1-1 1h-3l1-1-1-1v-2h-1l-1 1h1l-1 1-1 1v1l-2-1-2-2-2-2-2-1v1l1 1h-1l-1 1-1 1h-1l1-1-4 1-3 3v-1h-1c1 0 0 0 0 0h-1l-3 2v1h-1v1l-1-1 1-1 1-1h1l2-2h3l2-1 2-2h-1l-1 1-1-1-2 1h-1l-1 1-1 1h-2l-1 1h-2l-1 1v-2h-1v1h-2l-1 1h-1v1h1c-1 0-2 0-1 1h1l1 1-3-1h-2l-5-2-2-1-3-1h-4l-1-1h-1l-1-1h-2l-1-1h-1l-1 1h-3l-2-1h-6v-1h-3l-1-1h-1l-2 1-1-1h-2l-1 1h-2l1-1h-2v-1l-1-1h-3l-1 1-2-1-1-1h-1l-1 1h-1l1-1-1-1h-2l1-1-3 2-2 1h-1l-1 1h-2v-1l-1 1-1 1h1v1h-1v-1c-1-1-2 1-3 1l-2 1h-1 1-1l-2 1-1 2-1 1-1 2-3 1h-5l-1 3v-1 1h1l1 1h1l4 2 1 1 1 2 2 1h1l1-1h1l1 1v1c-1 0 0 0 0 0l1 1 1-1 1 1h1c1 1 0 1-1 1l-2-1h-1l-1-1-1-1v1l1 1 1 1h1l1 1-1-1h-1v1h-7v-2h-3l-1 1h-1v1h-3l-1 1h-1l-1 1h-1c-1 1 1 1 2 2h4-1v1h-2l2 1v1l3 1h7l-1-1 1 1 1 1v-1l2-1h2l1-1 1 1-1 1h-1l1 1v1l1 1c0 2-2 2-3 2h-2l-1 1-2 1h-1v-1h-2v1c-1-1-2 1-1 2v1h-2l-1 2-1 1h1c-1 1-2 0-1 1v1h1v1l1-1v1h1v1h3l2 1h-3v-1h-1l-1 1-1 1h1l1 1h1v1h1v1h1l2-1h2l-1-1c1 0 1-3 2-2l-1 2 1 1v4h1v1l-1 1h2l1-1h1l1-1v1h3l1 2 1-1v-1l1-1 1 1h-1l1 1 2-1 2-1-1 2-1 1c-1 1 0 1 1 1h-2v1l1 2h-2v1h-1l-1 2h-1l-1 1h-1l-2 2v1h-2c0-1 0 0 0 0h-1a1362 1362 0 0 0-2 0l-2 2-1 1h-1v1l1-1h2c0 1 0 0 0 0l2-1v-1h2c-1 0-2 1 0 1h1v-1h1a8 8 0 0 1 2-1v1l1-1h2l1-1s-1 0 0 0v-1l1-1s1 0 0 0h1l1-1 2-1 1-1v-1h2v-1l2-1h1v-1h2-1l1-1 1-1 1-1-1-1h-1v-1l1-1 1-1v1l1-1 1-1c1-1 0-1-1-1h1l1-1 1-1h1v-1l2-1 1-1h3l1-1-1 1h-1v1l2 1h1-3l-1-1-2 1-1 1v1l-1 2v2l1-1h1l-1 1h-1v2l1-1h2v-1h2v-1h1v-1 1l1-1h3v-1h1v-1h-2l1-1c1 0 0 0 0 0v-2h1l1-1v2h1l1-1s0 1 0 0h2l-1 1h1v1h2v1h2l1-1v2l2 1c-1 0 0 0 0 0h7l1-1v1c1 1 3 2 4 1h1l1-1 1 1-1 1v-1l-1 1 2 1 2 1 2 1 2 2 1 1 1-1h1l-1-1-1-1h-1v-1l2 1c1 1 1 0 1-1v1h1l-1 1h1v1h1l1 1v-2l-1-2v-1l1 2v1l1 1h1v1l2-1-1 1 1 1s0 1 0 0h2l-1 1 1 1-1-1v3h2v1h1v1l1 1h1l1 1h-1l-1 1v1l1-1 2-1v1l1 1v1c0 1 0 0 0 0l-1 1 1 1h1l1-1v-3 3l1-2 1 1-2 1v1l-1 1v2h1v1l-1 1 2 1 1 1 1-1v-1l2-1-1 1 1 1 2 1-2-1h-1v-1h-1v1l1 1 1 1h1v2h1-1v1h-1l1 2 1-2h1l1-2v1l1 1h-1l-1-1-1 2v2l1-1-1 2 2 1h2v1s-1 0 0 0h2l-2 1h2l1-1 1 1 1-2v1l-1 1 1 1v1l2 1 1-1v-1 1l1 1-1 1h1l1-1v1h1l-1 1v1h1l1 2h-1 1v1l1 1h-1v3h-2 1v-2h1v-1l-1 1-1 1h1-1l1-2v-1h-4l-2-1v2l1 1 1 3h1l-1 1h1v1l-1-1v1h2l1 1-1-1h-2l1 2v1l-1 3v5l-1 1v3l1 1v4l-1 2 1 1 1 2v2l1 1 1 1 1 1-1-1v1l2 1v-1h3-3l1 1v1l-1-1v2l2 2c-1 1 0 1 1 2l1 1 1 1v2l1 1h1l2 1h1l1 1h1l1 1 1 1 1 1 1 1v1l1 1v1l1 1v1l1 1v2h1v1l1 1 1 1 1 1 2 1v3s-1 0 0 0h-3l2 2 1 1h1v1h1l1-1 2 2 1 3v1l1 1v1h1l1 1 1 1 1 1 2 2 1-1v-1l-1-1a5 5 0 0 0-1-1c-1 0 0 0 0 0h-1l-1-1v-2l-1-1v-1l-1-2v-1h-1s1 1 0 0l-1-1v-2h-1l-1-1v-2h-1v-1h-1l-3-2-1-3v-4l2 1h1l1 1h1v1l1 2 1 2v1l1 1 1 2h1l1 1 2 1v2l1 1h1v1h1l1 1c-1 1-1 3 1 2l-1 1h2l1 1v1l1 1 3 2 1 2 2 2 1 1v2l1 1v1l-1 1h1l-1 1v1l1 2 3 1 2 2 2 1 2 1h1l1 1h1l2 1 3 2h3l1 1 1 1h2l2 1 2-1 2-1h1v-1 1h1l2 1-2-1 7 5 3 2h2l2 1 2 1h5l1 1h-1l1 1 1 1 1 2 2 1v1l1 1-1 1 1 1c1 1 1 2 2 1v-1l-1-1 2 2v1h2l1 1v1h-1l2 1-1-1 1 1 1 1 1-1h1l1 1h1v1h1l1-1v2h2l1-1-2-1 1-1 1-1 1-1h2l1 1 1 1 1 1-1-1-1 1 2 2 1-1h1v-3l-3-2h-2l-1-1h-1l-1 1h-1l-1 1-1 1h-2l-1-1h-1v-1l-1-1h-1l-2-3-1-1v-1l1-1-1-1h1v-5l1-1v-2s0-1 0 0v-1l-1-1h-1l-1-1 1 1-2-2h-10l-1 1-1-1c0 1 0 0 0 0h-1l1-1 1-2v-5l1-1v2l1-2v-1c0-1 0 0 0 0v-3l1-2 1-1v-2h-1v1l-2-1h-2l-1 1-4 1-1 2v2l-1 1v1l-2 1h1c-1 0 0 0 0 0l-1 1h-1v-1h-1l-2 1h-3l-1 1-2-1-1-1h-2l-1-1v-1l-1-2-1-1-2-3-1-2 1 1v1l1-1h-1l-1-2v-5l1-4 1-2v-1l-1-3v-1h-1 1l1-1v-2 1l1-1v-1h1v-1 1h2-1l3-1 1-1v-2 1h2l1-1v-1 1h3l2 1 1-1h1l1 1v1h2s0-1 0 0h1v-1h2l1 2v-1h1l-1-1h-1v-1h1l-1-1h-3l1-1h1l1 1 1-1h3l1-1v1h2l1-1-1 1h2l2 1 1-1v1l1 1h-1 4v-1h2l1 2 1 1v5l1-1h1l-1 1 1 2h1v1c0 1 0 0 0 0v1l1 2h1v1l1 1h-1 2l1-1v-1l1-3-1-2-2-5 1 2v-1l-2-3v-3l-1-1v-2h1v-2s1 0 0 0h1v-2h1c0 1 1 0 0 0h1l1-1 1-1h1v-1l2-2h1l1-1v1l2-2v-1 1h1c0-1 0 0 0 0l2-1h-2v-1h1v-1h-1 2l1-1c0-1 0 0 0 0v-1h-2v-1 1h1v-1l1 1v-2 1l1 2-1-2-1-2h-1v-1h-2 2l1 1-2-2h2l-3-2 2 1h1l-1-1-1-1h-1l1-2-1 1 1 1 2 1-1-2 1 1-1-1v-2c0 1 1 1 0 0l1-1h1s-1 0 0 0l-1 1v3h1v1h1c0 1-2 2-1 3v-1h1v-2l1-1h1l-1-1v-2l-1-1v-1l2-1-2 1v1l2 1v1l1-1 1-1 1-2v-1l-1-1 1-2v1l2-1h2l2-1h1l1-1v1h1v-1l1 1 1-1h1l-1-1 1 1h-2v-1l-1-1v-1h1c0-1 0 0 0 0l-1-1 1-2 1-1 1-1s0 1 0 0h1l2-1v-1l1 1v-1h3v-1h2v-1c-1 0 0 0 0 0l-1-1h1v1h1l1-1s1 0 0 0l1-1-1 1h2l1-1h1l1-1v-1l1 1-2 2h5l-3 1v-1h-1l-1 1-2 1h-1l-1 1h1l-1 1 1 2h2l1-1 1-1h1v-1h1v-1 1l1-1h3l2-1 2-1h-1l1-1h-1l-1-1h-1l-1 1v-1h-3l-1-1-1-1h-1v-1h-1v-2h-1l1-1 1-1-1-1-2 1v-1h-2v-1l-1 1 1-1h1l1 1 1-1h1l1-1v-2l1 1-1-2h-6l-7 3-1 1-1 2-1 1-2 1-3 2h-2v1h-1l-2 1-1 2h-1v1h-1l-1 1 1-1 1-1h-1 1l1-1h1v-1h1l1-1 2-1 2-1 1-1 2-1 1-2v-1h-1l-1-1h-1l2 1 3-1 1-2h1l1-1h1l2-1v-1l1-1h1l1-1h19l1-1 2-2zM393 381h-1 1zm0-4zm-10 6l-3-1h-3v1h1l1 1h3-1 2v-1zm41 2l-1 1h1v-1zm5 11zm-14-13zm0-1h-5v2h3l1-1h1v-1zm-19-10v-1 1zm-1 0v-1 1zm2 0l-1-1 1 1zm-26-12l-1 2 1-2zM208 240h-1 1zm-67 134h-1v1l1-1zm-10-3zm9 3l-1-1v1h1zm-2-1l-1-1h-1l1 1h1zm5 2l-1-1h-1l1 1h1zm-11-5v1h1l-1-1zm14 8v-1h-2c-1-1 0 0 0 0l-1 2v1l1 1 1-1 1-1h1l-1-1zm248-71h1l-1 1h-3l-1 1c1 0 0 0 0 0h3l3-2v1l-1-1-1 1v-1zm6-1h-1 1zm2 1v-1h-1v1h1zm-158-26h-1l1 1v-1h-1v-1l1 1zm-1 0zm0-2c-1 0-1 0 0 0zm-1 0h1-1zM82 266v1h1l-1-1zm0 0l1 1-1-1zm-4 1l-2-1 1 1h1zm2-1l-1 1h-1 2v-1zm3 0c0-1-1 0 0 0h-1 1zm-2 0v1h-1v1l1-1 1-1h-1zm10 0l-1-1-1 1h2zm3-2l-1 1h1v-1zm-5 0l-1 1h-1l-2 1h2l2-1c-1 0 0 0 0 0v-1zm13-2l-1 1 1-1zm6-2h-2v1h-1v1l-1 1 2-2h1l1-1zm4-2h-2c-1 1 1 1 1 1h-1v1l-2 1 2-1h1l1-1h-1 1v-1zm1 0l-1 1 1-1zm2-1h-2v1l2-1zm9-3zm-1 2l1-1-1 1zm-1-1l-1-1h-3l-1 1v1l2-1h3zm11-1v-1 1zm-1-1s-1 0 0 0h-1l-1 1 1-1h1zm0 0h1-1zm86 0v-2l-1-1-1 1v2l1-1v1c0-1 0 0 0 0s0-1 0 0v1c0-1 0 0 0 0h1v-1zm-6 1l-1-2 1 1v1zm-83-2v1h1v-1h-1zm1 0zm81 0v-1l-1 1v1l1-1zm-67-2c1 0 1 0 0 0zm66 0h1l-1 1h2v1s1 0 0 0l1 1 1 1 1 1v-3h-2l1-1 1 1-1-1v-1l-1-1h-1v-1h-1v1l-1 1zm3-3v-1l-1 1 1 1c-1-1-1 0 0 0 0 0 1-1 0 0v-1zm1 3h1v-2l-1-1v1l-1 1 1 1zm-66-3zm0 0s-2 1 0 0zm62-1v1h1c2 0 0 0 0-1l1 1v-2h-3l1 1h-2l1 2v1l1-2v-1zm-59-2v1h1v-1h-1zm56 2c0-1 0-3-2-3l-1 1v1h1v-1 1h1l-1 1h1l1 1-1 1h1v-2zm-53-4c-1 0 0 0 0 0h-1l-1-1h-1c1 1 0 0 0 0l1 1h-1l-1-1-1 1h1v2l-1-1v-1l-2 1v1l1 1c1 1 1 0 0 0h2l-1 1 1-1 1-1h2l-1-1h3l-1-1zm50 1c0-2 1 0 2 0l1-1h-2 1v-1l-1-1-1 1v-1h-2v2l1 1h1zm5 1h1l-1-1h1l-1-2c-1 0-1-1 0 0l1 1-1-2h-2v2l1 1v2l1-1zm-55-6h-1l1 1v-1zm1 1h-2v1h-2l2 1 1-1h1v-1zm-41-8l-1-1h-1l-1 1h-2l2 1 1 1h1c-1-1 1 0 1-1v-1zm314 167s0 1 0 0c1 0 1 0 0 0zm-10-14h-1 1zm153-176v-2h-2v-1h-1v-1l-1-1v-1h1-3l-1-1-1 1-1 1h-1l-1 1-1-1h-2l1 2-1-1-1-1h-2v1c0 2-2 0-2-1-2-1 0 3-1 3l-1-1-1 1v1l-1-1-1-1h1v-2h-1l-1-1-1-1-2 1h2c-1 0-2 0-1 1l1 1h-1c0-1 0 0 0 0h-1v-1h-1v1l-1-1 1 1c-1 0-2 0-1 1h-1l1 1h-1 6v1l-1 1h2-3l-1 1h-2v1h1l1-1 2 1v1l2-1-1 1v1h2l-2 1h-2l1 1h5l1 1s0-1 0 0c-1 0 0 0 0 0l3 1h4-1 1l1-1 1-1h2l2-1 2-1h1l2-1v-1l2-1 1-1h-1zM429 394l-1-1 1 1c-1 0 0 0 0 0s0 1 0 0zm-2-5zm1 0l-1-1v1h1z"/>
                    <g class="m-gi-map-area" data-id="sa" data-continent-name="samerica">
                        <path d="M430 411v-1l-1 1h1zm-1 0zm1-7h-1 1zm-3 3l-1 1h3v-3l-2 1v1zm36 32h-3v3l1 2 1-1v1l1-1 1-1 1 1v-1c1-1 2-1 1-2l1-1h-4zm-119 1l-1 1 1-1zm-4 0zm-1 0l-1-1v-1h-1v1h1v1l-1 1c1 1 3 0 2-1zm1-1h-1 1zm-3 1v-1 1zm95 168h-1 1zm1 1l1-1h-4l1 1h-1c0 1 2 0 1 1h-1l-1 1h2v-1h1l1-1zm5 0l-1-1v1l-1-1h-1v1l-1 1-1 1 1 1 1-1h-1 2v-1h1l2-1h-1zm-9 1h-1 1zm-41-24h1v-2l-1 1v1zm0-4l1 2 1 1v-1h1l-1-1v-1h1v-1l-1-1-1 1h-1v1zm4 0c0 2 2 0 1-1h-1v1s-1 0 0 0zm-2-3h-1 1v-1 1zm-1-3v1h1v1l1-1v-1l-1-1 1-1v-2h-1v1l-1 1v2zm-3 26l1-1 1-1-1 1v1l1 1v-5h-3v1l2-1-1 1 1 1h-1v1l-1 1h1zm-1-5v1l1-1v-2h-1v2zm2-3l-1 1v1l1 1h1-1l1-1v-1h-1v-1zm-1 9l-1 1h2v-1h-1zm0 2l-1-1v2l1-1zm1 3h1v-1l-2 1v1l1-1zm1 3v-3l-1 1v3l1-1zm9 9h1l1-1h-1l-2-1-1 1 1 1h1zm-2-2l-1-1h-1v-1l-1 1h-2 2v2h1v-1 1h2v-1zm-4-3l1 1-2-1-1-1h-1s0-1 0 0l1 1h2z"/>
                        <path d="M416 621l-4-1-3-2-1-1-1-1-1-1h1l-1-2h-4l-1 1-1 1 1 1h2l1 1h-2l-1 1 1 1 2 1h1l-1 1-1-1h-2l-1-1h1l-1-2v1l-1 1v1l2 1h-1v-1h-2l-1 1h-1 2v1h13l2 1 1-1h2v-1z"/>
                        <path d="M408 625l-1-1-1-1s1 0 0 0h-1l-3-1v1l1 1 1 1v-2l1 1v1h3zm-8-3l-1 1v-1h-1s-1 0 0 0c0 1 0 0 0 0l1 1h2l-1-1zm11 1h-4l1 1h1s0-1 0 0h2v-1zm97-161l-1 1v2c-1 0-2 3-3 2v2l-1 1-2 1v1l-1 1v-1 1l-1 1-1 2-1 1h-1v-1l-1 1 1 1-1 1v10l-1 2 1 1-1 1-1 4-1 1-1 2v1l-1 1-1 1v2l-1 1-2 1v1l-2 1-1-1h-1v1h-2 1l-1-1-1 1h-1l-1 1-1 1h-2l-1 1h-1l-1 1-2 1-1 1-1 1h-1l1 1-1 1v9h-2l-1 1-1 2-1 3-1 2-4 3v-1h1l1-1v-1h1v-1h1v-1c0-1 0 0 0 0v-1h-2v-1 3l-1 1-1 1-1 2v2l-2 3-1 1-1 2-3 2-4-1h-3l-1-1h-2l-1-2v-2l1-1-1-2v2c0 1 0 0 0 0v1l-1 1 1 2-1 1 1 1 2 1c1 0 2 1 1 2v1l1 1v1l1 1-1 2-1 2-1 1a25 25 0 0 1-13 3l-1-1v7l-1 1h-5l-2-1c1 0 0 0 0 0l-1 1 1 2v1l1 1v1c0 1 3-1 1-1h2v2h-4l2 1-1 1-2 1v4l-1 1h-1l-1 1h-1l-1 1-2 2 1 2 2 2 3 1-2 2 1 1-1 1-1 1-3 2v1l-1 2-1 1-1-1-1 1h1c1 0 0 0 0 0l-1 1-1 1v2l1 1-2 1h2v1l1 1v1h-3l-1 1h-2l-1 1v2l-1 2h-1l-2-1v-1h1v1l1-1 1-1v-1l-2 1-2 1h-1v-2h1l2-1h-3v2l-2-1 1-1h-2l-1-1v-1h4v-1l1 1v-1l-2-2 2 1-1 1h-1v1l-1-1-2-1h1v-1l-2-1-2-2h2v-1l2 2 1-1v-1l-1 2-1-2 1 1-1-1-1-1h1c0-1 0 0 0 0h1l-1-1v-1h1v-2l-1 1v1-4h1-1l-1-1v-1h3v-2l-1 2h-1v-1h-1v-1h1v-3h-1c-1 0-2 0-1-1l-1 1h-1l1-1 1-1v-1h1l1-1v-1h1v2l-1 1 1-1h1l-1 2c0 1 0 0 0 0l1-2-1-1 1-1h2l-2-1 1-1 2-1v-1h-1l-1-1 1-1v-4l1-1v-2c0 1-1 0 0 0l1-1h-2l-2 1v-1l-1-1v-1l1-3v-1l1-1v-2l-1-3v-4h1v-1l1-1 1-2v-1l1-1v-1l1-2v-2l1-1v-3l1-1-1-1v-2a53 53 0 0 1 0-4l1-1v-2l-1-1 1-1 1-3v-2l1-3v-7l1-2h-1v-1l1-2v-12l-2-2-1-1-1-1-1-1-1-1-2-1-3-1-1-1h-1l-2-1v-1l-1-1-1-1-1-1v-1l-2-4v-1l-1-1v-1l-1-1v-1l-1-1-1-2-1-2-1-2-1-2-1-2-1-2-3-1-1-1h1v-1l-1-1v-3l2-2 1-1 1-2v-2 1l-1 1h-1l-1-1v-3l1-1v-1h1v-1l1-1v-3h2l1-1v-1h1c0-1-1-2 1-2h1v-1h1v-1l1-1 1-2h-1v-1l-1 1 1-1v-1l-1-2 1-1-1-2 1-1h-1l-1-2v-1h1v-1h1v-1l-1-1 1 1 1 1v-2h1l1-1 1-1h1v-4l1-1h3l-1 1 1-1 1-1h2l2-1 1-1 1-1h2v2h-2l1 2v1l-1 1-1 2 1 1 1 1h1l1-2-2-2v-1l1-1 1-1h2l1-1h-1v-1l1-1 1 2h1l1 1 2 1v2l3-1h4v1l1 1h1l3-1h2l-2-1h7-3v1h1l1 1 2 1s-1 0 0 0v-1l1 1 1 1v1l-1 1h-1l1 1 2-1h1l2 1 3 2v4l1-1h2v1l1 1v2l1-2h1l2 1v-1h3l2 1v1l2-1h1v1h2l1 1v1h1v1h1v1l1-1v1l1 2v2l1 2 1 1 1 1v1l-1 1-1 1-1 1h-1v1l-1 1v2h-1l-1 1h-1 2l1-1 2-1v1l2 2h1l2-1-1 3 1-2h1l1-1h1v-2l1-1v1l1-1 1 1v-1h1v1h2l1 1h2v1h2v5l1-1v-1h1l-1 1 2-1h1v-1l1 1h1l2 1s0-1 0 0h6l1 1 2 1h1l1 1 2 2 1 1h1l2 1h3l1 2v2l1 2-1 1 1 1z"/>
                    </g>
                    <path class="m-gi-map-area" data-id="emea" data-continent-name="europe" d="M763 489l-1 1 1-1zm-5-10l-1-1 1 1zm6 4l-2-5-1-3h-1l-1 1v2l-1 1-1 1h-1l1 1-1 1 1 1h-1l-1 1v-1l-1 1v1h-1l-1 1h-2v1h-4v2l-2 3 1 1v3l1 1v2l-1 2-1 2-1 1v1l-1 2 1 2 1 1v3l1 1 1 2h5l2-1 2-2 1-4v-2l1-2 3-8 1-4v-3h1v-5l1 1h1v-3zm27-112v2h-1l-1 2-1 1-1-1-1 3v3l-3 1-1 1-1 1-3 1 1 1h-1l-1 1h-3l-2 1-3 1v2h-1l-2 1-2 1h-1l-1 1h-2l-2 2h-2l-2 1h-1l-3 1h-1v1h-1l-1 1h-4v-1l-1-1v-3l-1-2v-4l-1-3-1-1-1-1-1-2-2-3v-1h-1v-1l-2-1h-1v-2l-1-1v-4l-1-1-1-2-1-2-2-1-1-1v-1l-1-2v-1h-1l-1-2-1-2-2-2h-2l1-2v-1l1-2-1 1-1 2-1 3-1-1-1-1-1-3-2-3v3l1 1 1 2 1 1v1l1 2v1l1 1 2 4 1 2 2 2-1 2 1 1 1 1 1 1h1v2l1 1v3a16 16 0 0 0 1 4l1 1 1 1v1h1l1 2 1 2 1 3v1l1 1h1l1 1 1 1h1l1 1 1 1 1 1 1 1 1 1h1v1l1 1v1l-1 1h-2 1l2 1 2 2 3 1c1-1 1-2 3-1l2-1h3l3-1h2l3-1 1-1h1v4l1 1h-2v3l-1 2-1 1-1 1-1 3-1 2c0 2-2 3-3 5l-3 4-4 3-4 3-4 4-4 3-1 2-1 1h-1l-1 2h-1v2l-1 1-1 2v1h-1v2l-1 2 1 2v1h1v2l-1 1h1v4l1 1v1l1 1 1 1v7c0 1 0 0 0 0v4h1v3l-1 1-1 1v1h-1v1l-1 1-2 1-3 1-3 2-1 2h-1l-1 1-1 1-1 1h-1v3l1 1v3l1 1v5c0 1 0 0 0 0v2l-4 2-3 1-1 2v4l-1 3-1 2-1 1-1 1-2 3-1 2-4 4a25 25 0 0 1-7 5l-1 1h-2l-1 1-1-1-1 1h-1l-3-1-1 1h-3l-1 1h-4l-1 1h-3v-1h-1v-1h-1v1l-1-1 1-1-1-2-1-2h1v-1l-1-4-2-4-2-4-3-3-1-2v-3l-1-1v-4l-1-2v-4l-1-2-1-2-2-3-1-2-2-4-1-4v-5l1-2v-3l1-1v-1l1-1v-1l1-1 1-1 1-2v-2l-1-2-1-2v-4l-1-3v-1l-1-1-1-1 1-1h2-2l-1-1v-1l-1-1-1-1-1-2-2-2-2-2h1l-2-1-1-1v-2l1 1h-1v-1l-1-2h1v-3l2 1-1-1v-3l1-1v-4l-1-1 1-1h-1 1l-1-1h-2v-2s0 1 0 0h-1c1 1 0 1 0 0l-1-1v2l-2-1h-1l-1 1v-1 1h-3l-1-1v-1s-1 0 0 0l-1-1 1-1h-1c0 1 0 0 0 0l-2-2h-3l1-1-1 1h-2a29 29 0 0 0-4 1h-1l-1 1h-2l-2 1-2 1-2 1-2-1h-2v-1l-1 1h-1l-3-1h2l-2 1h-2 1l-6 1-2 1-2-1-3-2-2-2h-1l-1-1-1-1h-1l-2-2h-1v-1h-1l-1-1v-1h-1 1v-1h1-1v-1l-1-1-1-1v-1h-1l-1-1-1-1v-1h-1l-1-1v-1l1-1h-1l-2 1v-1l-1-1h-1l1-1h-1v-3 1h2l2-1-1 1h-2l-1-1v-1l-1-1-1-1 2-3 1-3 1-3v-4l-1-1v-5l-1-1c-1-1-1 0-1 1v-2l1-3h1v-2h1v-1l1-2-1 1 1-1 1-2 2-1v-1l1-3 2-2 1-2 2-2 2-1 3-1 2-2 1-2c1 0 2-1 1-2v-3l1-2 1-2 1-2 1-1 3-1 2-1 1-3 1-3h1l1-1 1 2 2 1h2l2-1 1 1h2l3-1 2-1h1l1-1 2-1 3-1h2l1-1h6l1 1 2-1h1v-1l2 1 1-1 1 1h3c1 0 3-2 4-1h1v1l1 1v-1h1l1-1v1l-1 1-1 1v2h1l1 1v1l-1 1-2 1v2l2 1 1 1 1 1 4 1h3l2 1h2l1 3 3 1 4 1 1 1 2 1c1 1 2 0 3-1l1-1-1-2 2-3 1-1h5l2 1v1h2l2 1h2l1 1h3l2 1h2l1 1h2c2 1 2 0 3-1h2l1-1-1 1 2-1h2l1 1-1-1v1l1 1v-1l1 1 2-1v1h1l2-1c2-1 2-4 3-6l1-2v-1l1-2h1l-1-1v-5l1-1v-1l-1 1h-2l-1-1-2 2-3 1h-1l-2-1-1-1-1-1h-3v2h-1l-1 1-1-1-1-1h-1l-1-1-1 1h-2l2-1h-3l1-1v-1h-1v-2h-1v-1l-1 1v-1c-1 0-1 0 0 0v-1l1 1h1l-1-1 1-1h-1v-2h-2v-2h1l1-1h3v-1l1 1h3l-1-1h3v-1h-2c-1-1 0-1 1-1h6v-1l2-1 2-1h7l1 1h2l1 2 1-1 1 1h1l2 1 4-1 2 1 1-1h2l1-1h5v1h1v1h1l-1 2 1 1h2l1 1h-1v1h-1v2l1 2-1 1 1 1v1l1 1v1l1 1v1l1 1h1s1 0 0 0v2h-1v1l-1 1v2l1 1v1h1v1c0 1 0 0 0 0l1 1 2 1 1 1 1 1v3l1 1v1h1v1h-4l-1 2-1 1 3 1 1 1h2l1 2v1h1v1h1l1 1 1 1v3l1 1v1l1 1v-2l1-2h1v6h1l1 1 2-1h4l1-1 1-1 3-3 1-1 1-1v4l1 3 4 2h1l2 1 1 2h1c1 1 0 2-1 2zm-75-45l-2 1h-3v1h-2l1 2h2c0-1 0 0 0 0l1-1h2l-1-2 2-1zm-38-85h1l1-1 1-1h1l-1-1h-2v1h-1v1h1l-1 1zm1-4l1 1 1-1h1l-1-1h-1v1h-1zm8 92l3-1h1v-1 1h-1v-1h-5l-1-1-1 1v1h2l2 1zm-2-12v1h1l-1-1v-1l-2-1h-2 1l1 1 1 1h1zm-47-14l1 1h-1 1v2h1l1-1v-5l-1 1v1h-1l-1 1zm4 7l-1-2v-1h-1l-2 1h-1l1 2v4h3v-1l1-2-1-1h1zm-5 4l1 1-1-1zm21 6l1-2v-1h-1v1h-7l-1 1 1 1 3 1 1 1 2 1h1v-3zm-31-95v1l2 1h3v-1l2 1 1-2-1 1 1 1s-2 0-1 1l-1-1h-5l-1 1 1 1h1l-1 1v1h1v1h-1v1s0 1 0 0h1v-1h1v-1h1l2-1h-1v1l-1-1v2l-1 1v1l-1-1-1 2h2l2-1-1 1-1 1 1 1v-1l-1 1h-1v1l1 1 1 1h1c1 0 0 0 0 0h1l2 1h1v-1h1l2-1 1-1 1-1h-1c1 0 2 0 1-1h1v1l1-1 1-1v-2l1 2 2 1h-1v3l1 1v1h1v2h1l1 3 1 1-1 1h1-1l1 2v2h4v-2l1-1h4l1-2 1-1v-5h1v-1l-1-1h1l-1-1h-1 2l2-1 2-1h1v-1h-5l-2-1h5c-1 0 0 0 0 0v1l2-1 1-1v-1l-1-1-1-1-1-1v1l-1-1h-1v-5h1v-3c-1 0 0 0 0 0h1l1-1h-1v-1h2v-1h-1 1v-1h2l1-1h1v-1h2l1-1 1-2 1-1-1-1 1-2v-1s0 1 0 0l1-1h1v-1l1-1v1l1-1 1 1h3l1-1v1h1l2 1-1 1v1h1v1h-1s1 0 0 0l-2 1-1 1v1h-1l-1 1v1l-2 1h-1l-1 1h1l-1 1h-2v1l-1 1v3l1 1v6h1v1h2v2h1v-1 1h1l-1 1 1-1h4l1-1h3l1-1h-1 2v-1 1h3l1-1 2-2 2-1 4-4 2-2 1-2-1-1-1-1-2-1 1-2v-1l-1-1v-1l-2-1 1-1-1-1h1v-1l1-1v-1l-1-2-1-2c-1 0-2-1-1-2 1 0 3-2 2-3v-1l-1-1h-2l-1-2v-1l1-1h-1l1-1 2-1c0-1 3-1 2-2h2v-1h-4v-1l-2-1h6v-1l-1-1h-1v-1h-2l-2-1-1 2-1 2v-3h-1 1v-2l-2 1c-1 0 0 0 0 0l-1 1v1l-2 1v-3l-2 2-1 1-1 1h-1l1-1v-1l2-2h-4l-1 1v1l-1 1-1 1h-1v1l-1-2h-2l-1 1h-1c-1 0 0 0 0 0l1 1v1l-1-1h-1v1l-1-1h-1v2l1 1h-1l-1 1v-2l1-1-1-1v1l-2 2 1-2h-2l-1 1v2h-1v-1l-1 1-1 1-1 1-2 1-1 1h3l-1 1-2-1-1 2h-3l1 1h-2v1h1v1h1c1 0 0 0 0 0h-1c-1-1-1 0-2 1h3l-2 1h-3v1s-1 0 0 0v1h-2v2h3l-4 1 1 1h-1l-1 1-1 1v1l1 1 1-1-1 1h-1l-2 1-1 1 1-1-2 2-1 1-1 1-1 1-1 1 1 1 1-1h2v-1l2-1-1 1h1l-2 1v1h-3l-1-1-1 1v-1h-2v2l-1 1 1 1-1-1h-2l-2 1v1l1-1h3l-2 1h-4v1h-1l-1 1h-1v1h1l2 1 2-1h-5l-1 2zm37 19l-1 1-1 1v2l1-2v-1l1-1zm5-2h1-1c-1-1-2 0-2 1v3l1-2h1v-2zm-44 69h-1l1 1v-1zm-3 0l-2 1h-1l1 1h2v-2zm-3-41l2-1 2-1h2s0 1 0 0h-2 2l-1-2 2-1v-2l1-1h1l1-1 1-1h2l2 1v-2h2l1 1 1-1 1-1 1 1 2 1-1-1-1-1-1-1-1-1h1v-1l-1-1v-2l-1-1v-4h2v-1h1v-1l-1 1h-2l1-1 3-1 1-1 1-1h1v5l1 1-1 1v-1l-1 1-1 1v1l-1 1v1l1 1v2h3l1 1-1 1h2l1-1h1l1-1h1l1 1h2v2h2l-1-1h-1v-1l1 1h2l3-1 2-1 1-1 3-1 3 1h-1l1 1h1l2-1 1-1 1-1 1-1 1-1-2 3h2v-9l2-2 2-1 1 1 1 1 1 1 3-1-1-2 1-2v-1h-1v1l-1-1-1-1 1-1h-1v-2h2l1-1h11v1h-1v1l-1 1v3l1 1-1 1v1l1 1v1l-1 1 2 1v2h2l1 1h1v1l1-1 2 1h1v2s1 0 0 0v1l1 1v2h1l1 1v1h2v1h1l-1 1-1 1-2-1-1 1h1v2l1 1 1 1 1-1h4l1 1 1 1h-1v2h3v1h1v2h2l1 1h2l1-1 1 2h3v1l1-1v1h2l1 1v1l-1 1v1s0-1 0 0v2h1l-1 1h-3l-1 1-1 1v1h-2v1h-2c0 1 0 0 0 0l-1 1h-3l-1 1h-1v1l1 2 2 1 1-1 1 1v1h-4v1h-2l-1 1h-2v-3h-3l1-1 1-1h1v-1h-3l-1-1h-1s1 0 0 0l-1-1h1v-2 2l-1-1v1h-2v1l-2 2h-2l1 1v1l-1 1-1 1v-1l-1 1v1l-1 1 1 1-1 1v1h-1l-1 1v1l-1 1 1 2c1 0 0 0 0 0l1 1 1 1 1 1h1-3l-1 1h-1l-1 1-2 1-1 1 1-1 1-1h-2l-1-1h-5v1l-1-1v2h1l1 1-2-1v1l-1-1v1h1-1l-1-1-1-1-1 1v1l1 1 1 1v1h-1l1 1h-2 1l1 1h1l1 1 1 2-2-1h-1v2h-1v2l1 1v1l-1-1v-1l-1 2v-1l-1-1h-1v1l-1-2v-2h-1v-1l1-1v1l1-1 2 1h2l-1-1h-4l-1-1-1-1-1-1h-1v-2l-1-1-2-1 1-1v-5h-1l-2-2-2-1h-1l-1-1 2 1-2-2h-1l-2-1h-1l-2-2h1l-2-1v-2s-1-2-2-1v1h-1l-1-1 1-1-1-1h-1l-2 1-1 1v1h1l-1 1v1l1 2 2 1h1l2 4 2 2h4l-1 1 1 1 3 2 2 1h1l1 2v1h-1l-1-2h-2l-1-1-1 2v1l2 1v2h-2v2h-1v1h-1v-1l1-1v-1l-1-2v-2l-3-1v-1h-2v-1l-1-1h-2l-1-1h-1l-1-1-1-1-1-1-1-1s0 1 0 0l-1-1-1-1v-1l-1-1v-1l-1-1h-5l-1 1-1 1c-1-1-2 0-2 1l-2 1h-2l-1-1h-1l-2-1h-1l-1 1-1 1v4l-2 2-2 1h-3l-1 1 1 1h-1l-1 1-2 3 1 1v1h1l-2 2-1 1v1l-1 1h-1l-2 2h-2l-2 1h-4l-1 1-1 1h-1l-1-1-1-1 1-1h-1l-1-1h-2l-1 1-1-1h-2l-1 1 1-3v-2l-1-1c0 1 0 1 0 0 0 0-1 0 0 0v-1l1-1-1 2-1-1v-2h1v-1l1-1v-9h-1v-2l1-1h1l1-1h8l4 1h7l1-2 1-3v-3l1 1 1 1-1-1v-1l-1-1v-2h-1l-1-1-1-1v-2l1 1-1-1h-1l-1-1h-2l-1-1h-3l1-1 1-1h-2l3-1 2-1 1 1v1l1-1h3v-1l-1-2v-1h2v1h2l1 1 2-1-1-1 2-1h2v-3l2-1zm30-16h1l-1-1v1zm0-1v-2l1-1v-1l-2 1v1l-1-1s0-1 0 0h-1l-1 1h1v1l1 1c1 0 1 2 2 1v-1zm-2 2v-1h-1v1h1zm-2-2l-1-2h-2v2h3zm-52-5h2l-1-1h-1 1l-1 1zm1 2l1-1v1h-1zm-1-8v1h-1c1 0 0 0 0 0l1 1h1l1 1v-1h-1l-1-2zm-1-3v1h-1v1h1l-1 1 1-1h1v-1l1-1h-2zm1 12l1-1h-1v1zm2-7l1 1-1 1h-1v1h1l2-1-1 2v2l-1 2h1v-2l1-2v1h1l1 1h-1v1l-1 3c0-1 0 0 0 0l1 1h1l1-1v1l1-1h2l-1 1v2h1l1 1v3l-1-1v1h-3l-1 1-1 1 1-1h1v3h-1l-2 1v1h3v1h4l1-1-1 1-1 1h-3l-1 1v1l-2 1-1 1h-1l1 1h1v-1h1l2-1 1 1 1-1 2-1h2s1 1 0 0h2v-1l2 1h3l2-1h1l1-1v-1l-2 1-1-1h1v-1h1v-1l1-1v-2l-3-1v1l-2-1 1-1v-1l-2-1h-1 3c-1 0-2-1-1-2l-1-1-2-1-2-4-1-1-2-1-1 1-2-1h3v-1h-2 1l1-1 1-1 1-2 1-1-1-1h-4l-2 1 1-1-1-1 3-2v-1h-3l-1 1v-1l-1 1-1-1v2h-1v1h1l-2 1 1 1-1 1zm-13 21h1l-2 2h1l1-1-1 2 2-1-1 1h3s2-1 1-2l1 1 1-1 1-1h3l1-2v-4l-1-1h1v-1h1l1-1h-1 1l-1-1v-1h-1l-1-1h-2s0 1 0 0l-1-1v1l-1 1h1l-1-1c1 0 0-1 0 0l-2 1-1 1h2l-1 1h-1v1h-4 1l-1 1h2v1h-1l-1 1h1v1h2l-1 1-2 2 1-1h3l-3 1v1h-2 1zm108-88h-1c-1 0 0 0 0 0v1h1l1-1h-1zm-7 3h-1l-1 1h1l1-1zm1-1zm-2 1l1-1h-5c1 2 3 1 4 1zm-8 2zm-7 4h-1l-1-1-1 1s1 0 0 0h-1v2h1l1-1h1l1-1zm0-1h2l1-1 1-1v-1h-1v1h-1v1h-1l-1 1zm5-3h-1 1zm-21 12l1-1-1 1zm3-2h-1v1h-1 1l2-1h-1zm3-3l-1 1h2v-1h-1zm2 3l1-1s0 1 0 0h1l1-1-1-1v1h-1v-3l-1 1v1l-1 2h-2l-1 2 2-1h2zm28-55h-3l-1-1h-1c-1-1 1-1 1-1l-3-1h-1v-2h-3l-3 1h1l1 1v1l2 1v1l-1 1-1 1h5v1h3l1-1 1-1 2-1zm-42-6l1 1 1 1 1 1h1l-1-1-2-1v-1l-2-1 1 1zm0-6v2l1 1s0 1 0 0h1v-1h2l-1 2 2 1h-3 1v1l1 1 1 1 1 1h4l1-1v-2h1v1l1-1h1l-1 1 2 1 1-1 2-1-1 2h2l-3 1h-1l-3 1h-2v1l-1-1v2h8l1-1 1 1-5 1h-2v1h-2v1l2 1 2 2 2 1 2 1 1-1v-2l1-1 1-2 1-1 1-2 1-1v-1l1-1 1-1h2l2-1h1l-1-1-1-1h1l-2-1v1l-1-1h-3s0-1 0 0v-2l-1-1-3 2 1-2v-1l-1-1h-2l-1-1-1 1-1 1v2l1 3-1-1-1-1-2-3h-1l-1 1v2l-2-1-1-1h-2 3l1-1h-9v1zm24-5l-2 1 2-1zm-2 2a7390955 7390955 0 0 0 4 2h4l-1 1h-3l3 1h1l1 1 5-1v2h1l3-1h4l1-2 3-1 1-1v-1l-4-1h-3v-1h-3v1h-2v-1l-1-1-1 1-1 2h-1l-1-1h-2l-2-1-2-1 1 1-1 1h-1 1l-1 1-1-1-3 1h1z"/>
                    <g class="m-gi-map-area" data-id="apac" data-continent-name="asia"> <path d="M1064 445l-1 1h2l-1-1zm-3 10h-3l1 1h1l1 1h4l1-1 2-1h2l-1-1 1-1 1-2h-3v2h-1l-1 1-1 1-1-1v-1l-1 2h-2zm-39 25zm-3-154h-1l-2 1h-4l-3 3-2 1-1 1h4v-1h3l1-1h1l2-1 1 1h1v3h2l2-2 1-1h-1l1-2v1h1v1h3v-1h1l1-1v2l1-1 1-2 1 1-1-1h1v-1 3l1-1 1-1 1-1-1-2 1-2v-4l1-1h1v-2l1-1v-4l-1-1v-3h-2v1h1v1h-2v-1h-1v1l-1 1v3s0-1 0 0h1l-1 2-1 3-1 1-1 1v1l-1 1-3 1h-2v-1l1-1c1 0 0 0 0 0l-1 1v1l-1 1-2 2v1l-1 1h-1v-1z"/>
                        <path d="M1028 319l1-1v-1l-1 1v1zm10-54v1l1 1 1 2v7l-1 2v1l1 1v3l-1 2v2l1 3c0-1 0-4 2-3h1l1 2v-3h-1l-1-2-1-1 1-4 1-2h2l1 1h1l1 1-1-1-1-1v-2l-1-2-1-3v-2l-1-2v-5l-1-2v-2l-1-1-1 1c1 0 2 1 1 2 1 0 0 0 0 0v1h-2v4l-1 1zm-4 36l-1 1v1l1 2v1l1-1h1v-1h-1v-2h4l2 1 1 1 1-1 1-1 2-2 1 1 1-1h2l1-1h-1l-1-1v-1l1-2-2 2h-2l-1-1-2-1-2-2-1-1-1-1-1 1 1 1v2l-1 1v3l-1 1h-1l-1-1v1l-1 1zm30-13l-2 3 1-1 2-2h-1zm-34 173h-2l-2 2h3l1 1-1-1 1-1v-1zm36-15l1 1 1 1h1l1 1 1 2 1 1v1l1-1v-1l-3-2-1-1-1-1h-1l-1-1zm-42 35a293 293 0 0 0 0-1h-1s1-1 0 0l-1 1h2zm-6-25v-1h-1c0-1 0 0 0 0h-1v1l1 1c1 1 1 0 1-1h-1 1zm-2 3l1-1-1-1v2zm55 6l1 1v-1h-1z"/>
                        <path d="M1065 469h1l-3-1v-1h-1l-1-1h-2v-2h-1v-1l-1-1-2-1v-1l-1-1h2l1-1-1-1-1-1-2-1h-2v-1l-1-2-1-1h-1l-1-1h-1l-2-1-2-1-3-1-2-1h-3v-1h-3l-2-1-1-1h-2l-1 1-1 1h-2v1l-1 1s-1 2-2 1l-1-1c-1 1-1-1-1-1v1l-1-3v-3l-1-1h-1l-3-1-2 1-2 1v1l-1 1h3v1l2 1h4v1h-4l-2 1h1l1 1 1 1v1h1l1-1v-1c1 1 0-1 1-1l-1 2 1 1h3c-2 0 0 1 1 1l2 1 2 1h2l2 1 1 1s-1 0 0 0c0 1 0 0 0 0v1l2 3h-1l2 1h-1l1 1-1 1v1l1-1 1 1 2-1v1l1 2 1 1h5l2-1v-1l-1-1h-2 4v-1h1l-1-1 2 1v-1h2v1h2l2 1 2 3 2 2 1 1h4l2 1h2v-1zm5-184l-1 1 1-1zm-68 49l-1 1 1-1zm-12 75v2h-2l-1 1h-1v1l-1 1v-2h-2l-1 1v1h-1l-1 1-1 1v1h1v-1l1-1 1 1 1-1v1l1-1 2 1-1 1v1l2 2 1 1 1-1s0 2 1 1v-5l1 1v1l1 1v-1l1-1v-3l-1-1v-3l-1-1v1l-1-1zm6 27v3h1v1l1 1h1l-2-3 1-1 2 1-1-1-1-1 1-1v-2l-1 1v1h-1v1l-1-1 1-1v-2l-1 1v3zm-4-27l-1-1v1h1zm-13-16s0-1 0 0zm10 8v-1h-3l1 2 1 1v1h1l1 1s0-1 0 0v-4h-1zm67 43z"/>
                        <path d="M995 439v1h1v1h1v-1h-1v-1h-1zm2-110c0 1 1 0 0 0zm1 103h1v-1h-1v1zm3-97h-1v1l1-1zm-2 112h-2v2l1-1 1 1v-1h4l1 1 2 1-1-2-1-1h-5zm0-110l1-1h-1v1zm0-9zm68 141v-1h-1l1 1zm-47-26l1 1h3l-1-1h-3zm-2-112v-1 1zm33-32zm1 0zm-39 33h-1s0-1 0 0l-1 1-2 1h2c-1 0 0 0 0 0v2h1v-1h1v-1h3l2-2-1-1h-3c1 1 0 1-1 1zm5 110l1-1h-1v1zm1-1h2v1h1l-1-2h-2v1zm36 13zm-80-84l1 1v-2l1-1 1-4 1-2v-1h-3l-1 2-1 2-1 2 1 2 1 1zm90 97s0-1 0 0zm-6-175h-2c0-1 0 0 0 0l-1 1-1 1-1 1h1v-1h1v-1h2l1-1h1v-1l-1 1zm-2 164v-1 1zm-51-14l1-1-2 1h1zm58 24zm-60-128l-1-1v1h1zm3 125v-1 1zm1-3l-1 1v1l1-1v-1s1 0 0 0zm1 0zm-3 3zm7-9l-1 1v1l1-1v-1zm-2 18v-1 1zm0-17s0 2 1 1v-1h-1zm-7-16h2l-1-1 1 1h1l-1-1-2 1zm2 35h1l1-1v-1h-4l1 1-1-1v2c-1 0 0 0 0 0h1v-1l1 1zm-1-130c-1 0-1 0 0 0zm1 0v-1 1zm0 97s0-1 0 0h-1 1zm-3 3h2l-1-1-1 1zm9 12zm-16-20h-1 1zm-96-294c1 1 3 0 3-1l-2 1h-2 1zm-42 11h1c0-1 0 0 0 0l1-1-1-1v1h-1v1zm-8 15h1v-2l-2 1 1 1zm36-53h2l-3-1s-3 0-2 1h3zm8 8h-3l-3-1-2 1 1 1h2l1 1 4-1v-1zm-6-2h2l1 1h5l2-1h3l4-1v-1l-1-1h2l1-1h-2l-2-1-2-2h-3l-1 1h-4l-1 1-1 1h2l-3 2h-2v2zm-104-1l1 1 2 1v-1h1v-1h3l-7-1v1zm70-4h-2l-2 1 4-1zm-12 10h4l-3-1h-2l1 1zm-50-7h2l2 1 1-1h1l1-1v-2l-5 1h-2l-1 1c-1 1 0 1 1 1zm-5-8h1l3-1h-4v1zm10 5v-1l-4 1h4zm39 51h1l1-1h-2v1zm-31-50l4-1v-1l-1-1h-2c-1 1 0 2-2 2h-2l-2 1 2 1 3-1zm18 49l3-1h2l-1-1h-4v2zm21 4s-1 0 0 0h3l1-1-2-1-1 1-1 1zm191-6h2l5 1h2v-1l-2-2-2-1h-3l-2 2-3 1h3zm-14-12c1 0 0 0 0 0l1-1-1-1-1-1v3h1zm16 8l-1-1h-2c-1 1 0 2 1 2l2-1zm-11-6l2 2h4l1-1h6l2 1 2-1-1-1h-1l-1-2v-2l2 1v1l1 2h4l1-1v-1l1-1-2-1-3-1h-3l-3-1h-1l-1 1v1l-1 1-1-1-1-1-3-1h-2l-2 1v1l-1 1v1h-1v1l2 1zm27 0h1l2 1h1l4 1h2l2-1 1-1h-2l-2-1h-3v-1h-5l-1-1-1 2 1 1zm98 24h7l2-1 1-1h-1l-2-1-1-1h-1l-3 1-2 1-1 1v2l1-1zm-33 6l2 1h1l1-1-2-1h-3l1 1zm-205-50l-1 1-1 1c2 1 4-1 6-1l3-1h1v1l1-1h5l2-1-1-3h-1l-1-1h-1v-1h-2l-1 1-2 1 1-1 1-1v-1l-2-1v2l-1-1h-1v1h-2v3h-1l-1 1-1 1v1zm-11 13h-3l2 1s0-1 0 0l1-1zm0-25h-5l-1 1v1h-1l-1 1-2 1h3l1 1 1 1v1h6l1 1h3l1 1 1-1h3l1-1-1-1-2-1h2v-1l1-2-1-1-1-1h-1l-1 1h-2l-1 1v-1l1-1-1-1-4 1zm2 24zm28-12h-1 1zm2 1h-2 2zm87 25l1 1-1-1-1-1c-1 0 0 0 0 0l1 1zM852 411zm58 31v-1l-1 1 1 1h1l-1-1zm3 3l-1-1v1l1 1v1l1-1-1-1zm1 2zm-10-15l1 1v-1h-1zm4 6v2l1-1-1-1zm20 17h1l1 1 1-2v-7l-1-1-2-1-1 1 1-1-1-1-1-2v-1h-2v-1h-1 1l-1-1 1-1v-1h-1l-2 1 1-1-1-1-1-1-1-1-1-1-1-1v1h-1l-1-1-1-1-1-1-1-1-2-1-1-1v-1l-1-1v-1l-2-1v1l-1-1h-4l-1-1v2l2 3 2 1h1l1 2 1 1 1 1 1 1 2 3v2l2 1 1 1 1 1v2l1 1 1 2 1 1 1 2 1 1 1 1 2 2 3 1 1 2 1 1v-1h1zm-23-22l-1 1 1 1 1 1h1l-1-1-1-2z"/>
                        <path d="M929 443v2l2 1 1 1h1l1-1-2-1v-1l-1-1h-2zm41-36l-1 1-2 2-2 2v1l1-1h1v-1l1-1 1-1 1-1h1v-1l1-1v-2l-1 1v1l-1 1zm2 34l-1 2v2l-1 1v3h1l1 1-1 4s1 2 2 1h2l-1-2v-6h2v2l2 1v2l1 1v-1l2-1h1c0-1 0 0 0 0l-2-2v-2l-1-1v-1h-1v-1h-1 2l1-1 2-2h1v-1s-2 0-1 1h-5l-1 1h-1l-1-1v-3c0-2 1-1 2-1h9l2-1 1-1 1-1v-1l-2 1v1l-2 1-3-1h-4l-2-1-1 1v1l-1-1v1l-1 1v1h-1v1l1 2h-1zm-33-62v2l1 1 1 1h1l1-1s1 0 0 0l1-1h1v-2l1-1v-1h-4l-1 1s0-1 0 0h-1l-1 1zm1 57v1l1 1v3h2v3l1 2v1h2c-1 0 0 0 0 0h3v2l1-1h1l1-1 1 1h4v3l2-1 2-1 1-1v-2h1l-1-1v-1l1-1v-2c1 2 2 0 2 0l1-1v-3l1-1v-1l1 1h2v-1l-1-1-1-1-1-1v-1l-1-1v-1l-1-1-1-1h2v-2h3l-1-1 1-1h2l-1-1-1-1h-2v-1l-1 1v-2l-1-1v-1l-1 1-1-1v1l-1 1-1 2h-1l-1 1 1 1h-2l-1 1h-1l-1 1-1 1-2 3-3 1h-1c-1 1 0 2-1 1v2h-1l1 1h-1l-1-1h-2l-1-1-1 1-1 1h1l-1 1v1zm-39-6l-1-1v1l2 1s1 0 0 0l-1-1zm53 34h2v-2l-3-1h-1v-1h-1v-1h-3v-1h-3v1h-6v-1l-1-1h-2l-1-1h-4v1l-1 1h-1v1h4l-1 1 1 1h3l2 1 1-1h1l3 1 2 1h4l3 1 1-1 1 1zm-17-16h1v-2h-2v2h1zM772 176h-2 1v1l1 1v-2zm20 6c-1-1-2-2-3-1l-1 1 1 1 1 1v-1l1 1h1l1 1 1-1-2-2zm-18-20l1 1 1 1h3l3 1 2-1v-1h1v-1s-1-1 0 0l1-1 1-1 2-1-1-1h2v-1h2v-1h1l1-1h-1l2-1 2-1h1l1-1 2-1 8-2 4-1 4-1 1-1 1-1 1-1h-1v-1l-2-1-5 1-1 1-1 1h-2l-1 1h-2l-4 1h-5v1h-3v1h-4l-1 1-1 1-1 1v1l-2-1-1 1-1 1-1-1-1 1 1 1h1l-2 2s-1 0 0 0h1v1h-2l-1 1-1 2h-1l-1 1h-1z"/>
                        <path d="M769 175h4l1 1 1 1h-1v1h-1l2 1h5v1l1-1 1 1v-1h1l1 1 2-1-3-1a11 11 0 0 1-3-4l-1-1v-4h1v-1l1-1v-1l1-1h-3l-1-1-2 1h-3v2h-2v3l-1 1h-1l-2 1c0 1 0 3 2 3zm84 234c-1 0 0 0 0 0zm-64-293l-2-1h-3l1 1 1 1h3v-1zm-9-2h7l-1-1h2l-2-1 1-1-2 1h-2l-1 1h-3l1 1zm-4 3h2l3 1h2l3-1-3-1-4-1h-3v1h-1c-1 1 0 1 1 1zm-4 4h2l-1-1h-2l-2 1h3zm85 292v-1l-1-1-1-1-1-1h-1l1 1-1-1v3l-1 1v4l2 3h2l2-1v-3l-1-3zm-74-293h-2v1l-1 1h4v-2h-1zm-33-1h4v-1h1l1-1 1 1h2l-1-1h-5l-3 1h-3l2 1h1zm223 270v3l1 1v1h1v-1l1 1-1 1v1l2 1 1-1h1l1 1 1 1v-2l1 1 1 1v1h2v1l1-1h-1l-1-2 1-1h-2v1l-1-1-1-1h-1v1l-1-1v1l-1-1v-5l1-1h1v-2h1v-1h-1v-4l-1 1c-1 0-2-2-3-1h-1l-1 2v5h-1zM760 186c-2 0-2 1-2 2-1 1 0 2 1 2l3-2h1v-1l-2-1h-1z"/>
                        <path d="M756 119l-3 1 2 1h2l-1 1h2v-1h1c1 0 1 0 0 0v-1h3v-1h3l1-1h2l-2-1-2-1h-3l-1 2v1h-4zm295 333zm34 11zm0 1l1 1v-1h-1zm2 0zm0-1h-1v-1l-1 1h1v1h1v-1zm-5-192zm4 190l-1-1v-1h-1l-1-1v1l2 1 1 1zm29 45l-1-1-3-2h-1v-1l-1-1-2-1h-1v1l1 1 2 2h1l1 1h1v1h3zm-32-45v1l1-1h-1zm17 10v-1h-1l-2-1h1v1h1l2 1h-1zm-2-4l-1-1v-1h-1v-1 1l1 1v1h1zm9-231h-2v1l-1 1h1l2-1v-1zm-13 229zm-132-16zm132 24l1 1-1-1zm1-6h-1l-1-1-1 1 2 1h2l-1-1zm-14-196v1h-1l-1 1v1l1-1h1l1-2h-1zm-54 279h-3l-1 1h2l1 1v-1h1v-1zm19 15l-1-1v1l1 1v-1zm-93-106h-1v1h4l-1-1h-2zm105 111v-2h-2v1h-5l-2-1h-1l-1 1 1 1 1 3 1 1-1-1 1 3 1 1 1 1h2l1-1h-1l1-1v-1l1 1 1 1v-3l1-1v-3zm-96-120zm0-2l-1 1v1l1-1v-1zm-3 16h1l-1-1h-2l1 1v1l1-1zm118-10v1l1-1h-1zm3 3l-1-1v-1h-1v1l1 1v1l1 1h1s0-1 0 0v-1l-1-1zm-4 16v-1 1zm2-197v-1l-1 2 1-1zm-4 197l-1-1v1h1zm-17 91v1l1 1s1 0 0 0v-1l-1-1z"/>
                        <path d="M1073 523v-5l-1-1-1-2v-1l-1-1-1-1h-1l-2-1v-4h-1l-1-1h-1v1l-1-1v-2h-1l-1-2v-1c-1 0 0 0 0 0l-1-1-1-1-2-1v-1h-2l-1-1-1-1v-1l-1-1 1-2-1-1-1-2v-2l-1-1v-2l-1-1h-3l-1-2v-2l-1-2v-2l-1-2v-1h-2v1l-1 3v-1l-1 2 1 1h-1v8l-1 3v1l-1 2-3 1-1-1-1-1-1-1h-2l-1-1-1-1-2-1h-1l-1-1-2-1v-2l1-2v-2h2v-1l1-1v-1h-1v-1l-1 1v1l-1-1h-1l1-1h-1l-1 1h-3l-1-1h-2v-1h-2v-1h-2l1 1h1v2h-5v1h-1l-1 1v1l-1 1v1l-1 1v3l-1-1v1l-1-1h-1l-1 1v-1l-1-1-1-1-1-1h-1l-1 1h-2 1l-1 1h-1v-1 1h-1v2h-1v1c1 0 0 0 0 0h-1l-1 1 1 1v-1 1h-1l2 1h-3l-1-1v2h1v1h-1v1l-1-1-1-2v1h-1l-1 2v3h-1l-1 1-1 2-3 2h-3l-1 1h-2l-2 1h-2l-1 1-2 1-2 1-2 1-1 2-1-1 1-1-1 1-1 1v4c-1 2 1 5 2 7v1c-1 1-1-1-1-1h-1v-1h-1l1 1v2l-1-2v1l3 5v1l1 1v1l1 1v3l1 3 1 2v6l-1 1h-1v3h2l1 1 4 1h3l1-1 2-1 1-1 1-1h2a12 12 0 0 1 3 0h6l1-1 1-2h2l1-1 1-1h4l3-1 3-1 4-1h3l3 2h3l1 1h2v2l1 1 1 1v1l1 2v1h1v1h1v-1l1-1 1-1 1-1 1-1 1-1v-1l1-1v3l-1 2v2l-1 1h-1v1l1-1h2v-1l1-2 1 3-1 2h2l1-1v1h-1l2 2 1 2v2l1 1 1 1 2 1h2l1 1h2l1 1 2-1h1l1-1 2-1-1 1v1l1-1h1v2h2c0 1 0 2 1 1v-1h-1 1l1-1 3-2h3l2-1 1-1v-1l1-2v-3l1-1 1-1h-1 1v-2l1-1v-2h1v-1l1-1 1-1 1-1v-1l1-2v-1l1-2v-1l1-3v-4l-1-2zm20-59v-1l-2-1h-1l-1-1 1 1 3 2zm39-202h-1 1v1h1l1-1h-2zm3 2h-1 1zm-24 207h1v-1l-1 1zm38 86h-2l-2 1h-2l-1-1-1-1v-2l-1-1v2h-1l-1-1v-2h-1v-3h-1v-1h-1l-1-1-1 1v-2h-1l1 2v1l1 1v-1 1l1 2h1l-1-1 1 1 1 1h-1l1 1v1h1v1c-1-2-1 0 0 0v3l-1 2v1l-2 1 1 1 1 1 2 1v1l-1 2v1h1v1l3-2 2-3 1-1v-1l-1-1 2-1 1 1v-2l2-1v-3zm-28-60l1 1v-1h-1zm15 73l1-1h-1l-1 1v-1h1-2l-1 1v-1l-1-1v-1l-2 1v3l-2 1v2l-1 1-1 1h-1v1c-1-1-1 0-2 1l-2 1-1 1h-1l-1 1-1 1-1 1-1 1v1h-1 1v1h-2l1 1h-1 1v1h3v1h2s-1 0 0 0c0 1 0 0 0 0h1l1 1 2-1v-1h1l1-1h1v-2l1-1v-3l1-1h1l1-1h1s0-1 0 0h2l-1-1h-1v-1h1l1-1 1-2 1-1h1v-3l1-1-1 1zm-15-75s0-1 0 0zm28 1h-1c0 1 0 0 0 0h1zm-123-243l-1 1v1l1-1 1 1 1-1-1-1h-1zm-3 1h1l1-1h-1l-1 1zm126 238v-1h-2l-1 1-1 1 2 1h1l2-1-1-1s1 0 0 0zm38-275h-1l-1-1h-1l-1-1h-5v1h2l3 1 1 1h1l3-1h-1zm-33 270h-1l-2 1h-1l-1 1 1 1h1v-1h2v-1l-1 1 2-2zM772 315v-1 1z"/>
                        <path d="M1180 206v-1s-1-1 0 0h2l1-1 2-1h-2v-1h-1l-1-1-2-1-2-1-2-1 1 1h-2v-1h-4 1v2l1 1v2l-1-2-1 1v-1h-1v-4h-1c1-2-2-3-3-3l-2-1-1-1h-1l-2-1 1 1h-1c1-1-2-1-2-2h1l-2-1h-1l-2-1-2-1-1-1h-1l-2-1h-2l-3-1h-7l-1-1v1l-2-1h-3l-4-1v2l-1 1h1l1 1 1 2-2 1h-3v-1h-1l-2-1-1-2-2-1-1 1-2 1-2-1h-7l-1-1-1 1h-2l-2 1v3l-1 1-1 1 1-2v-1l-1-3h-2l-1-1v-4l-1-1c-2-2-5-2-8-2h-6l-1 1h-8l1-1-3-2-3 1 1-1h-1l-2-1h-2c-1-1 3-1 3-1 1-1-1-2-1-2l-4-1-4 1-2 2-2 1h-1l-1-1h1c0-1 0-1 0 0l2-1-1-1h2a5155 5155 0 0 0 2-1h-5l-3 1 3-1h3v-1h-3l-5-1h-6l-1-1h-2l1 1 1 1h-3l-2 1-1 1h3-1l-1 1h-1l1 1c1 0 0 0 0 0l1 2h-2l-2-1h-1v1h-1l1 1h-1v1l-1-1-1-1-4-1-2 1h-5l-2-1-1-2-1 3-1 1v1l-2 2h-1v-1c-1 1-2 0-3-1l-1-1-1-1v-1h-1l2-1-1-1-1 1-1-1-3-2c1-1 2 0 3 1h2v-2h-2 1l1-1c1-1-2-1-2-1l2-1-1-1h-1l-1-1h-1l-1-1h-2v1h-2v-1l-2 1-1-1-1-1h-3l-1 1h-1l1 2-2 2-1-1v1s1 0 0 0h-1l-2-1-2 1-2-1h-4l-2-2h2l-4-1-3-1h-3l-3 1h-3l1 1-1 1v1l-1 1v1-1l1-1v-2h-1v-3h-1v1h-2l-3-1 1-1h-2v1h-3l-1 1h4l-2 1-2 1h-2l-1 1h-4l-3 1-1 1h-1l-1 1 1-1 2-2 1-1 1-1h2l2-1 2-2 3-1 1-1h1l2-1 2-1 3-1 2-2v-1l-1-1h-1l-1-1h1l2 1 1-2h-1l-1-1-1-1c1 1 0 1-1 1v-2h-2v-1h-1l-2-1h-9l-1 1h-4 1l1-1 1-1-1-1h-8l3-1 2-1-2-1-2-1h-4l-5 2-1 2-1 1v2h2l-1 1-1-1h-2l-2 1h-3 2l1 1 1 2-2 1 1-2h-1l-1-1h-2l-1 1h-1v1l-1-1-1 1h-4l1-1h-9v1h3l-3 1h-3l-2 1h-1l-4 1h-3l-1 1-2 1h-2c-1 1 2 0 1 1l-2 1h-2l-1 1h3l2 1-1 1-1-1-2 1 2 1 2 1 1 1-2 1h-2l-1 1 2 2-2-1-1-1 2-1 2-1-3-1-1 1h-9l-6 1v1h-1v1l1 1v2l1 1 2 1 2 1v1l1 1h2v5l1 2-1 1-1 1s1 1 0 0h-1l1-2v-2h-1l-1 2v1-5l2-2v-1h-1l-3 1-2-2-1-1h-1l-2-1h-5l-1 1h-1v1l1-1 1 1c1 1-1 1-1 1l-2-1h-3v1l1 1 2 1 1 1h3v1l2 1h-1l-4-1h-1l-1-1h-1c-1 0-4 0-3-1v-3l1-1v-2l-1-1-1-1v3l-2 2-2 1-1 1-1 1 2 1 1 2 1 2-2 2v5l2 1h2l2-1 3 1 2 1h1l1 2v1h-1l-1 2 1 1h2l2 1h-3l-2-1v-3l-1-2-1-1h-3l-4 1 1 2v2l-1 2-1 2-4 2-1 1v1h-7l-1-1h-2v-1h1l2-1 1 1h1l-1 1h2l1-1v-1h1l3-3 1-2v-2l1-1h1l-1-1-1-1c-2 0-2-1-2-2l1-2v-1l-1-2v-1h1v-3l-1-1-1-1v-2l1-1 1-3v-2l-2-1h-7c-1-1-2 1-2 1-1 2-1 5-3 6l-2 2h-1l-1 1v1h1v5l-1 1 1 1h1l2 1v1l1 1 2 1-2 3-1-1h-1v-1h-2v-1h-1l-1-1h-2v-1h-2l-4-2-3-1h-6l-1 1h-1l1 1 1 2v1l-1 1h-2l1 1h-3l1-1-1-1v-1l-3 1-1 1-2 1-1-1h-3l-1 1h-1l-1 2-1-1h-4 1l1-1v-1l1-1h-1l2-1-3 1-3 1 1 1-2 1c1-2-1-1-2-1l-2 1-3 1-2 1h-1v1l-3 1v1l-1 2h-2l-1 1-1-1-2-1c0-1-2-1-1-2l1-1 2-1h2l-1-1-1-1-2-1h-5l-1-1 1 1 1 2v3l-1 1 1 1 1 3-1 1v2l-2-1v-1h-3l-1-1-1 1-1 1-3 1-1 1-1 1 1 2 1 2h-2v1l-3-1-1-1h-1l-2-1h-2v1h-1l1 1 2 2h1l1 1-1 1h-3l-2-1v-1h-3l-1-2v-1l-1-2v-1l1-1-1-2-2-1h-1l1-1h-2v-1h-1l-1-1-2-1h3c-1 1 2 2 2 2h3v1h1l2 1h3l3 1h3c2 0 5 0 6-2l2-1v-1l1-1-1-1v-2h-2l-1-1-1-1-2-1h-2l-2-2-2-1-4-2h-6l-1 1h-1l1-1v-1h-2s1 0 0 0h-1v-1h-1 3l-2-1-1-1v1h-1l-1 1v-1h-1a4 4 0 0 0-1 0v1h-2c1 1-2 1-2 2l-2 1-1 1h1l-1 1v1l1 2h2l1 1v1c1 1-1 3-2 3-1 1 0 2 1 2l1 2 1 2v1l-1 1v1h-1l1 1-1 1 2 1v1l1 1v1l-1 2 2 1 1 1 1 1-1 2-2 2-4 4-2 1-2 2v1l2-1v1l1 1h3v1h-3v1h-1v-1 1h-2v1h1v1h-1v1l-1 1v3l1 1-1 1v1l1 1v1l-1 1 2 1v2h2l1 1h1v1l1-1 2 1h1v2s1 0 0 0v1l1 1v2h1l1 1v1h2v1h1l-1 1-1 1-2-1-1 1h1v2l1 1 1 1 1-1h4l1 1 1 1h-1v2h3v1h1v2h2l1 1h2l1-1 1 2h3v1l1-1v1h2l1 1v1l-1 1v1s0-1 0 0v2h1l-1 1h-3l-1 1-1 1v1h2v1h-2v1h-1v1a1 1 0 0 0 1 0v1h-1v1l-1 1-1 1v-1h-1v1h-1l1 1 1 1h2l1 1 1 1 2 1 1 1 2 1v1a3 3 0 0 0 2 0v1h1l1 1v1l1 1-1 1v1h5v1h3a9 9 0 0 1 2 0h1v1h1v1l1 1v1h-1l1 1h1v1h1v2h-1v-2h-1v-1h-1v1l-1-1h-2v1h-1v2l1 2-1 1 1 1v1l1 1v1l1 1v1l1 1 1 1h1s1 0 0 0v2h-1v1l-1 1v2l1 1v1h1v1c0 1 0 0 0 0l1 1 2 1 1 1 1 1v3l1 1v1h1v2l1-1 1-1v1h3v1l1 1v1h1v1l1 1 2 3h2v1l1 1h2v1h3l1 1 1-1h2v-1h1a1 1 0 0 1 1 0h1l1 1a9 9 0 0 0 0 2l1 1h1v1h2a2 2 0 0 1 1 0 2 2 0 0 0 2 0h1l1 1h1v-1l1 1h3a3 3 0 0 0 1 0h4l1-1h1l1 1h1v-1h6v2h1v1l1 1 1 1h1l1 1 1-1-1 1 1 2h5s0-1 0 0v1h-1l-2 1h-1c0-1 0 0 0 0l1 2c1 1 3 3 5 3l1-1h2v-4h2l-1 1h1v8l1 1h-1 1v5l1 3 1 3 1 1h-1l1 1v1l1 1 1 2v2l1 2 1 2 2 3v2h1l1 3 2 3 2-1 1-2 3-1s-2 0-1-1l1-1v-1h1v-5l1-2 1-2-1-1h1v-1l-1-1v-2l1-2 1-1h1l1-1h2l1-2 1-1 1-1 2-2 2-1 1-1 1-1 1-1v-1l-1 1 1-1c1 0 1 0 0 0h2l1-1h1v-1l1-1v-2l2-1 1-1v-1 2h2v-1 1h1v-1l1 1v-2l1 2 1-1v-1 1h1l1-1-1-1 1-1v-1l-1-1 1 1v-1 3l2-1 1 2h1v3l2 3v1l1-1v1l1 1v-1l1 1v1h1l-1 1s-1-1 0 0l1 1v-2l1 2v3l1 1-1 2v2h1v-1 2l1-1v1l1-1v2l1-2h2v-2 1h1l1-2v-1 1h1v2h1v5l1 1v1l1 2v-1 1l1 1v4l1 1-1 1v3l-1 4v3l1-1v1h1v1h1l1 1v2h1l1 3 1 2v4h1l1 2v1h1l1 1 1 1 1 1 2 1h1l1-1 1 1v-1l-1-2-1-1-1-2v-4l-1-2-1-1-1-1-1-1-1-1h-2l-1-1-1-1v-1c0 1 0 0 0 0l1 1-1-2v-1l-1-1v-2h-2v-5l1-1v-1l1-1v-4l2-1 1 1v2h3l1 1h1l1 2v1c1 0 0 0 0 0l1 1h1v1s-1 0 0 0h2l1 1c0 1 0 0 0 0l1 1c1 0 0 0 0 0v4h-1 2l1-1 2-1-1-2s1 2 2 1l-1-2 1 1v-1c1 0 0 0 0 0h1v-1 1h1l1-1h1v-1h1l1-1h1v-1h1v-8l-1-2-1-1-1-2v-1h-1l-1-1-1-1-2-2-1-1h1l-1-1-1-1-1-1v-1l1-2 1-1 1-1v-2h2l1-1h1l1-1h1v-1 1s2 0 1 1h1l1-1s0 1 0 0l1 1h-1v2h1v1h1v-3h3v-1h2v-1h2c0 1 0 1 0 0h1v-1l1 1v-1l1-1-1-1h1v-1 1l1 1v1h1v-1h4v-1h3v-1s1 0 0 0l1-1h2v-1l1-1v-1h1l1-1 1-1h1v-1h1v-2h-1 1l1-1-1-1h1s0 1 0 0l1-1v-1h1v-2l2-1h1v-3h1v-2l-1 1 1-1-1-1-1-1-2 1v-1h-1 1l2-1 1-1h1l-2-2h-1v-1h-3l2-1 1 1h1l2 1-1-1v-1l-1-1-1-1-1-2-1-2v-1l-2-1-1-1v-1l1-1 1-1 1-1v-1 1h1v-1l1-1h1l2-1h2v-2h-4l-1-1h-2c1 1-1 1-1 1l-1 1h-2v-3h-1l-3-1 1-3h3l1-2 3-2 1-1 1-1h3l1 1v1l-1 1-1 1-1 1h2l-1 1-1 1h2l2-2 3-1h1l1-1 1 1h1l1 1v2l1 1h-2v1l-1 1h1l1 1h1l1-1v1h2v1l1 1v1h-2v1h1v4l-1 1v1h1v1h-1l1 1 1-1 1-1v1l1-1s0 1 0 0h1v-1l1 1h1v-1h2l1-3-1-1 1-1c0-3-2-4-3-6l-1-1-1-1-1-1h-1l1-1v-1l1-1h1l2-1 1-1 1-1v-1l1-1-1-1h1l1-2h1l1-1h-1 2l1-1 1-2v1l1-1v2h4l2-1 2-1 1-1 1-1 1-2h1v-1h1l1-1 4-5v-1l1-1v-1l1-1 2-2 1-1 1-1v-3l1-2v-5l1-1v-2h1l1-1v-1h-1v-3h-1l1-1-1-1-1-1-1-1-1-1h-4c1 1 0 3-1 3l1-2-1 1h-3 1v-1h1l-2-1v1l-1 1-1-1h1v-2l-1-1h-2s-3 0-2-1l3-2 1-1 1-1 3-2 2-3h1l1-1h1v-1h1v-1h1l2-3 3-1 2-3h10l1 1 1-2 1 1h6v-1h1v-1h1l3 1h3l1 1h1l-1 1h-2l1 1h4l1-1h1l1-1 1 1h1c0-1 0 0 0 0h2v-1l-1-1h-2v-1h1v-1l3-3 2-2 1-1 1-1 2-1h3l2-1 1 1h2v1l-1 1v2l2-1-1 2h1l1-1 2-2 2-1 1-1h1l1 1v-4l3-1h2l2 1h-3l-1 3-1 1 1 1-2 1 1 1h-3v1l-3 1-2 3-1 1h-1v1l-2 1-2 3-2 1-1 1h-2v1h-2v2l-2 2-1 2-1 6 1 5 1 3v2l1 1v4l1 1 2-2h1l1-1 1-3v-2h1l1-1h3l-1-1v-1l1-2 1-1h1l1-1v1l2-1 1-1-1-1c-1-1 0-3 1-4h1v-1l1-1h1l-2 1 1 1h1v-3h-1v-2c0-1 2-1 1-2l-1-1-1 1-1-1v-2l2-2v-1h1v-2l1-1 1-1h3l1 1v-1l1-1 3-1-1 3 1-1 2-2h1l2-1h3l2 2s1 2 2 1v-1l1-1 3-2 2-1 1-1v-1l1 1 1-2h3l1-1 2-1 3-1 1-1h1v-1h1v1h1l2 1h2l1-1v-3h-1l-1-1s0 1 0 0l-1-1h1v-1l-1-1-1-1h-1l-1-1v-1h-3l-1 1v-2l-1 1h-4 3l1-1h3l-1-1h2l1 2h5l1-1 1-1 2-1 1-1-2-2 1-1h1v-1l1 1 1-1v1l-1 1v-1l1 2v1h6l2 1 1 2 1 1h2c2 1 3 3 4 1v1h1v-1c1 0 0 0 0 0h1s1 0 0 0l-1-1-1-1h3v-1l-1-1h1l-1-1h1l-2-1h1l1 1h3zM777 308c-1 0-2 0-1 1h-2v-1h-2v-1c-1 2-2 4 0 5v-1h1v1l1 1h-2v1h2v3l1 5h-1l-5 1-4-1-2-1-1-1-2-1-1-2v-2l1-1 1-1v-1l1-2h2l-2-1-1-1-2-3-1-1-1-1-1-1v-1l-1-1v-1l1-2-1 1-1-3h-1l1-2v1l1-2v-2l1 1 1-1h2v-1h1v-1h1l1-1 2-1 4-1v1h3l1 1v2l-1 1v1l1 1-2-1-1 1h-3v2l1 1h-1l-1-1h-1v1l1 1 1 2 1 1v1h1v1h2v2l1 4v-2l1-1 2-1 1 1v2l2 1v1zm338 178zm4 6s0-1 0 0h-1 1-1 1zm-1-3z"/>
                    </g>
                </svg>
                </div>
        </div>
    </div>
</div>
</div>
<div id="placeContainer" class="places"></div>
<script>
$(document).ready(function () {
    let currentContinent = null;
    let continentDataMap = {};
    let currentSort = 'views';  // 초기 정렬값
    let currentCountry = null;  // 선택된 국가

    $('#sortSelect').on('change', function() {
        currentSort = $(this).val();
        if (!currentContinent) return;  // 대륙 선택 안됐으면 무시

        if (currentCountry) {
            // 현재 선택된 국가가 있으면 해당 국가 관광지만 정렬
            const countryPlaces = continentDataMap[currentContinent][currentCountry] || [];
            showPlaces(currentCountry, countryPlaces);
        } else {
            // 국가 선택 안된 상태면 대륙 전체 관광지 정렬
            let allPlaces = [];
            $.each(continentDataMap[currentContinent], (_, placeList) => {
                allPlaces = allPlaces.concat(placeList);
            });
            showPlaces(currentContinent + ' 전체', allPlaces);
        }
    });

    function loadContinentPlaces(continent, limit, sort) {
        $.ajax({
            url: 'place/selectContinentAction.jsp',
            method: 'POST',
            data: { continent: continent, sort: sort },
            dataType: 'json',
            success: function(response) {
                showCountries(continent, response, false);
            },
            error: function() {
                alert(continent + ' 대륙 정보를 가져오는 데 실패했습니다.');
            }
        });
    }

    $('#aws-world-map .m-gi-map-area').on('click', function () {
        const continentName = $(this).data('continent-name');
        if (!continentName) {
            alert('continent-name이 지정되지 않았습니다.');
            return;
        }

        $('#aws-world-map .m-gi-map-area').removeClass('selected-continent');
        $(this).addClass('selected-continent');

        $.ajax({
            url: 'place/selectContinentAction.jsp',
            method: 'POST',
            data: { 
                continent: continentName, 
                sort: currentSort 
            },
            dataType: 'json',
            success: function (response) {
                console.log('대륙 데이터 받음:', response);
                currentContinent = continentName;
                currentCountry = null;  // 대륙을 다시 선택했으므로 국가 선택 초기화
                continentDataMap[continentName] = response;

                $('#placeContainer').empty();
                $('#selection-area').html('<h4>' + capitalize(continentName) + ' 대륙의 국가 목록</h4>');

                showCountries(continentName, response, false);
            },
            error: function () {
                alert(continentName + ' 대륙 정보를 가져오는 데 실패했습니다.');
            }
        });
    });

    function capitalize(text) {
        return text.charAt(0).toUpperCase() + text.slice(1);
    }

    function showCountries(continent, data, showBackButton = false) {
        console.log('showCountries 호출:', continent, data, showBackButton);
        const $area = $('#selection-area');
        $area.empty();





        const $buttonRow = $('<div>').addClass('country-button-row d-flex flex-wrap gap-2');
        
        const sortedCountries = Object.keys(data).sort((a, b) => a.localeCompare(b, 'ko'));

        $.each(sortedCountries, (i, country) => {
            const placeList = data[country];
            $('<button>').addClass('btn btn-outline-dark btn-sm')
                .text(country)
                .click(function () {
                    currentCountry = country;
                    showCountries(continent, data, true);
                    showPlaces(country, placeList);
                    $buttonRow.find('button').removeClass('active');
                    $(this).addClass('active');
                }).appendTo($buttonRow);
        });

        $area.append($buttonRow);

        if (showBackButton) {

            const continentNameMap = {
                "asia": "아시아",
                "europe": "유럽",
                "namerica": "북아메리카",
                "samerica": "남아메리카",

            };

            const koreanName = continentNameMap[continent] || continent; // 매핑 실패 시 원래 이름 사용

            $('<button>').addClass('btn btn-sm btn-outline-info allshow')
                .text(koreanName + ' 전체 보기') // 한글로 표시
                .click(() => {
                    currentCountry = null;
                    let allPlaces = [];
                    $.each(continentDataMap[continent], (_, placeList) => {
                        allPlaces = allPlaces.concat(placeList);
                    });
                    showPlaces(koreanName + ' 전체', allPlaces); // 표시되는 제목도 한글로
                    showCountries(continent, continentDataMap[continent], false);
                }).appendTo($area);
        }

        if (!showBackButton) {
            $('#placeContainer').empty();
            let allPlaces = [];
            $.each(data, (_, placeList) => {
                allPlaces = allPlaces.concat(placeList);
            });
            console.log('전체 관광지 수:', allPlaces.length);
            showPlaces(capitalize(continent) + ' 전체', allPlaces);
        }
    }

    function showPlaces(title, places) {
        console.log('showPlaces 호출:', title, places);
        const $container = $('#placeContainer');
        $container.empty().addClass('places');

        if (!places || places.length === 0) {
            $container.append('<p class="text-center text-muted col-12">관광지가 없습니다.</p>');
            return;
        }

        if (currentSort === 'views') {
            places.sort((a, b) => (b.views || 0) - (a.views || 0));
        } else if (currentSort === 'likes') {
            places.sort((a, b) => (b.likes || 0) - (a.likes || 0));
        } else if (currentSort === 'rating') {
            places.sort((a, b) => (b.avg_rating || 0) - (a.avg_rating || 0));
        }

        $.each(places, (_, place) => {
            appendPlaceCard(place, $container);
        });
    }

    function appendPlaceCard(place, $container) {
        const $card = $('<div class="place-card">').css('cursor', 'pointer');

        const fileName = place.place_img ? place.place_img.split(',')[0] : null;
        const imgPath = fileName ? (fileName) : 'https://via.placeholder.com/200x150?text=No+Image';

        const $imageWrapper = $('<div>').addClass('image-wrapper');
        const $img = $('<img>').attr('src', imgPath).attr('alt', place.place_name).css("border-radius","0.5rem");
        $imageWrapper.append($img);
        $card.append($imageWrapper);

        $('<div class="caption">').text(place.place_name).css({ marginBottom: '1px', paddingBottom: '0' }).appendTo($card);
        
        
        const $ratingDiv= $('<div class="rating">').text('⭐ 평점없음').css({ margin: '0', padding: '0' })
        $card.append($ratingDiv);
        const viewsText = (typeof place.views === 'number' && place.views >= 0)
        ? '👁 조회수: ' + place.views
        : '👁 조회수 정보 없음';
   		 const likesText = (typeof place.likes === 'number' && place.likes >= 0)
        ? '❤️ 좋아요: ' + place.likes
        : '❤️ 좋아요 정보 없음';
  		$('<div class="text-area">').css({ fontSize: '0.65rem', color: '#555' })
  		.html(viewsText + ' | ' + likesText)
  		.appendTo($card);
       
        let avgRating=0;
        var place_num=place.place_num;
        $.ajax({
        	type:"post",
        	dataType:"json",
        	url:"Review/insertApi.jsp",
        	data:{"place_num":place_num},
        	success:function(res){
        		var reviews=res.reviews;
        		var totCnt=0;
                var totStar = 0;               
	            
	            if (reviews && reviews.length > 0) { // 리뷰 데이터가 있는지 확인
	            	var totCnt = reviews.length;
	            
        		 	reviews.forEach(function(r){
        		 		
        		 		// 별점 통계 계산
	                    totStar += parseFloat(r.rating);
	                    
        		 	});
        		 // ⭐⭐⭐ 여기부터 별점 통계 진행 바 업데이트 로직 ⭐⭐⭐
                    avgRating = totCnt > 0 ? parseFloat((totStar / totCnt).toFixed(1)) : 0.0;
        			//console.log(avgRating); 
                    const ratingText = (avgRating !== null)
                    ? '⭐ ' + avgRating
                    : '⭐ 평점없음';
                    
                    $ratingDiv.text(ratingText);
                    
	            }
        	}
        });
       
		
        
        $card.click(() => {
            location.href = 'index.jsp?main=place/detailPlace.jsp&place_num=' + place.place_num;
        });

        $container.append($card);
    }

    function resetAndLoad() {
        currentContinent = null;
        currentCountry = null;
        $('#selection-area').html('<h4>지도를 클릭하여 대륙을 선택하세요.</h4>');
        $('#placeContainer').empty();
        $('#aws-world-map .m-gi-map-area').removeClass('selected-continent');
    }

    resetAndLoad();
});


</script>
</body>
</html>

