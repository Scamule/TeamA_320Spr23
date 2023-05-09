# Building USchedule

## Aquire files

Clone project from GitHub:

```
git clone https://github.com/SammyPie/TeamA_320Spr23
cd TeamA_320Spr23
```

- **Build Frontend**

  Download Flutter dependecies from https://docs.flutter.dev/get-started/install.

  Buld dependencies by running `flutter packages pub run build_runner build`.

  Then run the frontend by entering the directory and running the command `flutter run`.

- **Build Backend**

  Download Python from python.org.
  Dowload and setup MongoDB from https://www.mongodb.com/try/download/community.

  Add necessary credentials in `.env` file.

  ```
  # ENV VARIABLES
  JWT_SECRET="keystothecity"
  ```

  Then run `make run`.
