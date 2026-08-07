package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.ExampleModel;
import utils.ConnectDB;

/**
 * DAO mẫu theo cách viết JDBC trực tiếp mà sinh viên đã học.
 * Đổi ExampleItems, Id, Name theo bảng thật của dự án.
 */
public class ExampleDAO {

    public List<ExampleModel> getAll() {
        List<ExampleModel> list = new ArrayList<>();

        try {
            Connection con = ConnectDB.getConnect();
            String sql = "SELECT Id, Name FROM ExampleItems";
            PreparedStatement statement = con.prepareStatement(sql);
            ResultSet result = statement.executeQuery();

            while (result.next()) {
                ExampleModel item = new ExampleModel();
                item.setId(result.getInt("Id"));
                item.setName(result.getString("Name"));
                list.add(item);
            }
        } catch (Exception e) {
            System.err.println("Có lỗi get all: " + e.getMessage());
        }

        return list;
    }

    public void insert(ExampleModel item) {
        try {
            Connection con = ConnectDB.getConnect();
            String sql = "INSERT INTO ExampleItems (Name) VALUES (?)";
            PreparedStatement statement = con.prepareStatement(sql);
            statement.setString(1, item.getName());
            statement.execute();
        } catch (Exception e) {
            System.err.println("Có lỗi insert: " + e.getMessage());
        }
    }

    public void delete(int id) {
        try {
            Connection con = ConnectDB.getConnect();
            String sql = "DELETE FROM ExampleItems WHERE Id = ?";
            PreparedStatement statement = con.prepareStatement(sql);
            statement.setInt(1, id);
            statement.execute();
        } catch (Exception e) {
            System.err.println("Có lỗi delete: " + e.getMessage());
        }
    }
}
