package com.topvia.model;

/**
 *
 * @author putri
 */
public class laporan {
    
    private String idLaporan;
    private String periodeBulan;
    private int totalTransaksiBulanIni;
    private double omsetBulanIni;
    private String tanggalCetak;

    public laporan() {
    }

    public laporan(String idLaporan, String periodeBulan, int totalTransaksiBulanIni, double omsetBulanIni, String tanggalCetak) {
        this.idLaporan = idLaporan;
        this.periodeBulan = periodeBulan;
        this.totalTransaksiBulanIni = totalTransaksiBulanIni;
        this.omsetBulanIni = omsetBulanIni;
        this.tanggalCetak = tanggalCetak;
    }

    public String getIdLaporan() {
        return idLaporan;
    }

    public void setIdLaporan(String idLaporan) {
        this.idLaporan = idLaporan;
    }

    public String getPeriodeBulan() {
        return periodeBulan;
    }

    public void setPeriodeBulan(String periodeBulan) {
        this.periodeBulan = periodeBulan;
    }

    public int getTotalTransaksiBulanIni() {
        return totalTransaksiBulanIni;
    }

    public void setTotalTransaksiBulanIni(int totalTransaksiBulanIni) {
        this.totalTransaksiBulanIni = totalTransaksiBulanIni;
    }

    public double getOmsetBulanIni() {
        return omsetBulanIni;
    }

    public void setOmsetBulanIni(double omsetBulanIni) {
        this.omsetBulanIni = omsetBulanIni;
    }

    public String getTanggalCetak() {
        return tanggalCetak;
    }

    public void setTanggalCetak(String tanggalCetak) {
        this.tanggalCetak = tanggalCetak;
    }
}