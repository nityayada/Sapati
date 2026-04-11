package com.sapati.controllers;

import com.sapati.dao.BorrowDAO;
import com.sapati.dao.ItemDAO;
import com.sapati.model.BorrowRequest;
import com.sapati.model.BorrowRecord;
import com.sapati.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;

@WebServlet("/borrow")
public class BorrowController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BorrowDAO borrowDAO;

    public void init() {
        borrowDAO = new BorrowDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("view_requests".equals(action)) {
            // Forward to a page to view incoming requests
            request.getRequestDispatcher("/WEB-INF/Pages/manageRequests.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("request".equals(action)) {
            handleBorrowRequest(request, response);
        } else if ("approve".equals(action)) {
            handleApproveRequest(request, response);
        }
    }

    private void handleBorrowRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/WEB-INF/Pages/login.jsp");
            return;
        }

        int itemId = Integer.parseInt(request.getParameter("item_id"));
        String returnDateStr = request.getParameter("return_date");

        BorrowRequest req = new BorrowRequest();
        req.setItemId(itemId);
        req.setRequesterId(user.getUserId());
        req.setRequestedDate(Date.valueOf(LocalDate.now()));
        req.setProposedDueDate(Date.valueOf(returnDateStr));
        req.setRequestStatus("Pending");

        if (borrowDAO.createBorrowRequest(req)) {
            response.sendRedirect(request.getContextPath() + "/WEB-INF/Pages/myBorrows.jsp?msg=request_sent");
        } else {
            response.sendRedirect(request.getContextPath() + "/WEB-INF/Pages/itemDetail.jsp?id=" + itemId + "&error=failed_request");
        }
    }

    private void handleApproveRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Approval logic to transition from Request to Record
        int requestId = Integer.parseInt(request.getParameter("request_id"));
        int itemId = Integer.parseInt(request.getParameter("item_id"));
        int requesterId = Integer.parseInt(request.getParameter("requester_id"));
        Date dueDate = Date.valueOf(request.getParameter("due_date"));

        if (borrowDAO.updateRequestStatus(requestId, "Approved")) {
            BorrowRecord record = new BorrowRecord();
            record.setItemId(itemId);
            record.setBorrowerId(requesterId);
            record.setRequestId(requestId);
            record.setBorrowDate(Date.valueOf(LocalDate.now()));
            record.setDueDate(dueDate);
            record.setStatus("Active");

            if (borrowDAO.createBorrowRecord(record)) {
                // Update item status to Borrowed (Need ItemDAO update here or in record trigger)
                response.sendRedirect(request.getContextPath() + "/WEB-INF/Pages/memberHome.jsp?msg=approved");
            } else {
                response.sendRedirect(request.getContextPath() + "/WEB-INF/Pages/memberHome.jsp?error=record_creation_failed");
            }
        }
    }
}
