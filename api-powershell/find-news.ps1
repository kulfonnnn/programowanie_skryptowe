<#
.SYNOPSIS
Pobiera artykuły z newsapi.org na podstawie podanego słowa kluczowego.

.DESCRIPTION
Pobiera artykuły z newsapi.org na podstawie podanego słowa kluczowego.
Wymaga podania słowa kluczowego oraz liczby artykułów do pobrania.

.INPUTS
None.

.OUTPUTS
String.
Zwraca tytuł i URL artykułów.

.EXAMPLE
PS> Path\to\file\find-news.ps1
Podaj słowo kluczowe do wyszukiwania wiadomości:: trump
Podaj ile maksymalnie artykółów chcesz pobrać:: 2

#>


$api="<wpisz swój klucz API newsapi.org>"
$KeyWord = Read-Host "Podaj słowo kluczowe do wyszukiwania wiadomości:"
$count = Read-Host "Podaj ile maksymalnie artykułów chcesz pobrać:"

#pobranie danych ze strony newsapi.org
$response = Invoke-WebRequest -Uri ("https://newsapi.org/v2/everything?q=" + $KeyWord + "&sortBy=publishedAt&apiKey=" + $api) -Method GET

#tworzymy obiekt powershell z jsona
$responseContent = $response.Content | ConvertFrom-Json

Write-Host "Znalezione artykuły:"
$responseContent.articles | Select-Object -First $count title, url