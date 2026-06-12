<%@page import="com.topvia.model.user"%>
<%@page import="com.topvia.model.Koneksi"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Validasi otentikasi sesi pengguna aktif
    user userLogin = (user) session.getAttribute("userAktif");
    if (userLogin == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    String currentUser = userLogin.getUsername();
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Riwayat Transaksi - TOPVIA Premium</title>

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

        .navbar-user {
            background-color: rgba(15, 23, 42, 0.75) !important;
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            padding: 16px 0;
        }

        .navbar-brand {
            font-weight: 800;
            letter-spacing: 1.5px;
            color: #ffffff !important;
        }

        .glass-panel {
            background: rgba(255, 255, 255, 0.07) !important;
            backdrop-filter: blur(20px) !important;
            -webkit-backdrop-filter: blur(20px) !important;
            border: 1px solid rgba(255, 255, 255, 0.15) !important;
            border-radius: 20px !important;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.4);
            padding: 35px;
            margin-top: 50px;
            margin-bottom: 50px;
        }

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
            font-size: 0.85rem;
        }
        
        .table tbody tr:hover {
            background-color: rgba(255, 255, 255, 0.04) !important;
        }

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

        .badge-status { 
            background-color: rgba(5, 150, 105, 0.2); 
            color: #34d399 !important; 
            border: 1px solid rgba(5, 150, 105, 0.3); 
            padding: 5px 12px; 
            border-radius: 30px; 
            font-weight: 600; 
            font-size: 0.75rem; 
        }

        /* Desain Tombol Cetak Dokumen Premium */
        .btn-action-invoice {
            background-color: rgba(56, 189, 248, 0.1);
            color: #38bdf8 !important;
            border: 1px solid rgba(56, 189, 248, 0.3);
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.78rem;
            padding: 6px 14px;
            transition: all 0.2s ease-in-out;
            text-decoration: none;
        }
        
        .btn-action-invoice:hover {
            background-color: #0284c7;
            color: #ffffff !important;
            border-color: #0284c7;
            box-shadow: 0 0 10px rgba(2, 132, 199, 0.5);
        }

        .text-neon-blue { color: #38bdf8 !important; }
        .text-muted-glass { color: #94a3b8 !important; }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-user shadow-sm">
        <div class="container px-4">
            <a class="navbar-brand" href="dashboard.jsp"><i class="bi bi-controller text-primary me-2"></i>TOPVIA</a>
            <div class="d-flex align-items-center gap-2">
                <span class="text-light me-3" style="font-size: 0.9rem; opacity: 0.9;">
                    <i class="bi bi-person-fill text-primary me-1"></i> Sesi: <strong><%= currentUser %></strong>
                </span>
                <a href="dashboard.jsp" class="btn btn-nav-outline btn-sm px-3 py-2 fw-semibold">Katalog</a>
            </div>
        </div>
    </nav>

    <div class="container px-4">
        <div class="card glass-panel">
            
            <div class="mb-5">
                <h3 class="fw-bold text-white mb-2"><i class="bi bi-clock-history me-2 text-primary"></i>Log Informasi Transaksi</h3>
                <p class="text-muted-glass mb-0" style="font-size: 0.95rem;">Riwayat Transaksi Anda</p>
            </div>

            <div class="table-responsive">
                <table class="table table-borderless mb-0">
                    <thead>
                        <tr>
                            <th>No. Referensi</th>
                            <th>Deskripsi Layanan</th>
                            <th>ID Pengguna (Server)</th>
                            <th>Total Nominal Pembayaran</th>
                            <th>Status Validasi</th>
                            <th class="text-center">Dokumen</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            Connection conn = null;
                            PreparedStatement ps = null;
                            ResultSet rs = null;
                            boolean adaData = false;

                            try {
                                conn = Koneksi.getConnection();
                                
                                // Query SQL JOIN: Menarik arsip riil spesifik user yang aktif, terintegrasi ke tabel voucher
                                String sql = "SELECT t.*, v.nama_voucher, v.harga FROM transaksi t "
                                           + "LEFT JOIN voucher v ON t.id_voucher = v.id_voucher "
                                           + "WHERE t.username = ? "
                                           + "ORDER BY t.tanggal DESC";
                                           
                                ps = conn.prepareStatement(sql);
                                ps.setString(1, currentUser);
                                rs = ps.executeQuery();

                                while (rs.next()) {
                                    adaData = true;
                                    String idTransaksi = rs.getString("id_transaksi");
                                    String gameId = rs.getString("user_id");
                                    String zoneId = rs.getString("zone_id");
                                    
                                    String namaVoucher = rs.getString("nama_voucher");
                                    if(namaVoucher == null) namaVoucher = "Paket Pemesanan Top-Up";
                                    double hargaVoucher = rs.getDouble("harga");
                        %>
                        <tr>
                            <td class="fw-bold text-neon-blue"><%= idTransaksi %></td>
                            <td class="fw-semibold"><%= namaVoucher %></td>
                            <td><span class="fw-bold"><%= gameId %></span> <span class="text-muted-glass">(<%= zoneId %>)</span></td>
                            <td class="fw-bold text-light">Rp <%= String.format("%,.0f", hargaVoucher).replace(",", ".") %>,00</td>
                            <td><span class="badge-status">Berhasil</span></td>
                            <td class="text-center">
                                <a href="invoice.jsp?id=<%= idTransaksi %>" target="_blank" class="btn-action-invoice">
                                    <i class="bi bi-printer-fill me-1"></i> Invoice
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

                            if (!adaData) {
                        %>
                        <tr>
                            <td colspan="6" class="text-center py-5 text-muted-glass">
                                <i class="bi bi-folder-x d-block fs-2 mb-2 text-primary"></i> Belum terdapat arsip dokumentasi transaksi formal pada akun ini.
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