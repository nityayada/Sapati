package com.sapati.util;

import com.sapati.dao.BorrowDAO;
import com.sapati.dao.FineDAO;
import com.sapati.model.BorrowRecord;
import com.sapati.model.Fine;

import java.sql.Date;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

public class FineCalculator {

    private static final double RATE_PER_DAY = 50.0;
    
    // In a real production system, this could be capped (e.g., maximum fine = 1500 limit)
    private static final double MAX_FINE_CAP = 1500.0;

    public static void runCalculations() {
        BorrowDAO borrowDAO = new BorrowDAO();
        List<BorrowRecord> allRecords = borrowDAO.getAllBorrowRecordsAdmin();
        processRecords(allRecords);
    }

    public static void runCalculationsForUser(int userId) {
        BorrowDAO borrowDAO = new BorrowDAO();
        List<BorrowRecord> userRecords = borrowDAO.getBorrowRecordsByUser(userId);
        processRecords(userRecords);
    }

    private static void processRecords(List<BorrowRecord> records) {
        FineDAO fineDAO = new FineDAO();
        BorrowDAO borrowDAO = new BorrowDAO();
        LocalDate today = LocalDate.now();

        for (BorrowRecord record : records) {
            String status = record.getStatus();
            
            if ("Active".equalsIgnoreCase(status) || "Overdue".equalsIgnoreCase(status)) {
                Date sqlDueDate = record.getDueDate();
                if (sqlDueDate != null) {
                    LocalDate dueDate = sqlDueDate.toLocalDate();
                    
                    if (today.isAfter(dueDate)) {
                        long daysLate = ChronoUnit.DAYS.between(dueDate, today);
                        if (daysLate > 0) {
                            double calculatedFine = daysLate * RATE_PER_DAY;
                            if (calculatedFine > MAX_FINE_CAP) {
                                calculatedFine = MAX_FINE_CAP;
                            }
                            
                            Fine existingFine = fineDAO.getFineByRecordId(record.getRecordId());
                            
                            if (existingFine == null) {
                                Fine newFine = new Fine();
                                newFine.setRecordId(record.getRecordId());
                                newFine.setDaysLate((int) daysLate);
                                newFine.setAmount(calculatedFine);
                                fineDAO.issueFine(newFine);
                            } else {
                                if (!"Paid".equalsIgnoreCase(existingFine.getPaymentStatus())) {
                                    fineDAO.updateFineAmount(existingFine.getFineId(), (int) daysLate, calculatedFine);
                                }
                            }
                            
                            if (!"Overdue".equalsIgnoreCase(status)) {
                                borrowDAO.updateRecordStatus(record.getRecordId(), "Overdue");
                            }
                        }
                    }
                }
            }
        }
    }

}
