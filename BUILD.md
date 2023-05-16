# Building USchedule

## Aquire files

Clone project from GitHub:

```
git clone https://github.com/SammyPie/TeamA_320Spr23
cd TeamA_320Spr23
```
  
Note: You will probably want two terminal instances open from this point on, one for running frontend, and one for running backend.

- **Build Frontend**

  Download Flutter dependecies from https://docs.flutter.dev/get-started/install.

  Build dependencies by entering the directory `frontend` and running `flutter packages pub run build_runner build`.
  
  Then, from `frontend`, run the frontend by running the command `flutter run -d chrome`.

- **Build Backend**

  Add necessary credentials into an `.env` file.
  If this file does not exist, use `touch .env` to create it.

  ```
  # ENV VARIABLES
  JWT_SECRET="keystothecity"
  SENDER_EMAIL=""
  SENDER_PASSWORD=""
  ```

  *mac*
    Download the MongoDB Community Server Download tgz from https://www.mongodb.com/try/download/community for your platform. The platform `macOS` is for Intel based macs, and `macOS ARM 64` is for M series macs. To check which one you are, go to the menu bar and go to Apple Icon > About This Mac. The `chip` attribute will tell you whether you have an Intel (x86) or M chip.
    After it is done downloading, unzip the file and move the new folder to a nice location.
    Inside this new folder, you will find a folder called `bin`. You need to add this folder location to your path. To do this, go to this link: https://osxdaily.com/2014/08/14/add-new-path-to-path-command-line/#:~:text=Setting%20PATH%20in%20Shell%20Profile, and it should bring you to the Setting PATH in Shell Profile section. Follow the instructions here. The path for the `bin` folder can be optained by right clicking in Finder and Option clicking the copy button, or by going to the folder in a terminal instance and typing `pwd`.
      You will want to refresh your terminal instance by either using the `source FILE_NAME` command, `FILE_NAME` referring to the file you put the `export PATH` in when adding the bin file to your path.
    You can test if you installed MongoDB correctly by running `mongod --version`.
      If you get a `malicious software` error, that is good. You have everything set up properly and go to the System Settings > Security and Privacy and go down to the security section. There should be a prompt telling you to allow the `mongod` command. Click it. Run `mongod --version` again and click Open when it shows up.
    MongoDB should now be installed.
    To get MongoDB to work with the app, you need to make a database folder. This folder can go anywhere and be called anything. You can put it in TeamA_320Spr23 and add it to .gitignore to make sure the database doesn't get pushed to the GitHub.
    Update the Makefile to run `mongod --dbpath FOLDER_PATH` (instead of jsut `mongod`) where FOLDER_PATH is the database folder path.
    
    Download Python from https://www.python.org.
      You may need to add Python to your PATH. Follow the instructions used for MongoDB.
    You can test if you installed Python correctly by running `python --version`. Your machine may not accept `python` as a command, so try `python3` instead. If `python3` works, change the Makefile so every `python` is `python3`.
    You will need to install pip, you can do so by following this link: https://www.geeksforgeeks.org/how-to-install-pip-in-macos/.
    To test if pip is installed, type `pip --version` in the terminal, or, similarly to python, try `pip3 --version` instead, and then update the Makefile similar to python.

    Change the terminal instance to be inside `backend` and run `make run`.

  *windows*
    Download Python from https://www.python.org. You can test if you installed Python correctly by running `python --version`.
    Dowload MongoDB Community Server Download from https://www.mongodb.com/try/download/community.
    Windows stuff...
    Then run `make run`.
