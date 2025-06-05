#liczenie pola powierzchni trojkata

param(
[int]$a, 
[int]$h)

$pole = 0.5*$a*$h

Write-Host "Pole powierzchni trójkąta o boku $a i wykosci $h wynosi $pole"