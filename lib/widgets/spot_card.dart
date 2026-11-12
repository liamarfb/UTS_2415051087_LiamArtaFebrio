import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_constants.dart';
import '../providers/weather_provider.dart';

class SpotCard extends StatelessWidget {
  final Map<String, dynamic> spot;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  const SpotCard({
    super.key,
    required this.spot,
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOptimal = spot['status'] == 'Optimal';
    final String spotId = spot['id']?.toString() ?? '';
    final bool isFav = context.select<WeatherProvider, bool>(
      (prov) => prov.isFavorite(spotId),
    );
    final int windDir = (spot['windDirection'] as num?)?.toInt() ?? 180;

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: margin ?? const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isFav
              ? AppConstants.primaryMint.withValues(alpha: 0.5)
              : Colors.grey.shade200,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            if (isFav) ...[
                              const Icon(
                                Icons.bookmark,
                                size: 18,
                                color: AppConstants.accentPeach,
                              ),
                              const SizedBox(width: 4),
                            ],
                            Expanded(
                              child: Text(
                                spot['name'].toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
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
                      const Icon(Icons.location_on_outlined,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${spot['region']} • ${spot['terrain']}',
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black54),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.air,
                          size: 18, color: AppConstants.primaryMint),
                      const SizedBox(width: 4),
                      Text(
                        '${spot['windSpeed']} km/h ($windDir°)',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.thermostat_outlined,
                          size: 18, color: AppConstants.accentPeach),
                      const SizedBox(width: 2),
                      Text(
                        '${spot['temp']}°C',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      spot['recommendedWing'].toString(),
                      style:
                          const TextStyle(fontSize: 12, color: Colors.blueGrey),
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