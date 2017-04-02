#!/bin/sh

if [ `grep -c "iptables" /etc/ppp/ip-up` = 0 ]; then
cat >> /etc/ppp/ip-up <<EOF
if [ "\$PPP_IFACE" = "ppp0" ]; then
  exec /root/chg_iptables_forti.sh
fi
EOF
fi

if [ `grep -c "openfortivpn" /etc/rc.local` = 0 ]; then
   sed  -i  "/^exit/i\ if \[ \-f \/root\/configvpn.cfg \]\; then \/usr\/bin\/openfortivpn \-c \/root\/configvpn\.cfg  3\>\&1 2\>\&2 1\>\&3 \> \/dev\/tty2 \& fi\n" /etc/rc.local
fi


adresseVpn () {
ADDSRV=$(whiptail --title "Creation fichier VPN-SSL" --inputbox "Adresse du serveur vpn" 10 60 "vpnpda.gie-superh.com" 3>&1 1>&2 2>&3)

exit=$?
if [ $exit = 0 ]; then
#echo "Le serveur vpn est : $ADDSRV"
portVpn
else
echo "Annule"
fi
}

portVpn () {
PORTSRV=$(whiptail --title "Creation fichier VPN-SSL" --inputbox "Port du serveur vpn" 10 60 "10443" 3>&1 1>&2 2>&3)

exit=$?
if [ $exit = 0 ]; then
#echo "Le port du serveur vpn est : $PORTSRV"
userVpn
else
echo "Annule"
fi
}

userVpn () {
USRSRV=$(whiptail --title "Creation fichier VPN-SSL" --inputbox "Nom d'utilisateur" 10 60 "" 3>&1 1>&2 2>&3)

exit=$?
if [ $exit = 0 ]; then
#echo "L' utisateur est : $USRSRV"
passVpn
else
echo "Annule"
fi
}

passVpn () {
PASSSRV=$(whiptail --title "Creation fichier VPN-SSL" --inputbox "Mot de passe" 10 60 "" 3>&1 1>&2 2>&3)

exit=$?
if [ $exit = 0 ]; then
echo "Le serveur vpn est : $ADDSRV"
echo "Le port du serveur vpn est : $PORTSRV"
echo "L' utisateur est : $USRSRV"
echo "Creation du fichier vpn ok!"
cat > /root/configvpn.cfg <<EOF
host =$ADDSRV
port =$PORTSRV
username =$USRSRV
password =$PASSSRV
trusted-cert = fc2d735ddfc4a66dcdd18e41bb44a2d6c391d0ff075d3d1c49f0bab4475383de
EOF
if [ `grep -c "iptables" /etc/ppp/ip-up` = 0 ]; then
cat >> /etc/ppp/ip-up <<EOF
if [ "$PPP_IFACE" = "ppp0" ]; then
  exec /root/chg_iptables_forti.sh
fi
EOF
fi
else
echo "Annule"
fi
}

if ! [ -f /root/configvpn.cfg ]; then
adresseVpn
else
echo "Le fichier de configuration vpn exite déjà!"
fi
