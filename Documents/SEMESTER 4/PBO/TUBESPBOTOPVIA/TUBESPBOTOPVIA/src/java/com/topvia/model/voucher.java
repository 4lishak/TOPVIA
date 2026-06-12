package com.topvia.model;

public class voucher {
    private String idVoucher;
    private String namaVoucher;
    private double harga;

    public voucher(String idVoucher, String namaVoucher, double harga) {
        this.idVoucher = idVoucher;
        this.namaVoucher = namaVoucher;
        this.harga = harga;
    }

    public String getIdVoucher() { return idVoucher; }
    public String getNamaVoucher() { return namaVoucher; }
    public double getHarga() { return harga; }
}