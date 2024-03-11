# flutter_test_strat_plus

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Para correr la app:

Flutter 3.19.3
Dart 3.3.1
DevTools 2.31.1

PASOS A SEGUIR_
1-. git clone https://github.com/RicDev116/flutter_test_strat_plus.git en escritorio o el archivo de tu elección.

2-. Configuración del Proyecto
Para que esta aplicación funcione correctamente, necesitarás configurar algunas claves API que no se incluyen en el repositorio por razones de seguridad. Seguimos las mejores prácticas manteniendo estas claves fuera del control de versiones. Aquí te explicamos cómo configurar tu entorno local.

Pasos para configurar las claves API:
Obtener las Claves API de Marvel: Para comenzar, necesitarás obtener una clave pública y una clave privada de la API de Marvel. Puedes hacerlo registrándote como desarrollador en el portal de desarrolladores de Marvel.

Configurar las Claves API en tu Entorno Local:

Crea un archivo .env en la raíz del proyecto. Este archivo contendrá tus claves API locales y no será añadido al control de versiones.
Añade tus claves al archivo .env de la siguiente manera:

PUBLIC_KEY=tu_clave_publica_aqui
PRIVATE_KEY=tu_clave_privada_aqui

Asegúrate de que el archivo .env esté listado en tu .gitignore para evitar que se suba por accidente al repositorio.

añade en el pubspec.yaml, en la sección de assets el siguiente código 
assets:
  - .env

3-. Una vez configuradas tus claves API, puedes proceder a ejecutar la aplicación con Flutter:

flutter pub get
flutter run

Si encuentras algún problema al seguir estos pasos, asegúrate de verificar que las claves API sean correctas y que el archivo .env esté ubicado en la raíz del proyecto y configurado adecuadamente.
