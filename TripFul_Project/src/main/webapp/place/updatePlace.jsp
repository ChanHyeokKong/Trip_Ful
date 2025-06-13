<%@page import="place.PlaceDto"%>
<%@page import="place.PlaceDao"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>

<%
String GoogleAPIKEY = ""; //여기에 API KEY 입력

%>
<html>
<head>
  <meta charset="UTF-8">
<link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> <!-- jQuery 필수 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.js"></script>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
  <title>관광지 수정</title>
   <style>
    #map {
      height: 500px;
      width: 100%;
    }
    
  .carousel-inner {
  height: 300px; /* 고정 높이 */
  display: block;
  align-items: center;
  justify-content: center;
}

.carousel-item img {
  max-height: 100%;
  width: auto;
  border-radius: 8px;
  object-fit: cover;
}
    
    .place-title {
  font-size: 2rem;
  font-weight: 700;
  margin-bottom: 1rem;
  
}

.category {
  font-size: 1rem;
  color: #666;
  font-weight: 500;
}

.description {
  font-size: 1rem;
  line-height: 1.6;
  color: #333;
  margin-bottom: 1rem;
}

.location,
.address {
  font-size: 0.9rem;
  color: #888;
}

.main-section {
  display: flex;
  gap: 1rem;
  margin-top: 1rem;
}

.image-box img {
  border-radius: 10px;
  width: 100%;
  height: auto;
}

.info-box {
  flex-grow: 1;
}
    
    
  </style>
<%
	String num=request.getParameter("place_num"); 

	PlaceDao dao=new PlaceDao();
	
	PlaceDto dto=dao.getPlaceData(num);
	
    String content = dto.getPlace_content();
    String imgPaths = dto.getPlace_img();

    String imgTags = "";
    if (imgPaths != null && imgPaths.trim().length() > 0) {
        String[] paths = imgPaths.split(",");
        StringBuilder sb = new StringBuilder();
        for (String path : paths) {
            sb.append("<img src='").append(path.trim()).append("' style='max-width:100%;'><br>");
        }
        imgTags = sb.toString();
    }

    String combinedContent = (content != null ? content : "") + "<br>" + imgTags;

    // 자바스크립트에 그대로 넣을 문자열로 이스케이프
    String jsEscapedContent = combinedContent.replace("\\", "\\\\")
                                             .replace("\"", "\\\"")
                                             .replace("\'", "\\\'")
                                             .replace("\r", "\\r")
                                             .replace("\n", "\\n");
    
    System.out.println("imgaTags: "+imgTags);
    System.out.println("content: "+content);
