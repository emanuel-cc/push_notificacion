import 'package:flutter/material.dart';
import 'package:push_notification/src/pages/home_page.dart';
import 'package:push_notification/src/pages/mensaje_page.dart';
import 'package:push_notification/src/providers/push_notifications_provider.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //Sirve para manejar el estado de navegación
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  @override
  void initState() {
    super.initState();
    //Inicializamos la clase PushNotificationProvider
    final pushProvider = new PushNotificationProvider();
    //Llamamos al método definido en la clase que se va a encargar de obtener el token
    pushProvider.initNotificaciones();

    //Escuchar los mensajes
    pushProvider.mensajes.listen((data){
      print('Argumento del push');
      print(data);
      navigatorKey.currentState.pushNamed('mensaje',arguments: data);
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Push Notification',
      initialRoute: 'home',
      routes: {
        'home'  : (BuildContext context)=>HomePage(),
        'mensaje': (BuildContext context)=>MensajePage()
      },
    );
  }
}