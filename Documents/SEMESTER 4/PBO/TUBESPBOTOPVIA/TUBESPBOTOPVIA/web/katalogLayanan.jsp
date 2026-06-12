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

    Connection conn = null;
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Katalog Layanan Admin - Topvia</title>

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
            font-size: 0.85rem; 
            font-weight: 600; 
            text-transform: uppercase; 
            border-bottom: 1px solid rgba(255, 255, 255, 0.15) !important; 
            padding: 16px 12px; 
        }

        .table-catalog td {
            vertical-align: middle; 
            padding: 16px 12px; 
            border-bottom: 1px solid rgba(255, 255, 255, 0.05) !important; 
            font-size: 0.92rem; 
            white-space: nowrap;
        }

        .table tbody tr:hover { background-color: rgba(255, 255, 255, 0.04) !important; }

        .custom-responsive-table {
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
            padding-bottom: 8px;
        }
        
        .btn-modern { background-color: #2563eb; color: white !important; font-weight: 600; border-radius: 10px; border: none; padding: 10px 20px; box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3); }
        .btn-modern-outline { background-color: rgba(255, 255, 255, 0.05); color: #cbd5e1; border: 1px solid rgba(255, 255, 255, 0.15); border-radius: 10px; }
        
        .action-icon-btn {
            border: none; background: rgba(255, 255, 255, 0.06); color: #cbd5e1 !important; width: 32px; height: 32px;
            border-radius: 8px; display: inline-flex; align-items: center; justify-content: center;
            transition: all 0.2s; text-decoration: none; border: 1px solid rgba(255, 255, 255, 0.1);
            font-size: 0.9rem;
        }
        .action-icon-btn.edit:hover { background-color: #d97706; color: white !important; border-color: #d97706; box-shadow: 0 0 8px rgba(217, 119, 6, 0.4); }
        .action-icon-btn.delete:hover { background-color: #dc2626; color: white !important; border-color: #dc2626; box-shadow: 0 0 8px rgba(220, 38, 38, 0.4); }

        .text-neon-blue { color: #38bdf8 !important; }
        .text-muted-glass { color: #94a3b8 !important; }
    </style>
</head>
<body>

    <div class="sidebar">
        <div>
            <a class="sidebar-brand" href="#"><i class="bi bi-shield-lock-fill text-primary me-2"></i>TOPVIA ADMIN</a>
            <ul class="nav-menu">
                <li class="nav-menu-item">
                    <a href="adminDashboard.jsp" class="text-decoration-none"><i class="bi bi-grid-1x2-fill me-3"></i>Dashboard</a>
                </li>
                <li class="nav-menu-item active">
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
                <h3 class="fw-bold text-white mb-1">Katalog Layanan</h3>
                <p class="text-muted-glass mb-0" style="font-size: 0.9rem;">Kelola seluruh produk voucher game yang aktif pada sistem database Topvia.</p>
            </div>
            <div class="col-md-5 text-md-end mt-3 mt-md-0 d-flex justify-content-md-end gap-2">
                <a href="tambahLayanan.jsp" class="btn btn-modern text-decoration-none"><i class="bi bi-plus-lg me-1"></i> Tambah Layanan</a>
                <button class="btn btn-modern-outline px-3" onclick="window.location.reload();"><i class="bi bi-arrow-clockwise"></i></button>
            </div>
        </div>

        <% if("layanan_dihapus".equals(request.getParameter("status"))) { %>
            <div class="alert alert-success bg-success bg-opacity-20 border-success border-opacity-30 text-success alert-dismissible fade show mb-4" role="alert" style="border-radius: 12px;">
                <i class="bi bi-check-circle-fill me-2"></i> Layanan berhasil dihapus secara permanen dari database.
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <div class="row g-4">
            <div class="col-lg-12">
                <div class="card glass-panel h-100">
                    <div class="custom-responsive-table">
                        <table class="table table-borderless table-catalog mb-0" style="width: 100%;">
                            <thead>
                                <tr>
                                    <th style="width: 15%;">Kode</th>
                                    <th style="width: 50%;">Deskripsi / Nama Voucher</th>
                                    <th class="text-end" style="width: 20%;">Harga</th>
                                    <th class="text-center" style="width: 15%;">Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    PreparedStatement psCatalog = null;
                                    ResultSet rsCatalog = null;
                                    try {
                                        conn = Koneksi.getConnection();
                                        String sqlCatalog = "SELECT * FROM voucher ORDER BY id_voucher ASC";
                                        psCatalog = conn.prepareStatement(sqlCatalog);
                                        rsCatalog = psCatalog.executeQuery();

                                        while(rsCatalog.next()) {
                                            String idVch = rsCatalog.getString("id_voucher");
                                            String namaVch = rsCatalog.getString("nama_voucher");
                                            double hargaVch = rsCatalog.getDouble("harga");
                                %>
                                <tr>
                                    <td class="fw-bold text-neon-blue"><%= idVch %></td>
                                    <td class="fw-semibold text-white"><%= namaVch %></td>
                                    <td class="fw-bold text-end text-light">Rp <%= String.format("%,.0f", hargaVch).replace(",", ".") %></td>
                                    <td class="text-center">
                                        <div class="d-flex align-items-center justify-content-center gap-2">
                                            <a href="editLayanan.jsp?id=<%= idVch %>" class="action-icon-btn edit" title="Edit">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <a href="HapusLayananServlet?id=<%= idVch %>" class="action-icon-btn delete" onclick="return confirm('Apakah Anda yakin ingin menghapus layanan ini?')" title="Hapus">
                                                <i class="bi bi-trash"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } catch(Exception e) {
                                        e.printStackTrace();
                                    } finally {
                                        if (rsCatalog != null) rsCatalog.close();
                                        if (psCatalog != null) psCatalog.close();
                                        if (conn != null) conn.close();
                                    }
                                %>
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