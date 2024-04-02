Function UnquoteString($str) {
    $strlr = $str.Substring($str.Length-1,1)+$str.Substring(0,1)
    if (($strlr -eq '""') -or ($strlr -eq "''")) {
        $str = $str.Substring(1, $str.Length-2)
    }
    Return $str
}

Function SelectFileNewest($path, $glob) {
}