<#
.SYNOPSIS
Sprawdza otwarte porty i podstawowe informacje o adresie IP.

.DESCRIPTION
Bazując na API Shodan, sprawdza otwarte porty i podstawowe informacje o adresie IP.
Wymaga podania adresu IP oraz klucza API Shodan. W przypadku błędnego adresu IP lub klucza API, skrypt wyświetli komunikat o błędzie.

.INPUTS
None

.OUTPUTS
String

.EXAMPLE
PS> . 'C:\scieżka\do\open-ports.ps1'
Podaj adres IP do sprawdzenia: 1.1.1.1
Dane adresu 1.1.1.1 :
Miasto : Brisbane
Kraj : Australia
Organizacja : APNIC and Cloudflare DNS Resolver project
Otwarte porty: 161 2082 2083 2052 2086 2087 2095 80 8880 8080 53 8443 443

.LINK
https://developer.shodan.io/api
#>

#deklaracja zmiennych
$ip = Read-Host "Podaj adres IP do sprawdzenia"
$key="<wpisz swój klucz API Shodan>" 

#wysłanie zapytania do API Shodan i obsługa wyjątków
try {
    $response = Invoke-RestMethod -Uri ("https://api.shodan.io/shodan/host/" + $ip + "?key=" + $key) -Method GET
} catch {
        Write-Host "Podano nieprawidłowy adres IP/klucz API, do podanego adresu IP wymagana jest subskrypcja lub wystąpił inny błąd."
        exit
}

#wypisanie informacji
Write-Host "Dane adresu $ip :"
Write-Host "Miasto": $($response.city)
Write-Host "Kraj": $($response.country_name)
Write-Host "Organizacja": $($response.org)
Write-Host "Otwarte porty:" $($response.ports)