.SILENT: setup

run: setup 
	make -j 2 app mongodb
	
app: 
	python app.py

mongodb:
	mongod 

setup: requirements.txt
	pip install -r requirements.txt