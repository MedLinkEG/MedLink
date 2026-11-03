import 'package:flutter/material.dart';

class LocationSelector extends StatelessWidget {
  const LocationSelector({required this.label, super.key, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text.rich(
                    TextSpan(
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      children: [
                        const TextSpan(text: 'Find near '),
                        TextSpan(
                          text: label,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
