<#
.SYNOPSIS
Automaticly sends .txt files from one folder to another.

.DESCRIPTION
Skrypt tworzy obiekt FileSystemWatcher, który obserwuje wskazany folder źródłowy.
Gdy pojawi się nowy plik, po krótkim opóźnieniu (2 sekundy), zostaje on automatycznie
przeniesiony do określonego folderu docelowego.
Działa w pętli nieskończonej, dopóki użytkownik nie przerwie działania skryptu.

.PARAMETER None

.INPUTS
None. 

.OUTPUTS
System.String – Informacja tekstowa o przeniesionych plikach.

.EXAMPLE
PS> Path\to\file\Transfer-FilesWatcher.ps1

#>





# Tworzymy obiekt FileSystemWatcher
$watcher = New-Object System.IO.FileSystemWatcher

# Określamy folder, który chcemy monitorować
$watcher.Path = "C:\Users\mikol\desktop\pliki z zajec\semestr 2\programowanie skryptowe\lab7\zrodlo"
$watcher.Filter = "*.txt"


# Włączamy monitorowanie
$watcher.EnableRaisingEvents = $true


#akcja, gdy plik zostanie znaleziony
Register-ObjectEvent $watcher Created -Action{
#  Created-> akcja, inne to np. Changed/Deleted -Action { ... } -> pole akcji
    
    Start-Sleep -Seconds 2
    #delay, np. na ustalenie nazwy w GUI, przetworzenie przez komputer
    
    $plik = $Event.SourceEventArgs.FullPath 
     #uzyskanie pelnej sciezki argumentow (plikow, ktore watcher zobaczyl)

    $cel = "C:\Users\mikol\desktop\pliki z zajec\semestr 2\programowanie skryptowe\lab7\cel"

    Move-Item -Path $plik -Destination $cel
    Write-Host "Przeniesiono plik: $plik"

}


# Skrypt działa, dopóki nie zostanie przerwany
Write-Host "Monitorowanie folderu... Naciśnij Ctrl+C, aby zakończyć."
while ($true) {
    Start-Sleep -Seconds 1 #watcher aktualizuje się co sekundę
}