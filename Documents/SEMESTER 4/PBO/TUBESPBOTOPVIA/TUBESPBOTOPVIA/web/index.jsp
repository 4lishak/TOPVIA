<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistem Autentikasi - Topvia</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(180deg, #000000 0%, #0d3875 45%, #8bcbf5 100%);
            background-attachment: fixed;
            min-height: 100vh;
            position: relative;
            overflow-x: hidden;
        }

        /* Dekorasi Bentuk Kaca Sisi Kiri */
        body::before {
            content: "";
            position: absolute;
            width: 300px;
            height: 500px;
            left: -50px;
            top: 15%;
            background: rgba(255, 255, 255, 0.03);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 40px 150px 40px 8px;
            z-index: 0;
            pointer-events: none;
        }

        /* Dekorasi Bentuk Kaca Sisi Kanan */
        body::after {
            content: "";
            position: absolute;
            width: 320px;
            height: 200px;
            right: -30px;
            top: 25%;
            background: rgba(255, 255, 255, 0.03);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 24px 8px 24px 60px;
            z-index: 0;
            pointer-events: none;
        }

        /* FORM CARD GLASSMORPHISM TRANSPARAN */
        .login-card {
            border-radius: 24px;
            background: rgba(255, 255, 255, 0.08) !important;
            backdrop-filter: blur(20px) !important;
            -webkit-backdrop-filter: blur(20px) !important;
            border: 1px solid rgba(255, 255, 255, 0.2) !important;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
            position: relative;
            z-index: 10;
        }

        .main-title {
            color: #ffffff !important;
            font-weight: 800;
            letter-spacing: 2px;
            text-shadow: 0 0 10px rgba(255, 255, 255, 0.2);
        }
        .sub-title {
            color: #38bdf8 !important;
            font-weight: 500;
            font-size: 0.95rem;
        }

        .form-label {
            color: #f1f5f9 !important;
            font-size: 0.8rem;
            font-weight: 600;
            letter-spacing: 0.5px;
        }

        .form-control {
            border-radius: 10px;
            padding: 12px 15px;
            border: 1px solid rgba(255, 255, 255, 0.25);
            background-color: rgba(255, 255, 255, 0.1) !important;
            color: #ffffff !important;
        }
        .form-control:focus {
            background-color: rgba(255, 255, 255, 0.15) !important;
            border-color: #38bdf8;
            box-shadow: 0 0 0 0.25rem rgba(56, 189, 248, 0.25);
        }
        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.4) !important;
        }

        .input-group-text {
            background-color: rgba(255, 255, 255, 0.1) !important;
            color: #cbd5e1 !important;
            border: 1px solid rgba(255, 255, 255, 0.25);
            border-left: none;
            border-top-right-radius: 10px !important;
            border-bottom-right-radius: 10px !important;
            cursor: pointer;
            padding-right: 15px;
        }
        .input-group-text:hover {
            color: #ffffff !important;
            background-color: rgba(255, 255, 255, 0.2) !important;
        }

        .btn-elegant {
            background-color: #2563eb;
            color: #ffffff;
            border-radius: 12px;
            padding: 14px;
            font-weight: 700;
            border: none;
            box-shadow: 0 4px 14px rgba(37, 99, 235, 0.4);
            transition: all 0.3s;
        }
        .btn-elegant:hover {
            background-color: #1d4ed8;
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(37, 99, 235, 0.6);
        }

        /* 🛠️ PERUBAHAN: TEKS KONTRAST TINGGI DI BAGIAN BAWAH */
        .text-muted-glass {
            color: #ffffff !important; /* Diubah jadi putih murni agar kontras */
            font-size: 0.9rem;
            font-weight: 500;
            opacity: 0.9;
        }
        
        .text-accent-glow {
            color: #facc15 !important; /* Diubah ke Kuning Amber/Neon agar sangat mencolok */
            font-weight: 700;
            text-decoration: none;
            margin-left: 5px;
            transition: all 0.2s ease-in-out;
            text-shadow: 0 0 8px rgba(250, 204, 21, 0.3); /* Efek glow tipis */
        }
        .text-accent-glow:hover {
            color: #fde047 !important; /* Kuning lebih terang saat di-hover */
            text-shadow: 0 0 12px rgba(250, 204, 21, 0.7);
            text-decoration: underline;
        }
    </style>
</head>
<body class="d-flex justify-content-center align-items-center">

    <div class="card p-5 login-card" style="width: 100%; max-width: 440px;">
        <div class="text-center mb-4">
            <h4 class="main-title">TOPVIA</h4>
            <p class="sub-title">Portal Top-Up Eksklusif Mobile Legends</p>
        </div>
        
        <% if("success".equals(request.getParameter("signup"))) { %>
            <div class="alert alert-success p-2 text-center" style="font-size: 0.85rem; background: rgba(16, 185, 129, 0.2); border: 1px solid #10b981; color: #a7f3d0;">
                <i class="bi bi-check-circle"></i> Registrasi Berhasil! Silakan Login.
            </div>
        <% } %>

        <% if("1".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger p-2 text-center" style="font-size: 0.85rem; background: rgba(239, 68, 68, 0.2); border: 1px solid #ef4444; color: #fca5a5;">
                <i class="bi bi-exclamation-triangle"></i> Username atau Password salah!
            </div>
        <% } %>
        
        <form action="LoginServlet" method="POST">
            <div class="mb-3">
                <label class="form-label">USERNAME</label>
                <input type="text" class="form-control" name="txtUser" placeholder="Masukkan username" required>
            </div>
            
            <div class="mb-4">
                <label class="form-label">PASSWORD</label>
                <div class="input-group">
                    <input type="password" class="form-control" id="loginPasswordField" name="txtPass" 
                           placeholder="Masukkan password" 
                           style="border-top-right-radius: 0; border-bottom-right-radius: 0;" required>
                    <span class="input-group-text" id="toggleLoginPassword">
                        <i class="bi bi-eye-slash" id="loginEyeIcon"></i>
                    </span>
                </div>
            </div>
            
            <button type="submit" class="btn btn-elegant w-100 mb-3">Masuk Sistem</button>
        </form>
        
        <!-- Area Teks Bawah yang Sudah Ditingkatkan Kontrasnya -->
        <div class="text-center mt-3 pt-3 border-top" style="border-color: rgba(255, 255, 255, 0.15) !important;">
            <span class="text-muted-glass">Belum memiliki akun?</span> 
            <a href="signup.jsp" class="text-accent-glow">Daftar di sini</a>
        </div>
    </div>

    <script>
        const toggleLoginPassword = document.querySelector('#toggleLoginPassword');
        const loginPasswordField = document.querySelector('#loginPasswordField');
        const loginEyeIcon = document.querySelector('#loginEyeIcon');

        toggleLoginPassword.addEventListener('click', function () {
            const type = loginPasswordField.getAttribute('type') === 'password' ? 'text' : 'password';
            loginPasswordField.setAttribute('type', type);
            loginEyeIcon.classList.toggle('bi-eye');
            loginEyeIcon.classList.toggle('bi-eye-slash');
        });
    </script>
</body>
</html>