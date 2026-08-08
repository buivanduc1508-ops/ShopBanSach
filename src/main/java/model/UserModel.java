package model;

public class UserModel {
	private int id;
	private String fullName;
	private String email;
	private String passwordHash;
	private String phone;
	private String address;
	private String role;
	private String status;
	private String createdAt;

	public UserModel() {
		super();
	}

	public UserModel(int id, String fullName, String email, String passwordHash, String phone, String address,
			String role, String status, String createdAt) {
		super();
		this.id = id;
		this.fullName = fullName;
		this.email = email;
		this.passwordHash = passwordHash;
		this.phone = phone;
		this.address = address;
		this.role = role;
		this.status = status;
		this.createdAt = createdAt;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getFullName() {
		return fullName;
	}

	public void setFullName(String fullName) {
		this.fullName = fullName;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPasswordHash() {
		return passwordHash;
	}

	public void setPasswordHash(String passwordHash) {
		this.passwordHash = passwordHash;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(String createdAt) {
		this.createdAt = createdAt;
	}
}