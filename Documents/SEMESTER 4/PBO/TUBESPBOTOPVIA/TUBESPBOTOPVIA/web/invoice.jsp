<%@page import="com.topvia.model.user"%>
<%@page import="com.topvia.model.Koneksi"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Validasi otentikasi sesi pelanggan aktif
    user userLogin = (user) session.getAttribute("userAktif");
    if (userLogin == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Mengambil nomor referensi transaksi dari URL parameter
    String idTrx = request.getParameter("id");
    
    // Variabel penampung data dinamis dari database MySQL
    String uId = "";
    String zId = "";
    String tglTrx = "";
    String namaVoucher = "Paket Pemesanan Top-Up";
    double hargaVoucher = 0;
    boolean dataDitemukan = false;

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = Koneksi.getConnection();
        
        // Query mencari detail transaksi berdasarkan ID dan Username pembeli
        String sql = "SELECT t.*, v.nama_voucher, v.harga FROM transaksi t "
                   + "LEFT JOIN voucher v ON t.id_voucher = v.id_voucher "
                   + "WHERE t.id_transaksi = ? AND t.username = ?";
                   
        ps = conn.prepareStatement(sql);
        ps.setString(1, idTrx);
        ps.setString(2, userLogin.getUsername());
        rs = ps.executeQuery();

        if (rs.next()) {
            dataDitemukan = true;
            uId = rs.getString("user_id");
            zId = rs.getString("zone_id");
            tglTrx = rs.getString("tanggal");

            if (rs.getString("nama_voucher") != null) {
                namaVoucher = rs.getString("nama_voucher");
                hargaVoucher = rs.getDouble("harga");
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }

    // Jika id transaksi mencurigakan atau tidak ada di database, lempar balik ke riwayat
    if (!dataDitemukan) {
        response.sendRedirect("riwayat.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kuitansi_Resmi_<%= idTrx %></title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

    <style>
        body { 
            font-family: 'Inter', sans-serif; 
            background: linear-gradient(180deg, #000000 0%, #0d3875 45%, #8bcbf5 100%);
            background-attachment: fixed;
            color: #ffffff;
            min-height: 100vh;
            padding: 40px 0;
        }

        /* KARTU INVOICE GLASSMORPHISM PREMIUM */
        .invoice-card {
            background: rgba(255, 255, 255, 0.07) !important;
            backdrop-filter: blur(20px) !important;
            -webkit-backdrop-filter: blur(20px) !important;
            border: 1px solid rgba(255, 255, 255, 0.15) !important;
            border-radius: 20px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.4);
            padding: 40px;
            max-width: 600px;
            margin: 0 auto;
        }

        .divider {
            border-top: 1px dashed rgba(255, 255, 255, 0.2);
            margin: 20px 0;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            font-size: 0.95rem;
        }

        .info-label { color: #94a3b8; font-weight: 500; }
        .info-value { color: #ffffff; font-weight: 600; text-align: right; }

        .btn-modern-print {
            background-color: #2563eb; color: white; font-weight: 600;
            border-radius: 10px; padding: 12px 24px; border: none;
            box-shadow: 0 4px 14px rgba(37, 99, 235, 0.4);
        }
        .btn-modern-outline {
            background-color: rgba(255, 255, 255, 0.05); color: #cbd5e1;
            border: 1px solid rgba(255, 255, 255, 0.2); border-radius: 10px;
            padding: 12px 24px; font-weight: 500; text-decoration: none;
        }
        .btn-modern-outline:hover { background-color: rgba(255, 255, 255, 0.15); color: #ffffff; }

        .text-neon-blue { color: #38bdf8 !important; }
        .text-neon-green { color: #34d399 !important; }
        .text-muted-glass { color: #cbd5e1 !important; }

        /* KOTAK QR CODE QRIS ABAL-ABAL */
        .qris-container {
            background: #ffffff;
            padding: 15px;
            border-radius: 12px;
            display: inline-block;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }

        /* FORMAT DOKUMEN CETAK: QR Code disembunyikan otomatis saat diprint agar resmi */
        @media print {
            .no-print, .qr-print-hide { display: none !important; }
            body { background: #ffffff !important; color: #000000 !important; padding: 0; }
            .invoice-card {
                background: #ffffff !important; backdrop-filter: none !important;
                border: none !important; box-shadow: none !important; padding: 0;
                color: #000000 !important; max-width: 100%;
            }
            .info-label { color: #475569 !important; }
            .info-value { color: #000000 !important; }
            .divider { border-top: 1px dashed #000000; }
            .text-neon-blue, .text-neon-green { color: #000000 !important; }
        }
    </style>
</head>
<body>

    <div class="container">
        <div class="d-flex justify-content-center gap-3 mb-4 no-print">
            <a href="riwayat.jsp" class="btn-modern-outline">
                <i class="bi bi-arrow-left me-2"></i>Kembali ke Riwayat
            </a>
            <button class="btn btn-modern-print" onclick="window.print()">
                <i class="bi bi-printer me-2"></i>Cetak / Simpan PDF
            </button>
        </div>

        <div class="card invoice-card">
            <div class="text-center mb-4">
                <h4 class="fw-bold text-white mb-1" style="letter-spacing: 1.5px;">STRUK PEMBAYARAN RESMI</h4>
                <span class="text-neon-blue fw-semibold small">TOPVIA INSTANT SYSTEM</span>
            </div>

            <div class="divider"></div>

            <div class="info-row">
                <span class="info-label">No. Referensi</span>
                <span class="info-value text-neon-blue"><%= idTrx %></span>
            </div>
            <div class="info-row">
                <span class="info-label">Akun Pelanggan</span>
                <span class="info-value"><%= userLogin.getUsername() %></span>
            </div>
            <div class="info-row">
                <span class="info-label">Waktu Pencatatan</span>
                <span class="info-value"><%= tglTrx %></span>
            </div>
            <div class="info-row">
                <span class="info-label">Metode Pembayaran</span>
                <span class="info-value text-neon-blue"><i class="bi bi-qr-code me-1"></i>QRIS Instant</span>
            </div>
            <div class="info-row">
                <span class="info-label">Status Validasi</span>
                <span class="info-value text-neon-green"><i class="bi bi-patch-check-fill me-1"></i>SUCCESS / SETTLED</span>
            </div>

            <div class="divider"></div>

            <div class="info-row">
                <span class="info-label">Layanan Game</span>
                <span class="info-value"><%= namaVoucher %></span>
            </div>
            <div class="info-row">
                <span class="info-label">Target ID (Zone Server)</span>
                <span class="info-value"><%= uId %> (<%= zId %>)</span>
            </div>

            <div class="divider"></div>

            <div class="info-row my-3">
                <span class="info-label fs-5 text-white" style="align-self: center;">TOTAL BAYAR</span>
                <span class="info-value fs-4 text-neon-blue">Rp <%= String.format("%,.0f", hargaVoucher).replace(",", ".") %>,00</span>
            </div>

            <div class="divider"></div>

            <div class="text-center my-3 qr-print-hide">
                <p class="small text-muted-glass mb-2">E-QRIS Gateway Terverifikasi:</p>
                <div class="qris-container">
                    <img src="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=TOPVIA-<%= idTrx %>" 
                         alt="QRIS Sementara" title="QRIS Tiruan Pembayaran Topvia" style="display: block; margin: 0 auto; width: 150px; height: 150px;">
                </div>
                <p class="small text-neon-blue mt-2 mb-0" style="font-size: 0.75rem;"><i class="bi bi-shield-check me-1"></i>ID Pemesanan Ter-enkripsi Aman</p>
            </div>

            <div class="divider qr-print-hide"></div>
            
            <div class="text-center mt-4">
                <p class="text-muted-glass small mb-1 fw-semibold">Terima kasih telah melakukan top-up di Topvia!</p>
                <p class="text-muted-glass" style="font-size: 0.75rem; opacity: 0.8;">Simpan struk ini sebagai bukti transaksi.</p>
            </div>
        </div>
    </div>

    <script>
        window.addEventListener('DOMContentLoaded', () => {
            setTimeout(() => {
                window.print();
            }, 500); // Delay setengah detik agar rendering kartu kaca selesai sempurna
        });
    </script>

</body>
</html>