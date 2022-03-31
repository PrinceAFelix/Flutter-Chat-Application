import 'package:chat_app/widgets/common/icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class NotificationsPage extends StatelessWidget {
  static const keyNews = 'key-news';
  static const keyActivity = 'key-activity';
  static const keyNewsletter = 'key-newsletter';
  static const keyAppUpdates = 'key-appUpdates';

  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SimpleSettingsTile(
        title: 'Notifications',
        subtitle: 'Newsletter, App Updates',
        leading: const IconWidget(
          icon: Icons.notifications,
          color: Colors.redAccent,
        ),
        child: SettingsScreen(
          title: 'Notifications',
          children: <Widget>[
            buildNews(),
            buildActivity(),
            buildNewsletter(),
            buildAppUpdates(),
          ],
        ),
      );

  Widget buildNews() => SwitchSettingsTile(
        settingKey: keyNews,
        leading: IconWidget(icon: Icons.message, color: Colors.blueAccent),
        title: 'News For You',
      );

  Widget buildActivity() => SwitchSettingsTile(
        settingKey: keyActivity,
        leading: IconWidget(icon: Icons.person, color: Colors.orange),
        title: 'Account Activity',
      );
  Widget buildNewsletter() => SwitchSettingsTile(
        settingKey: keyNewsletter,
        leading: IconWidget(icon: Icons.text_snippet, color: Colors.pink),
        title: 'Newsletter',
      );

  Widget buildAppUpdates() => SwitchSettingsTile(
        settingKey: keyAppUpdates,
        leading: IconWidget(icon: Icons.update, color: Colors.greenAccent),
        title: 'App Updates',
      );
}
