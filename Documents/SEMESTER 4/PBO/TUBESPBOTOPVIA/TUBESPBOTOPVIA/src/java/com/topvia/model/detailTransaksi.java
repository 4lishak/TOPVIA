package com.topvia.model;

/**
 *
 * @author putri
 */
public class detailTransaksi {
    
    private String idDetail;
    private String idTransaksi;
    private String userIdGame;
    private String zoneIdGame;
    private String catatanTambahan;

    public detailTransaksi() {
    }

    public detailTransaksi(String idDetail, String idTransaksi, String userIdGame, String zoneIdGame, String catatanTambahan) {
        this.idDetail = idDetail;
        this.idTransaksi = idTransaksi;
        this.userIdGame = userIdGame;
        this.zoneIdGame = zoneIdGame;
        this.catatanTambahan = catatanTambahan;
    }

    public String getIdDetail() {
        return idDetail;
    }

    public void setIdDetail(String idDetail) {
        this.idDetail = idDetail;
    }

    public String getIdTransaksi() {
        return idTransaksi;
    }

    public void setIdTransaksi(String idTransaksi) {
        this.idTransaksi = idTransaksi;
    }

    public String getUserIdGame() {
        return userIdGame;
    }

    public void setUserIdGame(String userIdGame) {
        this.userIdGame = userIdGame;
    }

    public String getZoneIdGame() {
        return zoneIdGame;
    }

    public void setZoneIdGame(String zoneIdGame) {
        this.zoneIdGame = zoneIdGame;
    }

    public String getCatatanTambahan() {
        return catatanTambahan;
    }

    public void setCatatanTambahan(String catatanTambahan) {
        this.catatanTambahan = catatanTambahan;
    }
}