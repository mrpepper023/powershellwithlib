@set PSROOT=%CD%&&powershell -NoProfile -ExecutionPolicy Unrestricted "$s=[scriptblock]::create((gc \"%~f0\"|?{$_.readcount -gt 1})-join\"`n\");&$s" %*&goto:eof

#' --------------------------------------------------------------------
#' ここから普通にPowershellで記述する
#' --------------------------------------------------------------------

. "$(Convert-Path .)\pslib\test.ps1"
. "$(Convert-Path .)\pslib\shortcut.ps1"

testout("piyo")

Write-Host (Get-WmiObject Win32_OperatingSystem).Caption
Write-Host $PSVersionTable
Write-Host "開発管理ツール"

if ($true) {Read-Host "Press [ENTER]"; Exit}

###################################################################
# SAMPLE Code

# OS Version
Write-Host (Get-WmiObject Win32_OperatingSystem).Caption

# Powershell Version
Write-Host $PSVersionTable

# selectと無名ハッシュテーブル
Get-ChildItem *.txt | Select-Object Name, LastWriteTime, @{Name = "Youbi"; Expression = {$_.LastWriteTime.DayOfWeek}}

# スクリプトブロックを関数内関数のように使う
$youbi = { $this.LastWriteTime.DayOfWeek }
Get-ChildItem *.txt | % { $_ | Add-Member -MemberType ScriptProperty -Name "youbi" -Value $youbi -PassThru } | Select-Object Name, LastWriteTime, youbi

# ファイルチェックサム
Get-FileHash -Algorithm MD5 "C:\foo.exe"

# エコーなしのキー入力待ち
Write-Host -NoNewLine 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

# From CSV
Get-Content .\1.csv | ConvertFrom-Csv
Get-Content .\2.csv | ConvertFrom-Csv -Delimiter "`t"
Get-Content .\1.csv | Select-Object -Skip 1 | ConvertFrom-Csv -Header "ID","Namae","Nenrei"

# To CSV
Get-ChildItem *.txt | Select-Object FullName, FileSize, LastWriteTime | ConvertTo-Csv -NoTypeInformation
Get-ChildItem * | Select-Object FullName, FileSize, LastWriteTime | ConvertTo-Csv -Delimiter "`t"

# JSONの解釈
Get-Content .\test.json -Encoding UTF8 | ConvertFrom-Json


# ファイル検索
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


# ショートカットを作る
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\test.lnk")
$Shortcut.TargetPath = "C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe"
$Shortcut.Arguments = "-Nop -Executionpolicy bypass"
$Shortcut.IconLocation = "C:\Windows\System32\windowspowershell\v1.0\powershell.exe,0"
$Shortcut.WorkingDirectory = "."
$Shortcut.Save()

# ファイルの存在確認
ForEach($f in $args) {
    if (Test-Path $f) {
        Write-Host $f is found!
    } else {
        Write-Host $f is not found!
    }
}

# ディレクトリの作成
New-Item フォルダパス -ItemType Directory -Force

# ディレクトリの作成（階層まで強制的に作る）
New-Item ".\path\to\dir" -ItemType Directory -ErrorAction SilentlyContinue

# ディレクトリの複製（階層まで強制的に作る）
Copy-Item -Recurse dir1 dir2


# 文字列置換
"abc123" -replace "([a-z]+)\d{3}", '000$1'

# 文字列分割・結合
$nums = "2016-04-01" -split "-"
$strs = @("abc", "def")
$strs -join ""

# Trim
" abc ".Trim()

# GridViewでデータを表示する
$users = @()
$u = New-Object psobject -Property @{ Name = "taro"; Age = 19 }
$users += $u
$u = New-Object psobject -Property @{ Name = "jiro"; Age = 15 }
$users += $u
$users | Out-GridView

# 比較演算子
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

