package com.sapati.util;

import org.mindrot.jbcrypt.BCrypt;


/**
 * Utility class for secure password hashing using BCrypt.
 * BCrypt provides automatic salting and a configurable work factor,
 * making it much more secure against brute-force attacks than SHA-256.
 */
public class PasswordUtil {

    public static String hashPassword(String password) {
        // gensalt() creates a random salt for every password
        return BCrypt.hashpw(password, BCrypt.gensalt(12));
    }

    public static boolean checkPassword(String password, String hashed) {
        try {
            // checkpw extracts the salt from the 'hashed' string to verify
            return BCrypt.checkpw(password, hashed);
        } catch (Exception e) {
            // Returns false if the format is invalid
            return false;
        }
    }
}
