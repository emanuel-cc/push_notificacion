//Se va a encargar de gestionar los eventos push de notificaciones
import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider{
  //Se van a inicializar las notificaciones
  //Pedirle permiso al usuario de que va a recibir notificaciones
  // y pedirle el identificador único (idtoken), para almacenarlo en la base de datos
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final _mensajesStreamController = StreamController<String>.broadcast();
  Stream<String> get mensajes => _mensajesStreamController.stream;

  initNotificaciones(){
    //Vamos a pedir permiso para utilizar las notificaciones
    _firebaseMessaging.requestNotificationPermissions();

    //Se obtiene el token del dispositivo
    _firebaseMessaging.getToken().then((token){
      //Este token se va a almacenar en la base de datos
      print("======FCM Token=======");
      print(token);
      //Token del dispositivo
      // fI1mvTrYk04:APA91bEfY_6uVYUAu461GQXg-SKB-8Se7E1Y6AI5UKQ6PnQdSXN05GHPRlx1hPd74sLRE_dXx5XlWFftBHlI3peP4UXPTKvI6BQJG5PXS32lNOaRpKCYnV_nQmNomaRtknvhr6zkkNKP
    
      // cBv4W1Cjug8:APA91bGB3GazyviLrPIcHBY4s4N1pgIXZLJe1uLIcITOipeSQ4ZEhj0b99tm4LPJDx1GAwZseZhmqKO1M_rVIeIyEKvDH201s_vH9ncf2zsBMuP1NElF_l7Es3E_m9TooYFAkZGR8Yvw
    });

    //Se configura los métodos o pasos para las push notifications
    _firebaseMessaging.configure(
      //Se va a disparar cuando la aplicación está abierta
      onMessage: (info){
        print("======== on Message ========");
        print(info);
        String argumento = "no-data";
        if(Platform.isAndroid){
          argumento = info['data']['comida'] ?? 'no-data';
        }
        _mensajesStreamController.sink.add(argumento);
      },
      // Se va a disparar cuando la aplicación esté en segundo plano
      onLaunch: (info){
        print("======== on Launch ========");
        print(info);
        
      },
      // Se va a disparar cuando la aplicación esté cerrada por completo
      onResume: (info){
        print("======== on Resume ========");
        print(info);
        //Se obtiene el valor de la clave que trae la data
        final noti = info['data']['comida'];
        print(noti);
        _mensajesStreamController.sink.add(noti);
      }
    );
  }
  dispose(){
    _mensajesStreamController?.close();
  }
}