$Path = 'E:\BaiduCloudDownload2\CS373'
$Filter = '*.m3u'
$Counter = 1
 
Get-ChildItem -Path $Path -Filter $Filter -Recurse |
	ForEach-Object {		
		$script:Counter++
		echo $_.Name
		
	}

echo $Counter
pause






