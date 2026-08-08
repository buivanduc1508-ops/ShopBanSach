package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.SanPhamModel;
import utils.ConnectDB;

public class SanPhamDao {

	private SanPhamModel mapRow(ResultSet rs) throws SQLException {
		SanPhamModel sp = new SanPhamModel();
		sp.setId(rs.getInt("id"));
		sp.setCategoryId(rs.getInt("category_id"));
		sp.setName(rs.getString("name"));
		sp.setDes(rs.getString("description"));
		sp.setPrice(rs.getFloat("price"));
		float sp1 = rs.getFloat("sale_price");
		sp.setSalePrice(rs.wasNull() ? null : sp1);
		sp.setAuthor(rs.getString("author"));
		sp.setImage(rs.getString("image"));
		sp.setQuantity(rs.getInt("quantity"));
		sp.setStatus(rs.getString("status"));
		sp.setCreateAt(rs.getString("created_at"));
		return sp;
	}

	private static final String SELECT_ALL =
		"SELECT id, category_id, name, description, price, sale_price, author, image, quantity, status, created_at FROM san_pham";

	public List<SanPhamModel> getAll() {
		List<SanPhamModel> list = new ArrayList<>();
		try (Connection con = ConnectDB.getConnect();
			 PreparedStatement pr = con.prepareStatement(SELECT_ALL);
			 ResultSet rs = pr.executeQuery()) {
			while (rs.next()) {
				list.add(mapRow(rs));
			}
			System.out.println("[SanPhamDao.getAll] Tra ve " + list.size() + " san pham");
		} catch (Exception e) {
			System.err.println("[SanPhamDao.getAll] Loi: " + e.getMessage());
			e.printStackTrace();
		}
		return list;
	}

	public SanPhamModel findById(int id) {
		String sql = SELECT_ALL + " WHERE id = ?";
		try (Connection con = ConnectDB.getConnect();
			 PreparedStatement pr = con.prepareStatement(sql)) {
			pr.setInt(1, id);
			try (ResultSet rs = pr.executeQuery()) {
				if (rs.next()) {
					return mapRow(rs);
				}
			}
		} catch (Exception e) {
			System.err.println("[SanPhamDao.findById] Loi: " + e.getMessage());
		}
		return null;
	}

	public List<SanPhamModel> getByCategory(int categoryId) {
		List<SanPhamModel> list = new ArrayList<>();
		String sql = SELECT_ALL + " WHERE category_id = ?";
		try (Connection con = ConnectDB.getConnect();
			 PreparedStatement pr = con.prepareStatement(sql)) {
			pr.setInt(1, categoryId);
			try (ResultSet rs = pr.executeQuery()) {
				while (rs.next()) {
					list.add(mapRow(rs));
				}
			}
		} catch (Exception e) {
			System.err.println("[SanPhamDao.getByCategory] Loi: " + e.getMessage());
		}
		return list;
	}

	public List<SanPhamModel> getOnSale() {
		List<SanPhamModel> list = new ArrayList<>();
		String sql = SELECT_ALL
			+ " WHERE sale_price IS NOT NULL AND sale_price > 0 AND sale_price < price";
		try (Connection con = ConnectDB.getConnect();
			 PreparedStatement pr = con.prepareStatement(sql);
			 ResultSet rs = pr.executeQuery()) {
			while (rs.next()) {
				list.add(mapRow(rs));
			}
		} catch (Exception e) {
			System.err.println("[SanPhamDao.getOnSale] Loi: " + e.getMessage());
		}
		return list;
	}

	public List<SanPhamModel> getFeatured(int limit) {
		List<SanPhamModel> list = new ArrayList<>();
		String sql = "SELECT TOP " + limit
			+ " id, category_id, name, description, price, sale_price, author, image, quantity, status, created_at"
			+ " FROM san_pham ORDER BY created_at DESC, id DESC";
		try (Connection con = ConnectDB.getConnect();
			 PreparedStatement pr = con.prepareStatement(sql);
			 ResultSet rs = pr.executeQuery()) {
			while (rs.next()) {
				list.add(mapRow(rs));
			}
		} catch (Exception e) {
			System.err.println("[SanPhamDao.getFeatured] Loi: " + e.getMessage());
			e.printStackTrace();
		}
		return list;
	}

	public int countAll() {
		String sql = "SELECT COUNT(*) FROM san_pham";
		try (Connection con = ConnectDB.getConnect();
			 PreparedStatement pr = con.prepareStatement(sql);
			 ResultSet rs = pr.executeQuery()) {
			if (rs.next()) return rs.getInt(1);
		} catch (Exception e) {
			System.err.println("[SanPhamDao.countAll] Loi: " + e.getMessage());
		}
		return 0;
	}

	// ============ CRUD cho Admin ============

	public boolean insert(SanPhamModel sp) {
		String sql = "INSERT INTO san_pham(category_id, name, description, price, sale_price, author, image, quantity, status) "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
		try (Connection con = ConnectDB.getConnect();
			 PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
			ps.setInt(1, sp.getCategoryId());
			ps.setString(2, sp.getName());
			ps.setString(3, sp.getDes());
			ps.setFloat(4, sp.getPrice());
			if (sp.getSalePrice() == null) ps.setNull(5, java.sql.Types.FLOAT);
			else ps.setFloat(5, sp.getSalePrice());
			ps.setString(6, sp.getAuthor());
			ps.setString(7, sp.getImage());
			ps.setInt(8, sp.getQuantity());
			ps.setString(9, sp.getStatus() == null ? "ACTIVE" : sp.getStatus());
			return ps.executeUpdate() > 0;
		} catch (Exception e) {
			System.err.println("[SanPhamDao.insert] Loi: " + e.getMessage());
		}
		return false;
	}

