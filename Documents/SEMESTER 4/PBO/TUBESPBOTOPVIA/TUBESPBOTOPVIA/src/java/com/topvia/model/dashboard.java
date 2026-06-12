package com.topvia.model;

/**
 *
 * @author putri
 */
public class dashboard {
    
    // 1. Atribut (Variabel)
    private int totalTransaksi;
    private double totalPendapatan;
    private int layananAktif;

    // 2. Constructor Kosong
    public dashboard() {
    }

    // 3. Constructor dengan Parameter
    public dashboard(int totalTransaksi, double totalPendapatan, int layananAktif) {
        this.totalTransaksi = totalTransaksi;
        this.totalPendapatan = totalPendapatan;
        this.layananAktif = layananAktif;
    }

    // 4. Getter dan Setter
    public int getTotalTransaksi() {
        return totalTransaksi;
    }

    public void setTotalTransaksi(int totalTransaksi) {
        this.totalTransaksi = totalTransaksi;
    }

    public double getTotalPendapatan() {
        return totalPendapatan;
    }

    public void setTotalPendapatan(double totalPendapatan) {
        this.totalPendapatan = totalPendapatan;
    }

    public int getLayananAktif() {
        return layananAktif;
    }

    public void setLayananAktif(int layananAktif) {
        this.layananAktif = layananAktif;
    }
}