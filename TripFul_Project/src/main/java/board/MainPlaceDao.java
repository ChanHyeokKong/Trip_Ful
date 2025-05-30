package board;

import mysql.db.DbConnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class MainPlaceDao {
    DbConnect db = new DbConnect();

    public List<MainPlaceDto> getRandomPlaces(int count) {
        List<MainPlaceDto> list = new ArrayList<>();
        Connection conn = db.getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT * FROM tripful_place ORDER BY RAND() LIMIT ?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, count);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                MainPlaceDto dto = new MainPlaceDto(
                        rs.getInt("place_num"),
                        rs.getString("country_name"),
                        rs.getString("place_img"),
                        rs.getString("place_content"),
                        rs.getString("place_tag"),
                        rs.getString("place_code"),
                        rs.getString("place_name"),
                        rs.getInt("place_count"),
                        rs.getString("continent_name")
                );
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }

        return list;
    }
}