	public boolean update(SanPhamModel sp) {
		String sql = "UPDATE san_pham SET category_id=?, name=?, description=?, price=?, sale_price=?, "
				+ "author=?, image=?, quantity=?, status=? WHERE id=?";
		try (Connection con = ConnectDB.getConnect();
			 PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, sp.getCategoryId());
			ps.setString(2, sp.getName());
			ps.setString(3, sp.getDes());
			ps.setFloat(4, sp.getPrice());
			if (sp.getSalePrice() == null) ps.setNull(5, java.sql.Types.FLOAT);
			else ps.setFloat(5, sp.getSalePrice());
			ps.setString(6, sp.getAuthor());
			ps.setString(7, sp.getImage());
			ps.setInt(8, sp.getQuantity());
			ps.setString(9, sp.getStatus() == null ? "ACTIVE" : sp.getStatus());
			ps.setInt(10, sp.getId());
			return ps.executeUpdate() > 0;
		} catch (Exception e) {
			System.err.println("[SanPhamDao.update] Loi: " + e.getMessage());
		}
		return false;
	}

	public boolean delete(int id) {
		String sql = "DELETE FROM san_pham WHERE id=?";
		try (Connection con = ConnectDB.getConnect();
			 PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, id);
			return ps.executeUpdate() > 0;
		} catch (Exception e) {
			System.err.println("[SanPhamDao.delete] Loi: " + e.getMessage());
		}
		return false;
	}

	public List<SanPhamModel> search(String keyword) {
		List<SanPhamModel> list = new ArrayList<>();
		String sql = SELECT_ALL + " WHERE name LIKE ? OR author LIKE ? ORDER BY id DESC";
		try (Connection con = ConnectDB.getConnect();
			 PreparedStatement pr = con.prepareStatement(sql)) {
			String kw = "%" + (keyword == null ? "" : keyword.trim()) + "%";
			pr.setString(1, kw);
			pr.setString(2, kw);
			try (ResultSet rs = pr.executeQuery()) {
				while (rs.next()) list.add(mapRow(rs));
			}
		} catch (Exception e) {
			System.err.println("[SanPhamDao.search] Loi: " + e.getMessage());
		}
		return list;
	}

	public int countLowStock(int threshold) {
		String sql = "SELECT COUNT(*) FROM san_pham WHERE quantity <= ?";
		try (Connection con = ConnectDB.getConnect();
			 PreparedStatement pr = con.prepareStatement(sql)) {
			pr.setInt(1, threshold);
			try (ResultSet rs = pr.executeQuery()) {
				if (rs.next()) return rs.getInt(1);
			}
		} catch (Exception e) {
			System.err.println("[SanPhamDao.countLowStock] Loi: " + e.getMessage());
		}
		return 0;
	}

	// ============ PHAN TRANG + LOC ============

	/**
	 * Loc san pham theo keyword + categoryId, co phan trang.
	 * page >= 1, pageSize > 0.
	 */
	public List<SanPhamModel> filter(String keyword, Integer categoryId, int page, int pageSize) {
		List<SanPhamModel> list = new ArrayList<>();
		StringBuilder sql = new StringBuilder(SELECT_ALL).append(" WHERE 1=1");
		List<Object> params = new ArrayList<>();
		if (keyword != null && !keyword.trim().isEmpty()) {
			sql.append(" AND (name LIKE ? OR author LIKE ?)");
			String kw = "%" + keyword.trim() + "%";
			params.add(kw);
			params.add(kw);
		}
		if (categoryId != null && categoryId > 0) {
			sql.append(" AND category_id = ?");
			params.add(categoryId);
		}
		sql.append(" ORDER BY id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
		params.add((page - 1) * pageSize);
		params.add(pageSize);
		try (Connection con = ConnectDB.getConnect();
			 PreparedStatement pr = con.prepareStatement(sql.toString())) {
			for (int i = 0; i < params.size(); i++) pr.setObject(i + 1, params.get(i));
			try (ResultSet rs = pr.executeQuery()) {
				while (rs.next()) list.add(mapRow(rs));
			}
		} catch (Exception e) {
			System.err.println("[SanPhamDao.filter] Loi: " + e.getMessage());
		}
		return list;
	}

	public int countFilter(String keyword, Integer categoryId) {
		StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM san_pham WHERE 1=1");
		List<Object> params = new ArrayList<>();
		if (keyword != null && !keyword.trim().isEmpty()) {
			sql.append(" AND (name LIKE ? OR author LIKE ?)");
			String kw = "%" + keyword.trim() + "%";
			params.add(kw);
			params.add(kw);
		}
		if (categoryId != null && categoryId > 0) {
			sql.append(" AND category_id = ?");
			params.add(categoryId);
		}
		try (Connection con = ConnectDB.getConnect();
			 PreparedStatement pr = con.prepareStatement(sql.toString())) {
			for (int i = 0; i < params.size(); i++) pr.setObject(i + 1, params.get(i));
			try (ResultSet rs = pr.executeQuery()) {
				if (rs.next()) return rs.getInt(1);
			}
		} catch (Exception e) {
			System.err.println("[SanPhamDao.countFilter] Loi: " + e.getMessage());
		}
		return 0;
	}
}
