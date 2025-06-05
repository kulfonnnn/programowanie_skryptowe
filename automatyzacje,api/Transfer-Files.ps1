<#
.SYNOPSIS
Automaticl sends data from one folder to another.

.DESCRIPTION
Automaticly sends files from folder declared as $zrodlo to folder declared as $cel.
If path $cel doesnt exist it will get created.
Script won't stop working untill user stops it (ctrl+C)


.INPUTS
None.

.OUTPUTS
None.

.EXAMPLE
  PS> Path\to\file\Transfer-Files.ps1

#>




$zrodlo = "zrodlo"
$cel = "cel"


#sprawdza, czy folder docelowy istnieje
if(-not (Test-Path $cel)){
    mkdir $cel
}


Write-Host "Trwa monitoring folderu '$zrodlo'. Naciśnij Ctrl+C, aby zakończyć."


while ($true){
    $pliki = Get-ChildItem $zrodlo -Filter *.txt -File 

foreach($plik in $pliki){

    Move-Item -Path $plik.FullName -Destination $cel #bez pelnej sciezki (.FullName) nie dziala
    Write-Host "Przeniesiono $($plik.Name)"
}
}