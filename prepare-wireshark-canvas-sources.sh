#!/bin/sh
set -e

wget --continue https://www.wireshark.org/download/src/wireshark-2.4.14.tar.xz
tar xf wireshark-2.4.14.tar.xz
wget --continue https://canlogger.csselectronics.com/files/wiresharkplugin/WS_v2.4-Plugin_v7.1.zip
unzip -o -q WS_v2.4-Plugin_v7.1.zip
mkdir -p wireshark-2.4.14/plugins/canvas
mv WS_v2.4-Plugin_v7.1/CANvas-Wireshark-v2.4-Plugin-CSS-Electronics_v7.1/Source/* wireshark-2.4.14/plugins/canvas/
rm -f wireshark-2.4.14.tar.xz
rm -f WS_v2.4-Plugin_v7.1.zip
rm -rf WS_v2.4-Plugin_v7.1/
cd wireshark-2.4.14/ && patch -p1 -i ../add-canvas-plugin.patch
echo "Wireshark and CANvas sources are ready, you can now build them."
