import 'package:chat_app/utils.dart';
import 'package:chat_app/widgets/common/icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class HeaderPage extends StatelessWidget {
  static const keyDarkMode = 'key-dark-mode';

  const HeaderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          buildHeader(),
          const SizedBox(height: 32),
          buildUser(context),
          buildDarkMode(),
        ],
      );

  Widget buildDarkMode() => SwitchSettingsTile(
        settingKey: keyDarkMode,
        leading: const IconWidget(
          icon: Icons.drag_handle,
          color: Colors.redAccent,
        ),
        title: 'Dark Mode',
        onChange: (_) {},
      );

  Widget buildHeader() => const Center(
        child: Text(
          'Settings',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.1,
          ),
        ),
      );

  Widget buildUser(BuildContext context) => InkWell(
        onTap: () => Utils.showSnackBar(context, 'Clicked User'),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              ClipOval(
                child: Image.network(
                  'https://c.pxhere.com/photos/15/bd/photo-1408416.jpg!d',
                  fit: BoxFit.cover,
                  width: 95,
                  height: 95,
                ),
              ),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Jaime Little',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.chevron_right_sharp),
            ],
          ),
        ),
      );
}