%>
  <style>
    #map {
      height: 500px;
      width: 100%;
    }
  </style>
  
 <script>
  // 기존 이미지 배열 (경로만, 공백제거)
  let originalImages = [
    <% if (imgPaths != null && !imgPaths.trim().isEmpty()) {
         String[] arr = imgPaths.split(",");
         for (int i = 0; i < arr.length; i++) {
           out.print("\"" + arr[i].trim() + "\"");
           if (i != arr.length - 1) out.print(",");
         }
       } %>
  ];

  // 새로 업로드된 이미지 리스트 (기존 이미지 포함)
  let uploadedImageSrcList = [...originalImages];

  // URL 경로 정규화 함수 (디코딩 + 공백 제거)
  function normalizeUrl(url) {
    if (!url) return "";
    try {
      return decodeURIComponent(new URL(url).pathname).trim().replace(/\s/g, '');
    } catch (e) {
      return decodeURIComponent(url).trim().replace(/\s/g, '');
    }
  }

  // 에디터 내 모든 이미지 src 경로 배열 반환 (정규화)
  function getEditorImages() {
    return $('.note-editable img').map(function() {
      return normalizeUrl($(this).attr('src'));
    }).get();
  }

  // 이미지 삭제 처리 함수
  function handleImageDeleteByKey(fullUrl) {
    if (!fullUrl) return;

    const normalized = normalizeUrl(fullUrl);

    // 기존 이미지이면 서버 삭제 요청 안 함
    if (originalImages.some(orig => normalizeUrl(orig) === normalized)) {
      console.log("기존 이미지, 서버 삭제 요청 안함:", normalized);
      return;
    }

    // uploadedImageSrcList에서 제거
    uploadedImageSrcList = uploadedImageSrcList.filter(url => normalizeUrl(url) !== normalized);

    // 서버에 삭제 요청
    $.ajax({
      url: 'deleteImg2.jsp',
      type: 'POST',
      data: {   imageUrl: fullUrl,
    	   		 num: '<%=num%>' 
    	   		},
      success: function() { console.log("서버 이미지 삭제 성공:", fullUrl); },
      error: function() { console.error("서버 이미지 삭제 실패:", fullUrl); }
    });
  }

  $(document).ready(function () {
    // Summernote 초기화
    $('#summernote').summernote({
      height: 300,
      placeholder: '내용을 입력하세요...',
      toolbar: [
        ['style', ['bold', 'italic', 'underline', 'clear']],
        ['font', ['strikethrough', 'superscript', 'subscript']],
        ['color', ['color']],
        ['para', ['ul', 'ol', 'paragraph']],
        ['insert', ['link', 'picture']],
        ['view', ['fullscreen', 'codeview']]
      ],
      callbacks: {
        onImageUpload: function (files) {
          for (let i = 0; i < files.length; i++) {
            uploadFile(files[i]);
          }
        },
        onMediaDelete: function ($target) {
          const src = $target.attr('src');
          handleImageDeleteByKey(src);
        }
      }
    });

    // 초기값 에디터에 세팅 (기존 content + 이미지)
    const initialContent = `<%= content != null ? content.replace("\\", "\\\\").replace("`","\\`").replace("\r","").replace("\n","") : "" %>`;
    const initialImgTags = `<%= imgTags %>`;
    $('#summernote').summernote('code', initialContent + "<br>" + initialImgTags);

    // 이미지 업로드 ajax 함수
    function uploadFile(file) {
      let formData = new FormData();
      formData.append('file', file);

      $.ajax({
        url: 'uploadImg.jsp',
        type: 'POST',
        data: formData,
        contentType: false,
        processData: false,
        success: function(url) {
          let trimmedUrl = url.trim();
          $('#summernote').summernote('insertImage', trimmedUrl);
          // 새로 업로드된 이미지 리스트에 경로 추가 (정규화)
          uploadedImageSrcList.push(trimmedUrl);
          alert("이미지 업로드 성공!");
        },
        error: function() {
          alert("이미지 업로드 실패!");
        }
      });
    }

    // MutationObserver로 이미지 DOM 삭제 감지 (혹시 onMediaDelete 미작동시 대비)
    const editor = document.querySelector('.note-editable');
    if (editor) {
      const observer = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
          mutation.removedNodes.forEach(function(node) {
            if (node.tagName === 'IMG') {
              handleImageDeleteByKey(node.getAttribute('src'));
            }
            if (node.querySelectorAll) {
              node.querySelectorAll('img').forEach(img => {
                handleImageDeleteByKey(img.getAttribute('src'));
              });
            }
          });
        });
      });
      observer.observe(editor, { childList: true, subtree: true });
    }

    // 저장 전 실제 남아있는 이미지 필터링 함수
    $('form').on('submit', function() {
      const editorImgs = getEditorImages();

      // 기존 이미지 + 새로 업로드된 이미지 중 실제 남아있는 것만 필터링
      const filteredImgs = [
        ...originalImages.filter(img => editorImgs.includes(normalizeUrl(img))),
        ...uploadedImageSrcList.filter(img => editorImgs.includes(normalizeUrl(img)))
      ];

      // hidden input 또는 textarea에 JSON 문자열로 전달 (필요 시 서버에서 활용)
      if ($('#imgListInput').length === 0) {
        $('<input>').attr({
          type: 'hidden',
          id: 'imgListInput',
          name: 'imgList'
        }).appendTo('form');
      }
      $('#imgListInput').val(JSON.stringify(filteredImgs));
    });
    
    let observer;

    function observeImageDeletion() {
      const editorBody = document.querySelector('.note-editable');

      if (!editorBody) return;

      observer = new MutationObserver((mutations) => {
        mutations.forEach((mutation) => {
          // 삭제된 노드 중 이미지가 있는지 확인
          mutation.removedNodes.forEach((node) => {
            if (node.tagName === 'IMG') {
              const src = node.getAttribute('src');
              handleImageDeleteByKey(src);
            }

            // 혹시 감싸는 divごと 삭제된 경우 처리
            const imgs = node.querySelectorAll ? node.querySelectorAll('img') : [];
            imgs.forEach(img => {
              handleImageDeleteByKey(img.getAttribute('src'));
            });
          });
        });
      });

      observer.observe(editorBody, {
        childList: true,
        subtree: true
      });
    }

    // 이미지 삭제 처리 함수
    function handleImageDeleteByKey(fullUrl) {
      if (!fullUrl) return;

      let pathOnly;
      try {
        pathOnly = new URL(fullUrl).pathname;
      } catch (e) {
        pathOnly = fullUrl;
      }

      const normalizedDeleteTarget = normalizeUrl(pathOnly);

      // 배열에서 제거
      uploadedImageSrcList = uploadedImageSrcList.filter((url) => {
        return normalizeUrl(url) !== normalizedDeleteTarget;
      });

      // 서버에 삭제 요청
      $.ajax({
        url: 'deleteImg.jsp',
        type: 'POST',
        data: { imageUrl: pathOnly },
        success: function (response) {
          console.log('🔁 이미지 삭제 (키 입력 감지):', response);
        },
        error: function (xhr, status, error) {
          console.error('이미지 삭제 실패:', error);
        }
      });

      console.log("🧹 배열 삭제 후:", uploadedImageSrcList);
    }
    
    observeImageDeletion();


  });

