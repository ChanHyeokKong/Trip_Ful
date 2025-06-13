<%@ page pageEncoding="UTF-8" %>
<%@page import="review.ReportDao"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="review.ReviewDao"%>
<%@page import="java.util.TimeZone"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page import="java.net.*, java.io.*, org.json.*" %>
<%@ page contentType="application/json; charset=UTF-8" %>
	<%
	//정렬
	String sort=request.getParameter("sort");
	if (sort == null || sort.trim().equals("")) {
	    sort = "latest"; // 기본 정렬: 최신순
	}
	//관광지값
	String place_num=request.getParameter("place_num");
	ReviewDao dao=new ReviewDao();
	//관광지 이름
	String place_name=dao.getPlaceName(place_num);
	//관광지 코드
	String place_code=dao.getPlaceCode(place_num);
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
	//DB리스트
	List<HashMap<String,String>> DBlist=dao.getPlaceList(place_num);
	
    String apiKey = "GOOGLE_PLACE_API_KEY"; // 여기에 본인의 API 키 입력
    
  // String placeId = "ChIJod7tSseifDUR9hXHLFNGMIs"; // 예시: Sydney의 Google place ID
    
	//placeId를 place_code로 바꿔주면된다
    String urlString = "https://maps.googleapis.com/maps/api/place/details/json?place_id=" + place_code +"&language=ko" + "&fields=review,rating&key=" + apiKey;
	
    URL url = new URL(urlString);	
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    conn.setRequestMethod("GET");

    BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
    StringBuilder response1 = new StringBuilder();

    String line;
    while ((line = reader.readLine()) != null) {
        response1.append(line);
    }
    reader.close();

    JSONObject json = new JSONObject(response1.toString());
    JSONArray googleReviews = json.getJSONObject("result").optJSONArray("reviews");
    
    List<HashMap<String, String>> merged = new ArrayList<>();
    
 	// Google 리뷰 추가
 	if (googleReviews != null) {
     for (int i = 0; i < googleReviews.length(); i++) {
         JSONObject r = googleReviews.getJSONObject(i);
         HashMap<String, String> apilist = new HashMap<>();
         apilist.put("author", r.optString("author_name"));
         apilist.put("rating", String.valueOf(r.optDouble("rating")));
         apilist.put("text", r.optString("text"));
		 
         long time = r.optLong("time") * 1000L;
         String date = "";
         if (time > 0) {
             Date d = new Date(time);             
             sdf.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
             date = sdf.format(d);
         }
         apilist.put("date", date);
       	 apilist.put("photo1", "");
         apilist.put("photo2", "");
         apilist.put("photo3", "");
         apilist.put("read", "Google");
         apilist.put("review_idx", "");  // 임시값
         apilist.put("likeCheck", "0");
         apilist.put("likeCnt","0");
         //api 리뷰 리스트 병합 리스트에 추가
         merged.add(apilist);    // Google 리뷰
      	
     	
     }
 }
 	String member_id=(String)session.getAttribute("id");
 	ReportDao rdao=new ReportDao();
    // DB 리뷰에서 키명 맞추기
    for (HashMap<String, String> map : DBlist) {
        HashMap<String, String> review = new HashMap<>();
        String reviewData=map.get("review_writeday");
        reviewData=reviewData.substring(0,reviewData.length()-9);
        review.put("author", map.get("review_id"));	
        review.put("rating", map.get("review_star"));
        review.put("text", map.get("review_content"));       
        review.put("date", reviewData);               
        
        String review_img=map.get("review_img");
        if(review_img!=null && !"null".equals(review_img))
        {
        	String [] review_imgs=review_img.split(",");
        	for(int i=0;i<review_imgs.length;i++)
        	{
        		if(review_imgs.length>i)
        		{
        			review.put("photo"+(i+1), review_imgs[i].trim());
        		}else{
        			review.put("photo"+(i+1),"");
        		}
        	}
        }else{
        	review.put("photo1", "");
            review.put("photo2", "");
            review.put("photo3", "");
        }
        
        
     	int likeCheck=rdao.getlike(member_id, map.get("review_idx"));
     	int likeCount=rdao.getLikeCount(map.get("review_idx"));
     	String like=likeCheck+"";
     	String likeCnt=likeCount+"";
     	
        review.put("read","DB");
        review.put("review_idx", map.get("review_idx"));
        review.put("likeCheck",like);
        review.put("likeCnt",likeCnt);
        merged.add(review);
    } 	
 	
    // 병합 리스트 정렬
    if ("latest".equals(sort)) {
        Collections.sort(merged, (m1, m2) -> {
            try {
                return sdf.parse(m2.get("date")).compareTo(sdf.parse(m1.get("date")));
            } catch (Exception e) {
                return 0;
            }
        });
    } else if ("rating".equals(sort)) {
        Collections.sort(merged, (m1, m2) -> {
            try {
                double r1 = Double.parseDouble(m1.get("rating"));
                double r2 = Double.parseDouble(m2.get("rating"));
                return Double.compare(r2, r1); // 높은 별점 우선
            } catch (Exception e) {
                return 0;
            }
        });
    } else if ("likes".equals(sort)) {
        Collections.sort(merged, (m1, m2) -> {
        	   try {
                   // 리뷰 출처 우선순위: DB > Google
                   String source1 = m1.get("read");
                   String source2 = m2.get("read");
					
                   if (!source1.equals(source2)) {
                       // DB가 앞에 오도록: "DB"이면 -1, 아니면 1
                       return "DB".equals(source1) ? -1 : 1;
                   }

                   // 같은 출처(DB끼리 or Google끼리)라면 likeCnt 내림차순
                   int l1 = Integer.parseInt(m1.getOrDefault("likeCnt", "0"));
                   int l2 = Integer.parseInt(m2.getOrDefault("likeCnt", "0"));
                   return Integer.compare(l2, l1);
               } catch (Exception e) {
                   return 0;
               }
        });
    }

    // JSONArray로 변환
    JSONArray jsonArr = new JSONArray();
    for (HashMap<String, String> m : merged) {
        JSONObject obj = new JSONObject(m);
        jsonArr.put(obj);
    }

    JSONObject result = new JSONObject();
    result.put("reviews", jsonArr);
    //System.out.println(result.toString());
    
%>
<%=result.toString() %>
