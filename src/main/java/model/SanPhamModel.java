package model;
//id INT IDENTITY(1,1) PRIMARY KEY,
//category_id INT NOT NULL,
//name NVARCHAR(150) NOT NULL,
//description NVARCHAR(MAX),
//price DECIMAL(18,2) NOT NULL,
//image NVARCHAR(500),
//quantity INT NOT NULL DEFAULT 0,
//status NVARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
//created_at DATETIME2 DEFAULT SYSDATETIME(),
public class SanPhamModel {
	private int id;
	private int categoryId;
	private String name;
	private String des;
	private float price;
	private String image;
	private int quantity;
	private String status;
	private String createAt;
	
	public SanPhamModel() {
		super();
	}

	public SanPhamModel(int id, int categoryId, String name, String des, float price, String image, int quantity,
			String status, String createAt) {
		super();
		this.id = id;
		this.categoryId = categoryId;
		this.name = name;
		this.des = des;
		this.price = price;
		this.image = image;
		this.quantity = quantity;
		this.status = status;
		this.createAt = createAt;
	}

	public SanPhamModel(int categoryId, String name, String des, float price, String image, int quantity) {
		super();
		this.categoryId = categoryId;
		this.name = name;
		this.des = des;
		this.price = price;
		this.image = image;
		this.quantity = quantity;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getCategoryId() {
		return categoryId;
	}

	public void setCategoryId(int categoryId) {
		this.categoryId = categoryId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDes() {
		return des;
	}

	public void setDes(String des) {
		this.des = des;
	}

	public float getPrice() {
		return price;
	}

	public void setPrice(float price) {
		this.price = price;
	}

	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getCreateAt() {
		return createAt;
	}

	public void setCreateAt(String createAt) {
		this.createAt = createAt;
	}
	
	
}
