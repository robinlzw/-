$i = 0
 
Get-ChildItem -Path c:\pictures -Filter *.jpg |
ForEach-Object {
$extension = $_.Extension
$newName = 'pic_{0:d6}{1}' -f $i, $extension
$i++
Rename-Item -Path $_.FullName -NewName $newName
}