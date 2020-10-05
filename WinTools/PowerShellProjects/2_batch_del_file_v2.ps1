$Filter = '*.m3u'
$Counter = 1
$filePath='E:\BaiduCloudDownload2\CS373'   
$allFiles=get-childitem -path $filePath -Filter $Filter -Recurse 
 
foreach ($files in $allFiles)    
{      
    echo $files.FullName
	remove-item $files.fullname -Recurse -force    
}