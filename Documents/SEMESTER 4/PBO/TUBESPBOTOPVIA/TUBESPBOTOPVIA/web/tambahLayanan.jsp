<%@page import="com.topvia.model.admin"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Validasi sesi khusus Administrator agar halaman tidak bisa diintip orang lain
    admin adminLogin = (admin) session.getAttribute("adminAktif");
    if (adminLogin == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tambah Layanan Baru - Topvia Admin</title>

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
        
        /* Layout Sidebar Kiri Transparan Senada Dashboard */
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
        .nav-menu-item a:hover { background-color: rgba(255, 255, 255, 0.1); color: #ffffff; }
        .nav-menu-item.active a { background-color: rgba(255, 255, 255, 0.1); color: #ffffff; }

        /* PANEL FORM GLASSMORPHISM SINKRON METODE EDIT KANJENG RATU */
        .glass-panel {
            background: rgba(255, 255, 255, 0.05) !important;
            backdrop-filter: blur(20px) !important; -webkit-backdrop-filter: blur(20px) !important;
            border: 1px solid rgba(255, 255, 255, 0.1) !important;
            border-radius: 20px !important; padding: 40px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.3);
            max-width: 600px;
            margin: 30px auto 0 auto;
        }

        .form-label {
            font-size: 0.8rem;
            font-weight: 600;
            letter-spacing: 0.5px;
            color: #cbd5e1 !important;
            margin-bottom: 8px;
        }

        /* Desain Input Kaca Transparan Aktif */
        .form-control {
            border-radius: 10px;
            padding: 12px 16px;
            border: 1px solid rgba(255, 255, 255, 0.15);
            background-color: rgba(255, 255, 255, 0.08) !important;
            color: #ffffff !important;
            font-size: 0.9rem;
        }
        .form-control:focus {
            background-color: rgba(255, 255, 255, 0.15) !important;
            border-color: #38bdf8;
            box-shadow: 0 0 0 0.25rem rgba(56, 189, 248, 0.25);
        }
        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.35) !important;
        }

        /* FIX: Menyembunyikan panah penunjuk (spinner) pada input type number */
        .form-control::-webkit-outer-spin-button,
        .form-control::-webkit-inner-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }
        .form-control[type=number] {
            -moz-appearance: textfield;
        }

        .hint-text {
            font-size: 0.75rem;
            color: #38bdf8 !important;
            margin-top: 6px;
            display: block;
            opacity: 0.9;
        }

        /* Tombol Desain Modern */
        .btn-modern { 
            background-color: #2563eb; 
            color: white !important; 
            font-weight: 600; 
            border-radius: 10px; 
            border: none; 
            padding: 12px 24px; 
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3); 
            transition: all 0.2s;
        }
        .btn-modern:hover { background-color: #1d4ed8; transform: translateY(-1px); }
        
        .btn-modern-outline { 
            background-color: rgba(255, 255, 255, 0.05); 
            color: #cbd5e1; 
            border: 1px solid rgba(255, 255, 255, 0.15); 
            border-radius: 10px;
            padding: 12px 24px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.2s;
        }
        .btn-modern-outline:hover { background-color: rgba(255, 255, 255, 0.12); color: white; }

        .text-muted-glass { color: #94a3b8 !important; }
    </style>
</head>
<body>

    <div class="sidebar">
        <div>
            <a class="sidebar-brand" href="adminDashboard.jsp"><i class="bi bi-shield-lock-fill text-primary me-2"></i>TOPVIA ADMIN</a>
            <ul class="nav-menu">
                <li class="nav-menu-item">
                    <a href="adminDashboard.jsp" class="text-decoration-none"><i class="bi bi-grid-1x2-fill me-3"></i>Dashboard</a>
                </li>
                <li class="nav-menu-item">
                    <a href="katalogLayanan.jsp" class="text-decoration-none"><i class="bi bi-controller me-3"></i>Katalog Layanan</a>
                </li>
                <li class="nav-menu-item active">
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
        
        <% if("gagal".equals(request.getParameter("status"))) { %>
            <div class="alert alert-danger mx-auto mb-4 text-center rounded-3" style="max-width: 600px; background: rgba(239,68,68,0.15); border-color: rgba(239,68,68,0.3); color: #fca5a5;">
                <i class="bi bi-exclamation-octagon-fill me-2"></i> Gagal menyimpan data! Kode voucher sudah terdaftar atau struktur tabel database tidak cocok.
            </div>
        <% } %>

        <div class="card glass-panel">
            <div class="text-center mb-4">
                <h3 class="fw-bold text-white mb-1"><i class="bi bi-plus-circle-fill text-primary me-2"></i>Tambah Layanan Voucher</h3>
                <p class="text-muted-glass mb-0" style="font-size: 0.9rem;">Daftarkan kode produk, deskripsi item paket diamond, dan harga jual baru.</p>
            </div>

            <form action="LayananServlet" method="POST">
                
                <div class="mb-3">
                    <label class="form-label">KODE VOUCHER BARU (ID)</label>
                    <input type="text" class="form-control" name="txtIdVoucher" placeholder="Contoh: V05, V06" required autocomplete="off">
                </div>

                <div class="mb-3">
                    <label class="form-label">DESKRIPSI / NAMA ITEM LAYANAN</label>
                    <input type="text" class="form-control" name="txtNamaVoucher" placeholder="Contoh: Top Up 1500 Diamonds" required autocomplete="off">
                </div>

                <div class="mb-4">
                    <label class="form-label">HARGA JUAL AWAL (RP)</label>
                    <input type="number" class="form-control" name="txtHarga" placeholder="Contoh: 210000" required autocomplete="off" min="1">
                    <span class="hint-text"><i class="bi bi-info-circle me-1"></i> Wajib diisi angka murni tanpa menggunakan tanda titik ataupun koma.</span>
                </div>

                <div class="d-flex justify-content-end gap-2 pt-2">
                    <a href="katalogLayanan.jsp" class="btn-modern-outline">Batal</a>
                    <button type="submit" class="btn btn-modern">
                        <i class="bi bi-check-lg me-1"></i> Daftarkan Produk
                    </button>
                </div>
            </form>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>