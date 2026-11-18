Add-Type -AssemblyName System.Drawing
$card = [Drawing.Bitmap]::new(1200,800,[Drawing.Imaging.PixelFormat]::Format24bppRgb)
$g = [Drawing.Graphics]::FromImage($card)
$g.SmoothingMode = [Drawing.Drawing2D.SmoothingMode]::AntiAlias
function Ink([string]$hex) { [Drawing.SolidBrush]::new([Drawing.ColorTranslator]::FromHtml($hex)) }
$cream=Ink '#F8E0B3'
$g.Clear([Drawing.ColorTranslator]::FromHtml('#211737'))
$rng=[Random]::new(127)
for($i=0;$i -lt 150;$i++) {
    $x=$rng.Next(15,1180)
    $y=$rng.Next(15,780)
    $d=$rng.Next(2,7)
    $g.FillEllipse($cream,$x,$y,$d,$d)
}
$line=[Drawing.Pen]::new($cream,3)
$g.DrawRectangle($line,24,24,1152,752)
$g.FillEllipse((Ink '#C7A7BB'),455,270,290,290)
$g.TranslateTransform(600,416)
$g.RotateTransform(-18)
$ring=[Drawing.Pen]::new($cream,12)
$g.DrawEllipse($ring,-248,-54,496,108)
$g.ResetTransform()
$title=[Drawing.Font]::new('Georgia',64,[Drawing.FontStyle]::Bold)
$body=[Drawing.Font]::new('Segoe UI',22)
$g.DrawString('ORBITA AR',$title,$cream,360,113)
$g.DrawString('SATURNO  /  TARJETA DE OBSERVACION',$body,$cream,365,605)
$spots=@(@(150,130,'#F62939'),@(1050,130,'#154BFF'),@(1050,670,'#00DD29'),@(150,670,'#FFDF00'))
foreach($s in $spots) {
    $g.FillEllipse((Ink '#100C18'),($s[0]-65),($s[1]-65),130,130)
    $g.FillEllipse((Ink $s[2]),($s[0]-49),($s[1]-49),98,98)
}
$g.Dispose()
$card.Save((Join-Path $PSScriptRoot 'app/src/main/assets/tarjeta_orbita.png'),[Drawing.Imaging.ImageFormat]::Png)
$card.Dispose()
