import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:figuras_flame/figures.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:juego_2/tap_button.dart';
import 'my_game.dart';


import 'drag_component.dart';
import 'flower_player.dart';

class MyGame extends FlameGame with KeyboardEvents {
  final sizeOfPlayer = Vector2(80, 180);
  int puntaje=0;
  double TiempoGenerarFigura=0;
  late final FlowerPlayer player;
  late final JoystickComponent joystick;

  // PARA ACTIVAR EL DEBUG
  @override
  bool get debugMode => true;

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 200, 200, 200);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  Future<void> onLoad() async {
    children.register<Flower>();

    final image = await images.load('joystick.png');
    final sheet = SpriteSheet.fromColumnsAndRows(
      image: image,
      columns: 6,
      rows: 1,
    );
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: sheet.getSpriteById(1),
        size: Vector2.all(100),
      ),
      background: SpriteComponent(
        sprite: sheet.getSpriteById(0),
        size: Vector2.all(150),
      ),
      margin: const EdgeInsets.only(left: 40, bottom: 120),
      position: Vector2(0, 0),
    );
    player = FlowerPlayer(
      position: Vector2(size.x / 2, size.y - sizeOfPlayer.y),
      paint: Paint()..color = Colors.pink,
      size: sizeOfPlayer,
      joystick: joystick,
    );
    await add(player);
    //await add(joystick);

    // await add(Flower(
    //   position: Vector2(size.x / 2, size.y - sizeOfPlayer.y),
    //   paint: Paint()..color = Colors.pink,
    //   size: sizeOfPlayer,
    // ));
    //await add(TapButton(moverDerecha)
    //  ..position = Vector2(size.x - 50, 75)
    //  ..size = Vector2(100, 100));
    //await add(TapButton(moverIzquierda)
    //  ..position = Vector2(50, 75)
    //  ..size = Vector2(100, 100));
    await add(DragComponent(moverIzquierda, moverDerecha)
      ..position = Vector2(0, size.y - 100)
      ..size = Vector2(size.x, 100));
  }

  @override
  void update(double dt) {
    if (children.isNotEmpty) {
      final Flower flower = children.query<Flower>().first;
      flower.position = Vector2(flower.position.x, size.y - sizeOfPlayer.y);
    }
    
    TiempoGenerarFigura+=dt;
    if(TiempoGenerarFigura>2){
      var RanPos=Random();
      var RanFig=Random();

      switch(RanFig.nextInt(5)){
        case 0:
          add(Mexico(position: Vector2(RanPos.nextDouble()*(size.x-140),-80), size: Vector2(140,80), paint: Paint()..color = Colors.green) );
          break;
        case 1:
          add(Pinguino(position: Vector2(RanPos.nextDouble()*(size.x-40),-80), size: Vector2(40,80), paint: Paint()..color = Colors.grey) );
          break;
        case 2:
          add(Caballito(position: Vector2(RanPos.nextDouble()*(size.x-40),-80), size: Vector2(40,80), paint: Paint()..color = Colors.brown) );
          break;
        case 3:
          add(Libreta(position: Vector2(RanPos.nextDouble()*(size.x-40),-80), size: Vector2(40,80), paint: Paint()..color = Colors.pink) );
          break;
        case 4:
          add(Elefante(position: Vector2(RanPos.nextDouble()*(size.x-120),-80), size: Vector2(120,80), paint: Paint()..color = Colors.blue) );
          break;
      }

      //add(Pinguino(position: Vector2(RanPos.nextDouble()*(size.x-40),-80), size: Vector2(40,80), paint: Paint()..color = Colors.pink) );
      TiempoGenerarFigura=0;
    }

    for(var figura in children.query<Mexico>()){
      figura.y+=1;
      if(figura.y>size.y){
        children.remove(figura);
      }
    }
    for(var figura in children.query<Pinguino>()){
      figura.y+=1;
      if(figura.y>size.y){
        children.remove(figura);
      }
    }
    for(var figura in children.query<Caballito>()){
      figura.y+=1;
      if(figura.y>size.y){
        children.remove(figura);
      }
    }
    for(var figura in children.query<Stickman>()){
      figura.y+=1;
      if(figura.y>size.y){
        children.remove(figura);
      }
    }
    for(var figura in children.query<Elefante>()){
      figura.y+=1;
      if(figura.y>size.y){
        children.remove(figura);
      }
    }
    for(var figura in children.query<Libreta>()){
      figura.y+=1;
      if(figura.y>size.y){
        children.remove(figura);
      }
    }

    super.update(dt);
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyDown = event is RawKeyDownEvent;

    if (isKeyDown) {
      if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        moverIzquierda();
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        moverDerecha();
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void moverIzquierda() {
    final Flower flower = children.query<Flower>().first;
    flower.position.x -= 5;
    if (flower.position.x + flower.width < 0) {
      flower.position.x = size.x;
    }
  }

  void moverDerecha() {
    final Flower flower = children.query<Flower>().first;
    flower.position.x += 5;
    if (flower.position.x > size.x) {
      flower.position.x = -flower.size.x;
    }
  }
  
}