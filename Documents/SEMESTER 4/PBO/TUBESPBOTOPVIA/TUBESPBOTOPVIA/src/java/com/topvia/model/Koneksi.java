package com.topvia.model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Koneksi {
    // FIX DATABASE NAME: Disesuaikan dengan gambar phpMyAdmin menjadi topvia_db
    private static final String URL = "jdbc:mysql://localhost:3306/topvia_db";
    private static final String USER = "root";
    private static final String PASSWORD = "";
    
    // Nama Driver JDBC resmi MySQL Connector/J versi 8.0+ yang Kanjeng Ratu gunakan
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    public static Connection getConnection() {
        Connection conn = null;
        try {
            // Membuka dan meregistrasikan class Driver JDBC ke sistem memori Tomcat
            Class.forName(DRIVER);
            
            // Melakukan jabat tangan koneksi menggunakan URL, User, dan Password XAMPP
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Suksestama! Gerbang koneksi JDBC database topvia_db berhasil dibuka.");
            
        } catch (ClassNotFoundException e) {
            System.out.println("CRITICAL ERROR: Driver JDBC MySQL '" + DRIVER + "' tidak ditemukan di Libraries NetBeans!");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("DATABASE ERROR: Gagal terhubung ke MySQL XAMPP! Pastikan Apache dan MySQL di XAMPP Control Panel sudah dinyalakan.");
            e.printStackTrace();
        }
        return conn;
    }
}