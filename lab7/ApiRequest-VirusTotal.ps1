<#
.SYNOPSIS
Determinates whether a certain file is safe.

.DESCRIPTION
1. Sends request with file hash to virusustotal and checks if NotFoundError was received.
2. If no, it determinates safety by received data.
3. If NotFoundError was received, it sends file to VirusTotal and checks again.
Attention! Sending file to VirusTotal works only on powershell 7+!

.PARAMETER Plik
Specifies path to the file we want to check

.INPUTS
  None. You can't pipe objects to this script.

.OUTPUTS
  Information whether the file is safe to use.

.EXAMPLE
  PS> Path\to\file\ApiRequest-VirusTotal.ps1 -plik C:\Reports\2009\January.csv

#>

param(
    [Parameter(Mandatory)]
    [string]$Plik
)


#definiowanie klucza api 
$apiKey = "api_key"

#wysylanie hashu do bazy wirustotal
function get{
    param($hash, $apiKey)
    Invoke-RestMethod -Uri "https://www.virustotal.com/api/v3/files/$hash" `
        -Headers @{ "x-apikey" = $apiKey } -Method Get
# ' rozdziela komende na 2 linie
#method okresla jaki to rodzaj zapytania (inne to np post (wyslanie czegos) lub delete (usunieie)
}


#dodawanie pliku do bazy wirustotal
function post{
    param($plik, $apiKey)
    $POST = Invoke-WebRequest -Uri "https://www.virustotal.com/api/v3/files" `
        -Method Post `
        -Headers @{ "x-apikey" = $apiKey } `
        -Form @{ file = Get-Item $plik }
}

function ocena{
    param([int]$mal)
    if($mal -eq 0){
        Write-Host "Plik jest bezpieczny :)"
    }elseif($mal -gt 0){
        Write-Host "O nie! Plik jest niebezpieczny! NIE OTWIERAAAAAJ GO"
    }else{
        Write-Host "Nie udało mi się ocenić bezpieczeństwa tego pliku :("
    }
}




#obliczenie hashu i zczytanie właściwości (kolumny) hash
$hash = (Get-FileHash $plik).Hash



$znaleziony = $True
#obsluga wyjatkow pomaga nam okreslic, czy plik jest w bazie wirustotal
try {
$odp = get $hash $apiKey
}
catch {
    if ($_ -match "NotFoundError") {
        Write-Host "Plik nieznaleziony w bazie."
        $znaleziony=$False
    } else {
        Write-Host "wystąpił nieznany błąd."
    }
}

#gdy plik jest znaleziony, to oceniamy jego bezpieczenstwo
if ($znaleziony){
   
    $malicious =  $odp.data.attributes.last_analysis_stats.malicious
    ocena $malicious
    

} else{ #jezeli nie ma pliku w bazie, to go wysylamy
    
    Write-Host "Pliku nie ma w bazie, zaraz go wyślę i dostaniesz ocenę bezpieczeńśtwa."
    post $plik $apiKey

    
    Start-Sleep -Seconds 10 # chwilka na przetworzenie pliku
    
    #wysylamy jeszcze raz zapytanie
    $odp2 = get $hash $apiKey
    
    $malicious = $odp2.data.attributes.last_analysis_stats.malicious
    ocena $malicious

}
