package com.topvia.model;

/**
 *
 * @author putri
 */
public class pembayaran {
    
    private String idPembayaran;
    private String idTransaksi;
    private String metodePembayaran; // Contoh: QRIS, Mandiri, BCA, OVO
    private double jumlahBayar;
    private String statusBayar; // Contoh: Lunas, Pending, Gagal

    public pembayaran() {
    }

    public pembayaran(String idPembayaran, String idTransaksi, String metodePembayaran, double jumlahBayar, String statusBayar) {
        this.idPembayaran = idPembayaran;
        this.idTransaksi = idTransaksi;
        this.metodePembayaran = metodePembayaran;
        this.jumlahBayar = jumlahBayar;
        this.statusBayar = statusBayar;
    }

    public String getIdPembayaran() {
        return idPembayaran;
    }

    public void setIdPembayaran(String idPembayaran) {
        this.idPembayaran = idPembayaran;
    }

    public String getIdTransaksi() {
        return idTransaksi;
    }

    public void setIdTransaksi(String idTransaksi) {
        this.idTransaksi = idTransaksi;
    }

    public String getMetodePembayaran() {
        return metodePembayaran;
    }

    public void setMetodePembayaran(String metodePembayaran) {
        this.metodePembayaran = metodePembayaran;
    }

    public double getJumlahBayar() {
        return jumlahBayar;
    }

    public void setJumlahBayar(double jumlahBayar) {
        this.jumlahBayar = jumlahBayar;
    }

    public String getStatusBayar() {
        return statusBayar;
    }

    public void setStatusBayar(String statusBayar) {
        this.statusBayar = statusBayar;
    }
}