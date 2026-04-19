import 'package:flutter/material.dart';
import '../../core/widgets/app_form_field.dart';
import 'shared_widgets.dart';

class HelpCard extends StatelessWidget {
  const HelpCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(icon: Icons.help_outline, title: 'Help & Support'),
          const SizedBox(height: 16),
          ActionTile(
            icon: Icons.chat_bubble_outline,
            label: 'Chat Support',
            onTap: () {},
          ),
          ActionTile(
            icon: Icons.menu_book_outlined,
            label: 'How to Use Shiksha',
            onTap: () {},
          ),
          ActionTile(
            icon: Icons.star_outline,
            label: 'Rate the App',
            onTap: () {},
          ),
          ActionTile(
            icon: Icons.bug_report_outlined,
            label: 'Report a Bug',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
