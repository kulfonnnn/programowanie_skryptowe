#logowanie do systemu

#funkcja do hashowania, niestety nie jest tak latwo jak w bahsu (tylko na plikach bez problemu)
function sha256sum {
    param([string]$text)
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($text) #tekst -> tablica bajtow
    $sha256 = [System.Security.Cryptography.SHA256]::Create() #tworzymy algorytm hashujacy
    $hash = $sha256.ComputeHash($bytes) #hashujemy
    return [BitConverter]::ToString($hash) -replace "-" #zmienia tablice bajtow na format szesnastkowy
 
}



#deklaracja prawidłowych danych
[string]$login = "admin"
$sol = "kebab123"
$haslo_hash = sha256sum ("admin" + $sol) #haslo jest przechowywane jako hash hasla i soli

#wczytywanie danych
[string]$login_wpisany = Read-Host "Podaj login: "
$haslo_wpisane = Read-Host "Podaj haslo: " -AsSecureString #użytkownik nie widzi wpisywanego hasła, tylko *
[string]$haslo_wpisane_jawnie = [System.Net.NetworkCredential]::new('', $haslo_wpisane).Password
#z uzyciem wbudowanej klasy .net uzyskujemy wartosc hasla
$haslo_wpisane_jawnie_hash =  sha256sum ("$haslo_wpisane_jawnie" + $sol)


#walidacja danych
if ($login_wpisany -eq $login -and $haslo_wpisane_jawnie_hash -eq $haslo_hash){
Write-Host "Witaj ($login)! Jesteś zalogowany do systemu."
} else{
Write-Host "Podałeś błędne dane lub wystąpił nieoczekiwany błąd"
}


