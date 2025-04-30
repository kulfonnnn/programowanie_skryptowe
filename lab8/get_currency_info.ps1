<#
.SYNOPSIS
Pobiera kursy walut z ostatnich 5 dni roboczych z API NBP.

.DESCRIPTION
Pobiera kursy walut z ostatnich 5 dni roboczych z API NBP. Skrypt wymaga podania waluty, której kursy mają być pobrane. Obsługiwane są tylko najpopularniejsze waluty zgodnie z ISO 4217.
Skrypt nie obsługuje waluty PLN, ponieważ jest to waluta bazowa.
Skrypt wypisuje kursy walut względem złotówki z ostatnich 5 dni roboczych, z wyłączeniem dni wolnych od pracy i różnice między kursami.

.PARAMETER $currency
Waluta, której kursy mają być pobrane. Wymagana wartość. Zgodnie z ISO 4217, obłsugiwane tylko najpopularniejsze waluty.

.INPUTS
None

.OUTPUTS
String.

.EXAMPLE
PS> Path\to\file\get_currency_info.ps1 USD
#>

param(
    [Parameter(Mandatory)]    
    [string]$currency
    )

#walidacja argumentu głównego
if ($currency -eq $null -or $currency -eq "PLN") {
    Write-Host "Nie podałeś waluty lub podałeś PLN. Skrypt kończy działanie."
    exit
}

#uzyskanie daty teraz i 5 dni temu
$date = Get-Date -Format "yyyy-MM-dd"
$old_date = (Get-Date).AddDays(-5).ToString("yyyy-MM-dd")

#pobranie danych z API NBP
$dane = Invoke-RestMethod -Uri ("https://api.nbp.pl/api/exchangerates/rates/A/" + $currency + "/" + $old_date + "/" + $date + "/") -Method GET

Write-Host "Informacje o kursach $currency względem złotówki z ostatnich 5 dni, z wyłączeniem dni wolnych od pracy:"
$lista = $dane.rates.mid
Write-Host "Kurs = " $lista[0]
for ($i=1; $i -lt $lista.Length; $i++) {
    $zmiana = $lista[$i] - $lista[$i-1]
    Write-Host "Kurs = " $lista[$i] "Zmiana = " $zmiana
}