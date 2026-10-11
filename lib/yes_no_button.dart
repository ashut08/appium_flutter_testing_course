import 'package:flutter/material.dart';

/// One pill-shaped widget with YES on the left and NO on the right,
/// split by a thin divider, so it reads as a single control.
class YesNoButton extends StatelessWidget {
  const YesNoButton({
    super.key,
    required this.onYes,
    required this.onNo,
    this.yesKey = const ValueKey('yes_button'),
    this.noKey = const ValueKey('no_button'),
  });

  final VoidCallback onYes;
  final VoidCallback onNo;
  final Key yesKey;
  final Key noKey;

  static const _radius = BorderRadius.all(Radius.circular(14));

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: _radius,
        side: BorderSide(color: Colors.grey.shade300),
      ),
      clipBehavior: Clip.antiAlias, // keeps the tap ripple inside the pill
      child: SizedBox(
        height: 52,
        child: Row(
          children: [
            _half(key: yesKey, label: 'YES', color: Colors.teal, onTap: onYes),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: Colors.grey.shade300,
            ),
            _half(
              key: noKey,
              label: 'NO',
              color: Colors.redAccent,
              onTap: onNo,
            ),
          ],
        ),
      ),
    );
  }

  Widget _half({
    required Key key,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        key: key,
        onTap: onTap,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}