# フォーマット演算子
"{0}"     -f 5         # 5     {0}で引数の1番目を参照
"{0} {1}" -f 5,6       # 5 6   {0}{1}で引数の1番目、2番目を参照
"{0} {1} {0}" -f 5,6   # 5 6 5 {0}{1}{0}とすると引数の1番目を2度参照する
"COLOR:{0,4}"  -f "Red"   # COLOR: Red  4桁で右寄せ
"COLOR:{0,-4}" -f "Red"   # COLOR:Red   4桁で左寄せ
"COLOR:{0,4}"  -f "Black" # COLOR:Black 桁を超えていればそのまま
"{0:00}"   -f 1      # 01    足りない桁を0パディング
"{0:00.0}" -f 1      # 01.0  小数点も0パディング
"{0:00.0}" -f 123.45 # 123.5 桁を超えたら、整数部はそのまま、小数点以下は四捨五入される
"{0:#.#}" -f 1.2  # 1.2  対応する桁があればそのまま
"{0:#.#}" -f 1.29 # 1.3  小数点以下が対応する桁を超えていれば四捨五入
"{0:#}"   -f 123  # 123  整数部が対応する桁を超えていればそのまま
"{0:0}" -f 10.9    # 11
"{0:0.0}" -f 10.9  # 10.9
"{0:0.0}" -f 10.99 # 11.0
"{0:N}" -f 1000  # 1,000.00  標準
"{0:N0}" -f 1000 # 1,000     小数点以下四捨五入
"{0:N1}" -f 1000 # 1,000.0   小数点以下1桁で四捨五入
"NUM:{0:000}" -F 2            # NUM:002  ※3桁0パディング
"NUM:{0:000}" -F 1.99         # NUM:002  ※3桁0パディング
"NUM:{0:0.0}" -F 1.99         # NUM:2.0  ※小数点1位まで0パディング
"NUM:{0:0.00}" -F 1.99        # NUM:1.99 ※小数点2位まで0パディング
"NUM:{0:#}" -F 1.99           # NUM:2    ※1桁パディング
"NUM:{0:#.#}" -F 1.99         # NUM:2
"NUM:{0:#.##}" -F 1.99        # NUM:1.99
"NUM:{0:0%}" -F 0.33          # NUM:33%

# ループ記法と簡略表記2種
for ($i = 1; $i -le 3; $i++) {
    echo "DEBUG: $i"
}
$nums = @(1,2,3); ForEach ($n In $nums) { Write-Host DEBUG: $n }
1..3 | % { echo "DEBUG: $_" }

# 連想配列
$gender = @{"taro" = "man"; "jiro" = "man"; "hanako" = "woman"}
$gender["jiro"]
$gender.Keys | % { echo $_+","+$gender[$_] }
$gender.GetEnumerator() | ? { $_.key -in ("taro","jiro") }

# 特殊パスの取得
Write-Host [Environment]::GetFolderPath("Desktop")
# 特殊パスの色々
# AdminTools,ApplicationData,CDBurning,CommonAdminTools,CommonApplicationData,CommonDesktopDirectory
# CommonDocuments,CommonMusic,CommonOemLinks,CommonPictures,CommonProgramFiles,CommonProgramFilesX86
# CommonPrograms,CommonStartMenu,CommonStartup,CommonTemplates,CommonVideos,Cookies,Desktop
# DesktopDirectory,Favorites,Fonts,History,InternetCache,LocalApplicationData,LocalizedResources
# MyComputer,MyDocuments,MyMusic,MyPictures,MyVideos,NetworkShortcuts,Personal,PrinterShortcuts
# ProgramFiles,ProgramFilesX86,Programs,Recent,Resources,SendTo,StartMenu,Startup,System,SystemX86
# Templates,UserProfile,Windows

# ショートカットの作成
$WshShell = New-Object -ComObject WScript.Shell
$ShortCut = $WshShell.CreateShortcut("C:\Users\1st\Desktop\mycalc.lnk")
$ShortCut.TargetPath = "calc.exe"
$Shortcut.Arguments = "-Nop -Executionpolicy bypass"
$ShortCut.Save()

# 文字列置換と読み書きのエンコーディング
$in_file = 'in.txt'
$out_file = 'out.txt'
$find = '日本語'
$replace = 'にほんご'
(Get-Content -Encoding UTF8 $in_file).replace($find, $replace) | Set-Content -Encoding default $out_file

# UTF8-BOM CRLF
@("Hello World はろはろ","Foo Bar ふーばー") `
    | Out-File -FilePath c:\Users\1st\Desktop\utf8-bom-crlf.txt -Encoding utf8
# UTF8-BOMLess LF(Byteで書き込む場合、Out-Fileは使えないので注意)
@("Hello World はろはろ","Foo Bar ふーばー") `
    | %{ $_+"`n" } `
    | ForEach-Object{ [Text.Encoding]::UTF8.GetBytes($_) } `
    | Set-Content -Path c:\Users\1st\Desktop\utf8-bomless-lf.txt -Encoding Byte

# BOM除去
[System.IO.File]::WriteAllLines("utf8-bom.txt", "utf8-nobom.txt")

# https://tex2e.github.io/blog/powershell/array
# https://yanor.net/wiki/?PowerShell
