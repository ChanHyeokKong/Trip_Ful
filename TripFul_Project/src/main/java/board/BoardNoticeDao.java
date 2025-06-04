package board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import mysql.db.DbConnect;

public class BoardNoticeDao {
	
	
	DbConnect db=new DbConnect();
	
	//추가
	public void insertBoard(BoardNoticeDto dto)
	{
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		
		String sql="insert into tripful_notice values(null,?,?,?,?,now(),?)";
		
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, dto.getNotice_title());
			pstmt.setString(2, dto.getNotice_content());
			pstmt.setString(3, dto.getNotice_img());
			pstmt.setString(4, dto.getNotice_writer());
			pstmt.setInt(5, dto.getNotice_readcount());
			pstmt.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(pstmt, conn);
		}
		
	}
	
	//전체글갯수
	public int getTotalCount()
	{
		int n=0;
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="select count(*) from tripful_notice";
		
		try {
			pstmt=conn.prepareStatement(sql);
			rs=pstmt.executeQuery();
			if(rs.next())
			{
				n=rs.getInt(1);
			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}

		return n;
	}
		
	//페이징처리한 리스트 목록 반환
	public List<BoardNoticeDto> getList(int startNum,int perPage)
	{
		List<BoardNoticeDto> list=new ArrayList<BoardNoticeDto>();
		String sql="select * from tripful_notice order by notice_idx desc limit ?,?";
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
			
			
		try {
			pstmt=conn.prepareStatement(sql);
			//바인딩
			pstmt.setInt(1, startNum);
			pstmt.setInt(2, perPage);
			//실행
			rs=pstmt.executeQuery();
			while(rs.next())
			{
				BoardNoticeDto dto=new BoardNoticeDto();
				dto.setNotice_idx(rs.getString("notice_idx"));
				dto.setNotice_title(rs.getString("notice_title"));
				dto.setNotice_content(rs.getString("notice_content"));
				dto.setNotice_img(rs.getString("notice_img"));
				dto.setNotice_readcount(rs.getInt("notice_readcount"));
				dto.setNotice_writer(rs.getString("notice_writer"));
				dto.setNotice_writeday(rs.getTimestamp("notice_writeday"));
				//list 에 추가
				list.add(dto);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		return list;
	}
		
		//조회수 증가
		// 조회수 1 증가
	    public void updateReadCount(String idx) 
	    {
	        String sql = "update tripful_notice set notice_readcount=notice_readcount+1 where notice_idx=?";
	        Connection conn = db.getConnection();
	        PreparedStatement pstmt = null;
	        try {
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setString(1, idx);
	            pstmt.execute();
	        } catch (SQLException e) {
	            e.printStackTrace();
	        } finally {
	            db.dbClose(pstmt, conn);
	        }
	    }
	    
	    // 특정 게시물 데이터 가져오기 (getData 메소드)
	    public BoardNoticeDto getData(String notice_idx) {
	        BoardNoticeDto dto = null; // 게시물을 찾지 못하면 null 반환
	        String sql = "select * from tripful_notice where notice_idx=?";
	        Connection conn = db.getConnection();
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;

	        try {
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setString(1, notice_idx);
	            rs = pstmt.executeQuery();

	            if (rs.next()) {
	                dto = new BoardNoticeDto(); // 게시물을 찾았을 때만 DTO 객체 생성
	                dto.setNotice_idx(rs.getString("notice_idx"));
	                dto.setNotice_title(rs.getString("notice_title"));
	                dto.setNotice_content(rs.getString("notice_content"));
	                dto.setNotice_img(rs.getString("notice_img"));
	                dto.setNotice_readcount(rs.getInt("notice_readcount"));
	                dto.setNotice_writer(rs.getString("notice_writer"));
	                dto.setNotice_writeday(rs.getTimestamp("notice_writeday"));
	            }
	        } catch (SQLException e) {
	            e.printStackTrace(); // 실제 운영에서는 로깅 등으로 대체하는 것이 좋습니다.
	        } finally {
	            db.dbClose(rs, pstmt, conn);
	        }
	        return dto;
	    }
	    
	    // 게시물 수정
	    public void updateBoard(BoardNoticeDto dto) {
	        Connection conn = db.getConnection();
	        PreparedStatement pstmt = null;

	        // notice_writeday를 현재 시간으로 업데이트
	        // notice_writer는 일반적으로 수정하지 않지만, DTO에 포함되어 있다면 업데이트 가능 (정책에 따라 결정)
	        String sql = "update tripful_notice set notice_title=?, notice_content=?, notice_img=?, notice_writer=?, notice_writeday=now() where notice_idx=?";

	        try {
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setString(1, dto.getNotice_title());
	            pstmt.setString(2, dto.getNotice_content());
	            pstmt.setString(3, dto.getNotice_img());
	            pstmt.setString(4, dto.getNotice_writer());   
	            pstmt.setString(5, dto.getNotice_idx());

	            pstmt.executeUpdate(); // executeUpdate()는 영향받은 행의 수를 반환합니다.
	        } catch (SQLException e) {
	            e.printStackTrace();
	        } finally {
	            db.dbClose(pstmt, conn);
	        }
	    }
	    
	    // 공지사항 게시물 삭제
	    public void deleteNotice(String notice_idx) {
	        Connection conn = db.getConnection();
	        PreparedStatement pstmt = null;
	        String sql = "delete from tripful_notice where notice_idx=?";

	        try {
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setString(1, notice_idx);
	            pstmt.executeUpdate();
	        } catch (SQLException e) {
	            e.printStackTrace();
	        } finally {
	            db.dbClose(pstmt, conn);
	        }
	    }
	    
	    
	 // BoardNoticeDao.java
	 // ... (기존 메소드들은 그대로) ...

	 /**
	  * 공지사항 검색 결과의 전체 개수를 반환합니다.
	  * @param keyword 검색어
	  * @return 검색된 총 게시물 수
	  */
	 public int getSearchTotalCount(String keyword) {
	     int total = 0;
	     Connection conn = db.getConnection();
	     PreparedStatement pstmt = null;
	     ResultSet rs = null;
	     // 제목 또는 내용에서 키워드 검색 (실제 DB 컬럼명 확인 필요)
	     String sql = "select count(*) from tripful_notice where notice_title like ? or notice_content like ?";

	     try {
	         pstmt = conn.prepareStatement(sql);
	         pstmt.setString(1, "%" + keyword + "%");
	         pstmt.setString(2, "%" + keyword + "%");
	         rs = pstmt.executeQuery();
	         if (rs.next()) {
	             total = rs.getInt(1);
	         }
	     } catch (SQLException e) {
	         System.out.println("Notice Search Total Count Error: " + e.getMessage());
	         e.printStackTrace();
	     } finally {
	         db.dbClose(rs, pstmt, conn);
	     }
	     return total;
	 }

	 /**
	  * 키워드로 공지사항을 검색하고 페이징 처리된 목록을 반환합니다.
	  * @param keyword 검색어
	  * @param startNum 가져올 데이터의 시작 위치 (offset)
	  * @param perPage 페이지당 보여줄 게시물 수
	  * @return 검색된 공지사항 목록 (List<BoardNoticeDto>)
	  */
	 public List<BoardNoticeDto> searchNotices(String keyword, int startNum, int perPage) {
	     List<BoardNoticeDto> list = new ArrayList<>();
	     // 최신글이 위로 오도록 정렬 (notice_idx 또는 notice_writeday 기준)
	     String sql = "select * from tripful_notice where notice_title like ? or notice_content like ? order by notice_idx desc limit ?, ?";
	     Connection conn = db.getConnection();
	     PreparedStatement pstmt = null;
	     ResultSet rs = null;

	     try {
	         pstmt = conn.prepareStatement(sql);
	         pstmt.setString(1, "%" + keyword + "%");
	         pstmt.setString(2, "%" + keyword + "%");
	         pstmt.setInt(3, startNum);
	         pstmt.setInt(4, perPage);
	         rs = pstmt.executeQuery();
	         while (rs.next()) {
	             BoardNoticeDto dto = new BoardNoticeDto();
	             dto.setNotice_idx(rs.getString("notice_idx"));
	             dto.setNotice_title(rs.getString("notice_title"));
	             // dto.setNotice_content(rs.getString("notice_content")); // 목록에서는 보통 제목만
	             dto.setNotice_writer(rs.getString("notice_writer"));
	             dto.setNotice_writeday(rs.getTimestamp("notice_writeday"));
	             dto.setNotice_readcount(rs.getInt("notice_readcount"));
	             // 필요한 다른 필드들도 설정
	             list.add(dto);
	         }
	     } catch (SQLException e) {
	         System.out.println("Search Notices Error: " + e.getMessage());
	         e.printStackTrace();
	     } finally {
	         db.dbClose(rs, pstmt, conn);
	     }
	     return list;
	 }

}
