## Aby Caddy i lokalne domeny (.localhost) działały

### Poniższa komenda automatycznie wykrywa Twoją aktywną sieć Wi-Fi i ustawia w niej DNS na `127.0.0.1`. Dzięki temu ustawienie **przetrwa restart systemu i aktualizacje**

```sh
# Pobranie nazwy aktualnego połączenia
WIFI_CONN=$(nmcli -t -f NAME,DEVICE connection show --active | grep wlan0 | cut -d: -f1)

# Ustawienie DNS i ignorowanie danych z DHCP (routera)
nmcli connection modify "$WIFI_CONN" ipv4.dns "127.0.0.1"
nmcli connection modify "$WIFI_CONN" ipv4.ignore-auto-dns yes
nmcli connection up "$WIFI_CONN"
```

### Wykonaj poniższe komendy, aby skierować DNS na Pi-hole i zwolnić port 53

```sh
# Ustawienie DNS na localhost dla aktywnego połączenia (automatycznie wykrywa interfejs)
nmcli device modify $(nmcli device | grep connected | awk '{print $1}' | head -n1) ipv4.dns "127.0.0.1"

# Zwolnienie portu 53 zajętego przez systemd-resolved
sudo sed -i 's/#DNSStubListener=yes/DNSStubListener=no/' /etc/systemd/resolved.conf
sudo ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
sudo systemctl restart systemd-resolved

