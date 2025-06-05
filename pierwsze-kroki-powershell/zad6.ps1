#informacje o PC, ale o rzeczach z pliku input_file.csv z zawartoscia true

#pobranie klas z danymi o urządzeniu
$info1 = Get-CimInstance -ClassName Win32_ComputerSystem
$info2 = Get-CimInstance -ClassName Win32_BIOS
$Computername = $info1.Name
$Manufacturer = $info1.Manufacturer
$Model = $info1.Model
$SeriaNumber = $info2.SerialNumber
$CpuName = Get-WmiObject -Class Win32_Processor | Select-Object Name
[string]$RAM = ((Get-ComputerInfo).CsTotalPhysicalMemory /1GB).ToString() + " GB"

#wybranie interesujących nas danych
$lista_info= $Computername, $Manufacturer, $Model, $SeriaNumber, $CpuName, $RAM



#wczytanie danych (bez naglowkow)
$dane =  (Get-Content input_file.csv) -replace '"', '' | Select-Object -Skip 1



function raport{ 
$i=0
foreach($linia in $dane){
$lista = $linia -split ";"
[string]$boolean = $lista[1]
if($boolean -eq "True"){
    $lista[0] + ":" + $lista_info[$i] >> $nazwa_plik
}
$i++
}
}

#tworzenie raportu do pliku
$data= Get-Date -format "yyyymmdd-HHmmss"
[string]$nazwa_plik = "ComputerReport_" + $data + ".txt"

raport
Write-Host "Raport został zapisany w pliku:"
Write-Host (Get-Item $nazwa_plik).FullName