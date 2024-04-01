@set PSROOT=%CD%&&powershell -NoProfile -ExecutionPolicy Unrestricted "$s=[scriptblock]::create((gc \"%~f0\"|?{$_.readcount -gt 1})-join\"`n\");&$s" %*&goto:eof

#' --------------------------------------------------------------------
#' �������畁�ʂ�Powershell�ŋL�q����
#' --------------------------------------------------------------------

. "$(Convert-Path .)\pslib\test.ps1"
. "$(Convert-Path .)\pslib\shortcut.ps1"

testout("piyo")

Write-Host (Get-WmiObject Win32_OperatingSystem).Caption
Write-Host $PSVersionTable
Write-Host "�J���Ǘ��c�[��"

if ($true) {Read-Host "Press [ENTER]"; Exit}

###################################################################
# SAMPLE Code

# OS Version
Write-Host (Get-WmiObject Win32_OperatingSystem).Caption

# Powershell Version
Write-Host $PSVersionTable

# select�Ɩ����n�b�V���e�[�u��
Get-ChildItem *.txt | Select-Object Name, LastWriteTime, @{Name = "Youbi"; Expression = {$_.LastWriteTime.DayOfWeek}}

# �X�N���v�g�u���b�N���֐����֐��̂悤�Ɏg��
$youbi = { $this.LastWriteTime.DayOfWeek }
Get-ChildItem *.txt | % { $_ | Add-Member -MemberType ScriptProperty -Name "youbi" -Value $youbi -PassThru } | Select-Object Name, LastWriteTime, youbi

# �t�@�C���`�F�b�N�T��
Get-FileHash -Algorithm MD5 "C:\foo.exe"

# �G�R�[�Ȃ��̃L�[���͑҂�
Write-Host -NoNewLine 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

# From CSV
Get-Content .\1.csv | ConvertFrom-Csv
Get-Content .\2.csv | ConvertFrom-Csv -Delimiter "`t"
Get-Content .\1.csv | Select-Object -Skip 1 | ConvertFrom-Csv -Header "ID","Namae","Nenrei"

# To CSV
Get-ChildItem *.txt | Select-Object FullName, FileSize, LastWriteTime | ConvertTo-Csv -NoTypeInformation
Get-ChildItem * | Select-Object FullName, FileSize, LastWriteTime | ConvertTo-Csv -Delimiter "`t"

# JSON�̉���
Get-Content .\test.json -Encoding UTF8 | ConvertFrom-Json


# �t�@�C������
Get-ChildItem -Recurse -Filter '*.exe'
Get-ChildItem $env:USERPROFILE\tmp -Include *.txt,*.jpg -Exclude *.bak.txt -Recurse
Get-ChildItem *.txt | Select-Object -ExpandProperty FullName | % {Write-Host $_}

# WEB Access GET
$res = Invoke-WebRequest http://www.yahoo.co.jp/
$res.Content | Out-File index.html
Write-Host $res.Links.href
# WEB Access POST
$params = @{ name = "taro"; age = 10 } 
$res = Invoke-WebRequest -Method Post -Uri http://example.com/ -Body $params


# �V���[�g�J�b�g�����
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\test.lnk")
$Shortcut.TargetPath = "C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe"
$Shortcut.Arguments = "-Nop -Executionpolicy bypass"
$Shortcut.IconLocation = "C:\Windows\System32\windowspowershell\v1.0\powershell.exe,0"
$Shortcut.WorkingDirectory = "."
$Shortcut.Save()

# �t�@�C���̑��݊m�F
ForEach($f in $args) {
    if (Test-Path $f) {
        Write-Host $f is found!
    } else {
        Write-Host $f is not found!
    }
}

# �f�B���N�g���̍쐬
New-Item �t�H���_�p�X -ItemType Directory -Force

# �f�B���N�g���̍쐬�i�K�w�܂ŋ����I�ɍ��j
New-Item ".\path\to\dir" -ItemType Directory -ErrorAction SilentlyContinue

# �f�B���N�g���̕����i�K�w�܂ŋ����I�ɍ��j
Copy-Item -Recurse dir1 dir2


# ������u��
"abc123" -replace "([a-z]+)\d{3}", '000$1'

# �����񕪊��E����
$nums = "2016-04-01" -split "-"
$strs = @("abc", "def")
$strs -join ""

# Trim
" abc ".Trim()

# GridView�Ńf�[�^��\������
$users = @()
$u = New-Object psobject -Property @{ Name = "taro"; Age = 19 }
$users += $u
$u = New-Object psobject -Property @{ Name = "jiro"; Age = 15 }
$users += $u
$users | Out-GridView

# ��r���Z�q
"A" -eq "A"                 # True
"A" -ne "Z"                 # True
"Z" -gt "A"                 # True
"A" -lt "Z"                 # True
"Z" -ge "A"                 # True
"A" -le "Z"                 # True
"A" -ceq "a"                # False(Case sensitive)
"A" -eq  "a"                # True(Case insensitive)
"A" -ieq "a"                # True(Case insensitive)
"ABC" -like "*A*"           # True
"ABC" -like "A??"           # True
"ABC" -like "A"             # False
"ABC" -notlike "*Z*"        # True
"ABC" -match "^A"           # True
"ABC" -match "^[A-Z]{1,3}$" # True
"ABC" -notmatch "^Z"        # True

