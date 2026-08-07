package dao;

import java.sql.*;
import java.util.*;

import model.DanhMucModel;
import utils.ConnectDB;
public class DanhMucDao {
	public List<DanhMucModel> getAll() {
		List<DanhMucModel> list = new ArrayList<>();
		try {
			Connection con = ConnectDB.getConnect();
			String sql = "select * from danh_muc";
			PreparedStatement pr = con.prepareStatement(sql);
			ResultSet result = pr.executeQuery();
			while(result.next()) {
				DanhMucModel dm = new DanhMucModel();
				dm.setId(result.getInt("id"));
				dm.setName(result.getString("name"));
				dm.setDescription(result.getString("description"));
				dm.setStatus(result.getString("status"));
				dm.setCreateAt(result.getString("created_at"));
				list.add(dm);
				
			}
		} catch (Exception e) {
			System.out.println("CÓ lỗi get all: " + e.getMessage());
		}
		return list;
	}
}
