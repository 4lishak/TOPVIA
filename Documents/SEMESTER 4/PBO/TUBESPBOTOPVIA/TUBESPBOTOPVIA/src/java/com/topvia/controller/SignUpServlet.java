package com.topvia.controller;

import com.topvia.model.Koneksi;
import com.topvia.model.user;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "SignUpServlet", urlPatterns = {"/SignUpServlet"})
public class SignUpServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Menangkap data pendaftaran sesuai dengan attribute 'name' di form signup.jsp Kanjeng Ratu
        String namaLengkap = request.getParameter("txtNama");
        String usernameBaru = request.getParameter("txtUsername");
        String passwordBaru = request.getParameter("txtPassword");
        
        // Buat email default berdasarkan username untuk memenuhi parameter objek model user
        String emailOtomatis = usernameBaru.trim().toLowerCase() + "@topvia.com";

        // Validasi awal agar tidak ada data kosong yang masuk ke database
        if (usernameBaru == null || passwordBaru == null || namaLengkap == null || usernameBaru.trim().isEmpty()) {
            response.sendRedirect("signup.jsp?status=gagal");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            // 2. Membuka gerbang koneksi JDBC database MySQL topvia_db
            conn = Koneksi.getConnection();
            
            // 3. Query SQL INSERT untuk menyimpan data customer baru ke tabel users
            String sql = "INSERT INTO users (username, password, nama_lengkap, email) VALUES (?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            
            ps.setString(1, usernameBaru.trim());
            ps.setString(2, passwordBaru);
            ps.setString(3, namaLengkap.trim());
            ps.setString(4, emailOtomatis);
            
            int rowsInserted = ps.executeUpdate();
            
            if (rowsInserted > 0) {
                // 4. SINKRONISASI OBJEK (Opsional): Membuat objek user baru sesuai aturan constructor 4 parameter
                user pelangganBaru = new user(usernameBaru.trim(), passwordBaru, namaLengkap.trim(), emailOtomatis);
                
                // Jika sukses masuk database, arahkan ke index.jsp dengan notifikasi sukses daftar
                response.sendRedirect("index.jsp?signup=success");
            } else {
                response.sendRedirect("signup.jsp?status=gagal");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            // Jika username kembar (Duplicate Entry), MySQL otomatis menolak dan dilempar ke status gagal
            response.sendRedirect("signup.jsp?status=gagal");
        } finally {
            // Menutup koneksi database dengan aman
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Antisipasi jika halaman diakses via URL biasa, langsung balikkan ke halaman signup.jsp
        response.sendRedirect("signup.jsp");
    }
}