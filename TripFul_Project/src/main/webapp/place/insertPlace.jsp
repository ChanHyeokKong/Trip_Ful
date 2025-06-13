<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
<link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> <!-- jQuery 필수 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.js"></script>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <!-- Bootstrap 5 CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
  
  <%
  String GoogleAPIKEY = ""; //구글 API KEY 입력
  %>
  

  <title>관광지 추가</title>
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
  
  <script>
  let uploadedImageSrcList = [];

  $(document).ready(function () {
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
            sendFile(files[i]);
          }
        },
        onMediaDelete: function(target) {
        	  const fullUrl = target[0].src;
        	  let pathOnly;

        	  try {
        	    pathOnly = new URL(fullUrl).pathname; // ex: /TripFul_Project/save/에펠탑218.jpg
        	  } catch (e) {
        	    pathOnly = fullUrl;
        	  }

        	  const normalizedDeleteTarget = normalizeUrl(pathOnly);

        	  uploadedImageSrcList = uploadedImageSrcList.filter((url) => {
        	    return normalizeUrl(url) !== normalizedDeleteTarget;
        	  });

        	  $.ajax({
        	    url: 'deleteImg.jsp',
        	    type: 'POST',
        	    data: { imageUrl: pathOnly },
        	    success: function(response) {
        	      console.log('이미지 삭제 완료:', response);
        	    },
        	    error: function(xhr, status, error) {
        	      console.error('이미지 삭제 실패:', error);
        	    }
        	  });

        	  console.log("🧹 삭제 후 이미지 배열:", uploadedImageSrcList);
        	}




      }
    });
    
    function cleanSummernoteContent(html) {
    	  const wrapper = document.createElement('div');
    	  wrapper.innerHTML = html;

    	  // data-start, data-end 속성 제거
    	  wrapper.querySelectorAll('[data-start], [data-end]').forEach(el => el.remove());

    	  return wrapper.innerHTML;
    	}

    function sendFile(file) {
      const data = new FormData();
      data.append("file", file);

      $.ajax({
        url: 'uploadImg.jsp',
        type: 'POST',
        data: data,
        contentType: false,
        processData: false,
        success: function (url) {
        	 const cleanUrl = url.trim();

        	  // URL 객체 사용해서 절대경로에서 pathname 추출
        	  let pathnameOnly;
        	  try {
        	    pathnameOnly = new URL(cleanUrl).pathname; // ex: /TripFul_Project/save/에펠탑218.jpg
        	  } catch (e) {
        	    pathnameOnly = cleanUrl; // 상대 경로면 그대로
        	  }

        	  $('#summernote').summernote('insertImage', cleanUrl);
        	  uploadedImageSrcList.push(pathnameOnly); // ✅ 경로만 저장
        	  alert("서머노트에 이미지 추가 ✅");
        },
        error: function (xhr, status, error) {
          alert("이미지 업로드 실패: " + error);
        }
      });
    }
    
    function normalizeUrl(url) {
    	  // 인코딩된 것 디코딩하고, 공백 제거, \r\n 제거
    	  return decodeURIComponent(url).trim().replace(/\s/g, '');
    	}
    
    
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

<h2 class="mb-3 text-center">추가할 관광지를 검색하세요</h2>

<div class="d-flex justify-content-center mb-3" style="gap:10px; align-items:center;">
  <input id="autocomplete" type="text" class="form-control" placeholder="추가할 관광지를 검색하세요" style="max-width: 300px;" />
  <button type="button" class="btn btn-outline-primary" onclick="searchPlace()">검색</button>
  <button type="button" class="btn btn-outline-success" onclick="savePlace()">추가</button>
</div>

<div id="map" style="height: 400px; width: 100%; border-radius: 8px; border: 1px solid #ddd; margin-bottom: 20px;"></div>

<div class="d-flex justify-content-center">
  <form method="post" action="insertPlaceAction.jsp" style="width: 100%; max-width: 1500px;" id="previewForm">
    <div id="place-info" class="card p-2">
      <h5 class="mb-3 text-center">선택된 장소 정보</h5>

      <div class="row gx-3 gy-2">
        <div class="col-md-6">
          <label for="output-name" class="form-label fw-semibold">이름</label>
          <input type="text" id="output-name" name="place_name" class="form-control" required>
        </div>

        <div class="col-md-6">
          <label for="output-address" class="form-label fw-semibold">주소</label>
          <input type="text" id="output-address" name="place_address" class="form-control" required>
        </div>

        <div class="col-md-6">
          <label for="output-placeid" class="form-label fw-semibold">Place ID</label>
          <input type="text" id="output-placeid" name="place_id" class="form-control" required>
        </div>

        <div class="col-md-6">
          <label for="country_name" class="form-label fw-semibold">나라</label>
          <input type="text" id="country_name" name="country_name" class="form-control">
        </div>

        <div class="col-md-6">
          <label for="continent_name" class="form-label fw-semibold">대륙 (영어)</label>
          <input type="text" id="continent_name" name="continent_name" class="form-control">
        </div>

        <div class="col-md-6">
          <label for="place_tag" class="form-label fw-semibold">카테고리</label>
          <input type="text" id="place_tag" name="place_tag" class="form-control" placeholder="예: 관광, 문화, 자연">
        </div>

        <div class="col-12">
          <label for="summernote" class="form-label fw-semibold">관광지 설명</label>
          <textarea id="summernote" name="place_content" class="form-control"></textarea>
          
        </div>
      </div>
      <input type="hidden" id="input-name" name="preview_name">
<input type="hidden" id="input-address" name="preview_address">
<input type="hidden" id="input-placeid" name="preview_placeid">
<input type="hidden" id="input-tag" name="preview_tag">
<input type="hidden" id="input-content" name="preview_content">

      <div class="d-flex justify-content-center gap-3 mt-3">
  <button type="submit" class="btn btn-outline-primary" style="width: 300px;">추가</button>
  <button type="button" class="btn btn-outline-info" style="width: 300px;" id="btnPreview">미리보기</button>
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
  
  const rawcontent = $('#summernote').summernote('code');
  const content = cleanSummernoteContent(rawcontent); // 👈 정제된 conte
  const tag = $('#place_tag').val();

  console.log("저장할 데이터:", {
	    ...currentPlace,
	    tag: tag,
	    content: content
	  });
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