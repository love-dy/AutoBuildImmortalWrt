#!/bin/bash
# Log file for debugging
LOGFILE="/tmp/uci-defaults-log.txt"
echo "Starting 99-custom.sh at $(date)" >> $LOGFILE
# yml 传入的路由器型号 PROFILE
echo "Building for profile: $PROFILE"
# yml 传入的固件大小 ROOTFS_PARTSIZE
echo "Building for ROOTFS_PARTSIZE: $ROOTFS_PARTSIZE"

echo "Create pppoe-settings"
mkdir -p  /home/build/immortalwrt/files/etc/config

# 创建pppoe配置文件 yml传入环境变量ENABLE_PPPOE等 写入配置文件 供99-custom.sh读取
cat << EOF > /home/build/immortalwrt/files/etc/config/pppoe-settings
enable_pppoe=${ENABLE_PPPOE}
pppoe_account=${PPPOE_ACCOUNT}
pppoe_password=${PPPOE_PASSWORD}
EOF

echo "cat pppoe-settings"
cat /home/build/immortalwrt/files/etc/config/pppoe-settings


# 输出调试信息
echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting build process..."


# 定义所需安装的包列表 23.05.4 下列插件你都可以自行删减
PACKAGES=""
PACKAGES="$PACKAGES curl"
PACKAGES="$PACKAGES luci-i18n-opkg-zh-cn"
PACKAGES="$PACKAGES luci-i18n-firewall-zh-cn"
PACKAGES="$PACKAGES luci-i18n-filebrowser-zh-cn"
PACKAGES="$PACKAGES luci-i18n-passwall-zh-cn"
PACKAGES="$PACKAGES luci-app-openclash"
PACKAGES="$PACKAGES luci-i18n-homeproxy-zh-cn"
PACKAGES="$PACKAGES openssh-sftp-server"
PACKAGES="$PACKAGES luci-i18n-dockerman-zh-cn"
# 增加几个必备组件 方便用户安装iStore
PACKAGES="$PACKAGES fdisk"
PACKAGES="$PACKAGES script-utils"
PACKAGES="$PACKAGES luci-i18n-samba4-zh-cn"
# 增加***
PACKAGES="$PACKAGES kmod-usb-core"
PACKAGES="$PACKAGES kmod-usb-net"
PACKAGES="$PACKAGES kmod-usb-net-cdc-eem"
PACKAGES="$PACKAGES kmod-usb-net-cdc-ether"
PACKAGES="$PACKAGES kmod-usb-net-cdc-mbim"
PACKAGES="$PACKAGES kmod-usb-net-cdc-ncm"
PACKAGES="$PACKAGES kmod-usb-net-cdc-subset"
PACKAGES="$PACKAGES kmod-usb-net-huawei-cdc-ncm"
PACKAGES="$PACKAGES kmod-usb-net-ipheth"
PACKAGES="$PACKAGES kmod-usb-net-qmi-wwan"
PACKAGES="$PACKAGES kmod-usb-net-rndis"
PACKAGES="$PACKAGES kmod-usb-net-rtl8150"
PACKAGES="$PACKAGES kmod-usb-net-rtl8152-vendor"
PACKAGES="$PACKAGES kmod-usb-ehci"
PACKAGES="$PACKAGES kmod-usb-ohci"
PACKAGES="$PACKAGES kmod-usb-uhci"
PACKAGES="$PACKAGES kmod-usb2"
PACKAGES="$PACKAGES kmod-usb3"
PACKAGES="$PACKAGES kmod-usb-storage"
PACKAGES="$PACKAGES kmod-usb-storage-extras"
PACKAGES="$PACKAGES kmod-usb-storage-uas"
# 增加***
PACKAGES="$PACKAGES cfdisk"
PACKAGES="$PACKAGES wget-ssl"
PACKAGES="$PACKAGES ip6tables-extra"
PACKAGES="$PACKAGES ip6tables-mod-nat"
PACKAGES="$PACKAGES iptables-nft"
PACKAGES="$PACKAGES ip6tables-nft"
PACKAGES="$PACKAGES qrencode"
PACKAGES="$PACKAGES kmod-mtd-rw"
# 增加***
PACKAGES="$PACKAGES luci-i18n-arpbind-zh-cn"
PACKAGES="$PACKAGES luci-i18n-autoreboot-zh-cn"
PACKAGES="$PACKAGES luci-i18n-ddns-go-zh-cn"
PACKAGES="$PACKAGES luci-i18n-diskman-zh-cn"
PACKAGES="$PACKAGES luci-i18n-hd-idle-zh-cn"
PACKAGES="$PACKAGES luci-i18n-smartdns-zh-cn"
PACKAGES="$PACKAGES luci-i18n-ttyd-zh-cn"
PACKAGES="$PACKAGES luci-i18n-upnp-zh-cn"
PACKAGES="$PACKAGES luci-i18n-vlmcsd-zh-cn"
PACKAGES="$PACKAGES luci-proto-wireguard"
PACKAGES="$PACKAGES luci-i18n-zerotier-zh-cn"
# 增加***
PACKAGES="$PACKAGES luci-theme-bootstrap"
PACKAGES="$PACKAGES luci-theme-bootstrap-mod"
PACKAGES="$PACKAGES luci-theme-argon"
PACKAGES="$PACKAGES luci-app-argon-config"
PACKAGES="$PACKAGES luci-i18n-argon-config-zh-cn"
PACKAGES="$PACKAGES luci-theme-material"
# 增加***
PACKAGES="$PACKAGES kmod-drm-panfrost"
PACKAGES="$PACKAGES kmod-drm-rockchip"
PACKAGES="$PACKAGES luci-i18n-cpufreq-zh-cn"
# 增加***
PACKAGES="$PACKAGES wpad-openssl"
PACKAGES="$PACKAGES kmod-mt7921e"
PACKAGES="$PACKAGES kmod-mt7921-firmware"


# 构建镜像
echo "$(date '+%Y-%m-%d %H:%M:%S') - Building image with the following packages:"
echo "$PACKAGES"

make image PROFILE=$PROFILE PACKAGES="$PACKAGES" FILES="/home/build/immortalwrt/files" ROOTFS_PARTSIZE=$ROOTFS_PARTSIZE

if [ $? -ne 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: Build failed!"
    exit 1
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - Build completed successfully."