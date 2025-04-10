import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return shadcn.OutlinedContainer(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(
        0,
      ), // Reduced radius for sharper corners
      backgroundColor: Color.fromARGB(
        255,
        40,
        231,
        183,
      ), // Set the background color to light blue
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:
            Colors
                .transparent, // Make the AppBar transparent so the background is visible
        title: Row(
          children: [
            Image.asset('assets/trans_bg.png', height: 80),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'TichaFasta',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Be faster, Be Smarter',
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
        leading: shadcn.OutlineButton(
          density: shadcn.ButtonDensity.icon,
          onPressed: () {
            Navigator.of(context).maybePop(); // Smart back behavior
          },
          child: const Icon(Icons.arrow_back),
        ),
        actions: [
          shadcn.OutlineButton(
            density: shadcn.ButtonDensity.icon,
            onPressed: () {
              // You can customize this or remove if not needed
            },
            child: const Icon(Icons.more_vert),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 30);
}
