import 'package:flutter/material.dart';

class bar extends StatelessWidget implements PreferredSizeWidget {
  final void Function(int) onTabSelected;

  const bar({required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white10,
      centerTitle: true,
      title: const Text('T O D O L I S T'),
      elevation: 4,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            backgroundColor: const Color(0xFFF9F9FB),
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildBottomSheetOption(context, "Uncomplete (Today)", Icons.today, 0),
                    _buildBottomSheetOption(context, "Complete", Icons.check_circle, 1),
                    _buildBottomSheetOption(context, "All Tasks", Icons.list, 2),
                    _buildBottomSheetOption(context, "Overdue", Icons.warning_amber_rounded, 3),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBottomSheetOption(
      BuildContext context,
      String label,
      IconData icon,
      int index,
      ) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueGrey),
      title: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: () {
        onTabSelected(index);
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}