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

    public List<Item> searchItems(String query, Integer categoryId) {
        List<Item> items = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM items WHERE status = 'Available'");
        
        if (query != null && !query.trim().isEmpty()) {
            sql.append(" AND (name LIKE ? OR description LIKE ?)");
        }
        if (categoryId != null && categoryId > 0) {
            sql.append(" AND category_id = ?");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            if (query != null && !query.trim().isEmpty()) {
                String searchPattern = "%" + query + "%";
                pstmt.setString(paramIndex++, searchPattern);
                pstmt.setString(paramIndex++, searchPattern);
            }
            if (categoryId != null && categoryId > 0) {
                pstmt.setInt(paramIndex++, categoryId);
            }

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

    public Item getItemById(int itemId) {
        String sql = "SELECT * FROM items WHERE item_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, itemId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return mapItem(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateItemStatus(int itemId, String status) {
        String sql = "UPDATE items SET status = ? WHERE item_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            pstmt.setInt(2, itemId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
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

    public boolean updateItem(Item item) {
        String sql = "UPDATE items SET name = ?, category_id = ?, item_condition = ?, description = ?, image_path = ? WHERE item_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, item.getName());
            pstmt.setInt(2, item.getCategoryId());
            pstmt.setString(3, item.getItemCondition());
            pstmt.setString(4, item.getDescription());
            pstmt.setString(5, item.getImagePath());
            pstmt.setInt(6, item.getItemId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteItem(int itemId) {
        String sql = "DELETE FROM items WHERE item_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, itemId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }


    public List<Item> getAllItemsAdmin() {
        List<Item> items = new ArrayList<>();
        String sql = "SELECT * FROM items ORDER BY created_at DESC";
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

    public int getTotalItemCount() {
        String sql = "SELECT COUNT(*) FROM items";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
