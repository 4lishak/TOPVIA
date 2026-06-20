<%@page import="com.topvia.model.user"%>
<%@page import="com.topvia.model.Koneksi"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Validasi sesi khusus Pengguna/Pelanggan biasa
    user userLogin = (user) session.getAttribute("userAktif");
    if (userLogin == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Katalog Layanan Topvia - Premium</title>

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

        /* Navbar Atas Bergaya Kaca Tipis Premium */
        .navbar-user {
            background-color: rgba(15, 23, 42, 0.75) !important;
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            padding: 8px 0 !important; /* Dibuat lebih ramping */
            position: fixed; /* Memastikan navbar tetap di atas */
            top: 0;
            width: 100%;
            z-index: 1000;
        }
        .navbar-brand {
            font-weight: 800;
            letter-spacing: 1.5px;
            color: #ffffff !important;
            text-shadow: 0 0 10px rgba(255, 255, 255, 0.2);
        }

        /* KOTAK KATALOG GLASSMORPHISM (KACA TRANSPARAN) */
        .glass-panel {
            background: rgba(255, 255, 255, 0.07) !important;
            backdrop-filter: blur(20px) !important;
            -webkit-backdrop-filter: blur(20px) !important;
            border: 1px solid rgba(255, 255, 255, 0.15) !important;
            border-radius: 20px !important;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.4);
            padding: 35px;
            margin-top: 100px !important; /* Jarak dijauhkan agar tidak tenggelam */
            margin-bottom: 50px;
        }

        /* Memaksa Tabel Bootstrap Agar Transparan Penuh Tanpa Background Putih */
        .table, .table tr, .table td, .table th, .table tbody {
            background-color: transparent !important;
            color: #ffffff !important;
        }
        
        .table thead th {
            color: #cbd5e1 !important;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2) !important;
            padding: 16px 12px;
        }
        
        .table td {
            vertical-align: middle;
            padding: 20px 12px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08) !important;
        }
        
        .table tbody tr:hover {
            background-color: rgba(255, 255, 255, 0.04) !important;
        }

        /* Tombol Aksi Proses Transaksi Modern Glow */
        .btn-proses {
            background-color: #2563eb;
            color: white !important;
            font-weight: 600;
            border: none;
            border-radius: 10px;
            padding: 10px 20px;
            box-shadow: 0 4px 14px rgba(37, 99, 235, 0.4);
            transition: all 0.2s ease-in-out;
        }
        .btn-proses:hover {
            background-color: #1d4ed8;
            transform: translateY(-1px);
            box-shadow: 0 6px 18px rgba(37, 99, 235, 0.6);
        }

        /* Tombol Navigasi Sesi Atas */
        .btn-nav-outline {
            background-color: rgba(255, 255, 255, 0.05);
            color: #cbd5e1;
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.2s;
        }
        .btn-nav-outline:hover {
            background-color: rgba(255, 255, 255, 0.15);
            color: #ffffff;
        }
        
        .btn-nav-danger {
            background-color: rgba(239, 68, 68, 0.1);
            color: #fca5a5;
            border: 1px solid rgba(239, 68, 68, 0.25);
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.2s;
        }
        .btn-nav-danger:hover {
            background-color: #dc2626;
            color: white;
        }

        .text-muted-glass { color: #94a3b8 !important; }
        .text-neon-blue { color: #38bdf8 !important; }

        /* Gaya Dropdown Tema Glassmorphism Baru */
        .dropdown-menu-glass {
            background-color: rgba(15, 23, 42, 0.95) !important;
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.15);
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
            padding: 8px 0;
        }
        .dropdown-item-glass {
            color: #cbd5e1 !important;
            font-weight: 500;
            padding: 10px 20px;
            transition: all 0.2s;
        }
        .dropdown-item-glass:hover {
            background-color: rgba(255, 255, 255, 0.1);
            color: #ffffff !important;
        }
        .dropdown-item-danger {
            color: #ff7b72 !important;
        }
        .dropdown-item-danger:hover {
            background-color: rgba(239, 68, 68, 0.15);
        }
        
        /* Menghilangkan panah bawaan bootstrap agar lebih bersih */
        .dropdown-toggle::after {
            display: none !important;
        }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-user shadow-sm">
        <div class="container px-4">
            <a class="navbar-brand" href="#"><i class="bi bi-controller text-primary me-2"></i>TOPVIA</a>
            
            <div class="dropdown ms-auto">
                <button class="btn btn-nav-outline dropdown-toggle d-flex align-items-center gap-2 px-3 py-2" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="bi bi-person-circle text-primary"></i>
                    <span class="text-light" style="font-size: 0.9rem;">Akun: <strong><%= userLogin.getUsername() %></strong></span>
                    <i class="bi bi-list fs-5 ms-1"></i> </button>
                
                <ul class="dropdown-menu dropdown-menu-end dropdown-menu-glass mt-2">
                    <li>
                        <a class="dropdown-item dropdown-item-glass" href="riwayat.jsp">
                            <i class="bi bi-clock-history me-2 text-info"></i>Riwayat Transaksi
                        </a>
                    </li>
                    <li><hr class="dropdown-divider" style="border-color: rgba(255,255,255,0.1);"></li>
                    <li>
                        <a class="dropdown-item dropdown-item-glass dropdown-item-danger" href="LogoutServlet">
                            <i class="bi bi-box-arrow-right me-2"></i>Keluar
                        </a>
                    </li>
                </ul>
            </div>
            
        </div>
    </nav>

    <div class="container px-4">
        <div class="card glass-panel">
            
            <div class="mb-5">
                <h3 class="fw-bold text-white mb-2"><i class="bi bi-grid-3x3-gap me-2 text-primary"></i>Katalog Layanan</h3>
                <p class="text-muted-glass mb-0" style="font-size: 0.95rem;">Pilih paket layanan top-up yang tersedia pada sistem.</p>
            </div>

            <div class="table-responsive">
                <table class="table table-borderless mb-0">
                    <thead>
                        <tr>
                            <th>ID Layanan</th>
                            <th>Deskripsi Layanan</th>
                            <th>Harga Nominal (IDR)</th>
                            <th class="text-center">Aksi Sistem</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            Connection conn = null;
                            PreparedStatement ps = null;
                            ResultSet rs = null;
                            boolean adaKatalog = false;

                            try {
                                conn = Koneksi.getConnection();
                                String sql = "SELECT * FROM voucher ORDER BY id_voucher ASC";
                                ps = conn.prepareStatement(sql);
                                rs = ps.executeQuery();

                                while (rs.next()) {
                                    adaKatalog = true;
                                    
                                    // PROTEKSI GANDA: Mengamankan penarikan parameter ID jika skema kolom DB berubah-ubah
                                    String idVch = "";
                                    try {
                                        idVch = rs.getString("id_voucher");
                                    } catch (SQLException e) {
                                        idVch = rs.getString("idVoucher");
                                    }

                                    String namaVch = "";
                                    try {
                                        namaVch = rs.getString("nama_voucher");
                                    } catch (SQLException e) {
                                        namaVch = rs.getString("namaVoucher");
                                    }

                                    double hargaVch = rs.getDouble("harga");
                        %>
                        <tr>
                            <td class="fw-bold text-neon-blue"><%= idVch %></td>
                            <td class="fw-semibold"><%= namaVch %></td>
                            <td class="fw-bold text-light">Rp <%= String.format("%,.0f", hargaVch).replace(",", ".") %>,00</td>
                            <td class="text-center">
                                <a href="transaksi.jsp?id=<%= idVch %>" class="btn btn-proses btn-sm px-4 py-2">
                                    <i class="bi bi-wallet2 me-1"></i> Proses Transaksi
                                </a>
                            </td>
                        </tr>
                        <% 
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            } finally {
                                if (rs != null) rs.close();
                                if (ps != null) ps.close();
                                if (conn != null) conn.close();
                            }

                            if (!adaKatalog) {
                        %>
                        <tr>
                            <td colspan="4" class="text-center py-5 text-muted-glass">
                                <i class="bi bi-slash-circle d-block fs-2 mb-2 text-danger"></i> Katalog paket layanan belum tersedia saat ini di database.
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>