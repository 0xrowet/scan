#!/data/data/com.termux/files/usr/bin/bash

# Instal dependensi jika belum ada
pkg update -y
pkg install -y termux-api jq ncurses-utils

# Fungsi untuk mengirim barcode ke server
send_barcode() {
    IP=$1
    PORT=5000
    BARCODE=$2
    
    # Kirim barcode ke server desktop
    echo "Mengirim barcode $BARCODE ke $IP:$PORT"
    echo -n "$BARCODE" | nc -w 1 $IP $PORT
    
    if [ $? -eq 0 ]; then
        echo "Barcode berhasil dikirim"
    else
        echo "Gagal mengirim barcode"
    fi
}

# Main program
clear
echo "=== Barcode Scanner untuk Teko Tuku ==="
echo

# Dapatkan IP desktop (harus diinput manual)
read -p "Masukkan IP komputer desktop: " DESKTOP_IP

while true; do
    echo
    echo "Pilihan:"
    echo "1. Scan barcode"
    echo "2. Masukkan barcode manual"
    echo "3. Ganti IP desktop"
    echo "4. Keluar"
    echo
    read -p "Pilih menu (1-4): " choice
    
    case $choice in
        1)
            echo "Arahkan kamera ke barcode..."
            BARCODE=$(termux-barcode-scan)
            if [ -z "$BARCODE" ]; then
                echo "Gagal memindai barcode"
            else
                echo "Barcode terdeteksi: $BARCODE"
                send_barcode $DESKTOP_IP $BARCODE
            fi
            ;;
        2)
            read -p "Masukkan barcode: " BARCODE
            if [ -n "$BARCODE" ]; then
                send_barcode $DESKTOP_IP $BARCODE
            else
                echo "Barcode tidak boleh kosong"
            fi
            ;;
        3)
            read -p "Masukkan IP komputer desktop: " DESKTOP_IP
            ;;
        4)
            echo "Keluar dari aplikasi"
            exit 0
            ;;
        *)
            echo "Pilihan tidak valid"
            ;;
    esac
    
    read -p "Tekan Enter untuk melanjutkan..."
    clear
done
