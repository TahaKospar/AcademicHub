import 'package:academichub/presentation/theme/task_status_colors.dart';
import 'package:flutter/material.dart';

class Helpscreen extends StatefulWidget {
  const Helpscreen({super.key});

  @override
  State<Helpscreen> createState() => _HelpscreenState();
}

class _HelpscreenState extends State<Helpscreen> {
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
      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [_buildContainer()],
      ),
    );
  }

  Widget _buildHeader() {
    final colors = Theme.of(context).colorScheme;

    return ListTile(
      title: Text("Help & support", style: TextStyle(fontSize: 20)),
      subtitle: Text(
        "A little help goes a long way",
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

        child: Icon(Icons.headset_mic_outlined),
      ),
    );
  }

  Widget _buildContainer() {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.3),
        ),
        color: colors.adaptiveColor(
          light: const Color.fromARGB(255, 223, 238, 249),
          dark: colors.secondaryFixed,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Icon(Icons.headset_mic_outlined)],
        ),
      ),
    );
  }
}
