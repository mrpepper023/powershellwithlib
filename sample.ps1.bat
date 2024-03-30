@set PSROOT=%CD%&&powershell -NoProfile -ExecutionPolicy Unrestricted "$s=[scriptblock]::create((gc \"%~f0\"|?{$_.readcount -gt 1})-join\"`n\");&$s" %*&goto:eof

#' --------------------------------------------------------------------
#' ここから普通にPowershellで記述する
#' --------------------------------------------------------------------

. "$(Convert-Path .)\pslib\test.ps1"

testout("piyo")

if ($true) {Read-Host "Press [ENTER]"; Exit}
