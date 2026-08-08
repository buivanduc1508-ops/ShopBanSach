package model;

public class SanPhamModel {
	private int id;
	private int categoryId;
	private String name;
	private String des;
	private float price;
	private Float salePrice; // có thể null nếu không giảm giá
	private String author;
	private String image;
	private int quantity;
	private String status;
	private String createAt;

	public SanPhamModel() {
		super();
	}

	public SanPhamModel(int id, int categoryId, String name, String des, float price, Float salePrice, String author,
			String image, int quantity, String status, String createAt) {
		super();
		this.id = id;
		this.categoryId = categoryId;
		this.name = name;
		this.des = des;
		this.price = price;
		this.salePrice = salePrice;
		this.author = author;
		this.image = image;
		this.quantity = quantity;
		this.status = status;
		this.createAt = createAt;
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

	public Float getSalePrice() {
		return salePrice;
	}

	public void setSalePrice(Float salePrice) {
		this.salePrice = salePrice;
	}

	public String getAuthor() {
		return author;
	}

	public void setAuthor(String author) {
		this.author = author;
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

	// Helpers cho UI motbookstore
	public boolean hasSale() {
		return salePrice != null && salePrice > 0 && salePrice < price;
	}

	public int getDiscountPercent() {
		if (!hasSale()) {
			return 0;
		}
		return (int) Math.round((1 - salePrice / price) * 100);
	}

	public float getDisplayPrice() {
		return hasSale() ? salePrice : price;
	}

	public String getOriginalPriceFormatted() {
		return String.format("%,.0f", price);
	}

	public String getDisplayPriceFormatted() {
		return String.format("%,.0f", getDisplayPrice());
	}
}
