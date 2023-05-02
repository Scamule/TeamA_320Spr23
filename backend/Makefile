.SILENT: setup

run: setup 
	make -j 2 app mongodb
	
app: 
	python app.py

mongodb:
	mongod --dbpath /usr/local/var/mongodb 

setup: requirements.txt
	pip install -r requirements.txt