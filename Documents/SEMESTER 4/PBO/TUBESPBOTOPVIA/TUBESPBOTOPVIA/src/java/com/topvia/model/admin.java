package com.topvia.model;

public class admin extends account {

    // Constructor Kosong
    public admin() {
        super();
    }

    // Constructor Berparameter menggunakan super()
    public admin(String username, String password) {
        super(username, password);
    }
}