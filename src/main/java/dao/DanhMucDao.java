package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.DanhMucModel;
import utils.ConnectDB;

public class DanhMucDao {

	private DanhMucModel mapRow(ResultSet rs) throws SQLException {
		DanhMucModel dm = new DanhMucModel();
		dm.setId(rs.getInt("id"));
		dm.setName(rs.getString("name"));
		dm.setDescription(rs.getString("description"));
		dm.setStatus(rs.getString("status"));
		dm.setCreateAt(rs.getString("created_at"));
		return dm;
	}

	public List<DanhMucModel> getAll() {
		List<DanhMucModel> list = new ArrayList<>();
		String sql = "SELECT id, name, description, status, created_at FROM danh_muc";
		try (Connection con = ConnectDB.getConnect();
			 PreparedStatement pr = con.prepareStatement(sql);
			 ResultSet rs = pr.executeQuery()) {
			while (rs.next()) {
				list.add(mapRow(rs));
			}
		} catch (Exception e) {
			System.err.println("[DanhMucDao.getAll] Loi: " + e.getMessage());
			e.printStackTrace();
		}
		return list;
	}

	public DanhMucModel findById(int id) {
		String sql = "SELECT id, name, description, status, created_at FROM danh_muc WHERE id = ?";
		try (Connection con = ConnectDB.getConnect();
			 PreparedStatement pr = con.prepareStatement(sql)) {
			pr.setInt(1, id);
			try (ResultSet rs = pr.executeQuery()) {
				if (rs.next()) return mapRow(rs);
			}
		} catch (Exception e) {
			System.err.println("[DanhMucDao.findById] Loi: " + e.getMessage());
		}
		return null;
	}

	// ============ CRUD cho Admin ============

	public boolean insert(DanhMucModel dm) {
		String sql = "INSERT INTO danh_muc(name, description, status) VALUES (?, ?, ?)";
		try (Connection con = ConnectDB.getConnect();
			 PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setString(1, dm.getName());
			ps.setString(2, dm.getDescription());
			ps.setString(3, dm.getStatus() == null ? "ACTIVE" : dm.getStatus());
			return ps.executeUpdate() > 0;
		} catch (Exception e) {
			System.err.println("[DanhMucDao.insert] Loi: " + e.getMessage());
		}
		return false;
	}

	public boolean update(DanhMucModel dm) {
		String sql = "UPDATE danh_muc SET name=?, description=?, status=? WHERE id=?";
		try (Connection con = ConnectDB.getConnect();
			 PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setString(1, dm.getName());
			ps.setString(2, dm.getDescription());
			ps.setString(3, dm.getStatus() == null ? "ACTIVE" : dm.getStatus());
			ps.setInt(4, dm.getId());
			return ps.executeUpdate() > 0;
		} catch (Exception e) {
			System.err.println("[DanhMucDao.update] Loi: " + e.getMessage());
		}
		return false;
	}

	public boolean delete(int id) {
		String sql = "DELETE FROM danh_muc WHERE id=?";
		try (Connection con = ConnectDB.getConnect();
			 PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, id);
			return ps.executeUpdate() > 0;
		} catch (Exception e) {
			System.err.println("[DanhMucDao.delete] Loi (co the do san_pham dang tham chieu): " + e.getMessage());
		}
		return false;
	}
}
