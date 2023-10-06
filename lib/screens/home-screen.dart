import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:sotn_map/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color _pickerColor = const Color(0xFFD54F4F);
  Color? _mapColor;

  Color? _backgroundColor;
  double _opacity = .6;

  bool get _isTransparent => _backgroundColor == null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/sotn_map.png',
              width: double.maxFinite,
              height: double.maxFinite,
              fit: BoxFit.fill,
              opacity: AlwaysStoppedAnimation(_opacity),
              color: _mapColor,
            ),
          ),

          Positioned(
            top: 15, right: 15,
            child: Container(
              decoration: BoxDecoration(
                color: _isTransparent ? null : Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: IconButton(
                onPressed: (){
                  setState(() {
                    _backgroundColor = _isTransparent ? Colors.transparent : null;
                  });
                },
                icon: Icon(
                  _isTransparent ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  color: AppTheme.colorScheme.primary,
                ),
              ),
            ),
          ),

          Positioned(
            right: 15, bottom: 15,
            child: Container(
              padding: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: _isTransparent ? null : Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Slider(
                    min: 0,
                    max: 1,
                    value: _opacity,
                    onChanged: (value) {
                      setState(() => _opacity = value);
                    },
                  ),

                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              enableAlpha: false,
                              pickerColor: _pickerColor,
                              onColorChanged: (value) => _pickerColor = value,
                            ),
                          ),
                          actions: [
                            ElevatedButton.icon(
                              icon: const Icon(Icons.cancel_rounded),
                              label: const Text('Cancelar'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.cleaning_services_rounded),
                              label: const Text('Limpar'),
                              onPressed: () {
                                setState(() => _mapColor = null);
                                Navigator.of(context).pop();
                              },
                            ),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.check_circle),
                              label: const Text('Selecionar'),
                              onPressed: () {
                                setState(() => _mapColor = _pickerColor);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.palette_rounded,
                      color: AppTheme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}