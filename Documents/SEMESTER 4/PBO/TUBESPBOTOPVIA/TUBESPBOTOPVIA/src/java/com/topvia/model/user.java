package com.topvia.model;

public class user extends account {
    private String namaLengkap;
    private String email;

    // Constructor Kosong
    public user() {
        super();
    }

    // Constructor Berparameter memanggil properti induk lewat super()
    public user(String username, String password, String namaLengkap, String email) {
        super(username, password); // Melempar username & password ke class account
        this.namaLengkap = namaLengkap;
        this.email = email;
    }

    // Getter dan Setter khusus untuk properti tambahan milik user biasa
    public String getNamaLengkap() {
        return namaLengkap;
    }

    public void setNamaLengkap(String namaLengkap) {
        this.namaLengkap = namaLengkap;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}