# �t�H�[�}�b�g���Z�q
"{0}"     -f 5         # 5     {0}�ň�����1�Ԗڂ��Q��
"{0} {1}" -f 5,6       # 5 6   {0}{1}�ň�����1�ԖځA2�Ԗڂ��Q��
"{0} {1} {0}" -f 5,6   # 5 6 5 {0}{1}{0}�Ƃ���ƈ�����1�Ԗڂ�2�x�Q�Ƃ���
"COLOR:{0,4}"  -f "Red"   # COLOR: Red  4���ŉE��
"COLOR:{0,-4}" -f "Red"   # COLOR:Red   4���ō���
"COLOR:{0,4}"  -f "Black" # COLOR:Black ���𒴂��Ă���΂��̂܂�
"{0:00}"   -f 1      # 01    ����Ȃ�����0�p�f�B���O
"{0:00.0}" -f 1      # 01.0  �����_��0�p�f�B���O
"{0:00.0}" -f 123.45 # 123.5 ���𒴂�����A�������͂��̂܂܁A�����_�ȉ��͎l�̌ܓ������
"{0:#.#}" -f 1.2  # 1.2  �Ή����錅������΂��̂܂�
"{0:#.#}" -f 1.29 # 1.3  �����_�ȉ����Ή����錅�𒴂��Ă���Ύl�̌ܓ�
"{0:#}"   -f 123  # 123  ���������Ή����錅�𒴂��Ă���΂��̂܂�
"{0:0}" -f 10.9    # 11
"{0:0.0}" -f 10.9  # 10.9
"{0:0.0}" -f 10.99 # 11.0
"{0:N}" -f 1000  # 1,000.00  �W��
"{0:N0}" -f 1000 # 1,000     �����_�ȉ��l�̌ܓ�
"{0:N1}" -f 1000 # 1,000.0   �����_�ȉ�1���Ŏl�̌ܓ�
"NUM:{0:000}" -F 2            # NUM:002  ��3��0�p�f�B���O
"NUM:{0:000}" -F 1.99         # NUM:002  ��3��0�p�f�B���O
"NUM:{0:0.0}" -F 1.99         # NUM:2.0  �������_1�ʂ܂�0�p�f�B���O
"NUM:{0:0.00}" -F 1.99        # NUM:1.99 �������_2�ʂ܂�0�p�f�B���O
"NUM:{0:#}" -F 1.99           # NUM:2    ��1���p�f�B���O
"NUM:{0:#.#}" -F 1.99         # NUM:2
"NUM:{0:#.##}" -F 1.99        # NUM:1.99
"NUM:{0:0%}" -F 0.33          # NUM:33%

# ���[�v�L�@�Ɗȗ��\�L2��
for ($i = 1; $i -le 3; $i++) {
    echo "DEBUG: $i"
}
$nums = @(1,2,3); ForEach ($n In $nums) { Write-Host DEBUG: $n }
1..3 | % { echo "DEBUG: $_" }

# �A�z�z��
$gender = @{"taro" = "man"; "jiro" = "man"; "hanako" = "woman"}
$gender["jiro"]
$gender.Keys | % { echo $_+","+$gender[$_] }
$gender.GetEnumerator() | ? { $_.key -in ("taro","jiro") }

# ����p�X�̎擾
Write-Host [Environment]::GetFolderPath("Desktop")
# ����p�X�̐F�X
# AdminTools,ApplicationData,CDBurning,CommonAdminTools,CommonApplicationData,CommonDesktopDirectory
# CommonDocuments,CommonMusic,CommonOemLinks,CommonPictures,CommonProgramFiles,CommonProgramFilesX86
# CommonPrograms,CommonStartMenu,CommonStartup,CommonTemplates,CommonVideos,Cookies,Desktop
# DesktopDirectory,Favorites,Fonts,History,InternetCache,LocalApplicationData,LocalizedResources
# MyComputer,MyDocuments,MyMusic,MyPictures,MyVideos,NetworkShortcuts,Personal,PrinterShortcuts
# ProgramFiles,ProgramFilesX86,Programs,Recent,Resources,SendTo,StartMenu,Startup,System,SystemX86
# Templates,UserProfile,Windows

# �V���[�g�J�b�g�̍쐬
$WshShell = New-Object -ComObject WScript.Shell
$ShortCut = $WshShell.CreateShortcut("C:\Users\1st\Desktop\mycalc.lnk")
$ShortCut.TargetPath = "calc.exe"
$Shortcut.Arguments = "-Nop -Executionpolicy bypass"
$ShortCut.Save()

# ������u���Ɠǂݏ����̃G���R�[�f�B���O
$in_file = 'in.txt'
$out_file = 'out.txt'
$find = '���{��'
$replace = '�ɂق�'
(Get-Content -Encoding UTF8 $in_file).replace($find, $replace) | Set-Content -Encoding default $out_file

# UTF8-BOM CRLF
@("Hello World �͂�͂�","Foo Bar �Ӂ[�΁[") `
    | Out-File -FilePath c:\Users\1st\Desktop\utf8-bom-crlf.txt -Encoding utf8
# UTF8-BOMLess LF(Byte�ŏ������ޏꍇ�AOut-File�͎g���Ȃ��̂Œ���)
@("Hello World �͂�͂�","Foo Bar �Ӂ[�΁[") `
    | %{ $_+"`n" } `
    | ForEach-Object{ [Text.Encoding]::UTF8.GetBytes($_) } `
    | Set-Content -Path c:\Users\1st\Desktop\utf8-bomless-lf.txt -Encoding Byte

# BOM����
[System.IO.File]::WriteAllLines("utf8-bom.txt", "utf8-nobom.txt")

# https://tex2e.github.io/blog/powershell/array
# https://yanor.net/wiki/?PowerShell