</script>


</head>

<body>

<h2 class="mb-3 text-center">수정할 관광지를 검색하세요</h2>

<div class="d-flex justify-content-center mb-3" style="gap:10px; align-items:center;">
  <input id="autocomplete" type="text" class="form-control" placeholder="수정할 관광지를 검색하세요" style="max-width: 300px;" />
  <button type="button" class="btn btn-outline-primary" onclick="searchPlace()">검색</button>
  <button type="button" class="btn btn-outline-success" onclick="savePlace()">추가</button>
</div>

<div id="map" style="height: 400px; width: 100%; border-radius: 8px; border: 1px solid #ddd; margin-bottom: 20px;"></div>

<div class="d-flex justify-content-center">
  <form method="post" action="updatePlaceAction.jsp" style="width: 100%; max-width: 1500px;">
    <div id="place-info" class="card p-3">
      <h5 class="mb-3 text-center">선택된 장소 정보</h5>
      
      <input type="hidden" name="num" value="<%=num%>">

      <div class="row gx-3 gy-2">
        <div class="col-md-6">
          <label for="output-name" class="form-label fw-semibold">이름</label>
          <input type="text" id="output-name" name="place_name" value="<%=dto.getPlace_name()%>" class="form-control" required>
        </div>

        <div class="col-md-6">
          <label for="output-address" class="form-label fw-semibold">주소</label>
          <input type="text" id="output-address" name="place_address" value="<%=dto.getPlace_addr()%>" class="form-control" required>
        </div>

        <div class="col-md-6">
          <label for="output-placeid" class="form-label fw-semibold">Place ID</label>
          <input type="text" id="output-placeid" name="place_id" value="<%=dto.getPlace_code()%>" class="form-control" required>
        </div>

        <div class="col-md-6">
          <label for="country_name" class="form-label fw-semibold">나라</label>
          <input type="text" id="country_name" name="country_name" value="<%=dto.getCountry_name()%>" class="form-control">
        </div>

        <div class="col-md-6">
          <label for="continent_name" class="form-label fw-semibold">대륙 (영어)</label>
          <input type="text" id="continent_name" name="continent_name" value="<%=dto.getContinent_name()%>" class="form-control">
        </div>

        <div class="col-md-6">
          <label for="place_tag" class="form-label fw-semibold">카테고리</label>
          <input type="text" id="place_tag" name="place_tag" value="<%=dto.getPlace_tag()%>" class="form-control" placeholder="예: 관광, 문화, 자연">
        </div>

        <div class="col-12">
          <label for="summernote" class="form-label fw-semibold">관광지 설명</label>
          <textarea id="summernote" name="place_content" class="form-control"><%=dto.getPlace_content() != null ? dto.getPlace_content() : "" %><%=imgTags %></textarea>
        </div>
      </div>
		


      <div class="d-flex justify-content-center gap-3 mt-3">
  <button type="submit" class="btn btn-outline-primary" style="width: 300px;">수정</button>
  <button type="button" class="btn btn-outline-secondary" style="width: 300px;" id="btnPreview">미리보기</button>
  <button type="button" class="btn btn-outline-warning" style="width: 300px;" onclick="history.back()">뒤로가기</button>
