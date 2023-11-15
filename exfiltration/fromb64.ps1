$sourcePath = "C:\Windows\temp\storefront\aes\b64\eicar.7z.b64"
$targetPath = "C:\Windows\temp\storefront\aes\b64\eicar2.7z"
$size = Get-Item -Path $sourcePath | Select -ExpandProperty Length
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

$converterStream = [System.Security.Cryptography.CryptoStream]::new(
    [System.IO.File]::OpenRead($sourcePath),
    [System.Security.Cryptography.FromBase64Transform]::new(), 
    [System.Security.Cryptography.CryptoStreamMode]::Read,
    $false) # keepOpen = $false => When we close $converterStream, it will close source file stream also
$targetFileStream = [System.IO.File]::Create($targetPath)
$converterStream.CopyTo($targetFileStream)
$converterStream.Close() # And it also closes source file stream because of keepOpen = $false parameter.
$targetFileStream.Close() # Flush() is called internally.

$stopwatch.Stop()
Write-Host "Elapsed: $($stopwatch.Elapsed.TotalSeconds) seconds for $([Math]::Round($size / 1MB))-Mbyte file"