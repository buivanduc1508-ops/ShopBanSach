package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.InvoiceModel;
import utils.ConnectDB;

public class InvoiceDao {

	/**
	 * Tao hoa don + chi tiet hoa don + tru quantity trong san_pham. Tra ve id
	 * hoa don moi tao, hoac -1 neu loi.
	 */
	public int createInvoice(InvoiceModel inv, java.util.List<model.CartItemModel> items) {
		String insertInvoice = "INSERT INTO hoa_don(user_id, receiver_name, receiver_phone, receiver_address, note, "
				+ "total_amount, payment_method, order_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
		String insertDetail = "INSERT INTO hoa_don_chi_tiet(invoice_id, product_id, product_name, product_image, "
				+ "price_at_purchase, quantity, line_total) VALUES (?, ?, ?, ?, ?, ?, ?)";
		String updateStock = "UPDATE san_pham SET quantity = quantity - ? WHERE id = ? AND quantity >= ?";

		try (Connection con = ConnectDB.getConnect()) {
			con.setAutoCommit(false);
			try {
				int invoiceId = -1;
				try (PreparedStatement ps = con.prepareStatement(insertInvoice, java.sql.Statement.RETURN_GENERATED_KEYS)) {
					ps.setInt(1, inv.getUserId());
					ps.setString(2, inv.getReceiverName());
					ps.setString(3, inv.getReceiverPhone());
					ps.setString(4, inv.getReceiverAddress());
					ps.setString(5, inv.getNote());
					ps.setDouble(6, inv.getTotalAmount());
					ps.setString(7, inv.getPaymentMethod() == null ? "COD" : inv.getPaymentMethod());
					ps.setString(8, inv.getOrderStatus() == null ? "PENDING" : inv.getOrderStatus());
					ps.executeUpdate();
					try (ResultSet keys = ps.getGeneratedKeys()) {
						if (keys.next()) invoiceId = keys.getInt(1);
					}
				}
				if (invoiceId <= 0) {
					con.rollback();
					return -1;
				}

				for (model.CartItemModel item : items) {
					try (PreparedStatement ps = con.prepareStatement(insertDetail)) {
						ps.setInt(1, invoiceId);
						ps.setInt(2, item.getProductId());
						ps.setString(3, item.getName());
						ps.setString(4, item.getImage());
						ps.setDouble(5, item.getPrice());
						ps.setInt(6, item.getQuantity());
						ps.setDouble(7, item.getLineTotal());
						ps.executeUpdate();
					}
					try (PreparedStatement ps = con.prepareStatement(updateStock)) {
						ps.setInt(1, item.getQuantity());
						ps.setInt(2, item.getProductId());
						ps.setInt(3, item.getQuantity());
						ps.executeUpdate();
					}
				}

				con.commit();
				return invoiceId;
			} catch (Exception e) {
				con.rollback();
				System.err.println("Loi createInvoice (rollback): " + e.getMessage());
				return -1;
			} finally {
				con.setAutoCommit(true);
			}
		} catch (Exception e) {
			System.err.println("Loi createInvoice connection: " + e.getMessage());
			return -1;
		}
	}

	// ============ CRUD cho Admin ============

	private InvoiceModel mapRow(ResultSet rs) throws SQLException {
		InvoiceModel inv = new InvoiceModel();
		inv.setId(rs.getInt("id"));
		inv.setUserId(rs.getInt("user_id"));
		inv.setReceiverName(rs.getString("receiver_name"));
		inv.setReceiverPhone(rs.getString("receiver_phone"));
		inv.setReceiverAddress(rs.getString("receiver_address"));
		inv.setNote(rs.getString("note"));
		inv.setTotalAmount(rs.getDouble("total_amount"));
		inv.setPaymentMethod(rs.getString("payment_method"));
		inv.setOrderStatus(rs.getString("order_status"));
		inv.setCreatedAt(rs.getString("created_at"));
		return inv;
	}

	public List<InvoiceModel> getAll() {
		List<InvoiceModel> list = new ArrayList<>();
		String sql = "SELECT id, user_id, receiver_name, receiver_phone, receiver_address, note, "
				+ "total_amount, payment_method, order_status, created_at FROM hoa_don ORDER BY created_at DESC, id DESC";
		try (Connection con = ConnectDB.getConnect();
			 PreparedStatement pr = con.prepareStatement(sql);
			 ResultSet rs = pr.executeQuery()) {
			while (rs.next()) list.add(mapRow(rs));
		} catch (Exception e) {
			System.err.println("[InvoiceDao.getAll] Loi: " + e.getMessage());
		}
		return list;
	}

