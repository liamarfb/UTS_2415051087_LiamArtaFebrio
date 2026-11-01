import 'package:flutter/material.dart';
import '../core/app_constants.dart';

class SpotCard extends StatelessWidget {
  final Map<String, dynamic> spot;
  final VoidCallback? onTap;

  const SpotCard({
    super.key,
    required this.spot,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOptimal = spot['status'] == 'Optimal';

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      spot['name'].toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isOptimal
                          ? AppConstants.primaryMint.withValues(alpha: 0.15)
                          : AppConstants.accentPeach.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      spot['status'].toString(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isOptimal
                            ? const Color(0xFF0F766E)
                            : const Color(0xFFB45309),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${spot['region']} • ${spot['terrain']}',
                      style: const TextStyle(fontSize: 13, color: Colors.black54),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.air, size: 18, color: AppConstants.primaryMint),
                      const SizedBox(width: 6),
                      Text(
                        '${spot['windSpeed']} km/h',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 14),
                      const Icon(Icons.thermostat_outlined, size: 18, color: AppConstants.accentPeach),
                      const SizedBox(width: 4),
                      Text(
                        '${spot['temp']}°C',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Flexible(
                    child: Text(
                      spot['recommendedWing'].toString(),
                      style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}