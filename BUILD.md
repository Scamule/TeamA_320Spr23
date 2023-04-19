# Building USchedule #

## Aquire files

Clone project from GitHub:
```
git clone https://github.com/SammyPie/TeamA_320Spr23
cd TeamA_320Spr23
```

* **Build Frontend**
    
    
    Download Flutter dependecies from https://docs.flutter.dev/get-started/install
    Then run the frontend by entering the directory and running the command 'flutter run'
* **Build Backend**
    

    Download Python from python.org
    Then download all dependencies (boto3, flask, json, request)
    
    Generate .env in backend directory with valid credentials for database access
    ```
    {
    "database_key": "i lost my keys",
    "database_secret": "super_secret",
    "bcrypt_salt": "salty",
    "jwt_secret": "keystothecar"
    }
    ```
    Then run app.py
