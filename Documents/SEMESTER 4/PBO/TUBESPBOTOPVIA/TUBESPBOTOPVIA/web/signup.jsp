<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pendaftaran Akun Baru - Topvia</title>
    
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
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            overflow-x: hidden;
        }

        .glass-card {
            width: 100%;
            max-width: 480px;
            background: rgba(255, 255, 255, 0.05) !important;
            backdrop-filter: blur(25px) !important; 
            -webkit-backdrop-filter: blur(25px) !important;
            border: 1px solid rgba(255, 255, 255, 0.12) !important;
            border-radius: 24px; 
            padding: 40px; 
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.4);
        }

        .brand-title {
            font-weight: 800;
            letter-spacing: 1.5px;
            background: linear-gradient(45deg, #ffffff, #38bdf8);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .form-label {
            font-size: 0.78rem;
            font-weight: 600;
            letter-spacing: 0.5px;
            color: #cbd5e1 !important;
            margin-bottom: 6px;
        }

        .input-group-text {
            background-color: rgba(255, 255, 255, 0.05) !important;
            border: 1px solid rgba(255, 255, 255, 0.15) !important;
            border-right: none !important;
            color: #38bdf8 !important;
            border-top-left-radius: 12px !important;
            border-bottom-left-radius: 12px !important;
            padding-left: 16px;
            padding-right: 12px;
        }

        .form-control {
            border-top-right-radius: 12px !important;
            border-bottom-right-radius: 12px !important;
            border-top-left-radius: 0px !important;
            border-bottom-left-radius: 0px !important;
            padding: 12px 16px;
            border: 1px solid rgba(255, 255, 255, 0.15) !important;
            background-color: rgba(255, 255, 255, 0.06) !important;
            color: #ffffff !important;
            font-size: 0.9rem;
        }

        .form-control:focus {
            background-color: rgba(255, 255, 255, 0.12) !important;
            border-color: #38bdf8 !important;
            box-shadow: none !important;
            color: #ffffff !important;
        }

        .input-group:focus-within .input-group-text {
            border-color: #38bdf8 !important;
        }

        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.3) !important;
        }

        .btn-signup { 
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
            color: white !important; 
            font-weight: 600; 
            border-radius: 12px; 
            border: none; 
            padding: 14px; 
            box-shadow: 0 4px 15px rgba(37, 99, 235, 0.4); 
            transition: all 0.2s ease;
            width: 100%;
            letter-spacing: 0.5px;
        }

        .btn-signup:hover { 
            background: linear-gradient(135deg, #1d4ed8 0%, #1e40af 100%);
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(37, 99, 235, 0.6);
        }

        .link-login {
            color: #facc15 !important; /* Warna Kuning Amber bersinar agar mencolok */
            text-decoration: none;
            font-weight: 700;
            transition: all 0.2s;
            text-shadow: 0 0 8px rgba(250, 204, 21, 0.3);
        }

        .link-login:hover {
            color: #fde047 !important;
            text-shadow: 0 0 12px rgba(250, 204, 21, 0.6);
            text-decoration: underline;
        }

        .text-white-contrast {
            color: #ffffff !important;
            font-size: 0.88rem;
            font-weight: 500;
            opacity: 0.95;
        }
    </style>
</head>
<body>

    <div class="glass-card">
        <div class="text-center mb-4">
            <div class="display-5 text-primary mb-2">
                <i class="bi bi-person-plus-fill" style="color: #38bdf8;"></i>
            </div>
            <h3 class="brand-title mb-1">DAFTAR AKUN</h3>
            <p class="text-white small opacity-75">Bergabunglah bersama Topvia Top Up</p>
        </div>

        <% if("gagal".equals(request.getParameter("status"))) { %>
            <div class="alert alert-danger text-center py-2 rounded-3 small mb-3" style="background: rgba(239, 68, 68, 0.15); border: 1px solid rgba(239, 68, 68, 0.3); color: #fca5a5;">
                <i class="bi bi-exclamation-triangle-fill me-1"></i> Registrasi gagal! Username sudah digunakan atau data salah.
            </div>
        <% } %>

        <form action="SignUpServlet" method="POST">
            
            <div class="mb-3">
                <label class="form-label">NAMA LENGKAP</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-person-vcard"></i></span>
                    <input type="text" class="form-control" name="txtNama" placeholder="Masukkan nama lengkap Anda" required autocomplete="off">
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label">USERNAME BARU</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-person"></i></span>
                    <input type="text" class="form-control" name="txtUsername" placeholder="Buat nama pengguna unik" required autocomplete="off">
                </div>
            </div>

            <div class="mb-4">
                <label class="form-label">PASSWORD</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                    <input type="password" class="form-control" name="txtPassword" placeholder="Buat kata sandi aman" required>
                </div>
            </div>

            <div class="mb-4">
                <button type="submit" class="btn btn-signup">
                    <i class="bi bi-check-circle-fill me-2"></i>Buat Akun Sekarang
                </button>
            </div>

            <div class="text-center">
                <p class="text-white-contrast mb-0">Sudah punya akun resmi? <a href="index.jsp" class="link-login">Masuk di sini</a></p>
            </div>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>