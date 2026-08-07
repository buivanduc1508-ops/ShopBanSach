package dao;

import java.sql.*;
import java.util.*;

import model.DanhMucModel;
import model.SanPhamModel;
import utils.ConnectDB;
public class SanPhamDao {
	public List<SanPhamModel> getAll() {
		List<SanPhamModel> list = new ArrayList();
		try {
			Connection con = ConnectDB.getConnect();
			String sql = "select * from san_pham";
			PreparedStatement pr = con.prepareStatement(sql);
			ResultSet result = pr.executeQuery();
			while(result.next()) {
				SanPhamModel sp = new SanPhamModel();
				sp.setId(result.getInt("id"));
				sp.setCategoryId(result.getInt("category_id"));
				sp.setName(result.getString("name"));
				sp.setDes(result.getString("description"));
				sp.setPrice(result.getFloat("price"));
				sp.setImage(result.getString("image"));
				sp.setQuantity(result.getInt("quantity"));
				sp.setStatus(result.getString("status"));
				sp.setCreateAt(result.getString("created_at"));
				list.add(sp);
			}
		} catch (Exception e) {
			System.out.println("Có lỗi get all sản phẩm: " + e.getMessage());
		}
		return list;
	}
}
