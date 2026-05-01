package com.sapati.model;

import java.sql.Timestamp;

public class ContactMessage {
    private int messageId;
    private String name;
    private String email;
    private String subject;
    private String message;
    private Timestamp sentAt;
    private boolean isRead;

    // Constructors
    public ContactMessage() {}

    public ContactMessage(String name, String email, String subject, String message) {
        this.name = name;
        this.email = email;
        this.subject = subject;
        this.message = message;
    }

    // Getters and Setters
    public int getMessageId() { return messageId; }
    public void setMessageId(int messageId) { this.messageId = messageId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public Timestamp getSentAt() { return sentAt; }
    public void setSentAt(Timestamp sentAt) { this.sentAt = sentAt; }

    public boolean isRead() { return isRead; }
    public void setRead(boolean read) { isRead = read; }
}
