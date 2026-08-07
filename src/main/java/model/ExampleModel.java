package model;

/**
 * Model mẫu để sinh viên đổi tên và thuộc tính theo đề tài thật.
 */
public class ExampleModel {
    private int id;
    private String name;

    public ExampleModel() {
    }

    public ExampleModel(int id, String name) {
        this.id = id;
        this.name = name;
    }

    public ExampleModel(String name) {
        this.name = name;
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
}
