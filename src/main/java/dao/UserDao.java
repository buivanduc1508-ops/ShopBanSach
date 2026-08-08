package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.UserModel;
import utils.ConnectDB;

public class UserDao {

	private UserModel mapRow(ResultSet rs) throws SQLException {
		UserModel u = new UserModel();
		u.setId(rs.getInt("id"));
		u.setFullName(rs.getString("full_name"));
		u.setEmail(rs.getString("email"));
		u.setPasswordHash(rs.getString("password_hash"));
		u.setPhone(rs.getString("phone"));
		u.setAddress(rs.getString("address"));
		u.setRole(rs.getString("role"));
		u.setStatus(rs.getString("status"));
		u.setCreatedAt(rs.getString("created_at"));
		return u;
	}

	public UserModel findByEmail(String email) {
		UserModel user = null;
		String sql = "SELECT id, full_name, email, password_hash, phone, address, role, status, created_at "
				+ "FROM users WHERE email = ?";
		try (Connection con = ConnectDB.getConnect();
				PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setString(1, email);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) user = mapRow(rs);
			}
		} catch (Exception e) {
			System.err.println("Loi findByEmail: " + e.getMessage());
		}
		return user;
	}

	public UserModel findById(int id) {
		UserModel user = null;
		String sql = "SELECT id, full_name, email, password_hash, phone, address, role, status, created_at "
				+ "FROM users WHERE id = ?";
		try (Connection con = ConnectDB.getConnect();
				PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, id);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) user = mapRow(rs);
			}
		} catch (Exception e) {
			System.err.println("Loi findById: " + e.getMessage());
		}
		return user;
	}

	public boolean insert(UserModel user) {
		String sql = "INSERT INTO users(full_name, email, password_hash, phone, address, role, status) "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?)";
		try (Connection con = ConnectDB.getConnect();
				PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setString(1, user.getFullName());
			ps.setString(2, user.getEmail());
			ps.setString(3, user.getPasswordHash());
			ps.setString(4, user.getPhone());
			ps.setString(5, user.getAddress());
			ps.setString(6, user.getRole() == null ? "CUSTOMER" : user.getRole());
			ps.setString(7, user.getStatus() == null ? "ACTIVE" : user.getStatus());
			return ps.executeUpdate() > 0;
		} catch (Exception e) {
			System.err.println("Loi insert user: " + e.getMessage());
		}
		return false;
	}

	// ============ CRUD cho Admin ============

	public List<UserModel> getAll() {
		List<UserModel> list = new ArrayList<>();
		String sql = "SELECT id, full_name, email, password_hash, phone, address, role, status, created_at FROM users ORDER BY id ASC";
		try (Connection con = ConnectDB.getConnect();
			 PreparedStatement pr = con.prepareStatement(sql);
			 ResultSet rs = pr.executeQuery()) {
			while (rs.next()) list.add(mapRow(rs));
		} catch (Exception e) {
			System.err.println("[UserDao.getAll] Loi: " + e.getMessage());
		}
		return list;
	}

	public boolean updateStatus(int id, String status) {
		String sql = "UPDATE users SET status=? WHERE id=?";
		try (Connection con = ConnectDB.getConnect();
			 PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setString(1, status);
			ps.setInt(2, id);
			return ps.executeUpdate() > 0;
		} catch (Exception e) {
			System.err.println("[UserDao.updateStatus] Loi: " + e.getMessage());
		}
		return false;
	}

	public boolean updateRole(int id, String role) {
		String sql = "UPDATE users SET role=? WHERE id=?";
		try (Connection con = ConnectDB.getConnect();
			 PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setString(1, role);
			ps.setInt(2, id);
			return ps.executeUpdate() > 0;
		} catch (Exception e) {
			System.err.println("[UserDao.updateRole] Loi: " + e.getMessage());
		}
		return false;
	}

	public int countAll() {
		String sql = "SELECT COUNT(*) FROM users";
		try (Connection con = ConnectDB.getConnect();
			 PreparedStatement pr = con.prepareStatement(sql);
			 ResultSet rs = pr.executeQuery()) {
			if (rs.next()) return rs.getInt(1);
		} catch (Exception e) {
			System.err.println("[UserDao.countAll] Loi: " + e.getMessage());
		}
		return 0;
	}
}
