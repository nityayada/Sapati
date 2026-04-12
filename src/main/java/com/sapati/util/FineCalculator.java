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
        FineDAO fineDAO = new FineDAO();
        
        // Note: For coursework, we might want to just grab ALL records and filter in Java
        // since we haven't written a specific 'getAllActiveOrOverdue' method yet.
        // We'll use getAllBorrowRecordsAdmin() to scan the entire ledger.
        List<BorrowRecord> allRecords = borrowDAO.getAllBorrowRecordsAdmin();
        LocalDate today = LocalDate.now();

        for (BorrowRecord record : allRecords) {
            String status = record.getStatus();
            
            // Only calculate for items that haven't been finally returned
            if ("Active".equalsIgnoreCase(status) || "Overdue".equalsIgnoreCase(status)) {
                
                Date sqlDueDate = record.getDueDate();
                if (sqlDueDate != null) {
                    LocalDate dueDate = sqlDueDate.toLocalDate();
                    
                    if (today.isAfter(dueDate)) { // It is late!
                        
                        // Calculate days difference
                        long daysLate = ChronoUnit.DAYS.between(dueDate, today);
                        if (daysLate > 0) {
                            double calculatedFine = daysLate * RATE_PER_DAY;
                            if (calculatedFine > MAX_FINE_CAP) {
                                calculatedFine = MAX_FINE_CAP;
                            }
                            
                            // Check if fine already exists
                            Fine existingFine = fineDAO.getFineByRecordId(record.getRecordId());
                            
                            if (existingFine == null) {
                                // Issue new fine
                                Fine newFine = new Fine();
                                newFine.setRecordId(record.getRecordId());
                                newFine.setDaysLate((int) daysLate);
                                newFine.setAmount(calculatedFine);
                                fineDAO.issueFine(newFine);
                            } else {
                                // Update existing fine if unpaid
                                if (!"Paid".equalsIgnoreCase(existingFine.getPaymentStatus())) {
                                    fineDAO.updateFineAmount(existingFine.getFineId(), (int) daysLate, calculatedFine);
                                }
                            }
                            
                            // Ensure BorrowRecord status is 'Overdue'
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
