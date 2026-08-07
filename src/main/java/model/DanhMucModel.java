package model;

public class DanhMucModel {
	private int id;
	private String name;
	private String description;
	private String status;
	private String createAt;
	
	public DanhMucModel() {
		super();
	}

	public DanhMucModel(int id, String name, String description, String status, String createAt) {
		super();
		this.id = id;
		this.name = name;
		this.description = description;
		this.status = status;
		this.createAt = createAt;
	}

	

	public DanhMucModel(String name, String description) {
		super();
		this.name = name;
		this.description = description;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
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
