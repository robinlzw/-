#Powershell批量修改文件名
#将重命名你指定的文件夹内所有扩展名为.ps1的Powershell脚本。
#新的名字将成为powershellscriptX.ps1，这里的“X”是一个递增数字。
#注意脚本默认还没有真正开始重命名。请特别小心要去掉它的-Whatif参数才真正的重命名文件。
#假设你录入的变量或输入了一个错误的目录路径，这时你的脚本会错误将数以千计的文件重命名，
#那可是你不想看到的。

$Path = 'c:\temp'
$Filter = '*.ps1'
$Prefix = 'powershellscript'
$Counter = 1
 
Get-ChildItem -Path $Path -Filter $Filter -Recurse |
  Rename-Item -NewName {
    $extension = [System.IO.Path]::GetExtension($_.Name)
    '{0}{1}.{2}' -f $Prefix, $script:Counter, $extension
    $script:Counter++
   } -WhatIf
   