<%@page import="com.topvia.model.user"%>
<%@page import="com.topvia.model.Koneksi"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. Validasi Keamanan Sesi Pengguna
    user userLogin = (user) session.getAttribute("userAktif");
    if (userLogin == null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }

    // 2. Ambil parameter ID Voucher yang dikirim dari katalog
    String idParam = request.getParameter("id");
    String namaVoucher = "";
    double harga = 0;

    if (idParam == null || idParam.trim().isEmpty()) {
        response.sendRedirect("dashboard.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = Koneksi.getConnection();
        String sql = "SELECT * FROM voucher WHERE id_voucher = ?";
        ps = conn.prepareStatement(sql);
        ps.setString(1, idParam.trim());
        rs = ps.executeQuery();

        if (rs.next()) {
            namaVoucher = rs.getString("nama_voucher");
            harga = rs.getDouble("harga");
        } else {
            if(ps != null) ps.close();
            if(rs != null) rs.close();
            String sqlAlt = "SELECT * FROM voucher WHERE idVoucher = ?";
            ps = conn.prepareStatement(sqlAlt);
            ps.setString(1, idParam.trim());
            rs = ps.executeQuery();
            if(rs.next()) {
                namaVoucher = rs.getString("namaVoucher");
                harga = rs.getDouble("harga");
            } else {
                response.sendRedirect("dashboard.jsp");
                return;
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("dashboard.jsp");
        return;
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
    <title>Form Pemesanan Top Up - Topvia</title>
    <!-- CSS Bootstrap Wajib di Atas -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
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
            border: 1px solid rgba(255, 255, 255, 0.15) !important;
            border-radius: 20px !important; padding: 40px; box-shadow: 0 20px 40px rgba(0,0,0,0.3); width: 100%; max-width: 550px;
        }
        .form-control {
            border-radius: 10px; padding: 12px 16px; border: 1px solid rgba(255, 255, 255, 0.15);
            background-color: rgba(255, 255, 255, 0.08) !important; color: #ffffff !important;
        }
        .form-control:focus { border-color: #38bdf8; box-shadow: 0 0 0 0.25rem rgba(56, 189, 248, 0.25); }
        .btn-modern { background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%); color: white !important; font-weight: 600; border-radius: 10px; border: none; padding: 14px; width: 100%; box-shadow: 0 4px 15px rgba(37, 99, 235, 0.4); }
        .text-neon-blue { color: #38bdf8 !important; }
        
        /* GAYA POP-UP MODAL QRIS SEMENTARA PROTOTYPE */
        .modal-glass {
            background: rgba(15, 23, 42, 0.8) !important;
            backdrop-filter: blur(10px); -webkit-backdrop-filter: blur(10px);
        }
        .modal-content-glass {
            background: rgba(30, 41, 59, 0.95) !important;
            border: 1px solid rgba(255, 255, 255, 0.15) !important;
            border-radius: 24px !important;
            color: #ffffff;
        }
        .qr-box {
            background: #ffffff; padding: 12px; border-radius: 16px; display: inline-block; box-shadow: 0 4px 20px rgba(0,0,0,0.3);
        }
    </style>
</head>
<body>

    <div class="card glass-panel">
        <div class="text-center mb-4">
            <div class="display-6 text-primary mb-2"><i class="bi bi-joystick" style="color: #38bdf8;"></i></div>
            <h3 class="fw-bold text-white mb-1">Formulir Top Up</h3>
            <p class="text-muted small mb-0" style="color: #cbd5e1 !important;">Lengkapi data akun Mobile Legends Anda.</p>
        </div>

        <form id="formTransaksi" action="TransaksiServlet" method="POST">
            
            <div class="p-3 mb-4 rounded-3 text-center" style="background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.08);">
                <span class="text-muted small d-block mb-1">PAKET LAYANAN TERPILIH</span>
                <h4 class="fw-bold text-white mb-1"><%= namaVoucher %></h4>
                <span class="fw-bold text-neon-blue">Rp <%= String.format("%,.0f", harga).replace(",", ".") %></span>
                <input type="hidden" name="txtIdVoucher" value="<%= idParam %>">
            </div>

            <div class="row g-2 mb-4">
                <div class="col-8">
                    <label class="form-label small fw-bold">USER ID GAME (9 DIGIT)</label>
                    <input type="text" id="userId" class="form-control" name="txtUserId" 
                           placeholder="Contoh: 123456789" required autocomplete="off"
                           pattern="\d{9}" title="User ID harus berupa angka murni sepanjang 9 digit!"
                           oninput="this.value = this.value.replace(/[^0-9]/g, '').substring(0, 9);">
                </div>
                <div class="col-4">
                    <label class="form-label small fw-bold">SERVER ID (5 DIGIT)</label>
                    <input type="text" id="serverId" class="form-control" name="txtZoneId" 
                           placeholder="12345" required autocomplete="off"
                           pattern="\d{5}" title="Server ID harus berupa angka murni sepanjang 5 digit!"
                           oninput="this.value = this.value.replace(/[^0-9]/g, '').substring(0, 5);">
                </div>
            </div>

            <div class="mb-4">
                <button type="submit" class="btn btn-modern">
                    <i class="bi bi-qr-code-scan me-2"></i>Bayar & Selesaikan Transaksi
                </button>
            </div>

            <div class="text-center">
                <a href="dashboard.jsp" class="text-decoration-none small" style="color: #cbd5e1;"><i class="bi bi-arrow-left me-1"></i>Kembali ke Katalog</a>
            </div>
        </form>
    </div>

    <!-- ELEMENT MODAL COMPONENT (QRIS PROTOTYPE SCREEN) -->
    <div class="modal fade modal-glass" id="qrisModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content modal-content-glass shadow-lg">
                <div class="modal-body text-center p-5">
                    
                    <!-- KONDISI 1: TAMPILAN SCAN QRIS -->
                    <div id="qrScanState">
                        <h4 class="fw-bold mb-1"><i class="bi bi-qr-code text-primary me-2"></i>PEMBAYARAN</h4>
                        <p class="text-muted small mb-4">Silakan scan kode QR di bawah ini.</p>
                        
                        <div class="qr-box mb-4">
                            <img src="https://api.qrserver.com/v1/create-qr-code/?size=180x180&data=PAYMENT-<%= idParam %>" alt="QRIS" style="width: 180px; height: 180px;">
                        </div>
                        
                        <h5 class="fw-bold text-info mb-3">Rp <%= String.format("%,.0f", harga).replace(",", ".") %>,00</h5>
                        
                        <div class="d-flex align-items-center justify-content-center gap-2 text-warning small">
                            <div class="spinner-border spinner-border-sm" role="status"></div>
                            <span>Menunggu verifikasi sistem: <strong id="countdownTimer">5</strong> detik...</span>
                        </div>
                    </div>

                    <!-- KONDISI 2: NOTIFIKASI SUKSES OTOMATIS -->
                    <div id="qrSuccessState" class="d-none">
                        <div class="display-1 text-success mb-3"><i class="bi bi-check-circle-fill"></i></div>
                        <h4 class="fw-bold text-white mb-2">PEMBAYARAN RESMI DIVERIFIKASI</h4>
                        <p class="text-muted small mb-4" style="color: #cbd5e1 !important;">Transaksi sukses!</p>
                        
                        <div class="spinner-grow spinner-grow-sm text-success" role="status"></div>
                    </div>

                </div>
            </div>
        </div>
    </div>

    <!-- SCRIPT UTAMA BOOTSTRAP WAJIB DI BAWAH FRAME BUMI -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Memastikan seluruh elemen DOM dan pustaka Bootstrap siap dibaca browser
        document.addEventListener('DOMContentLoaded', () => {
            const form = document.getElementById('formTransaksi');
            
            form.addEventListener('submit', function(e) {
                // Tahan submit default browser
                e.preventDefault();
                
                // Validasi panjang digit input
                const uid = document.getElementById('userId').value;
                const sid = document.getElementById('serverId').value;
                if(uid.length !== 9 || sid.length !== 5) return;

                // Inisialisasi manual objek modal menggunakan instansiasi Bootstrap 5 resmi
                const elementModal = document.getElementById('qrisModal');
                const bootstrapModal = new bootstrap.Modal(elementModal);
                bootstrapModal.show();

                // Logika Hitung Mundur 5 Detik Prototype
                let counter = 5;
                const timerDisplay = document.getElementById('countdownTimer');
                
                const interval = setInterval(() => {
                    counter--;
                    timerDisplay.textContent = counter;
                    
                    if (counter <= 0) {
                        clearInterval(interval);
                        
                        // Switch visual state ke Sukses
                        document.getElementById('qrScanState').classList.add('d-none');
                        document.getElementById('qrSuccessState').classList.remove('d-none');
                        
                        // Jeda 1.5 detik untuk kepuasan demo visual, lalu submit data murni ke MySQL
                        setTimeout(() => {
                            form.submit();
                        }, 1500);
                    }
                }, 1000);
            });
        });
    </script>
</body>
</html>