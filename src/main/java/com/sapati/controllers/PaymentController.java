package com.sapati.controllers;

import com.sapati.dao.BorrowDAO;
import com.sapati.dao.FineDAO;
import com.sapati.dao.ItemDAO;
import com.sapati.model.BorrowRecord;
import com.sapati.model.Fine;
import com.sapati.model.User;
import com.sapati.util.FineCalculator;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.UUID;

@WebServlet("/payment")
public class PaymentController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BorrowDAO borrowDAO;
    private FineDAO fineDAO;
    private ItemDAO itemDAO;

    public void init() {
        borrowDAO = new BorrowDAO();
        fineDAO = new FineDAO();
        itemDAO = new ItemDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=login");
            return;
        }

        if ("settle".equals(action)) {
            handleSettleInterstitial(request, response);
        } else if ("mock_gateway".equals(action)) {
            handleMockGateway(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("finalize".equals(action)) {
            handleFinalizePayment(request, response);
        }
    }

    private void handleSettleInterstitial(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int recordId = Integer.parseInt(request.getParameter("record_id"));
        BorrowRecord record = borrowDAO.getBorrowRecordById(recordId);
        
        if (record == null) {
            response.sendRedirect(request.getContextPath() + "/item?action=myBorrowings&error=record_not_found");
            return;
        }

        LocalDate today = LocalDate.now();
        long daysLate = ChronoUnit.DAYS.between(record.getDueDate().toLocalDate(), today);
        double amount = daysLate * 50.0; // Rate from FineCalculator

        request.setAttribute("record", record);
        request.setAttribute("daysLate", daysLate);
        request.setAttribute("amount", amount);
        request.getRequestDispatcher("/WEB-INF/pages/settleFine.jsp").forward(request, response);
    }

    private void handleMockGateway(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String amount = request.getParameter("amount");
        String recordId = request.getParameter("record_id");
        
        request.setAttribute("amount", amount);
        request.setAttribute("record_id", recordId);
        request.getRequestDispatcher("/WEB-INF/pages/mockPayment.jsp").forward(request, response);
    }

    private void handleFinalizePayment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int recordId = Integer.parseInt(request.getParameter("record_id"));
        String method = request.getParameter("payment_method");
        double amount = Double.parseDouble(request.getParameter("amount"));
        int daysLate = Integer.parseInt(request.getParameter("days_late"));
        
        String mockTxId = "TXN-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();

        // 1. Ensure Fine exists or create it
        Fine fine = fineDAO.getFineByRecordId(recordId);
        if (fine == null) {
            fine = new Fine();
            fine.setRecordId(recordId);
            fine.setDaysLate(daysLate);
            fine.setAmount(amount);
            fineDAO.issueFine(fine);
            fine = fineDAO.getFineByRecordId(recordId);
        }

        // 2. Mark Fine as Paid
        if (fine != null && fineDAO.markAsPaid(fine.getFineId(), method, mockTxId)) {
            // 3. Complete the Return
            Date returnDate = Date.valueOf(LocalDate.now());
            if (borrowDAO.returnResource(recordId, returnDate)) {
                BorrowRecord record = borrowDAO.getBorrowRecordById(recordId);
                itemDAO.updateItemStatus(record.getItemId(), "Returned");
                response.sendRedirect(request.getContextPath() + "/item?action=myBorrowings&msg=fine_paid_item_returned&txid=" + mockTxId);
            } else {
                response.sendRedirect(request.getContextPath() + "/item?action=myBorrowings&error=return_finalization_failed");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/item?action=myBorrowings&error=payment_recording_failed");
        }
    }
}
