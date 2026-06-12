<%@page import="com.topvia.model.admin"%>
<%@page import="com.topvia.model.Koneksi"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Validasi sesi Administrator
    admin adminLogin = (admin) session.getAttribute("adminAktif");
    if (adminLogin == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Ambil parameter ID dari URL klik tombol edit
    String idParam = request.getParameter("id");
    String namaVoucher = "";
    double harga = 0;

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = Koneksi.getConnection();
        // Query mencari data voucher spesifik dari database MySQL
        String sql = "SELECT * FROM voucher WHERE id_voucher = ?";
        ps = conn.prepareStatement(sql);
        ps.setString(1, idParam);
        rs = ps.executeQuery();

        if (rs.next()) {
            namaVoucher = rs.getString("nama_voucher");
            harga = rs.getDouble("harga");
        } else {
            // Jika kolom di DB Kanjeng Ratu ternyata idVoucher (tanpa underscore)
            if(ps != null) ps.close();
            if(rs != null) rs.close();
            String sqlAlt = "SELECT * FROM voucher WHERE idVoucher = ?";
            ps = conn.prepareStatement(sqlAlt);
            ps.setString(1, idParam);
            rs = ps.executeQuery();
            if(rs.next()){
                namaVoucher = rs.getString("namaVoucher");
                harga = rs.getDouble("harga");
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Layanan - Topvia Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body { 
            font-family: 'Inter', sans-serif; 
            background: linear-gradient(180deg, #000000 0%, #0d3875 45%, #8bcbf5 100%);
            background-attachment: fixed; color: #ffffff; min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 20px;
        }
        .glass-panel {
            background: rgba(255, 255, 255, 0.05) !important;
            backdrop-filter: blur(20px) !important; -webkit-backdrop-filter: blur(20px) !important;
            border: 1px solid rgba(255, 255, 255, 0.1) !important;
            border-radius: 20px !important; padding: 40px; box-shadow: 0 20px 40px rgba(0,0,0,0.3); width: 100%; max-width: 550px;
        }
        .form-control {
            border-radius: 10px; padding: 12px 16px; border: 1px solid rgba(255, 255, 255, 0.15);
            background-color: rgba(255, 255, 255, 0.08) !important; color: #ffffff !important;
        }
        .form-control:focus { border-color: #38bdf8; box-shadow: 0 0 0 0.25rem rgba(56, 189, 248, 0.25); }
        .btn-modern { background-color: #2563eb; color: white !important; font-weight: 600; border-radius: 10px; border: none; padding: 12px 24px; }
        .btn-modern:hover { background-color: #1d4ed8; }
        .btn-modern-outline { background-color: rgba(255, 255, 255, 0.05); color: #cbd5e1; border: 1px solid rgba(255, 255, 255, 0.15); border-radius: 10px; padding: 12px 24px; text-decoration: none; }
    </style>
</head>
<body>
    <div class="card glass-panel">
        <div class="text-center mb-4">
            <h3 class="fw-bold text-white mb-1"><i class="bi bi-pencil-square text-primary me-2"></i>Edit Layanan Voucher</h3>
            <p class="text-muted mb-0" style="color: #94a3b8 !important;">Ubah detail informasi paket item layanan.</p>
        </div>

        <form action="UpdateLayananServlet" method="POST">
            <!-- ID ditaruh di input READONLY agar tidak bisa diubah karena merupakan Primary Key -->
            <div class="mb-3">
                <label class="form-label small fw-bold" style="color: #cbd5e1;">KODE VOUCHER (ID)</label>
                <input type="text" class="form-control" name="txtIdVoucher" value="<%= idParam %>" readonly style="opacity: 0.6;">
            </div>

            <div class="mb-3">
                <label class="form-label small fw-bold" style="color: #cbd5e1;">DESKRIPSI / NAMA ITEM</label>
                <input type="text" class="form-control" name="txtNamaVoucher" value="<%= namaVoucher %>" required autocomplete="off">
            </div>

            <div class="mb-4">
                <label class="form-label small fw-bold" style="color: #cbd5e1;">HARGA BARU (RP)</label>
                <input type="number" class="form-control" name="txtHarga" value="<%= (int)harga %>" required autocomplete="off">
            </div>

            <div class="d-flex justify-content-end gap-2">
                <a href="adminDashboard.jsp" class="btn-modern-outline">Batal</a>
                <button type="submit" class="btn btn-modern"><i class="bi bi-save me-1"></i> Simpan Perubahan</button>
            </div>
        </form>
    </div>
</body>
</html>