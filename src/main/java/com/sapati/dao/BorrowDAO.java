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
        String sql = "SELECT br.* FROM borrow_requests br JOIN items i ON br.item_id = i.item_id WHERE i.owner_id = ? AND br.request_status = 'Pending'";
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
}
