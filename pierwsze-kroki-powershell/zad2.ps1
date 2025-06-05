#sprawdzenie, czy liczba jest wieksza niz 10

[int]$liczba = Read-Host "Podaj liczbe: "

if ($liczba -gt 10){
Write-Host "Liczba jest większa od 10"
} else{
Write-Host "Liczba jest mniejsza od 10"
}