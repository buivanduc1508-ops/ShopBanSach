package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.CartItemModel;
import utils.ConnectDB;

public class CartDao {

	public List<CartItemModel> getByUserId(int userId) {
		List<CartItemModel> list = new ArrayList<>();
		// Sale: uu tien sale_price neu co, nho hon price
		String sql = "SELECT sp.id AS product_id, sp.name, sp.image, "
				+ "sp.price, COALESCE(NULLIF(sp.sale_price, 0), sp.price) AS display_price, "
				+ "gh.quantity "
				+ "FROM gio_hang gh JOIN san_pham sp ON gh.product_id = sp.id "
				+ "WHERE gh.user_id = ?";
		try (Connection con = ConnectDB.getConnect();
				PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, userId);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					CartItemModel item = new CartItemModel();
					item.setProductId(rs.getInt("product_id"));
					item.setName(rs.getString("name"));
					item.setImage(rs.getString("image"));
					item.setPrice(rs.getDouble("price"));
					item.setDisplayPrice(rs.getDouble("display_price"));
					item.setQuantity(rs.getInt("quantity"));
					list.add(item);
				}
			}
		} catch (Exception e) {
			System.err.println("Loi getByUserId cart: " + e.getMessage());
			e.printStackTrace();
		}
		return list;
	}

	public boolean addOrUpdate(int userId, int productId, int quantity) {
		// Check exists
		String check = "SELECT quantity FROM gio_hang WHERE user_id = ? AND product_id = ?";
		String insert = "INSERT INTO gio_hang(user_id, product_id, quantity) VALUES (?, ?, ?)";
		String update = "UPDATE gio_hang SET quantity = ?, updated_at = SYSDATETIME() "
				+ "WHERE user_id = ? AND product_id = ?";
		try (Connection con = ConnectDB.getConnect()) {
			int current = 0;
			boolean exists = false;
			try (PreparedStatement ps = con.prepareStatement(check)) {
				ps.setInt(1, userId);
				ps.setInt(2, productId);
				try (ResultSet rs = ps.executeQuery()) {
					if (rs.next()) {
						current = rs.getInt("quantity");
						exists = true;
					}
				}
			}
			if (exists) {
				try (PreparedStatement ps = con.prepareStatement(update)) {
					ps.setInt(1, current + quantity);
					ps.setInt(2, userId);
					ps.setInt(3, productId);
					return ps.executeUpdate() > 0;
				}
			} else {
				try (PreparedStatement ps = con.prepareStatement(insert)) {
					ps.setInt(1, userId);
					ps.setInt(2, productId);
					ps.setInt(3, quantity);
					return ps.executeUpdate() > 0;
				}
			}
		} catch (Exception e) {
			System.err.println("Loi addOrUpdate cart: " + e.getMessage());
		}
		return false;
	}

	public boolean updateQuantity(int userId, int productId, int quantity) {
		String sql = "UPDATE gio_hang SET quantity = ?, updated_at = SYSDATETIME() "
				+ "WHERE user_id = ? AND product_id = ?";
		try (Connection con = ConnectDB.getConnect();
				PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, quantity);
			ps.setInt(2, userId);
			ps.setInt(3, productId);
			return ps.executeUpdate() > 0;
		} catch (Exception e) {
			System.err.println("Loi updateQuantity cart: " + e.getMessage());
		}
		return false;
	}

	public boolean remove(int userId, int productId) {
		String sql = "DELETE FROM gio_hang WHERE user_id = ? AND product_id = ?";
		try (Connection con = ConnectDB.getConnect();
				PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, userId);
			ps.setInt(2, productId);
			return ps.executeUpdate() > 0;
		} catch (Exception e) {
			System.err.println("Loi remove cart: " + e.getMessage());
		}
		return false;
	}

	public boolean clear(int userId) {
		String sql = "DELETE FROM gio_hang WHERE user_id = ?";
		try (Connection con = ConnectDB.getConnect();
				PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, userId);
			return ps.executeUpdate() >= 0;
		} catch (Exception e) {
			System.err.println("Loi clear cart: " + e.getMessage());
		}
		return false;
	}
}