.SILENT: setup

run: setup 
	make -j 3 app mongodb scraper
	
app: 
	python app.py

scraper:
	python -m scrapers.spire_scraper.py

mongodb:
	mongod 

setup: requirements.txt
	pip install -r requirements.txt