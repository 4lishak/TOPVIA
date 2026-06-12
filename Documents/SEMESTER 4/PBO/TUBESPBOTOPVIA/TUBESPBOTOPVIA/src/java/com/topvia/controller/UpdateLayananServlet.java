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

@WebServlet(name = "UpdateLayananServlet", urlPatterns = {"/UpdateLayananServlet"})
public class UpdateLayananServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Otorisasi Keamanan Admin
        HttpSession session = request.getSession();
        admin adminLogin = (admin) session.getAttribute("adminAktif");
        if (adminLogin == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        // 2. Tangkap data dari form editLayanan.jsp
        String idVoucher = request.getParameter("txtIdVoucher");
        String namaVoucher = request.getParameter("txtNamaVoucher");
        String hargaStr = request.getParameter("txtHarga");

        if (idVoucher == null || namaVoucher == null || hargaStr == null) {
            response.sendRedirect("adminDashboard.jsp");
            return;
        }

        double harga = Double.parseDouble(hargaStr.trim());
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = Koneksi.getConnection();
            
            // 3. Eksekusi Query UPDATE SQL mencocokkan format underscore database topvia_db
            String sql = "UPDATE voucher SET nama_voucher = ?, harga = ? WHERE id_voucher = ?";
            
            try {
                ps = conn.prepareStatement(sql);
                ps.setString(1, namaVoucher.trim());
                ps.setDouble(2, harga);
                ps.setString(3, idVoucher.trim());
                ps.executeUpdate();
            } catch (SQLException ex) {
                // Skema Cadangan jika nama field database menggunakan format camelCase (idVoucher)
                System.out.println("Mencoba update dengan skema kolom alternatif...");
                if (ps != null) ps.close();
                String sqlAlt = "UPDATE voucher SET namaVoucher = ?, harga = ? WHERE idVoucher = ?";
                ps = conn.prepareStatement(sqlAlt);
                ps.setString(1, namaVoucher.trim());
                ps.setDouble(2, harga);
                ps.setString(3, idVoucher.trim());
                ps.executeUpdate();
            }

            // Kembalikan ke dasbor operasional dengan status sukses ter-update
            response.sendRedirect("adminDashboard.jsp?status=update_sukses");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminDashboard.jsp?status=gagal");
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
}