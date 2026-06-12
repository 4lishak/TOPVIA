package com.topvia.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LogoutServlet", urlPatterns = {"/LogoutServlet"})
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Mengambil sesi yang sedang aktif
        HttpSession session = request.getSession();
        
        // Menghapus semua data di dalam sesi tersebut
        session.invalidate();
        
        // Mengarahkan kembali ke halaman login
        response.sendRedirect("index.jsp");
    }
}