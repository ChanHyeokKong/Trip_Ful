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
	    public void updateReadCount(String idx) {
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
}
