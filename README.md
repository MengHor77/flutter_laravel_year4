# app selling book flutter with Laravel 


 # soorce code in git  https://github.com/MengHor77/flutter_laravel_year4.git
 
# how to set up

 + go to folder  and run commend in laravel
 
    D:\flutter\book_backend> 
    - composer install
    - npm install
    - create file in D:\flutter\book_backend\.env
    - change ip example : APP_URL="http://10.1.42.124:8000"

   - modifies name database

    DB_CONNECTION=mysql
    DB_HOST=127.0.0.1
    DB_PORT=3306
    DB_DATABASE=flutter_book
    DB_USERNAME=root
    DB_PASSWORD=


 +  go to http://localhost/phpmyadmin/ 

    - create database name flutter_book

    - run commend

    php artisan migrate 
    php artian db:seed
    php artisan server --host=0.0.0.0 --port=8000


 + go to folder and config

    D:\flutter\mobile_year4\lib\api_config.dart 
    -change ip 
    example static const String baseUrl = "http://10.1.42.124:8000";  (actual ip machine) 

+ go to folder then run commend in flutter 
    D:\flutter\mobile_year4>

    - click No Device at right botton 
    - click start emulator
  -run commend
    flutter run


