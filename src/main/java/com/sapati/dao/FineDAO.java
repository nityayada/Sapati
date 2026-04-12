package com.sapati.dao;

import com.sapati.config.DBConnection;
import com.sapati.model.Fine;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FineDAO {

    public boolean issueFine(Fine fine) {
        String sql = "INSERT INTO fines (record_id, days_late, amount, payment_status) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, fine.getRecordId());
            pstmt.setInt(2, fine.getDaysLate());
            pstmt.setDouble(3, fine.getAmount());
            pstmt.setString(4, "Unpaid");
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Fine> getFinesByUser(int userId) {
        List<Fine> fines = new ArrayList<>();
        String sql = "SELECT f.* FROM fines f JOIN borrow_records br ON f.record_id = br.record_id WHERE br.borrower_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Fine fine = new Fine();
                fine.setFineId(rs.getInt("fine_id"));
                fine.setRecordId(rs.getInt("record_id"));
                fine.setDaysLate(rs.getInt("days_late"));
                fine.setAmount(rs.getDouble("amount"));
                fine.setPaymentStatus(rs.getString("payment_status"));
                fine.setCreatedAt(rs.getTimestamp("created_at"));
                fine.setPaidAt(rs.getTimestamp("paid_at"));
                fines.add(fine);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return fines;
    }

    public boolean markAsPaid(int fineId) {
        String sql = "UPDATE fines SET payment_status = 'Paid', paid_at = CURRENT_TIMESTAMP WHERE fine_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, fineId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public double getTotalUnpaidFines() {
        String sql = "SELECT SUM(amount) FROM fines WHERE payment_status = 'Unpaid'";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    public List<Fine> getAllFinesWithDetails() {
        List<Fine> fines = new ArrayList<>();
        String sql = "SELECT f.*, u.full_name as member_name, i.name as item_name " +
                     "FROM fines f " +
                     "JOIN borrow_records br ON f.record_id = br.record_id " +
                     "JOIN users u ON br.borrower_id = u.user_id " +
                     "JOIN items i ON br.item_id = i.item_id " +
                     "ORDER BY f.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Fine fine = new Fine();
                fine.setFineId(rs.getInt("fine_id"));
                fine.setRecordId(rs.getInt("record_id"));
                fine.setDaysLate(rs.getInt("days_late"));
                fine.setAmount(rs.getDouble("amount"));
                fine.setPaymentStatus(rs.getString("payment_status"));
                fine.setCreatedAt(rs.getTimestamp("created_at"));
                fine.setPaidAt(rs.getTimestamp("paid_at"));
                fine.setMemberName(rs.getString("member_name"));
                fine.setItemName(rs.getString("item_name"));
                fines.add(fine);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return fines;
    }

    public Fine getFineByRecordId(int recordId) {
        String sql = "SELECT * FROM fines WHERE record_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, recordId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Fine fine = new Fine();
                fine.setFineId(rs.getInt("fine_id"));
                fine.setRecordId(rs.getInt("record_id"));
                fine.setDaysLate(rs.getInt("days_late"));
                fine.setAmount(rs.getDouble("amount"));
                fine.setPaymentStatus(rs.getString("payment_status"));
                fine.setCreatedAt(rs.getTimestamp("created_at"));
                fine.setPaidAt(rs.getTimestamp("paid_at"));
                return fine;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateFineAmount(int fineId, int daysLate, double amount) {
        String sql = "UPDATE fines SET days_late = ?, amount = ? WHERE fine_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, daysLate);
            pstmt.setDouble(2, amount);
            pstmt.setInt(3, fineId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
