package com.topvia.model;

import java.util.ArrayList;

public class dataDummy {
    public static ArrayList<user> listPelanggan = new ArrayList<>();
    public static ArrayList<voucher> listVoucher = new ArrayList<>();
    public static ArrayList<transaksi> listTransaksi = new ArrayList<>();
    
    // MENAMBAHKAN AKUN ADMIN DEFAULT
    public static admin adminSistem = new admin("admin", "admin123");

    static {
        listVoucher.add(new voucher("V01", "Top Up 100 Diamonds", 15000));
        listVoucher.add(new voucher("V02", "Top Up 300 Diamonds", 45000));
        listVoucher.add(new voucher("V03", "Top Up 500 Diamonds", 70000));
        listVoucher.add(new voucher("V04", "Top Up 1000 Diamonds", 135000));
    }
}