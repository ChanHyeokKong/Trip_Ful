package review;

import java.net.ConnectException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import mysql.db.DbConnect;

public class ReviewDao {
	DbConnect db=new DbConnect();
	
	//insertReview
	public void insertReview(ReviewDto dto) {
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		String sql="insert into tripful_review values(null,?,?,?,?,now(),?)";
		
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, dto.getReview_id());
			pstmt.setString(2, dto.getReview_content());
			pstmt.setString(3, dto.getReview_img());
			pstmt.setDouble(4, dto.getReview_star());
			pstmt.setString(5, dto.getPlace_num());
			pstmt.execute();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(pstmt, conn);
		}
		
	}
	//관광지 이름 가져오기
	public String getPlaceName(String place_num)
	{
		String Place_name="";
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="select Place_name from tripful_place where place_num=?";
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, place_num);
			rs=pstmt.executeQuery();
			if(rs.next())
			{
				Place_name=rs.getString("place_name");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return Place_name;
	}
	
	//관광지 아이디
	public String getPlaceCode(String place_num)
	{
		String Place_code="";
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="select Place_code from tripful_place where place_num=?";
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, place_num);
			rs=pstmt.executeQuery();
			if(rs.next())
			{
				Place_code=rs.getString("place_code");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return Place_code;
	}
	
	//관광지 전체리스트
	public List<HashMap<String, String>> getPlaceList(String place_num)
	{
		String sql="select r.review_idx, r.review_id, r.review_content, r.review_img, r.review_star, r.review_writeday, p.place_num "
				+ "from tripful_review r,tripful_place p "
				+ "where r.place_num=p.place_num and p.place_num=?";
		
		List<HashMap<String, String>> list=new ArrayList<HashMap<String,String>>();
		
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, place_num);
			rs=pstmt.executeQuery();
			
			while(rs.next())
			{
				HashMap<String, String> map=new HashMap<String, String>();
				
				map.put("review_idx", rs.getString("review_idx"));
				map.put("review_id", rs.getString("review_id"));
				map.put("review_content", rs.getString("review_content"));
				map.put("review_img", rs.getString("review_img"));
				map.put("review_star", rs.getString("review_star"));
				map.put("review_writeday", rs.getString("review_writeday"));
				map.put("place_num", rs.getString("place_num"));				
				
				//list에 추가
				list.add(map);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}		
		
		return list;
	}
	
	public ReviewDto getOneData(String review_idx) {
		ReviewDto dto=new ReviewDto();
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="select * from tripful_review where review_idx=?";
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, review_idx);
			rs=pstmt.executeQuery();
			if(rs.next())
			{
				dto.setReview_idx(rs.getString("review_idx"));
				dto.setReview_id(rs.getString("review_id"));
				dto.setReview_content(rs.getString("review_content"));
				dto.setReview_img(rs.getString("review_img"));
				dto.setReview_star(rs.getDouble("review_star"));
				dto.setReview_writeday(rs.getTimestamp("review_writeday"));
				dto.setPlace_num(rs.getString("place_num"));
				
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return dto;
		
	}
	
	public double getAverageRatingByPlace(String place_num) {
	    
			Connection conn=db.getConnection();
			PreparedStatement pstmt=null;
			ResultSet rs=null;
		
		double avg = 0.0;
	    try {
	        String sql = "SELECT round(AVG(review_star),1) FROM tripful_review WHERE place_num = ?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, place_num);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            avg = rs.getDouble(1);
	            if (rs.wasNull()) { // 평균값이 없으면
	                avg = -1.0; // 평점 없음 표시를 위해 -1.0 반환
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }finally {
			db.dbClose(rs, pstmt, conn);
		}
	    return avg;
	}

}
