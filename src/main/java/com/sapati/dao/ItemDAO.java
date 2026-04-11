package com.sapati.dao;

import com.sapati.config.DBConnection;
import com.sapati.model.Item;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ItemDAO {

    public boolean addItem(Item item) {
        String sql = "INSERT INTO items (owner_id, name, category_id, item_condition, description, image_path, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, item.getOwnerId());
            pstmt.setString(2, item.getName());
            pstmt.setInt(3, item.getCategoryId());
            pstmt.setString(4, item.getItemCondition());
            pstmt.setString(5, item.getDescription());
            pstmt.setString(6, item.getImagePath());
            pstmt.setString(7, "Listed"); // Default initial status
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Item> getAllAvailableItems() {
        List<Item> items = new ArrayList<>();
        String sql = "SELECT * FROM items WHERE status = 'Available'";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                items.add(mapItem(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    public List<Item> searchItems(String query) {
        List<Item> items = new ArrayList<>();
        String sql = "SELECT * FROM items WHERE status = 'Available' AND (name LIKE ? OR description LIKE ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + query + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                items.add(mapItem(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    public List<Item> getItemsByOwner(int ownerId) {
        List<Item> items = new ArrayList<>();
        String sql = "SELECT * FROM items WHERE owner_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, ownerId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                items.add(mapItem(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    private Item mapItem(ResultSet rs) throws SQLException {
        Item item = new Item();
        item.setItemId(rs.getInt("item_id"));
        item.setOwnerId(rs.getInt("owner_id"));
        item.setName(rs.getString("name"));
        item.setCategoryId(rs.getInt("category_id"));
        item.setItemCondition(rs.getString("item_condition"));
        item.setDescription(rs.getString("description"));
        item.setImagePath(rs.getString("image_path"));
        item.setStatus(rs.getString("status"));
        item.setCreatedAt(rs.getTimestamp("created_at"));
        return item;
    }
}
