<%@page import="com.topvia.model.admin"%>
<%@page import="com.topvia.model.Koneksi"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Validasi otentikasi sesi Administrator Sistem
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
    <title>Laporan_Rekapitulasi_Pendapatan</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body { 
            font-family: 'Inter', sans-serif; 
            background: linear-gradient(180deg, #000000 0%, #0d3875 45%, #8bcbf5 100%);
            background-attachment: fixed; color: #ffffff; min-height: 100vh; padding: 40px 0;
        }
        .report-card {
            background: rgba(255, 255, 255, 0.07) !important;
            backdrop-filter: blur(20px) !important; -webkit-backdrop-filter: blur(20px) !important;
            border: 1px solid rgba(255, 255, 255, 0.15) !important;
            border-radius: 20px; box-shadow: 0 20px 50px rgba(0, 0, 0, 0.4); padding: 40px; margin: 0 auto; max-width: 1000px;
        }
        .divider { border-top: 1px dashed rgba(255, 255, 255, 0.2); margin: 20px 0; }
        .table, .table tr, .table td, .table th, .table tbody { background-color: transparent !important; color: #ffffff !important; }
        .table thead th {
            color: #cbd5e1 !important; font-size: 0.78rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px;
            border-bottom: 2px solid rgba(255, 255, 255, 0.2) !important; padding: 12px 8px;
        }
        .table td { vertical-align: middle; padding: 16px 8px; border-bottom: 1px solid rgba(255, 255, 255, 0.08) !important; font-size: 0.85rem; }
        .total-panel { background-color: rgba(37, 99, 235, 0.2) !important; border: 1px solid rgba(37, 99, 235, 0.3); border-radius: 12px; padding: 20px; }
        .btn-modern-print { background-color: #2563eb; color: white; font-weight: 600; border-radius: 10px; padding: 12px 24px; border: none; }
        .btn-modern-outline { background-color: rgba(255, 255, 255, 0.05); color: #cbd5e1; border: 1px solid rgba(255, 255, 255, 0.2); border-radius: 10px; padding: 12px 24px; text-decoration: none; }
        .text-neon-blue { color: #38bdf8 !important; }
        
        @media print {
            .no-print { display: none !important; }
            body { background: #ffffff !important; color: #000000 !important; padding: 0; }
            .report-card { background: #ffffff !important; backdrop-filter: none !important; border: none !important; box-shadow: none !important; padding: 0; color: #000000 !important; max-width: 100%; }
            .table thead th { color: #000000 !important; border-bottom: 2px solid #000000 !important; }
            .table td { color: #000000 !important; border-bottom: 1px solid #e2e8f0 !important; }
            .divider { border-top: 1px dashed #000000; }
            .total-panel { background-color: #f1f5f9 !important; border: 1px solid #cbd5e1; color: #000000 !important; }
            .text-neon-blue { color: #000000 !important; }
        }
    </style>
</head>
<body>

    <div class="container">
        <!-- Panel Tombol Navigasi Atas -->
        <div class="d-flex justify-content-center gap-3 mb-4 no-print">
            <a href="adminDashboard.jsp" class="btn-modern-outline">
                <i class="bi bi-arrow-left me-2"></i>Kembali ke Dashboard
            </a>
            <button class="btn btn-modern-print" onclick="window.print()">
                <i class="bi bi-printer me-2"></i>Cetak Laporan Pemesanan
            </button>
        </div>

        <!-- Lembar Laporan Utama -->
        <div class="card report-card">
            <div class="text-center mb-4">
                <h4 class="fw-bold text-white mb-1" style="letter-spacing: 1px;">REKAPITULASI PENDAPATAN OPERASIONAL</h4>
                <span class="text-neon-blue fw-semibold small">SISTEM INTEGRASI MANAJEMEN PUSAT - TOPVIA</span>
            </div>

            <div class="divider"></div>

            <!-- Metadata Dokumen -->
            <div class="mb-4 small text-muted" style="color: #cbd5e1 !important;">
                <div class="mb-1"><i class="bi bi-calendar3 me-2 text-primary"></i><strong>Tanggal Cetak Laporan:</strong> <%= new java.text.SimpleDateFormat("dd MMMM yyyy HH:mm").format(new java.util.Date()) %> WIB</div>
                <div><i class="bi bi-person-badge me-2 text-primary"></i><strong>Otoritas Operator:</strong> <%= adminLogin.getUsername() %> (Administrator Sistem)</div>
            </div>

            <!-- Tabel Data Sinkronisasi Database -->
            <div class="table-responsive">
                <table class="table table-borderless mb-4">
                    <thead>
                        <tr>
                            <th>Waktu Transaksi</th>
                            <th>No. Referensi</th>
                            <th>Akun Pemproses</th>
                            <th>Layanan Terjual</th>
                            <th>Target Game ID</th>
                            <th class="text-end">Nominal Pendapatan</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            Connection conn = null;
                            PreparedStatement ps = null;
                            ResultSet rs = null;
                            double totalPendapatanAll = 0;

                            try {
                                conn = Koneksi.getConnection();
                                
                                // FIX QUERY: Menggunakan LEFT JOIN agar nama_voucher dan harga ditarik murni dari database MySQL secara riil
                                String sql = "SELECT t.*, v.nama_voucher, v.harga FROM transaksi t "
                                           + "LEFT JOIN voucher v ON t.id_voucher = v.id_voucher "
                                           + "ORDER BY t.tanggal DESC";
                                           
                                ps = conn.prepareStatement(sql);
                                rs = ps.executeQuery();

                                while(rs.next()) {
                                    String tgl = rs.getString("tanggal");
                                    String idTrx = rs.getString("id_transaksi");
                                    String username = rs.getString("username");
                                    String gameId = rs.getString("user_id");
                                    String zoneId = rs.getString("zone_id");
                                    
                                    // Mengambil properti riil dari database hasil JOIN
                                    String namaVch = rs.getString("nama_voucher");
                                    if(namaVch == null) {
                                        namaVch = "Layanan Terhapus (" + rs.getString("id_voucher") + ")";
                                    }
                                    
                                    double hargaVch = rs.getDouble("harga");
                                    totalPendapatanAll += hargaVch;
                        %>
                        <tr>
                            <td><%= tgl %></td>
                            <td class="fw-bold text-neon-blue"><%= idTrx %></td>
                            <td class="fw-semibold"><%= username %></td>
                            <td><%= namaVch %></td>
                            <td><span class="fw-bold"><%= gameId %></span> <span class="opacity-75" style="font-size:0.75rem;">(<%= zoneId %>)</span></td>
                            <td class="text-end fw-bold">Rp <%= String.format("%,.0f", hargaVch).replace(",", ".") %></td>
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
                        %>
                    </tbody>
                </table>
            </div>

            <!-- Panel Total Akumulasi Finansial Akhir -->
            <div class="total-panel d-flex justify-content-between align-items-center">
                <span class="fw-bold uppercase small" style="letter-spacing: 0.5px;">TOTAL PENDAPATAN OPERASIONAL KESELURUHAN:</span>
                <h3 class="fw-bold m-0 text-neon-blue">Rp <%= String.format("%,.0f", totalPendapatanAll).replace(",", ".") %></h3>
            </div>

            <div class="text-center mt-5">
                <p class="text-muted small mb-0" style="font-size: 0.75rem; opacity: 0.7;">Laporan ini dihasilkan secara sah dan otomatis oleh sistem pangkalan data pusat TOPVIA.</p>
            </div>
        </div>
    </div>

</body>
</html>