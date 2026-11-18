# Órbita AR

Escanea la tarjeta astronómica para ver Saturno sobre ella. Los anillos y la luna se dibujan en perspectiva según la posición de la tarjeta. Puedes pausar el movimiento, activar el sonido de detección y consultar la tarjeta desde la aplicación.

## Ejecutar el APK

Instala `OrbitaAR.apk` en un Android con cámara trasera y Android 7 o posterior. Concede permiso de cámara. Imprime `Tarjeta_Orbita.png` a 20 cm de ancho o ábrela en otra pantalla. Encuadra la tarjeta completa con luz uniforme. Al retirar la tarjeta, el planeta desaparece. El seguimiento se realiza en el teléfono.

## Compilar el APK

En PowerShell ejecuta `./Compilar.ps1`. El script usa el JDK de Android Studio y Android SDK Platform 36 y Build Tools 36.0.0 incluidos con Unity Hub. Es posible indicar otra instalación con `-Sdk` y `-Java`. La salida es `salida/OrbitaAR.apk`.

## Desarrollo y verificación

Adaptación del proyecto proporcionado Lumen AR. Órbita incorpora una imagen propia, una interfaz en español centrada en un solo recorrido, un planeta 3D con animación y un detector de cuatro marcas sobre la imagen. El APK entregado usa Android nativo y un estimador de pose local. El diseño y los recursos de la variante Unity se incluyen en `unity-vuforia`.

El APK compiló y se verificó su firma. El detector y la pose pasaron doce ensayos sintéticos a varias escalas y rotaciones. Se rechazaron la tarjeta anterior, una tarjeta incompleta y un cuadro vacío. Queda pendiente validar la cámara y la experiencia completa en un teléfono físico.

La variante Unity requiere la extensión oficial y una licencia personal de Vuforia. [Configuración para Unity y Android](docs/UNITY_VUFORIA_ANDROID.md).
