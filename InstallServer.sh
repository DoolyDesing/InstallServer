#!/bin/bash

# Создаем пользователя server
useradd -m server
echo "server:Ivan_van2008" | chpasswd
usermod -aG sudo server
usermod -s /bin/bash server

# Перезапускаем SSH для применения изменений
systemctl restart sshd

# Выполняем команды от имени пользователя server
sudo -u server bash << EOF
cd ~

# Обновляем систему и устанавливаем зависимости
yes | sudo apt update && sudo apt upgrade -y
yes | sudo apt install lib32gcc-s1 -y

# Скачиваем и распаковываем SteamCMD
mkdir ~/steamcmd && cd ~/steamcmd
wget http://media.steampowered.com/client/steamcmd_linux.tar.gz
tar xvfz steamcmd_linux.tar.gz

# Устанавливаем CS2
STEAMEXE=steamcmd ./steamcmd.sh +login anonymous +force_install_dir /home/server/server +app_update 730 +exit

# Копируем Steam Client для CS2
mkdir -p ~/.steam/sdk64
cp ~/steamcmd/linux64/steamclient.so ~/.steam/sdk64

# Создаем скрипт для запуска CS2
cd ~
echo "#!/bin/bash" > start.sh
echo "~/server/game/bin/linuxsteamrt64/cs2 -port 27015 -game csgo -dedicated -console -maxplayers 8 +game_type 0 +game_mode 0 +map de_inferno" >> start.sh
chmod +x start.sh

# Настройка конфигурации сервера (если требуется ручная настройка)
#nano ~/server/game/csgo/cfg/server.cfg

# Запускаем сервер CS2
./start.sh
EOF
