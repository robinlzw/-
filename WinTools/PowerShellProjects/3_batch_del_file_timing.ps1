#delete logs in specify website, just save logs in eight days~   
$TimeOutDays=8
$filePath="C:\public\"    
$allFiles=get-childitem -path $filePath
 
foreach ($files in $allFiles)    
{      
   $daypan=((get-date)-$files.lastwritetime).days      
   if ($daypan -gt $TimeOutDays)      
   { 
     #$files.FullName
     remove-item $files.fullname -Recurse -force      
    }    
}