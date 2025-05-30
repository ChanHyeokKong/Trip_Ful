

	// elements
	var modalBtn = $("#modalBtn");
	var modal = $("#myModal");
	var closeBtn = $("#closeBtn");
	var save = $(".save");
	
	
	/*modalBtn.click(function() {
			toggleModal();
		});*/
	closeBtn.click(function() {
		$('.modal').removeClass('show');
		setTimeout(function() {
		    $('.modal').css('display', 'none'); // 트랜지션 완료 후 display를 none으로 변경
		}, 300);
	});
	save.click(function(e) {		
		
		e.preventDefault(); // 폼 제출 막기
		var frm=document.querySelector(".modalfrm");
		
		var formData = new FormData(frm);
		console.log(formData);
		$.ajax({
			type:"post",
			dataType:"html",
			url:"reviewAddAction.jsp",
			data:formData,
			processData: false, // 필수
			contentType: false, // 필수
			success:function(){
				
			}
			
		})
		$('.modal').removeClass('show');
		setTimeout(function() {
		    $('.modal').css('display', 'none'); // 트랜지션 완료 후 display를 none으로 변경
		}, 300);
	});

	$(window).on("click", function(event) {
		// 모달의 검은색 배경 부분이 클릭된 경우 닫히도록 하는 코드
		if ($(event.target).is(modal)) {
			$('.modal').removeClass('show');
			setTimeout(function() {
			    $('.modal').css('display', 'none'); // 트랜지션 완료 후 display를 none으로 변경
			}, 300);
		}
	});

	//별점
	$(".star_rating .star").click(function() {
		//alert("aa");
		var clickedStar = $(this);

		//console.log(clickedStar.hasClass("on"));

		// 이미 on인 경우 = 다시 클릭하면 전부 off
		if (clickedStar.hasClass('on') && !clickedStar.next().hasClass('on')) 
		{
			clickedStar.removeClass('on').prevAll('.star').removeClass('on');
		} else {
			// 해당 별까지 on, 나머지는 off
			clickedStar.addClass('on').prevAll('.star').addClass('on');
			clickedStar.nextAll('.star').removeClass('on');
		}
			//별점 값 저장 (1~5)
			var review_star = clickedStar.hasClass('on') ? clickedStar.index() + 1 : 0;
			$('#review_star').val(review_star);
			//console.log($("#review_star").val());
	});
	 
	  // 파일 선택 이벤트는 1회만 바인딩
	  $("#file").change(function () {
	    const file = this.files[0];
	    if (file) {
	      const reader = new FileReader();
	      reader.onload = function (e) {
	    	// 기존 이미지 제거
	    	 $("#show").find(".img-wrapper").remove();
	        // 버튼 숨기고 이미지 표시
	        $(".btn-upload").hide();
	        $("#show").append("<div class='img-wrapper'><img id='showimg' src='"+e.target.result+"'><i class='bi bi-x img-icon'></i></div>");
	      };
	      reader.readAsDataURL(file);
	    }
	  });
		
	  // 이미지 클릭하면 파일 선택 다시 열기
	  $(document).on("click", "#showimg", function () {
	    $("#file").click();
	  });
	  $(document).on("click", ".img-icon", function (e) {
		 e.stopPropagation(); // <- 이 줄이 핵심!
		    $(".img-wrapper").hide();
		    $(".btn-upload").show();
		  });		  
	
	