	public InvoiceModel findById(int id) {
		String sql = "SELECT id, user_id, receiver_name, receiver_phone, receiver_address, note, "
				+ "total_amount, payment_method, order_status, created_at FROM hoa_don WHERE id=?";
		try (Connection con = ConnectDB.getConnect();
			 PreparedStatement pr = con.prepareStatement(sql)) {
			pr.setInt(1, id);
			try (ResultSet rs = pr.executeQuery()) {
				if (rs.next()) return mapRow(rs);
			}
		} catch (Exception e) {
			System.err.println("[InvoiceDao.findById] Loi: " + e.getMessage());
		}
		return null;
	}

	public boolean updateStatus(int id, String status) {
		String sql = "UPDATE hoa_don SET order_status=?, updated_at=SYSDATETIME() WHERE id=?";
		try (Connection con = ConnectDB.getConnect();
			 PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setString(1, status);
			ps.setInt(2, id);
			return ps.executeUpdate() > 0;
		} catch (Exception e) {
			System.err.println("[InvoiceDao.updateStatus] Loi: " + e.getMessage());
		}
		return false;
	}

	public int countAll() {
		String sql = "SELECT COUNT(*) FROM hoa_don";
		try (Connection con = ConnectDB.getConnect();
			 PreparedStatement pr = con.prepareStatement(sql);
			 ResultSet rs = pr.executeQuery()) {
			if (rs.next()) return rs.getInt(1);
		} catch (Exception e) {
			System.err.println("[InvoiceDao.countAll] Loi: " + e.getMessage());
		}
		return 0;
	}

	public double sumRevenue() {
		String sql = "SELECT ISNULL(SUM(total_amount),0) FROM hoa_don WHERE order_status <> 'CANCELLED'";
		try (Connection con = ConnectDB.getConnect();
			 PreparedStatement pr = con.prepareStatement(sql);
			 ResultSet rs = pr.executeQuery()) {
			if (rs.next()) return rs.getDouble(1);
		} catch (Exception e) {
			System.err.println("[InvoiceDao.sumRevenue] Loi: " + e.getMessage());
		}
		return 0;
	}

	public int countByStatus(String status) {
		String sql = "SELECT COUNT(*) FROM hoa_don WHERE order_status=?";
		try (Connection con = ConnectDB.getConnect();
			 PreparedStatement pr = con.prepareStatement(sql)) {
			pr.setString(1, status);
			try (ResultSet rs = pr.executeQuery()) {
				if (rs.next()) return rs.getInt(1);
			}
		} catch (Exception e) {
			System.err.println("[InvoiceDao.countByStatus] Loi: " + e.getMessage());
		}
		return 0;
	}

	/**
	 * Loc hoa don theo trang thai va/hoac keyword (tim theo ten nguoi nhan hoac SDT).
	 * Neu status null/empty/"ALL" -> khong loc theo trang thai.
	 * Neu keyword null/empty -> khong loc theo keyword.
	 */
	public List<InvoiceModel> filter(String status, String keyword) {
		List<InvoiceModel> list = new ArrayList<>();
		StringBuilder sql = new StringBuilder(
				"SELECT id, user_id, receiver_name, receiver_phone, receiver_address, note, "
				+ "total_amount, payment_method, order_status, created_at FROM hoa_don WHERE 1=1");
		List<Object> params = new ArrayList<>();

		boolean hasStatus = status != null && !status.isEmpty() && !"ALL".equalsIgnoreCase(status);
		boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();

		if (hasStatus) {
			sql.append(" AND order_status = ?");
			params.add(status);
		}
		if (hasKeyword) {
			sql.append(" AND (receiver_name LIKE ? OR receiver_phone LIKE ?)");
			String kw = "%" + keyword.trim() + "%";
			params.add(kw);
			params.add(kw);
		}
		sql.append(" ORDER BY created_at DESC, id DESC");

		try (Connection con = ConnectDB.getConnect();
			 PreparedStatement pr = con.prepareStatement(sql.toString())) {
			for (int i = 0; i < params.size(); i++) {
				pr.setObject(i + 1, params.get(i));
			}
			try (ResultSet rs = pr.executeQuery()) {
				while (rs.next()) list.add(mapRow(rs));
			}
		} catch (Exception e) {
			System.err.println("[InvoiceDao.filter] Loi: " + e.getMessage());
		}
		return list;
	}

