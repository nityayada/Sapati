package com.sapati.model;

import java.sql.Date;
import java.sql.Timestamp;

public class BorrowRequest {
    private int requestId;
    private int itemId;
    private int requesterId;
    private Date requestedDate;
    private Date proposedDueDate;
    private String requestStatus; // 'Pending', 'Approved', 'Rejected', 'Cancelled'
    private Timestamp createdAt;
    
    // Convenience fields for UI
    private String itemName;
    private String requesterName;

    public BorrowRequest() {}

    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }

    public String getRequesterName() { return requesterName; }
    public void setRequesterName(String requesterName) { this.requesterName = requesterName; }

    public int getRequestId() { return requestId; }
    public void setRequestId(int requestId) { this.requestId = requestId; }

    public int getItemId() { return itemId; }
    public void setItemId(int itemId) { this.itemId = itemId; }

    public int getRequesterId() { return requesterId; }
    public void setRequesterId(int requesterId) { this.requesterId = requesterId; }

    public Date getRequestedDate() { return requestedDate; }
    public void setRequestedDate(Date requestedDate) { this.requestedDate = requestedDate; }

    public Date getProposedDueDate() { return proposedDueDate; }
    public void setProposedDueDate(Date proposedDueDate) { this.proposedDueDate = proposedDueDate; }

    public String getRequestStatus() { return requestStatus; }
    public void setRequestStatus(String requestStatus) { this.requestStatus = requestStatus; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
