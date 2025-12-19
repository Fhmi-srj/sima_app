import 'package:flutter/material.dart';

class CustomTopBar extends StatelessWidget {
  final VoidCallback? onProfileTap;
  final VoidCallback? onSettingsTap;
  final bool showProfileIcon;
  final bool showSettingsIcon;

  const CustomTopBar({
    super.key,
    this.onProfileTap,
    this.onSettingsTap,
    this.showProfileIcon = true,
    this.showSettingsIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(color: Color(0xFF4A90E2)),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'SIMA',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
            Row(
              children: [
                if (showSettingsIcon) ...[
                  GestureDetector(
                    onTap: onSettingsTap,
                    child: const Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                if (showProfileIcon)
                  GestureDetector(
                    onTap: onProfileTap,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Color(0xFF4A90E2),
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