	// Chi tiet san pham trong don hang (de admin xem)
	public List<model.CartItemModel> getItems(int invoiceId) {
		List<model.CartItemModel> list = new ArrayList<>();
		String sql = "SELECT product_id, product_name, product_image, price_at_purchase, quantity, line_total "
				+ "FROM hoa_don_chi_tiet WHERE invoice_id=?";
		try (Connection con = ConnectDB.getConnect();
			 PreparedStatement pr = con.prepareStatement(sql)) {
			pr.setInt(1, invoiceId);
			try (ResultSet rs = pr.executeQuery()) {
				while (rs.next()) {
					model.CartItemModel it = new model.CartItemModel();
					it.setProductId(rs.getInt("product_id"));
					it.setName(rs.getString("product_name"));
					it.setImage(rs.getString("product_image"));
					it.setPrice(rs.getDouble("price_at_purchase"));
					it.setDisplayPrice(rs.getDouble("price_at_purchase"));
					it.setQuantity(rs.getInt("quantity"));
					list.add(it);
				}
			}
		} catch (Exception e) {
			System.err.println("[InvoiceDao.getItems] Loi: " + e.getMessage());
		}
		return list;
	}

	// ============ DASHBOARD: doanh thu 7 ngay + top san pham ============

	/**
	 * Doanh thu 7 ngay gan nhat (khong tinh don huy).
	 * Tra ve 7 phan tu [0..6] tuong ung 7 ngay (hom nay o cuoi).
	 */
	public double[] revenueLast7Days() {
		double[] arr = new double[7];
		String sql = "SELECT CAST(created_at AS DATE) AS d, ISNULL(SUM(total_amount),0) AS s "
				+ "FROM hoa_don "
				+ "WHERE order_status <> 'CANCELLED' AND created_at >= DATEADD(day, -6, CAST(GETDATE() AS DATE)) "
				+ "GROUP BY CAST(created_at AS DATE) ORDER BY d ASC";
		try (Connection con = ConnectDB.getConnect();
			 PreparedStatement pr = con.prepareStatement(sql);
			 ResultSet rs = pr.executeQuery()) {
			while (rs.next()) {
				java.sql.Date d = rs.getDate("d");
				double s = rs.getDouble("s");
				long diff = (d.getTime() - startOfToday().getTime()) / (1000L * 60 * 60 * 24);
				int idx = 6 - (int) diff; // 0 = cach day 6, 6 = hom nay
				if (idx >= 0 && idx < 7) arr[idx] = s;
			}
		} catch (Exception e) {
			System.err.println("[InvoiceDao.revenueLast7Days] Loi: " + e.getMessage());
		}
		return arr;
	}

	private java.sql.Date startOfToday() {
		java.util.Calendar c = java.util.Calendar.getInstance();
		c.set(java.util.Calendar.HOUR_OF_DAY, 0);
		c.set(java.util.Calendar.MINUTE, 0);
		c.set(java.util.Calendar.SECOND, 0);
		c.set(java.util.Calendar.MILLISECOND, 0);
		return new java.sql.Date(c.getTimeInMillis());
	}

	/**
	 * Top N san pham ban chay (theo so luong).
	 * Tra ve List<Object[]>: [0]=name, [1]=totalQty, [2]=revenue
	 */
	public List<Object[]> topProducts(int limit) {
		List<Object[]> list = new ArrayList<>();
		String sql = "SELECT TOP (?) ct.product_name, SUM(ct.quantity) AS total_qty, SUM(ct.line_total) AS revenue "
				+ "FROM hoa_don_chi_tiet ct JOIN hoa_don hd ON ct.invoice_id = hd.id "
				+ "WHERE hd.order_status <> 'CANCELLED' "
				+ "GROUP BY ct.product_name ORDER BY total_qty DESC";
		try (Connection con = ConnectDB.getConnect();
			 PreparedStatement pr = con.prepareStatement(sql)) {
			pr.setInt(1, limit);
			try (ResultSet rs = pr.executeQuery()) {
				while (rs.next()) {
					list.add(new Object[]{
						rs.getString("product_name"),
						rs.getInt("total_qty"),
						rs.getDouble("revenue")
					});
				}
			}
		} catch (Exception e) {
			System.err.println("[InvoiceDao.topProducts] Loi: " + e.getMessage());
		}
		return list;
	}
}
