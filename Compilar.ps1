param(
    [string]$Sdk = 'C:\Program Files\UnityHub\6000.6.6f1\Editor\Data\PlaybackEngines\AndroidPlayer\SDK',
    [string]$Java = 'C:\Program Files\Android\Android Studio\jbr'
)
$ErrorActionPreference = 'Stop'
$env:JAVA_HOME = $Java
$root = $PSScriptRoot
$bt = Join-Path $Sdk 'build-tools/36.0.0'
$android = Join-Path $Sdk 'platforms/android-36/android.jar'
$app = Join-Path $root 'app/src/main'
$out = Join-Path $root 'salida'
$classes = Join-Path $out 'classes'
$dex = Join-Path $out 'dex'
New-Item -ItemType Directory -Path $classes,$dex -Force | Out-Null
function Run([string]$program,[string[]]$arguments) {
    & $program @arguments
    if($LASTEXITCODE -ne 0) { throw "$program terminó con código $LASTEXITCODE" }
}
$sources = @(Get-ChildItem (Join-Path $app 'java') -Recurse -Filter '*.java' | ForEach-Object FullName)
Run (Join-Path $Java 'bin/javac.exe') (@('-encoding','UTF-8','--release','8','-classpath',$android,'-d',$classes)+$sources)
$bytecode = @(Get-ChildItem $classes -Recurse -Filter '*.class' | ForEach-Object FullName)
Run (Join-Path $bt 'd8.bat') (@('--lib',$android,'--min-api','24','--output',$dex)+$bytecode)
$res = Join-Path $out 'resources.zip'
$unsigned = Join-Path $out 'unsigned.apk'
$unaligned = Join-Path $out 'unaligned.apk'
$aligned = Join-Path $out 'aligned.apk'
$apk = Join-Path $out 'OrbitaAR.apk'
Run (Join-Path $bt 'aapt2.exe') @('compile','--dir',(Join-Path $app 'res'),'-o',$res)
Run (Join-Path $bt 'aapt2.exe') @('link','-o',$unsigned,'-I',$android,'--manifest',(Join-Path $app 'AndroidManifest.xml'),'-A',(Join-Path $app 'assets'),$res)
Add-Type -AssemblyName System.IO.Compression.FileSystem
Copy-Item -LiteralPath $unsigned -Destination $unaligned -Force
$archive=[IO.Compression.ZipFile]::Open($unaligned,[IO.Compression.ZipArchiveMode]::Update)
try {
    [IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive,(Join-Path $dex 'classes.dex'),'classes.dex') | Out-Null
} finally { $archive.Dispose() }
Run (Join-Path $bt 'zipalign.exe') @('-f','4',$unaligned,$aligned)
$keystore = Join-Path $out 'debug.keystore'
if(!(Test-Path -LiteralPath $keystore)) {
    Run (Join-Path $Java 'bin/keytool.exe') @('-genkeypair','-keystore',$keystore,'-alias','androiddebugkey','-storepass','android','-keypass','android','-dname','CN=Android Debug','-keyalg','RSA','-keysize','2048','-validity','10000')
}
Run (Join-Path $bt 'apksigner.bat') @('sign','--ks',$keystore,'--ks-pass','pass:android','--out',$apk,$aligned)
Run (Join-Path $bt 'apksigner.bat') @('verify','--verbose',$apk)
Write-Output $apk
