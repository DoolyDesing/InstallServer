#!/bin/bash

# Создаем пользователя server
useradd -m server
passwd server
usermod -aG sudo server
usermod -s /bin/bash server

# Перезапускаем SSH для применения изменений
systemctl restart sshd

# Переходим к пользователю server
su server

# Обновляем систему и устанавливаем зависимости
cd
sudo apt update && sudo apt upgrade -y
sudo apt install lib32gcc-s1

# Скачиваем и распаковываем SteamCMD
mkdir ~/steamcmd && cd ~/steamcmd
wget http://media.steampowered.com/client/steamcmd_linux.tar.gz
tar xvfz steamcmd_linux.tar.gz

# Устанавливаем CS2
STEAMEXE=steamcmd ./steamcmd.sh +login anonymous +force_install_dir /home/server/server +app_update 730 +exit

# Копируем Steam Client для CS2
cd ~/ && mkdir .steam && cd .steam && mkdir sdk64; cp ~/steamcmd/linux64/steamclient.so ~/.steam/sdk64

# Создаем скрипт для запуска CS2
cd
touch start.sh && nano start.sh
echo "#!/bin/bash" >> start.sh
echo "~/server/game/bin/linuxsteamrt64/cs2 -port 27015 -game csgo -dedicated -console -maxplayers 8 +game_type 0 +game_mode 0 +map de_inferno" >> start.sh
sudo chmod +x start.sh

# Настройка конфигурации сервера
nano server/game/csgo/cfg/server.cfg

# Запускаем сервер CS2
sh start.sh