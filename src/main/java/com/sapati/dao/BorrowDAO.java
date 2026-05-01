package com.sapati.dao;

import com.sapati.config.DBConnection;
import com.sapati.model.BorrowRequest;
import com.sapati.model.BorrowRecord;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BorrowDAO {

    public boolean createBorrowRequest(BorrowRequest request) {
        String sql = "INSERT INTO borrow_requests (item_id, requester_id, requested_date, proposed_due_date, request_status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, request.getItemId());
            pstmt.setInt(2, request.getRequesterId());
            pstmt.setDate(3, request.getRequestedDate());
            pstmt.setDate(4, request.getProposedDueDate());
            pstmt.setString(5, "Pending");
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<BorrowRequest> getRequestsForOwner(int ownerId) {
        List<BorrowRequest> requests = new ArrayList<>();
        String sql = "SELECT br.*, i.name as item_name, u.full_name as requester_name " +
                     "FROM borrow_requests br " +
                     "JOIN items i ON br.item_id = i.item_id " +
                     "JOIN users u ON br.requester_id = u.user_id " +
                     "WHERE i.owner_id = ? AND br.request_status = 'Pending'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, ownerId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                BorrowRequest req = new BorrowRequest();
                req.setRequestId(rs.getInt("request_id"));
                req.setItemId(rs.getInt("item_id"));
                req.setRequesterId(rs.getInt("requester_id"));
                req.setRequestedDate(rs.getDate("requested_date"));
                req.setProposedDueDate(rs.getDate("proposed_due_date"));
                req.setRequestStatus(rs.getString("request_status"));
                req.setItemName(rs.getString("item_name"));
                req.setRequesterName(rs.getString("requester_name"));
                requests.add(req);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return requests;
    }

    public List<BorrowRequest> getRequestsByRequester(int requesterId) {

        List<BorrowRequest> requests = new ArrayList<>();
        String sql = "SELECT br.*, i.name as item_name, u.full_name as owner_name " +
                     "FROM borrow_requests br " +
                     "JOIN items i ON br.item_id = i.item_id " +
                     "JOIN users u ON i.owner_id = u.user_id " +
                     "WHERE br.requester_id = ? " +
                     "ORDER BY br.requested_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, requesterId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                BorrowRequest req = new BorrowRequest();
                req.setRequestId(rs.getInt("request_id"));
                req.setItemId(rs.getInt("item_id"));
                req.setRequesterId(rs.getInt("requester_id"));
                req.setRequestedDate(rs.getDate("requested_date"));
                req.setProposedDueDate(rs.getDate("proposed_due_date"));
                req.setRequestStatus(rs.getString("request_status"));
                req.setItemName(rs.getString("item_name"));
                req.setRequesterName(rs.getString("owner_name")); // Reusing this field to store owner name for display
                requests.add(req);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return requests;
    }


    public boolean updateRequestStatus(int requestId, String status) {
        String sql = "UPDATE borrow_requests SET request_status = ? WHERE request_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            pstmt.setInt(2, requestId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean createBorrowRecord(BorrowRecord record) {
        String sql = "INSERT INTO borrow_records (item_id, borrower_id, request_id, borrow_date, due_date, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, record.getItemId());
            pstmt.setInt(2, record.getBorrowerId());
            pstmt.setInt(3, record.getRequestId());
            pstmt.setDate(4, record.getBorrowDate());
            pstmt.setDate(5, record.getDueDate());
            pstmt.setString(6, "Active");
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<BorrowRecord> getBorrowRecordsByUser(int userId) {
        List<BorrowRecord> records = new ArrayList<>();
        String sql = "SELECT br.*, i.name as item_name, u.full_name as owner_name " +
                     "FROM borrow_records br " +
                     "JOIN items i ON br.item_id = i.item_id " +
                     "JOIN users u ON i.owner_id = u.user_id " +
                     "WHERE br.borrower_id = ? " +
                     "ORDER BY br.borrow_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                BorrowRecord record = new BorrowRecord();
                record.setRecordId(rs.getInt("record_id"));
                record.setItemId(rs.getInt("item_id"));
                record.setBorrowerId(rs.getInt("borrower_id"));
                record.setRequestId(rs.getInt("request_id"));
                record.setBorrowDate(rs.getDate("borrow_date"));
                record.setDueDate(rs.getDate("due_date"));
                record.setReturnDate(rs.getDate("return_date"));
                record.setStatus(rs.getString("status"));
                record.setItemName(rs.getString("item_name"));
                record.setOwnerName(rs.getString("owner_name"));
                records.add(record);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return records;
    }

    public java.util.Map<String, Integer> getBorrowStats(int userId) {
        java.util.Map<String, Integer> stats = new java.util.HashMap<>();
        String sql = "SELECT " +
                     "COUNT(*) as total, " +
                     "SUM(CASE WHEN status = 'Active' THEN 1 ELSE 0 END) as active, " +
                     "SUM(CASE WHEN status = 'Overdue' THEN 1 ELSE 0 END) as overdue " +
                     "FROM borrow_records WHERE borrower_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                stats.put("total", rs.getInt("total"));
                stats.put("active", rs.getInt("active"));
                stats.put("overdue", rs.getInt("overdue"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    public int getTotalBorrowCount() {
        String sql = "SELECT COUNT(*) FROM borrow_records";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<BorrowRecord> getAllBorrowRecordsAdmin() {
        List<BorrowRecord> records = new ArrayList<>();
        String sql = "SELECT br.*, i.name as item_name, u_owner.full_name as owner_name, u_borrower.full_name as borrower_name " +
                     "FROM borrow_records br " +
                     "JOIN items i ON br.item_id = i.item_id " +
                     "JOIN users u_owner ON i.owner_id = u_owner.user_id " +
                     "JOIN users u_borrower ON br.borrower_id = u_borrower.user_id " +
                     "ORDER BY br.borrow_date DESC";
                     
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                BorrowRecord record = new BorrowRecord();
                record.setRecordId(rs.getInt("record_id"));
                record.setItemId(rs.getInt("item_id"));
                record.setBorrowerId(rs.getInt("borrower_id"));
                record.setRequestId(rs.getInt("request_id"));
                record.setBorrowDate(rs.getDate("borrow_date"));
                record.setDueDate(rs.getDate("due_date"));
                record.setReturnDate(rs.getDate("return_date"));
                record.setStatus(rs.getString("status"));
                record.setItemName(rs.getString("item_name"));
                record.setOwnerName(rs.getString("owner_name"));
                record.setBorrowerName(rs.getString("borrower_name"));
                records.add(record);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return records;
    }

    public int getActiveBorrowCount() {
        String sql = "SELECT COUNT(*) FROM borrow_records WHERE status = 'Active' OR status = 'Overdue'";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean returnResource(int recordId, java.sql.Date returnDate) {
        String sql = "UPDATE borrow_records SET status = 'Returned', return_date = ? WHERE record_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setDate(1, returnDate);
            pstmt.setInt(2, recordId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateRecordStatus(int recordId, String status) {
        String sql = "UPDATE borrow_records SET status = ? WHERE record_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            pstmt.setInt(2, recordId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    public BorrowRecord getBorrowRecordById(int recordId) {
        String sql = "SELECT * FROM borrow_records WHERE record_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, recordId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                BorrowRecord record = new BorrowRecord();
                record.setRecordId(rs.getInt("record_id"));
                record.setItemId(rs.getInt("item_id"));
                record.setBorrowerId(rs.getInt("borrower_id"));
                record.setRequestId(rs.getInt("request_id"));
                record.setBorrowDate(rs.getDate("borrow_date"));
                record.setDueDate(rs.getDate("due_date"));
                record.setReturnDate(rs.getDate("return_date"));
                record.setStatus(rs.getString("status"));
                return record;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    public List<BorrowRecord> getRecordsAwaitingVerification(int ownerId) {
        List<BorrowRecord> records = new ArrayList<>();
        String sql = "SELECT br.record_id, br.item_id, br.borrower_id, br.request_id, br.borrow_date, br.due_date, br.return_date, br.status, " +
                     "i.name as item_name, u.full_name as borrower_name " +
                     "FROM borrow_records br " +
                     "JOIN items i ON br.item_id = i.item_id " +
                     "LEFT JOIN users u ON br.borrower_id = u.user_id " +
                     "WHERE i.owner_id = ? AND br.status = 'Returned' AND i.status IN ('Returned', 'Pending Check') " +
                     "ORDER BY br.return_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, ownerId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                BorrowRecord record = new BorrowRecord();
                record.setRecordId(rs.getInt("record_id"));
                record.setItemId(rs.getInt("item_id"));
                record.setBorrowerId(rs.getInt("borrower_id"));
                record.setRequestId(rs.getInt("request_id"));
                record.setBorrowDate(rs.getDate("borrow_date"));
                record.setDueDate(rs.getDate("due_date"));
                record.setReturnDate(rs.getDate("return_date"));
                record.setStatus(rs.getString("status"));
                record.setItemName(rs.getString("item_name"));
                record.setBorrowerName(rs.getString("borrower_name"));
                records.add(record);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return records;
    }
}


