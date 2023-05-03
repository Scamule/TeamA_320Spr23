.SILENT: setup

run: setup 
	make -j 2 app mongodb
	
app: 
	python3 app.py

mongodb:
	mongod --dbpath /Users/samhigh/Development/MongoDB/db

setup: requirements.txt
	pip3 install -r requirements.txt