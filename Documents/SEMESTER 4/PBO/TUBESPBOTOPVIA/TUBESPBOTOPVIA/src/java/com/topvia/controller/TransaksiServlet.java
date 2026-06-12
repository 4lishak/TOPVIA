package com.topvia.controller;

import com.topvia.model.user;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "TransaksiServlet", urlPatterns = {"/TransaksiServlet"})
public class TransaksiServlet extends HttpServlet {

    // Konfigurasi Koneksi Database XAMPP MySQL Bawaan JDBC
    private static final String DB_URL = "jdbc:mysql://localhost:3306/topvia_db";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        user userLogin = (user) session.getAttribute("userAktif");
        
        // Proteksi jika sesi kosong
        if (userLogin == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        // Menangkap data kiriman parameter dari form transaksi.jsp
        String idVoucher = request.getParameter("txtIdVoucher");
        String userId = request.getParameter("txtUserId");
        String zoneId = request.getParameter("txtZoneId");
        String usernamePelanggan = userLogin.getUsername();

        // Membuat Kode Transaksi Unik Otomatis secara Instan (Contoh: TRX-20260529-12345)
        String timeStamp = new SimpleDateFormat("yyyyMMdd-HHmmss").format(new Date());
        String idTransaksi = "TRX-" + timeStamp;

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            // Memanggil Driver MySQL JDBC Bawaan
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // Query SQL untuk menyimpan data riwayat pembayaran secara permanen
            String sql = "INSERT INTO transaksi (id_transaksi, username, id_voucher, user_id, zone_id) VALUES (?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, idTransaksi);
            ps.setString(2, usernamePelanggan);
            ps.setString(3, idVoucher);
            ps.setString(4, userId);
            ps.setString(5, zoneId);

            // Eksekusi penulisan data ke dalam XAMPP
            int rowsInserted = ps.executeUpdate();
            
            if (rowsInserted > 0) {
                // Jika sukses tersimpan di XAMPP, langsung arahkan Kanjeng Ratu ke halaman riwayat
                response.sendRedirect("riwayat.jsp");
            } else {
                // Jika gagal, kembalikan ke dashboard katalog
                response.sendRedirect("dashboard.jsp");
            }

        } catch (ClassNotFoundException | SQLException e) {
            // Cetak log error ke console glassfish/tomcat jika koneksi XAMPP mati
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp");
        } finally {
            // Menutup resource koneksi database demi keamanan data
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
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

    @Override
    public String getServletInfo() {
        return "Transaksi Servlet terintegrasi langsung dengan JDBC XAMPP MySQL";
    }
}