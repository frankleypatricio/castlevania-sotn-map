import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:sotn_map/models/user-preferences.dart';
import 'package:sotn_map/theme.dart';

class HomeScreen extends StatefulWidget {
  final UserPreferences userPrefs;

  const HomeScreen({required this.userPrefs, Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late final UserPreferences _userPrefs;
  late Color _pickerColor;
  Color? _backgroundColor;
  int _rotateMap = 0;

  bool get _isTransparent => _backgroundColor != null;

  @override
  void initState() {
    super.initState();
    _userPrefs = widget.userPrefs;
    _pickerColor = _userPrefs.mapColor;
    _backgroundColor = _userPrefs.transparentScreen ? Colors.transparent : null;
  }

  void _saveUserPrefs() {
    _userPrefs.setSize(MediaQuery.of(context));
    _userPrefs.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: LayoutBuilder(
        builder: (_, __) {
          _saveUserPrefs();
          return Stack(
            children: [
              Center(
                child: RotatedBox(
                  quarterTurns: _rotateMap,
                  child: Image.asset(
                    'assets/sotn_map.png',
                    width: double.maxFinite,
                    height: double.maxFinite,
                    fit: BoxFit.fill,
                    opacity: AlwaysStoppedAnimation(_userPrefs.opacity),
                    color: _userPrefs.showMap ? null : _userPrefs.mapColor,
                  ),
                ),
              ),

              Positioned(
                top: 15, right: 15,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastOutSlowIn,

                  decoration: BoxDecoration(
                    color: _isTransparent ? Colors.white : null,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: IconButton(
                    tooltip: '${_isTransparent ? 'Exibir' :'Esconder'} cor de fundo',
                    onPressed: (){
                      setState(() {
                        _backgroundColor = _isTransparent ? null : Colors.transparent;
                      });
                      _userPrefs.transparentScreen = _isTransparent;
                    },
                    icon: Icon(
                      _isTransparent ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                      color: AppTheme.colorScheme.primary,
                    ),
                  ),
                ),
              ),

              Positioned(
                right: 15, bottom: 15,
                child: AnimatedContainer(
                  width: _userPrefs.expandirMenu ? 362 : 40, // +37 por cada botão
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.fastOutSlowIn,

                  padding: _userPrefs.expandirMenu ? const EdgeInsets.only(right: 8) : null,
                  decoration: BoxDecoration(
                    color: _isTransparent ? Colors.white : null,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        if(_userPrefs.expandirMenu) Row(
                          children: [
                            Slider(
                              min: 0, max: 1,
                              value: _userPrefs.opacity,
                              onChanged: (value) => setState(() => _userPrefs.opacity = value),
                            ),

                            IconButton(
                              tooltip: 'Inverter mapa',
                              onPressed: () {
                                setState(() {
                                  _rotateMap = _rotateMap == 0 ? 2 : 0;
                                });
                              },
                              icon: Icon(
                                Icons.rotate_left_rounded,
                                color: AppTheme.colorScheme.primary,
                              ),
                            ),

                            IconButton(
                              tooltip: '${_userPrefs.showMap ? 'Aplicar' : 'Remover'} cor no mapa',
                              onPressed: () {
                                setState(() => _userPrefs.showMap = !_userPrefs.showMap);
                              },
                              icon: Icon(
                                _userPrefs.showMap ? Icons.map_rounded : Icons.map_outlined,
                                color: AppTheme.colorScheme.primary,
                              ),
                            ),

                            IconButton(
                              tooltip: 'Alterar cor do mapa',
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
                                        icon: const Icon(Icons.check_circle),
                                        label: const Text('Selecionar'),
                                        onPressed: () {
                                          setState(() => _userPrefs.mapColor = _pickerColor);
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

                        IconButton(
                          tooltip: '${_userPrefs.expandirMenu ? 'Recolher' :'Expandir'} configurações de cores',
                          onPressed: () {
                            setState(() => _userPrefs.expandirMenu = !_userPrefs.expandirMenu);
                          },
                          icon: Icon(
                            _userPrefs.expandirMenu ? Icons.menu_open_rounded : Icons.menu_rounded,
                            color: AppTheme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}