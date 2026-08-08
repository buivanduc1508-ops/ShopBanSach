package model;

public class CartItemModel {
	private int productId;
	private String name;
	private String image;
	private double price; // gia goc
	private double displayPrice; // gia sau giam (neu co)
	private int quantity;

	public CartItemModel() {
		super();
	}

	public CartItemModel(int productId, String name, String image, double price, double displayPrice,
			int quantity) {
		super();
		this.productId = productId;
		this.name = name;
		this.image = image;
		this.price = price;
		this.displayPrice = displayPrice;
		this.quantity = quantity;
	}

	public int getProductId() {
		return productId;
	}

	public void setProductId(int productId) {
		this.productId = productId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
	}

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
		this.price = price;
	}

	public double getDisplayPrice() {
		if (displayPrice <= 0) return price;
		return displayPrice;
	}

	public void setDisplayPrice(double displayPrice) {
		this.displayPrice = displayPrice;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public double getLineTotal() {
		return getDisplayPrice() * quantity;
	}

	public boolean hasSale() {
		return displayPrice > 0 && displayPrice < price;
	}
}
