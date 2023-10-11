import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  final _key = 'user-preferences';
  bool _onProcessing = false; // Indica se já está em processo de gravação

  double screenWidth = 1280, screenHeight = 720, opacity = .6;
  Color mapColor = const Color(0xFFD54F4F);
  bool transparentScreen = false;
  bool expandirMenu = true;
  bool showMap = true;

  void set(Map<String, dynamic> json) {
    screenWidth = json['screen-width'];
    screenHeight = json['screen-height'];
    mapColor = Color(json['map-color']);
    opacity = json['opacity'];
    transparentScreen = json['transparent-screen'];
    expandirMenu = json['expandir-menu'] ;
    showMap = json['show-map'];
  }

  void setSize(MediaQueryData mediaQuery) {
    screenWidth = mediaQuery.size.width;
    screenHeight = mediaQuery.size.height;
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey(_key)) {
      set(jsonDecode(prefs.getString(_key)!));
    } else {
      await save();
    }
  }

  Future<void> save() async {
    if(!_onProcessing) {
      _onProcessing = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, jsonEncode(toJson()));
      _onProcessing = false;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'screen-width': screenWidth,
      'screen-height': screenHeight,
      'map-color': mapColor.value,
      'opacity': opacity,
      'transparent-screen': transparentScreen,
      'expandir-menu': expandirMenu,
      'show-map': showMap,
    };
  }
}