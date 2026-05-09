import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_scaffold.dart';

class LocationPickerScreen extends StatefulWidget {
  final double? initialLat;
  final double? initialLng;
  final String? initialAddress;

  const LocationPickerScreen({
    super.key,
    this.initialLat,
    this.initialLng,
    this.initialAddress,
  });

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late LatLng _selectedLocation;
  late MapController _mapController;
  String _address = '';
  final _searchController = TextEditingController();
  double _currentZoom = 15.0;

  // Toshkent markazi default
  static const double _defaultLat = 41.2995;
  static const double _defaultLng = 69.2401;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _selectedLocation = LatLng(
      widget.initialLat ?? _defaultLat,
      widget.initialLng ?? _defaultLng,
    );
    _address = widget.initialAddress ?? '';
    if (_address.isNotEmpty) {
      _searchController.text = _address;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onMapTap(TapPosition tapPosition, LatLng point) {
    setState(() {
      _selectedLocation = point;
      _address =
          '${point.latitude.toStringAsFixed(6)}, ${point.longitude.toStringAsFixed(6)}';
      _searchController.text = _address;
    });
  }

  void _confirmLocation() {
    if (_address.isEmpty) return;
    Navigator.pop(context, {
      'lat': _selectedLocation.latitude,
      'lng': _selectedLocation.longitude,
      'address': _address,
    });
  }

  void _zoomIn() {
    _currentZoom = (_currentZoom + 1).clamp(3, 18);
    _mapController.move(_selectedLocation, _currentZoom);
  }

  void _zoomOut() {
    _currentZoom = (_currentZoom - 1).clamp(3, 18);
    _mapController.move(_selectedLocation, _currentZoom);
  }

  void _searchAddress() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return;

    // Asosiy shaharlar va tuman markazlari
    final locations = <String, LatLng>{
      'toshkent': const LatLng(41.2995, 69.2401),
      'tashkent': const LatLng(41.2995, 69.2401),
      'samarqand': const LatLng(39.6542, 66.9597),
      'samarkand': const LatLng(39.6542, 66.9597),
      'buxoro': const LatLng(39.7747, 64.4286),
      'bukhara': const LatLng(39.7747, 64.4286),
      'namangan': const LatLng(40.9983, 71.6726),
      'andijon': const LatLng(40.7821, 72.3442),
      'andijan': const LatLng(40.7821, 72.3442),
      'fargona': const LatLng(40.3842, 71.7974),
      'fergana': const LatLng(40.3842, 71.7974),
      'nukus': const LatLng(42.4628, 59.6003),
      'xorazm': const LatLng(41.5513, 60.6318),
      'urganch': const LatLng(41.5513, 60.6318),
      'navoiy': const LatLng(40.1033, 65.3793),
      'qarshi': const LatLng(38.8604, 65.7986),
      'qashqadaryo': const LatLng(38.8604, 65.7986),
      'termiz': const LatLng(37.2243, 67.2783),
      'surxondaryo': const LatLng(37.2243, 67.2783),
      'jizzax': const LatLng(40.1158, 67.8422),
      'sirdaryo': const LatLng(40.8390, 68.6621),
      'guliston': const LatLng(40.4894, 68.7842),
      'chirchiq': const LatLng(41.4689, 69.5828),
      'olmaliq': const LatLng(40.8444, 69.5994),
      'angren': const LatLng(41.0167, 70.1439),
      'kokand': const LatLng(40.5281, 70.9429),
      'qoqon': const LatLng(40.5281, 70.9429),
      'margilan': const LatLng(40.4700, 71.7147),
    };

    for (final entry in locations.entries) {
      if (query.contains(entry.key) || entry.key.contains(query)) {
        final point = entry.value;
        _mapController.move(point, 14);
        setState(() {
          _selectedLocation = point;
          _address = _searchController.text.trim();
        });
        return;
      }
    }

    // Agar topilmasa, hozirgi manzilni yozilgan qilib qo'yish
    setState(() {
      _address = _searchController.text.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        title: const Text('Манзилни танланг'),
        actions: [
          TextButton(
            onPressed: _address.isNotEmpty ? _confirmLocation : null,
            child: const Text(
              'Тасдиқлаш',
              style: TextStyle(
                  color: AppTheme.accentCyan, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedLocation,
              initialZoom: _currentZoom,
              onTap: _onMapTap,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.mobile_marketplace',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _selectedLocation,
                    width: 50,
                    height: 50,
                    child: const Column(
                      children: [
                        Icon(Icons.location_pin, color: Colors.red, size: 40),
                        Icon(Icons.circle, color: Colors.red, size: 6),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Search bar
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.primaryDark.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                style:
                    const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Манзил қидириш (масалан: Тошкент)',
                  hintStyle:
                      const TextStyle(color: AppTheme.textHint, fontSize: 13),
                  prefixIcon: const Icon(Icons.search,
                      color: AppTheme.textHint, size: 20),
                  suffixIcon: IconButton(
                    onPressed: _searchAddress,
                    icon: const Icon(Icons.arrow_forward,
                        color: AppTheme.accentCyan, size: 20),
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                onSubmitted: (_) => _searchAddress(),
              ),
            ),
          ),

          // Zoom controls
          Positioned(
            right: 10,
            bottom: 180,
            child: Column(
              children: [
                _buildZoomButton(Icons.add, _zoomIn),
                const SizedBox(height: 8),
                _buildZoomButton(Icons.remove, _zoomOut),
              ],
            ),
          ),

          // Crosshair center indicator
          Center(
            child: IgnorePointer(
              child: Container(
                width: 2,
                height: 20,
                color: Colors.black38,
              ),
            ),
          ),

          // Address bar at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryDark,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            color: AppTheme.error, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _address.isNotEmpty
                                ? _address
                                : 'Хариталарда нуқтани танланг',
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_selectedLocation.latitude.toStringAsFixed(4)}, ${_selectedLocation.longitude.toStringAsFixed(4)}',
                      style: const TextStyle(
                          color: AppTheme.textHint, fontSize: 11),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed:
                            _address.isNotEmpty ? _confirmLocation : null,
                        icon: const Icon(Icons.check),
                        label: const Text(
                          'Ушбу манзилни танлаш',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoomButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.primaryDark.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.3), blurRadius: 4),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}
