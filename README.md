# laravel + docker configuration
Minimal docker container image (219 MB): laravel with nginx and php-fpm without bd

Your need docker and docker-compose in your operation system.

Clone: git clone https://github.com/codesshaman/laravel8_cryptopro_oncentos.git

GO TO FOLDER:
cd laravel8_cryptopro_oncentos

INSTALL LARAVEL:

chmod +x start.sh
./start.sh

Enter laravel port number and enjoy!

STOP:
docker-compose down

CONNECT:
docker exec -it nginx_laravel sh

OPEN:
http://localhost:your_port/
