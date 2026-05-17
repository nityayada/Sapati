package com.sapati.util;

import java.util.Properties;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class EmailUtil {
    
    
    private static final String SMTP_EMAIL = "yadavnitya809@gmail.com"; 
    private static final String SMTP_PASSWORD = "cuvk ueov ydwe eavm"; 

    private static Session getSession() {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        
        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_EMAIL, SMTP_PASSWORD);
            }
        });
    }

    public static boolean sendWelcomeEmail(String toEmail, String fullName) {
        String subject = "Welcome to Sapati.com!";
        String body = "Dear " + fullName + ",\n\n"
                    + "Welcome to Sapati.com! We are thrilled to have you join our community.\n\n"
                    + "You can now start borrowing and lending items.\n\n"
                    + "Best regards,\nThe Sapati Team";
        return sendEmail(toEmail, subject, body);
    }

    public static boolean sendPasswordResetOtp(String toEmail, String otp) {
        String subject = "Sapati.com - Password Reset Verification Code";
        String body = "Dear User,\n\n"
                    + "We received a request to reset your password.\n\n"
                    + "Your 6-digit verification code is: " + otp + "\n\n"
                    + "Please enter this code on the website to set a new password.\n"
                    + "If you did not request this, please ignore this email.\n\n"
                    + "Best regards,\nThe Sapati Team";
        return sendEmail(toEmail, subject, body);
    }

    public static boolean sendApprovalEmail(String toEmail, String itemName) {
        String subject = "Sapati.com - Borrow Request Approved!";
        String body = "Great news!\n\n"
                    + "Your request to borrow '" + itemName + "' has been approved.\n"
                    + "Please arrange collection with the owner and enjoy your item!\n\n"
                    + "Best regards,\nThe Sapati Team";
        return sendEmail(toEmail, subject, body);
    }

    public static boolean sendRejectionEmail(String toEmail, String itemName) {
        String subject = "Sapati.com - Borrow Request Update";
        String body = "Hello,\n\n"
                    + "Unfortunately, your request to borrow '" + itemName + "' has been rejected by the owner.\n"
                    + "Don't worry, you can always request other items on our platform.\n\n"
                    + "Best regards,\nThe Sapati Team";
        return sendEmail(toEmail, subject, body);
    }

    private static boolean sendEmail(String toEmail, String subject, String body) {
        try {
            Message message = new MimeMessage(getSession());
            message.setFrom(new InternetAddress(SMTP_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setText(body);

            Transport.send(message);
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }
}
