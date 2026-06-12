package com.topvia.controller;

import com.topvia.model.admin;
import com.topvia.model.Koneksi;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "HapusLayananServlet", urlPatterns = {"/HapusLayananServlet"})
public class HapusLayananServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Validasi Keamanan
        HttpSession session = request.getSession();
        admin adminLogin = (admin) session.getAttribute("adminAktif");
        
        if (adminLogin == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        // 2. Tangkap parameter "id" sesuai dengan yang dikirim oleh adminDashboard.jsp
        String idHapus = request.getParameter("id"); 
        
        // 3. Eksekusi hapus langsung ke database MySQL
        if (idHapus != null && !idHapus.trim().isEmpty()) {
            Connection conn = null;
            PreparedStatement ps = null;
            try {
                // Panggil koneksi dari class Koneksi Kanjeng Ratu
                conn = Koneksi.getConnection();
                
                // Hapus data dari tabel voucher berdasarkan id_voucher
                String sql = "DELETE FROM voucher WHERE id_voucher = ?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, idHapus);
                
                // Jalankan query hapus
                ps.executeUpdate();
                
            } catch (Exception e) {
                e.printStackTrace(); // Cek console/log jika ada error foreign key
            } finally {
                // Tutup koneksi agar server tidak berat
                try {
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
        }
        
        // 4. Kembali ke Dasbor Admin
        response.sendRedirect("adminDashboard.jsp?status=layanan_dihapus");
    }
}