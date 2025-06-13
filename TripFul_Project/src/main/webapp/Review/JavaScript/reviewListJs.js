
$(document).on('click', '.review_category', function(e) {
    // 현재 클릭된 아이콘의 review-id를 가져옵니다. (옵션)
    var clickedId = $(this).attr("review_id");
	//console.log(clickedId);
    // 다른 모든 열려있는 드롭다운 메뉴를 닫습니다.
    // 현재 클릭된 메뉴만 열리도록 하기 위함.
    $('.dropdown-menu').not($(this).next('.dropdown-menu')).slideUp(100);

    // 현재 클릭된 아이콘 바로 다음에 오는 '.dropdown-menu'를 찾아서 토글합니다.
    $(this).next('.dropdown-menu').slideToggle(100); // slideToggle로 부드러운 효과

    // 클릭 이벤트가 버블링되는 것을 막아, document 클릭 시 닫히는 이벤트와 충돌 방지
    e.stopPropagation();
});

// 2. 드롭다운 메뉴 외부를 클릭했을 때 메뉴 닫기
$(document).on('click', function() {
    $('.dropdown-menu').slideUp(100);
});

//리뷰 삭제
$(document).on("click", ".delete-btn", function(){
	
	var review_idx=$(this).attr("review_idx");
	swal.fire({
				        title: "리뷰를 삭제하시겠습니까?",		 
				        confirmButtonColor: "#d33",
				        cancelButtonColor: "#3085d6",
				        confirmButtonText: "삭제",
				        cancelButtonText: "취소",			        
				        showCancelButton: true
				        })
				          .then((result) => {
				          if (result.value) {
							
				              $.ajax({
								type:"post",
								dataType:"html",
								url:"Review/reviewDelete.jsp",
								data:{"review_idx":review_idx},
								success:function(){
									closeModalAndRefresh(); // 성공 시 모달 닫고 목록 새로고침
								}
							  })
				          }
				        });
});




//리뷰 삭제
$(document).on("click", ".delete-btn2", function(){
	
	var review_idx=$(this).attr("review_idx");
	//console.log(review_idx);
	var a=$(".reportListBtn").is(":checked");
	console.log(a);
	swal.fire({
				        title: "리뷰를 삭제하시겠습니까?",	
				        confirmButtonColor: "#d33",
				        cancelButtonColor: "#3085d6",
				        confirmButtonText: "삭제",
				        cancelButtonText: "취소",			        
				        showCancelButton: true
				        })
				          .then((result) => {
				          if (result.value) {
							
				              $.ajax({
								type:"post",
								dataType:"html",
								url:"Review/reviewDelete.jsp",
								data:{"review_idx":review_idx},
								success:function(){
									// 폼 초기화 로직
									location.reload();	
									if(a)
										{										
											$(".allReviewList").hide();
											$(".reportList").show();
											$(".reportListBtn").siblings("i.bi").addClass("bi-check-circle-fill");
											$(".reportListBtn").siblings("i.bi").removeClass("bi-check-circle");
										}
									
								}
							  })
				          }
				        });
});



$(document).on("click",".report",function(){
	var review_idx=$(this).attr("review_idx");
	var loginok=$(this).attr("loginok");
	if(loginok==null || loginok=="null")
		{
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
		}else{
			location.href="index.jsp?main=Review/reviewReport.jsp?review_idx="+review_idx;
		}	
});

$(document).on("click",".likedicon",function(){
	var review_idx=$(this).attr("review_idx");
	var loginok=$(this).attr("loginok");
	var likeIcon=$(this);
	//console.log(review_idx);
	var data={"review_idx":review_idx}
	if(loginok==null || loginok=="null")
		{
			swal.fire({
						title: "로그인이 필요한 서비스입니다.", 
						text: "로그인 페이지로 이동하시겠습니까?", 
						type: "warning",
						confirmButtonColor: "#3085d6",
						cancelButtonColor: "#d33",
						confirmButtonText: "네, 이동하겠습니다",
						cancelButtonText: "아니요",  
						showCancelButton: true
					}).then((result) => {
						if (result.value) {
								const currentUrl = window.location.href;
								// 로그인 페이지 주소 + redirect 파라미터로 현재 URL 전달
								const loginUrl = 'index.jsp?main=login/login.jsp&redirect=' + encodeURIComponent(currentUrl);
								location.href = loginUrl;
								return;
							}
						});
		}else{	
			
				$.ajax({
					type:"get",
					dataType:"json",
					url:"Review/reviewLike.jsp",
					data:data,		
					success:function(r){
						var like=r.like;
						//console.log(r.likeCnt);
						if(like=="1")
							{
								likeIcon.removeClass("bi-heart");
								likeIcon.addClass("bi-heart-fill");
								likeIcon.css("color","red");
							}else{
								likeIcon.removeClass("bi-heart-fill");
								likeIcon.addClass("bi-heart");								
								likeIcon.css("color","black");
							}
						
						likeIcon.siblings(".likedcnt").text(r.likeCnt);
					}
				});
		}
});

