package com.topvia.controller;

import com.topvia.model.admin;
import com.topvia.model.Koneksi;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LayananServlet", urlPatterns = {"/LayananServlet"})
public class LayananServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Validasi Keamanan: Pastikan hanya Admin yang bisa mengeksekusi ini
        HttpSession session = request.getSession();
        admin adminLogin = (admin) session.getAttribute("adminAktif");
        
        if (adminLogin == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        // 2. Menangkap data dari form sesuai dengan attribute 'name' di tambahLayanan.jsp
        String idVoucher = request.getParameter("txtIdVoucher"); 
        String namaVoucher = request.getParameter("txtNamaVoucher"); 
        String hargaStr = request.getParameter("txtHarga"); 
        
        // Antisipasi awal jika ada form kosong yang terkirim
        if (idVoucher == null || namaVoucher == null || hargaStr == null || idVoucher.trim().isEmpty()) {
            response.sendRedirect("tambahLayanan.jsp?status=gagal");
            return;
        }

        double harga = 0;
        try {
            harga = Double.parseDouble(hargaStr.trim());
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("tambahLayanan.jsp?status=gagal");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            // 3. Membuka gerbang koneksi database MySQL XAMPP topvia_db
            conn = Koneksi.getConnection();
            
            // 4. FIX SINKRONISASI KOLOM DATABASE: Menyesuaikan nama kolom murni agar match dengan tabel voucher Kanjeng Ratu
            String sql = "INSERT INTO voucher (idVoucher, namaVoucher, harga) VALUES (?, ?, ?)";
            
            try {
                ps = conn.prepareStatement(sql);
                ps.setString(1, idVoucher.trim());
                ps.setString(2, namaVoucher.trim());
                ps.setDouble(3, harga);
                ps.executeUpdate();
            } catch (SQLException sqlEx) {
                // ALTERNATIF CADANGAN: Jika ternyata di phpMyAdmin Kanjeng Ratu memakai format underscore (id_voucher)
                System.out.println("Mencoba skema penamaan kolom alternatif (underscore)...");
                if (ps != null) ps.close();
                
                String sqlAlternatif = "INSERT INTO voucher (id_voucher, nama_voucher, harga) VALUES (?, ?, ?)";
                ps = conn.prepareStatement(sqlAlternatif);
                ps.setString(1, idVoucher.trim());
                ps.setString(2, namaVoucher.trim());
                ps.setDouble(3, harga);
                ps.executeUpdate();
            }
            
            // Sukses tersimpan di database MySQL, alihkan kembali ke dasbor utama admin
            response.sendRedirect("adminDashboard.jsp?status=layanan_ditambah");
            
        } catch (Exception e) {
            System.out.println("CRITICAL ERROR SAAT TAMBAH PRODUK:");
            e.printStackTrace(); // Intip pesan error merah sesungguhnya di tab Output NetBeans Kanjeng Ratu
            response.sendRedirect("tambahLayanan.jsp?status=gagal");
        } finally {
            // Menutup koneksi demi menghemat resource Apache Tomcat Kanjeng Ratu
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
}