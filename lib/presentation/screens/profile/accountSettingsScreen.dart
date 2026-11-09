import 'package:academichub/business_logic/profile/account_settings_cubit.dart';
import 'package:academichub/business_logic/theme/theme_cubit.dart';
import 'package:academichub/data/model/profile/account_settings_model.dart';
import 'package:academichub/presentation/theme/task_status_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  bool liveClassReminders = true;
  bool taskFeedbackUpdates = true;
  bool academyAnnouncements = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null && mounted) {
        context.read<AccountSettingsCubit>().fetchAccountSettings(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: _buildHeader(),
        ),
      ),
      body: BlocBuilder<AccountSettingsCubit, AccountSettingsState>(
        builder: (context, state) {
          if (state is AccountSettingsLoading ||
              state is AccountSettingsInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AccountSettingsError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.errorMessage),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      final uid = FirebaseAuth.instance.currentUser?.uid;
                      if (uid != null) {
                        context
                            .read<AccountSettingsCubit>()
                            .fetchAccountSettings(uid);
                      }
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (state is AccountSettingsLoaded) {
            return _buildSettingsContent(state.settingsData, colors);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHeader() {
    final colors = Theme.of(context).colorScheme;

    return ListTile(
      title: Text("Account settings", style: TextStyle(fontSize: 20)),
      subtitle: Text(
        "Make your workplace feel like you",
        style: TextStyle(fontSize: 12),
      ),
      trailing: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: colors.adaptiveColor(
            light: const Color.fromARGB(255, 223, 238, 249),
            dark: colors.primaryContainer,
          ),
          borderRadius: BorderRadius.circular(15),
        ),

        child: Icon(Icons.gpp_good_outlined),
      ),
    );
  }

  Widget _buildSettingsContent(
    AccountSettingsModel account,
    ColorScheme colors,
  ) {
    final academicEmail = account.academicCode;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _sectionTitle('Personal Information'),
        _settingsCard([
          _infoTile(
            icon: Icons.person_outline,
            title: 'Full Name',
            value: account.name,
          ),
          _cardDivider(),
          _infoTile(
            icon: Icons.email_outlined,
            title: 'Academic Email',
            value: academicEmail,
          ),
        ]),
        const SizedBox(height: 24),
        _sectionTitle('Security'),
        _settingsCard([
          _actionTile(
            icon: Icons.lock_outline,
            title: 'Change Password',
            subtitle: 'Update your account password',
            onTap: () {},
          ),
          _cardDivider(),
          _actionTile(
            icon: Icons.support_agent,
            title: 'Contact Support',
            subtitle: 'Get help with your account',
            onTap: () {},
          ),
        ]),

        const SizedBox(height: 24),

        _sectionTitle('Notification Preferences'),
        _settingsCard([
          _switchTile(
            title: 'Live Class Reminders',
            subtitle: 'Get notified before your live classes',
            value: liveClassReminders,
            onChanged: (value) {
              setState(() => liveClassReminders = value);
            },
          ),
          _cardDivider(),
          _switchTile(
            title: 'Task & Feedback Updates',
            subtitle: 'Stay updated on tasks and instructor feedback',
            value: taskFeedbackUpdates,
            onChanged: (value) {
              setState(() => taskFeedbackUpdates = value);
            },
          ),
          _cardDivider(),
          _switchTile(
            title: 'Academy Announcements',
            subtitle: 'Receive important academy announcements',
            value: academyAnnouncements,
            onChanged: (value) {
              setState(() => academyAnnouncements = value);
            },
          ),
        ]),

        const SizedBox(height: 24),

        _sectionTitle('Appearance'),
        _settingsCard([
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return _switchTile(
                title: 'Dark Mode',
                subtitle: 'Switch between light and dark appearance',
                value: themeMode == ThemeMode.dark,
                onChanged: (value) {
                  context.read<ThemeCubit>().toggleTheme();
                },
              );
            },
          ),
        ]),

        const SizedBox(height: 24),

        _sectionTitle('Regional Settings'),
        _settingsCard([
          _infoTile(
            icon: Icons.access_time,
            title: 'Time Zone',
            value: 'Automatically detected',
          ),
          _cardDivider(),
          _infoTile(
            icon: Icons.location_on_outlined,
            title: 'Academy Time Zone',
            value: 'Africa/Cairo',
          ),
        ]),

        const SizedBox(height: 28),

        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              // هنربط حفظ الإعدادات بالـ Cubit في الخطوة القادمة.
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Save Changes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _settingsCard(List<Widget> children) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.3),
          ),
        ),
        child: Column(children: children),
      ),
    );
  }

  Widget _cardDivider() {
    return Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: Theme.of(context).dividerColor.withOpacity(0.3),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      subtitle: Text(value),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
    );
  }

  Widget _switchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      activeTrackColor: Theme.of(context).colorScheme.primary,
    );
  }
}
