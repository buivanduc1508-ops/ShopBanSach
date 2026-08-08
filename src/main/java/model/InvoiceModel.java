package model;

public class InvoiceModel {
	private int id;
	private int userId;
	private String receiverName;
	private String receiverPhone;
	private String receiverAddress;
	private String note;
	private double totalAmount;
	private String paymentMethod;
	private String orderStatus;
	private String createdAt;

	public InvoiceModel() {
		super();
	}

	public InvoiceModel(int id, int userId, String receiverName, String receiverPhone, String receiverAddress,
			String note, double totalAmount, String paymentMethod, String orderStatus, String createdAt) {
		super();
		this.id = id;
		this.userId = userId;
		this.receiverName = receiverName;
		this.receiverPhone = receiverPhone;
		this.receiverAddress = receiverAddress;
		this.note = note;
		this.totalAmount = totalAmount;
		this.paymentMethod = paymentMethod;
		this.orderStatus = orderStatus;
		this.createdAt = createdAt;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public String getReceiverName() {
		return receiverName;
	}

	public void setReceiverName(String receiverName) {
		this.receiverName = receiverName;
	}

	public String getReceiverPhone() {
		return receiverPhone;
	}

	public void setReceiverPhone(String receiverPhone) {
		this.receiverPhone = receiverPhone;
	}

	public String getReceiverAddress() {
		return receiverAddress;
	}

	public void setReceiverAddress(String receiverAddress) {
		this.receiverAddress = receiverAddress;
	}

	public String getNote() {
		return note;
	}

	public void setNote(String note) {
		this.note = note;
	}

	public double getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(double totalAmount) {
		this.totalAmount = totalAmount;
	}

	public String getPaymentMethod() {
		return paymentMethod;
	}

	public void setPaymentMethod(String paymentMethod) {
		this.paymentMethod = paymentMethod;
	}

	public String getOrderStatus() {
		return orderStatus;
	}

	public void setOrderStatus(String orderStatus) {
		this.orderStatus = orderStatus;
	}

	public String getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(String createdAt) {
		this.createdAt = createdAt;
	}
}