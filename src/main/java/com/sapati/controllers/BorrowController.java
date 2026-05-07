package com.sapati.controllers;

import com.sapati.dao.BorrowDAO;
import com.sapati.dao.ItemDAO;
import com.sapati.model.BorrowRequest;
import com.sapati.model.BorrowRecord;
import com.sapati.model.User;
import com.sapati.model.Item;
import com.sapati.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;
import com.sapati.util.FineCalculator;
import com.sapati.dao.FineDAO;
import com.sapati.model.Fine;
import java.time.temporal.ChronoUnit;

@WebServlet("/borrow")
public class BorrowController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BorrowDAO borrowDAO;
    private ItemDAO itemDAO;
    private FineDAO fineDAO;
    private UserDAO userDAO;

    public void init() {
        borrowDAO = new BorrowDAO();
        itemDAO = new ItemDAO();
        fineDAO = new FineDAO();
        userDAO = new UserDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=login");
            return;
        }

        if ("view_requests".equals(action)) {
            List<BorrowRequest> requests = borrowDAO.getRequestsForOwner(user.getUserId());
            List<BorrowRecord> pendingReturns = borrowDAO.getRecordsAwaitingVerification(user.getUserId());
            
            request.setAttribute("incomingRequests", requests);
            request.setAttribute("pendingReturns", pendingReturns);
            request.getRequestDispatcher("/WEB-INF/pages/manageRequests.jsp").forward(request, response);
        }

    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("request".equals(action)) {
            handleBorrowRequest(request, response);
        } else if ("approve".equals(action)) {
            handleApproveRequest(request, response);
        } else if ("reject".equals(action)) {
            handleRejectRequest(request, response);
        } else if ("return".equals(action)) {
            handleReturnResource(request, response);
        } else if ("confirm_return".equals(action)) {
            handleConfirmReturn(request, response);
        }

    }

    private void handleBorrowRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=login");
            return;
        }

        String itemIdStr = request.getParameter("item_id");
        if (itemIdStr == null || itemIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/item?action=list&error=missing_item_id");
            return;
        }
        int itemId = Integer.parseInt(itemIdStr);
        String returnDateStr = request.getParameter("return_date");
        
        // Basic validation
        if (returnDateStr == null || returnDateStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/item?action=view&id=" + itemId + "&error=missing_date");
            return;
        }

        Item item = itemDAO.getItemById(itemId);
        if (item == null) {
            response.sendRedirect(request.getContextPath() + "/item?action=list&error=item_not_found");
            return;
        }

        if (item.getOwnerId() == user.getUserId()) {
            response.sendRedirect(request.getContextPath() + "/item?action=view&id=" + itemId + "&error=own_item");
            return;
        }

        LocalDate today = LocalDate.now();
        LocalDate proposedDate;
        try {
            proposedDate = LocalDate.parse(returnDateStr);
        } catch (java.time.format.DateTimeParseException e) {
            response.sendRedirect(request.getContextPath() + "/item?action=view&id=" + itemId + "&error=invalid_date_format");
            return;
        }
        long daysDiff = ChronoUnit.DAYS.between(today, proposedDate);

        if (proposedDate.isBefore(today)) {
            response.sendRedirect(request.getContextPath() + "/item?action=view&id=" + itemId + "&error=past_date");
            return;
        }

        if (daysDiff > 7) {
            response.sendRedirect(request.getContextPath() + "/item?action=view&id=" + itemId + "&error=duration_exceeded");
            return;
        }

        BorrowRequest req = new BorrowRequest();
        req.setItemId(itemId);
        req.setRequesterId(user.getUserId());
        req.setRequestedDate(Date.valueOf(today));
        req.setProposedDueDate(Date.valueOf(proposedDate));
        req.setRequestStatus("Pending");

        if (borrowDAO.createBorrowRequest(req)) {
            response.sendRedirect(request.getContextPath() + "/item?action=myBorrowings&msg=request_sent");
        } else {
            response.sendRedirect(request.getContextPath() + "/item?action=view&id=" + itemId + "&error=failed_request");
        }
    }

    private void handleApproveRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=login");
            return;
        }

        String requestIdStr = request.getParameter("request_id");
        String itemIdStr = request.getParameter("item_id");
        String requesterIdStr = request.getParameter("requester_id");
        String dueDateStr = request.getParameter("due_date");

        if (requestIdStr == null || itemIdStr == null || requesterIdStr == null || dueDateStr == null) {
            response.sendRedirect(request.getContextPath() + "/borrow?action=view_requests&error=missing_parameters");
            return;
        }

        int requestId = Integer.parseInt(requestIdStr);
        int itemId = Integer.parseInt(itemIdStr);
        int requesterId = Integer.parseInt(requesterIdStr);
        Date dueDate = Date.valueOf(dueDateStr);

        // Security: Ensure current user is the owner of the item
        Item item = itemDAO.getItemById(itemId);
        if (item == null || item.getOwnerId() != user.getUserId()) {
            response.sendRedirect(request.getContextPath() + "/borrow?action=view_requests&error=unauthorized_action");
            return;
        }


        if (borrowDAO.updateRequestStatus(requestId, "Approved")) {
            BorrowRecord record = new BorrowRecord();
            record.setItemId(itemId);
            record.setBorrowerId(requesterId);
            record.setRequestId(requestId);
            record.setBorrowDate(Date.valueOf(LocalDate.now()));
            record.setDueDate(dueDate);
            record.setStatus("Active");

            if (borrowDAO.createBorrowRecord(record)) {
                itemDAO.updateItemStatus(itemId, "Borrowed");
                
                // Send approval email async
                User requester = userDAO.getUserById(requesterId);
                if(requester != null) {
                    new Thread(() -> {
                        com.sapati.util.EmailUtil.sendApprovalEmail(requester.getEmail(), item.getName());
                    }).start();
                }

                response.sendRedirect(request.getContextPath() + "/borrow?action=view_requests&msg=approved");
            } else {
                response.sendRedirect(request.getContextPath() + "/borrow?action=view_requests&error=record_failed");
            }
        }
    }

    private void handleRejectRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=login");
            return;
        }

        String requestIdStr = request.getParameter("request_id");
        String itemIdStr = request.getParameter("item_id");
        String requesterIdStr = request.getParameter("requester_id");

        if (requestIdStr == null || itemIdStr == null || requesterIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/borrow?action=view_requests&error=missing_parameters");
            return;
        }

        int requestId = Integer.parseInt(requestIdStr);
        int itemId = Integer.parseInt(itemIdStr);
        int requesterId = Integer.parseInt(requesterIdStr);

        // Security: Ensure current user is the owner of the item
        Item item = itemDAO.getItemById(itemId);
        if (item == null || item.getOwnerId() != user.getUserId()) {
            response.sendRedirect(request.getContextPath() + "/borrow?action=view_requests&error=unauthorized_action");
            return;
        }

        if (borrowDAO.updateRequestStatus(requestId, "Rejected")) {
            // Send rejection email async
            User requester = userDAO.getUserById(requesterId);
            if(requester != null) {
                new Thread(() -> {
                    com.sapati.util.EmailUtil.sendRejectionEmail(requester.getEmail(), item.getName());
                }).start();
            }

            response.sendRedirect(request.getContextPath() + "/borrow?action=view_requests&msg=rejected");
        } else {
            response.sendRedirect(request.getContextPath() + "/borrow?action=view_requests&error=update_failed");
            }
        }

    private void handleReturnResource(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=login");
            return;
        }

        String recordIdStr = request.getParameter("record_id");
        String itemIdStr = request.getParameter("item_id");

        if (recordIdStr == null || itemIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/item?action=myBorrowings&error=missing_parameters");
            return;
        }

        int recordId = Integer.parseInt(recordIdStr);
        int itemId = Integer.parseInt(itemIdStr);
        
        // Security: Ensure current user is either the borrower or an admin
        BorrowRecord record = borrowDAO.getBorrowRecordById(recordId);
        if (record == null || (record.getBorrowerId() != user.getUserId() && !"Admin".equals(user.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/item?action=myBorrowings&error=unauthorized_return");
            return;
        }

        Date returnDate = Date.valueOf(LocalDate.now());

        // [NEW] Fine Check Logic
        if (record.getDueDate() != null && returnDate.after(record.getDueDate())) {
            long daysLate = ChronoUnit.DAYS.between(record.getDueDate().toLocalDate(), LocalDate.now());
            if (daysLate > 0) {
                // Redirect to payment flow
                response.sendRedirect(request.getContextPath() + "/payment?action=settle&record_id=" + recordId);
                return;
            }
        }

        if (borrowDAO.returnResource(recordId, returnDate)) {
            // Update item to 'Returned' - Owner must now verify
            itemDAO.updateItemStatus(itemId, "Returned");
            response.sendRedirect(request.getContextPath() + "/item?action=myBorrowings&msg=item_returned_pending");
        } else {
            response.sendRedirect(request.getContextPath() + "/item?action=myBorrowings&error=return_failed");
        }
    }

    private void handleConfirmReturn(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=login");
            return;
        }

        String itemIdStr = request.getParameter("item_id");
        if (itemIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/borrow?action=view_requests&error=missing_item_id");
            return;
        }

        int itemId = Integer.parseInt(itemIdStr);
        
        // Security: Ensure current user is the owner
        Item item = itemDAO.getItemById(itemId);
        if (item == null || item.getOwnerId() != user.getUserId()) {
            response.sendRedirect(request.getContextPath() + "/borrow?action=view_requests&error=unauthorized_confirm");
            return;
        }

        // Set item back to Available for new borrowers
        if (itemDAO.updateItemStatus(itemId, "Available")) {
            response.sendRedirect(request.getContextPath() + "/borrow?action=view_requests&msg=return_confirmed");
        } else {
            response.sendRedirect(request.getContextPath() + "/borrow?action=view_requests&error=confirm_failed");
        }
    }


}
