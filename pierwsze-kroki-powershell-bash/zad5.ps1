#wyswietlanie podstawowcyh informacji o systemie; Aktualna data, Wersja systemu, Użytkownik, AdresIP."


#data to chyba zarezerowane slowo, nie moge nazwac funkcji "data"
function data123 {
return "Aktualna data na $(hostname) to $(Get-Date)"
}

function os_version{
$os = Get-ComputerInfo | Select-Object OsName, OsVersion
return "Nazwa i wersja systemu na $(hostname) to $os"
}

function username{
$name = $env:USERNAME
return "Nazwa aktualnego użytkownika $(hostname) to $name"
}

function ipaddress{
$ip=Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -eq "Ethernet"} | Select-Object IPAddress
return "Adres IPv4 na $(hostname) to $ip"
}

data123
os_version
username
ipaddress