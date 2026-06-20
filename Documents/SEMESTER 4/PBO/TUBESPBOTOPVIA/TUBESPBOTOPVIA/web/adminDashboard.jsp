<%@page import="com.topvia.model.admin"%>
<%@page import="com.topvia.model.Koneksi"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Validasi sesi khusus Administrator
    admin adminLogin = (admin) session.getAttribute("adminAktif");
    if (adminLogin == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Variabel untuk menampung hitungan kartu dasbor dari database MySQL XAMPP secara riil
    int totalTransaksi = 0;
    double totalPendapatan = 0;
    int layananAktif = 0;

    Connection conn = null;
    PreparedStatement psCountTrx = null;
    PreparedStatement psCountVch = null;
    PreparedStatement psSum = null;
    
    ResultSet rsCountTrx = null;
    ResultSet rsCountVch = null;
    ResultSet rsSum = null;

    try {
        // Memanggil koneksi terpusat database topvia_db
        conn = Koneksi.getConnection();
        
        // 1. Menghitung TOTAL TRANSAKSI dari tabel transaksi
        String sqlCountTrx = "SELECT COUNT(*) AS total FROM transaksi";
        psCountTrx = conn.prepareStatement(sqlCountTrx);
        rsCountTrx = psCountTrx.executeQuery();
        if (rsCountTrx.next()) {
            totalTransaksi = rsCountTrx.getInt("total");
        }
        
        // 2. Menghitung LAYANAN AKTIF langsung dari isi tabel voucher database
        String sqlCountVch = "SELECT COUNT(*) AS total_vch FROM voucher";
        psCountVch = conn.prepareStatement(sqlCountVch);
        rsCountVch = psCountVch.executeQuery();
        if (rsCountVch.next()) {
            layananAktif = rsCountVch.getInt("total_vch");
        }
        
        // 3. Menghitung TOTAL PENDAPATAN secara riil dengan melakukan JOIN tabel transaksi dan voucher
        String sqlSum = "SELECT SUM(v.harga) AS omset FROM transaksi t JOIN voucher v ON t.id_voucher = v.id_voucher";
        psSum = conn.prepareStatement(sqlSum);
        rsSum = psSum.executeQuery();
        if (rsSum.next()) {
            totalPendapatan = rsSum.getDouble("omset");
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        // Menutup resource penampung hitungan awal agar Tomcat stabil
        if (rsCountTrx != null) rsCountTrx.close();
        if (psCountTrx != null) psCountTrx.close();
        if (rsCountVch != null) rsCountVch.close();
        if (psCountVch != null) psCountVch.close();
        if (rsSum != null) rsSum.close();
        if (psSum != null) psSum.close();
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dasbor Operasional Admin - Topvia</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

    <style>
        body { 
            font-family: 'Inter', sans-serif; 
            background: linear-gradient(180deg, #000000 0%, #0d3875 45%, #8bcbf5 100%);
            background-attachment: fixed;
            color: #ffffff;
            min-height: 100vh;
            overflow-x: hidden;
        }
        
        .sidebar {
            width: 260px; height: 100vh;
            background-color: rgba(15, 23, 42, 0.9);
            backdrop-filter: blur(10px); -webkit-backdrop-filter: blur(10px);
            position: fixed; top: 0; left: 0; z-index: 100; padding: 24px;
            display: flex; flex-direction: column; justify-content: space-between;
            border-right: 1px solid rgba(255, 255, 255, 0.05);
        }
        
        .main-content { margin-left: 260px; padding: 40px; }
        .sidebar-brand { font-weight: 700; font-size: 1.25rem; color: #ffffff; text-decoration: none; display: flex; align-items: center; margin-bottom: 40px; }
        .nav-menu { list-style: none; padding-left: 0; margin-bottom: auto; }
        .nav-menu-item a { display: flex; align-items: center; padding: 12px 16px; color: #94a3b8; text-decoration: none; border-radius: 8px; font-weight: 500; margin-bottom: 8px; }
        .nav-menu-item.active a, .nav-menu-item a:hover { background-color: rgba(255, 255, 255, 0.1); color: #ffffff; }

        .stat-card {
            background: rgba(255, 255, 255, 0.06) !important;
            backdrop-filter: blur(15px) !important; -webkit-backdrop-filter: blur(15px) !important;
            border: 1px solid rgba(255, 255, 255, 0.12) !important;
            border-radius: 16px !important; padding: 24px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.25);
        }
        .stat-icon { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.3rem; }
        .bg-glass-blue { background: rgba(37, 99, 235, 0.2); color: #3b82f6; border: 1px solid rgba(37, 99, 235, 0.3); }
        .bg-glass-green { background: rgba(16, 185, 129, 0.2); color: #10b981; border: 1px solid rgba(16, 185, 129, 0.3); }
        .bg-glass-cyan { background: rgba(6, 182, 212, 0.2); color: #06b6d4; border: 1px solid rgba(6, 182, 212, 0.3); }

        .glass-panel {
            background: rgba(255, 255, 255, 0.05) !important;
            backdrop-filter: blur(20px) !important; -webkit-backdrop-filter: blur(20px) !important;
            border: 1px solid rgba(255, 255, 255, 0.1) !important;
            border-radius: 20px !important; padding: 30px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.3);
        }

        .table, .table tr, .table td, .table th, .table tbody { background-color: transparent !important; color: #ffffff !important; }
        
        .table thead th { 
            color: #cbd5e1 !important; 
            font-size: 0.75rem; 
            font-weight: 600; 
            text-transform: uppercase; 
            border-bottom: 1px solid rgba(255, 255, 255, 0.15) !important; 
            padding: 12px 6px; 
        }

        .table-trx td { 
            vertical-align: middle; 
            padding: 12px 4px !important; 
            border-bottom: 1px solid rgba(255, 255, 255, 0.05) !important; 
            font-size: 0.78rem; 
            white-space: nowrap;
        }

        .table tbody tr:hover { background-color: rgba(255, 255, 255, 0.04) !important; }

        .custom-responsive-table {
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
            padding-bottom: 8px;
        }
        .custom-responsive-table::-webkit-scrollbar {
            height: 4px !important; 
        }
        .custom-responsive-table::-webkit-scrollbar-track {
            background: rgba(255, 255, 255, 0.02); 
            border-radius: 10px;
        }
        .custom-responsive-table::-webkit-scrollbar-thumb {
            background: rgba(56, 189, 248, 0.25); 
            border-radius: 10px;
        }
        .custom-responsive-table::-webkit-scrollbar-thumb:hover {
            background: rgba(56, 189, 248, 0.5); 
        }

        .badge-success-modern { 
            background-color: rgba(5, 150, 105, 0.2); 
            color: #34d399 !important; 
            border: 1px solid rgba(5, 150, 105, 0.3); 
            padding: 3px 8px; 
            border-radius: 30px; 
            font-weight: 600; 
            font-size: 0.7rem; 
            display: inline-block;
        }
        
        .btn-modern { background-color: #2563eb; color: white !important; font-weight: 600; border-radius: 10px; border: none; padding: 10px 20px; box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3); }
        .btn-modern-outline { background-color: rgba(255, 255, 255, 0.05); color: #cbd5e1; border: 1px solid rgba(255, 255, 255, 0.15); border-radius: 10px; }
        .btn-modern-outline:hover { background-color: rgba(255, 255, 255, 0.12); color: white; }
        
        .text-neon-blue { color: #38bdf8 !important; }
        .text-muted-glass { color: #94a3b8 !important; }
    </style>
</head>
<body>

    <div class="sidebar">
        <div>
            <a class="sidebar-brand" href="#"><i class="bi bi-shield-lock-fill text-primary me-2"></i>TOPVIA ADMIN</a>
            <ul class="nav-menu">
                <li class="nav-menu-item active">
                    <a href="adminDashboard.jsp" class="text-decoration-none"><i class="bi bi-grid-1x2-fill me-3"></i>Dashboard</a>
                </li>
                <li class="nav-menu-item">
                    <a href="katalogLayanan.jsp" class="text-decoration-none"><i class="bi bi-controller me-3"></i>Katalog Layanan</a>
                </li>
                <li class="nav-menu-item">
                    <a href="tambahLayanan.jsp" class="text-decoration-none"><i class="bi bi-plus-circle-fill me-3"></i>Tambah Layanan</a>
                </li>
                <li class="nav-menu-item">
                    <a href="laporan.jsp" class="text-decoration-none"><i class="bi bi-file-bar-graph-fill me-3"></i>Laporan</a>
                </li>
            </ul>
        </div>
        
        <div class="pt-3 border-top border-secondary" style="border-color: rgba(255,255,255,0.1) !important;">
            <div class="d-flex align-items-center justify-content-between">
                <div class="text-light" style="font-size: 0.85rem; opacity: 0.8;">
                    <i class="bi bi-person-circle me-2 text-primary"></i>Admin Sistem
                </div>
                <a href="LogoutServlet" class="btn btn-sm text-danger border-0" style="background: rgba(255,255,255,0.05);"><i class="bi bi-box-arrow-right"></i></a>
            </div>
        </div>
    </div>

    <div class="main-content">
        
        <div class="row align-items-center mb-4">
            <div class="col-md-7">
                <h3 class="fw-bold text-white mb-1">Dashboard Operasional</h3>
                <p class="text-muted-glass mb-0" style="font-size: 0.9rem;">Aktivitas sistem Topvia.</p>
            </div>
            <div class="col-md-5 text-md-end mt-3 mt-md-0 d-flex justify-content-md-end gap-2">
                <a href="tambahLayanan.jsp" class="btn btn-modern text-decoration-none"><i class="bi bi-plus-lg me-1"></i> Tambah Layanan</a>
                <a href="laporan.jsp" class="btn btn-modern-outline px-3 text-decoration-none d-flex align-items-center"><i class="bi bi-printer-fill"></i></a>
                <button class="btn btn-modern-outline px-3" onclick="window.location.reload();"><i class="bi bi-arrow-clockwise"></i></button>
            </div>
        </div>

        <div class="row g-4 mb-5">
            <div class="col-md-4">
                <div class="card stat-card d-flex flex-row align-items-center gap-3">
                    <div class="stat-icon bg-glass-blue"><i class="bi bi-receipt"></i></div>
                    <div>
                        <div class="text-muted-glass small fw-bold text-uppercase" style="font-size: 0.72rem; letter-spacing: 0.5px;">TOTAL TRANSAKSI</div>
                        <h3 class="fw-bold mb-0 text-white mt-1"><%= totalTransaksi %></h3>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card stat-card d-flex flex-row align-items-center gap-3">
                    <div class="stat-icon bg-glass-green"><i class="bi bi-wallet2"></i></div>
                    <div>
                        <div class="text-muted-glass small fw-bold text-uppercase" style="font-size: 0.72rem; letter-spacing: 0.5px;">TOTAL PENDAPATAN</div>
                        <h3 class="fw-bold mb-0 text-white mt-1">Rp <%= String.format("%,.0f", totalPendapatan).replace(",", ".") %></h3>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card stat-card d-flex flex-row align-items-center gap-3">
                    <div class="stat-icon bg-glass-cyan"><i class="bi bi-tags"></i></div>
                    <div>
                        <div class="text-muted-glass small fw-bold text-uppercase" style="font-size: 0.72rem; letter-spacing: 0.5px;">LAYANAN AKTIF</div>
                        <h3 class="fw-bold mb-0 text-white mt-1"><%= layananAktif %> <span style="font-size: 0.9rem; font-weight: 500;" class="text-muted-glass">Item</span></h3>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-4">
            
            <div class="col-lg-12">
                <div class="card glass-panel h-100">
                    <h5 class="fw-bold mb-4 text-white"><i class="bi bi-list-stars me-2 text-primary"></i>Daftar Transaksi Terbaru</h5>
                    <div class="custom-responsive-table">
                        <table class="table table-borderless table-trx mb-0">
                            <thead>
                                <tr>
                                    <th>ID Ref</th>
                                    <th>Pengguna</th>
                                    <th>Item (MLBB)</th>
                                    <th>Target</th>
                                    <th>Nominal</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    PreparedStatement psTable = null;
                                    ResultSet rsTable = null;
                                    boolean adaTransaksi = false;

                                    try {
                                        // Query SQL JOIN
                                        String sqlTable = "SELECT t.*, v.nama_voucher, v.harga FROM transaksi t "
                                                        + "LEFT JOIN voucher v ON t.id_voucher = v.id_voucher "
                                                        + "ORDER BY t.tanggal DESC";
                                        psTable = conn.prepareStatement(sqlTable);
                                        rsTable = psTable.executeQuery();

                                        while (rsTable.next()) {
                                            adaTransaksi = true;
                                            String rId = rsTable.getString("id_transaksi");
                                            String rUser = rsTable.getString("username");
                                            String rGameId = rsTable.getString("user_id");
                                            String rZoneId = rsTable.getString("zone_id");
                                            
                                            String vName = rsTable.getString("nama_voucher");
                                            if(vName == null) vName = "Paket Diamond";
                                            double vPrice = rsTable.getDouble("harga");
                                %>
                                <tr>
                                    <td class="fw-bold text-neon-blue"><%= rId %></td>
                                    <td class="fw-semibold"><%= rUser %></td>
                                    <td><%= vName %></td>
                                    <td><span class="fw-bold"><%= rGameId %></span> <span class="text-muted-glass" style="font-size: 0.72rem;">(<%= rZoneId %>)</span></td>
                                    <td class="fw-bold">Rp <%= String.format("%,.0f", vPrice).replace(",", ".") %></td>
                                    <td><span class="badge-success-modern">Berhasil</span></td>
                                </tr>
                                <%
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    } finally {
                                        if (rsTable != null) rsTable.close();
                                        if (psTable != null) psTable.close();
                                        // Memindahkan penutupan koneksi ke sini karena tabel katalog sudah dipisah
                                        if (conn != null) conn.close();
                                    }

                                    if (!adaTransaksi) {
                                %>
                                <tr>
                                    <td colspan="6" class="text-center py-5 text-muted-glass">
                                        <i class="bi bi-inbox d-block fs-3 mb-2"></i> Belum ada data transaksi masuk di database MySQL.
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>