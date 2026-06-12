package com.topvia.controller;

import com.topvia.model.Koneksi;
import com.topvia.model.admin;
import com.topvia.model.user;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Menangkap data dari form input index.jsp
        String usernameInput = request.getParameter("txtUser");
        String passwordInput = request.getParameter("txtPass");

        if (usernameInput == null || passwordInput == null || usernameInput.trim().isEmpty()) {
            response.sendRedirect("index.jsp?error=1");
            return;
        }

        Connection conn = null;
        PreparedStatement psAdmin = null;
        PreparedStatement psUser = null;
        ResultSet rsAdmin = null;
        ResultSet rsUser = null;
        HttpSession session = request.getSession();

        try {
            // Menggunakan database 'topvia_db' melalui helper Koneksi
            conn = Koneksi.getConnection();
            usernameInput = usernameInput.trim();

            // ========================================================
            // LANGKAH A: Cek kredensial di tabel 'admin' terlebih dahulu
            // ========================================================
            String sqlAdmin = "SELECT * FROM admin WHERE username = ? AND password = ?";
            psAdmin = conn.prepareStatement(sqlAdmin);
            psAdmin.setString(1, usernameInput);
            psAdmin.setString(2, passwordInput);
            rsAdmin = psAdmin.executeQuery();

            if (rsAdmin.next()) {
                // SINKRONISASI INHERITANCE: Memanfaatkan constructor berparameter bawaan super() dari account
                admin adminLogin = new admin(rsAdmin.getString("username"), rsAdmin.getString("password"));
                
                // Daftarkan ke session khusus admin
                session.setAttribute("adminAktif", adminLogin);
                
                // Alihkan langsung ke dashboard khusus Admin
                response.sendRedirect("adminDashboard.jsp");
                return;
            }

            // ========================================================
            // LANGKAH B: Jika bukan Admin, cek kredensial di tabel 'users'
            // ========================================================
            String sqlUser = "SELECT * FROM users WHERE username = ? AND password = ?";
            psUser = conn.prepareStatement(sqlUser);
            psUser.setString(1, usernameInput);
            psUser.setString(2, passwordInput);
            rsUser = psUser.executeQuery();

            if (rsUser.next()) {
                // SINKRONISASI INHERITANCE: Memanggil constructor anak yang melempar username & password ke account induk
                String usernameDb = rsUser.getString("username");
                String passwordDb = rsUser.getString("password");
                String namaLengkapDb = rsUser.getString("nama_lengkap");
                String emailDb = rsUser.getString("email");
                
                user userLogin = new user(usernameDb, passwordDb, namaLengkapDb, emailDb);
                
                // Daftarkan ke session khusus pelanggan biasa
                session.setAttribute("userAktif", userLogin);
                
                // Alihkan ke dashboard utama Pelanggan
                response.sendRedirect("dashboard.jsp");
                return;
            }

            // ========================================================
            // LANGKAH C: Jika di kedua tabel tidak ada, lempar error
            // ========================================================
            response.sendRedirect("index.jsp?error=1");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp?error=1");
        } finally {
            // Menutup seluruh gerbang resource database dengan aman demi kestabilan server Tomcat
            try {
                if (rsAdmin != null) rsAdmin.close();
                if (psAdmin != null) psAdmin.close();
                if (rsUser != null) rsUser.close();
                if (psUser != null) psUser.close();
                if (conn != null) conn.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}