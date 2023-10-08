import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  final _key = 'user-preferences';
  bool _onProcessing = false; // Indica se já está em processo de gravação

  double screenWidth = 1280, screenHeight = 720, opacity = .6;
  Color? mapColor;
  bool transparentScreen = false;

  void set(Map<String, dynamic> json) {
    screenWidth = json['screen-width'];
    screenHeight = json['screen-height'];
    mapColor = json['map-color'] != null ? Color(json['map-color']) : null;
    opacity = json['opacity'];
    transparentScreen = json['transparent-screen'];
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
    print('- load: ${toJson()}\n-----------------------------------');
  }

  Future<void> save() async {
    if(!_onProcessing) {
      _onProcessing = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, jsonEncode(toJson()));
      print('- save: ${toJson()}\n-----------------------------------');
      _onProcessing = false;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'screen-width': screenWidth,
      'screen-height': screenHeight,
      'map-color': mapColor?.value,
      'opacity': opacity,
      'transparent-screen': transparentScreen,
    };
  }
}