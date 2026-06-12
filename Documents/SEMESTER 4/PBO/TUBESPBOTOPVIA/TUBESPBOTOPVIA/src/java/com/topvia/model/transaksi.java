package com.topvia.model;

public class transaksi {
    private String idTransaksi;
    private user pelanggan;
    private voucher itemVoucher;
    private String userId;
    private String zoneId;
    private String tanggalWaktu; // Atribut baru untuk menyimpan waktu transaksi

    public transaksi(String idTransaksi, user pelanggan, voucher itemVoucher, String userId, String zoneId, String tanggalWaktu) {
        this.idTransaksi = idTransaksi;
        this.pelanggan = pelanggan;
        this.itemVoucher = itemVoucher;
        this.userId = userId;
        this.zoneId = zoneId;
        this.tanggalWaktu = tanggalWaktu;
    }

    public String getIdTransaksi() { return idTransaksi; }
    public user getPelanggan() { return pelanggan; }
    public voucher getItemVoucher() { return itemVoucher; }
    public String getUserId() { return userId; }
    public String getZoneId() { return zoneId; }
    public String getTanggalWaktu() { return tanggalWaktu; }
}