</div>
    </div>
  </form>
</div>



  <script>
    let map, marker, autocomplete, currentPlace = null;

    function initMap() {
      const defaultCenter = { lat: 37.5665, lng: 126.9780 }; // 서울

      map = new google.maps.Map(document.getElementById("map"), {
        center: defaultCenter,
        zoom: 13
      });

      marker = new google.maps.Marker({ map: map });

      autocomplete = new google.maps.places.Autocomplete(document.getElementById("autocomplete"));

      // 장소 선택 시 정보 저장
      autocomplete.addListener("place_changed", function () {
        const place = autocomplete.getPlace();

        if (!place.geometry) {
          alert("장소 정보를 찾을 수 없습니다.");
          return;
        }

        // ✅ place_id도 포함해서 저장
        currentPlace = {
          name: place.name,
          address: place.formatted_address,
          lat: place.geometry.location.lat(),
          lng: place.geometry.location.lng(),
          place_id: place.place_id
        };
      });
    }

    // 지도 이동
    function searchPlace() {
      if (!currentPlace) {
        alert("검색어를 입력하고 자동완성에서 장소를 선택해주세요.");
        return;
      }

      const location = new google.maps.LatLng(currentPlace.lat, currentPlace.lng);
      map.setCenter(location);
      map.setZoom(16);
      marker.setPosition(location);
    }

    // 정보 출력
   function savePlace() {
  if (!currentPlace) {
    alert("먼저 장소를 검색하고 선택해주세요.");
    return;
  }

  document.getElementById("output-name").value = currentPlace.name;
  document.getElementById("output-address").value = currentPlace.address;
  document.getElementById("output-placeid").value = currentPlace.place_id;

  console.log("저장할 데이터:", currentPlace);
}
    
   $(document).ready(function () {
	   $('#btnPreview').on('click', function () {
	     const name = $('#output-name').val();
	     const address = $('#output-address').val();
	     const placeId = $('#output-placeid').val();
	     const tag = $('#place_tag').val();
	     const content = $('#summernote').summernote('code');
	     //const imageList = JSON.stringify(uploadedImageSrcList);
	     const imageList = JSON.stringify(
		  uploadedImageSrcList.map(url => {
		    try {
		      return new URL(url).pathname; // 전체 URL에서 `/TripFul_Project/save/...` 추출
		    } catch (e) {
		      return url; // 혹시 상대경로가 이미 있으면 그대로
		    }
		  })
		);

	     
	     // 새 팝업창 먼저 오픈
	     const popup = window.open('', 'previewPopup', 'width=1100,height=800');
	     if (!popup) {
	       alert("팝업이 차단되었습니다. 팝업 허용 후 다시 시도해주세요.");
	       return;
	     }

	     // 기존에 생성된 폼이 있다면 삭제
	     $('#dynamicPreviewForm').remove();

	     // 폼 동적 생성
	     const $form = $('<form>', {
	       method: 'post',
	       action: 'detailPreview.jsp',
	       target: 'previewPopup',
	       id: 'dynamicPreviewForm'
	     });

	     // hidden input 추가
	     $form.append($('<input>', { type: 'hidden', name: 'preview_name', value: name }));
	     $form.append($('<input>', { type: 'hidden', name: 'preview_address', value: address }));
	     $form.append($('<input>', { type: 'hidden', name: 'preview_placeid', value: placeId }));
	     $form.append($('<input>', { type: 'hidden', name: 'preview_tag', value: tag }));
	     $form.append($('<input>', { type: 'hidden', name: 'preview_content', value: content }));
	     $form.append($('<input>', { type: 'hidden', name: 'preview_images', value: imageList }));  // ✅ 이미지 배열 추가

	     // form을 body에 붙이고 submit
	     $('body').append($form);
	     $form.submit();
	   });
	 });
  </script>
  
  
  

  <script src="https://maps.googleapis.com/maps/api/js?key=<%=GoogleAPIKEY %>&libraries=places&callback=initMap" async defer></script>

</body>
</html>