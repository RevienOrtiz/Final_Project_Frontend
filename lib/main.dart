import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

final String apiBase = (!kIsWeb && Platform.isAndroid)
    ? 'http://10.0.2.2:4000/api'
    : 'http://localhost:4000/api';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const BookingApp());
}

class BookingApp extends StatelessWidget {
  const BookingApp({super.key});
  @override
  Widget build(BuildContext context) {
    const airbnbPink = Color(0xFFFF385C);
    const airbnbGray = Color(0xFF717171);
    const airbnbSurface = Color(0xFFF7F7F7);
    final textTheme = GoogleFonts.nunitoTextTheme().copyWith(
      titleLarge: GoogleFonts.nunito(
        fontWeight: FontWeight.w800,
        fontSize: 22,
        color: Colors.black,
      ),
      titleMedium: GoogleFonts.nunito(
        fontWeight: FontWeight.w700,
        fontSize: 18,
        color: Colors.black,
      ),
      bodyLarge: GoogleFonts.nunito(fontSize: 16, color: Colors.black87),
      bodyMedium: GoogleFonts.nunito(fontSize: 14, color: airbnbGray),
    );
    final scheme = const ColorScheme.light().copyWith(
      primary: airbnbPink,
      secondary: airbnbPink,
      surface: Colors.white,
      onSurface: Colors.black,
    );
    return MaterialApp(
      title: 'Booking System',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: Colors.white,
        textTheme: textTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: airbnbPink,
          elevation: 0.5,
          centerTitle: true,
          foregroundColor: Colors.white,
          titleTextStyle: textTheme.titleLarge?.copyWith(color: Colors.white),
          iconTheme: const IconThemeData(color: Colors.white),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          elevation: 0,
          indicatorColor: airbnbPink.withValues(alpha: 0.15),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: airbnbPink);
            }
            return const IconThemeData(color: airbnbPink);
          }),
          labelTextStyle: WidgetStateProperty.all(
            GoogleFonts.nunito(color: airbnbPink, fontWeight: FontWeight.bold),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: airbnbPink,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: airbnbPink,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: airbnbPink,
            side: const BorderSide(color: airbnbPink),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: airbnbPink,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: airbnbSurface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(color: airbnbSurface),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(color: airbnbSurface),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: const BorderSide(color: airbnbPink, width: 1.5),
          ),
          labelStyle: GoogleFonts.nunito(color: airbnbGray),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.black87,
          contentTextStyle: GoogleFonts.nunito(color: Colors.white),
          behavior: SnackBarBehavior.floating,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final pages = [const RoomsPage(), const BookingsPage()];
    return Scaffold(
      appBar: AppBar(title: const Text('Booking System')),
      body: pages[index],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: NavigationBar(
            selectedIndex: index,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.meeting_room),
                selectedIcon: Icon(Icons.meeting_room),
                label: 'Rooms',
              ),
              NavigationDestination(
                icon: Icon(Icons.book_online),
                selectedIcon: Icon(Icons.book_online),
                label: 'Bookings',
              ),
            ],
            onDestinationSelected: (i) => setState(() => index = i),
          ),
        ),
      ),
    );
  }
}

class RoomsPage extends StatefulWidget {
  const RoomsPage({super.key});
  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<dynamic>> _roomsFuture;
  String query = '';

  Future<List<dynamic>> fetchRooms() async {
    final roomsRes = await http.get(Uri.parse('$apiBase/rooms'));
    if (roomsRes.statusCode != 200) {
      throw Exception('Failed to load rooms');
    }
    return List<dynamic>.from(jsonDecode(roomsRes.body));
  }

  @override
  void initState() {
    super.initState();
    _roomsFuture = fetchRooms();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Map<String, List<dynamic>> groupRoomsByType(List<dynamic> rooms) {
    final grouped = <String, List<dynamic>>{};
    for (var r in rooms) {
      final type = r['type'] ?? 'Unknown';
      if (!grouped.containsKey(type)) {
        grouped[type] = [];
      }
      grouped[type]!.add(r);
    }
    return grouped;
  }

  String _getRoomImage(String type) {
    switch (type) {
      case 'Deluxe Suite':
        return 'assets/images/deluxe_room.jpg';
      case 'Standard Room':
        return 'assets/images/standard_room.jpg';
      case 'Presidential Suite':
        return 'assets/images/presidential_room.jpg';
      case 'Family Room':
        return 'assets/images/Family_room.jpg';
      default:
        return 'assets/images/standard_room.jpg';
    }
  }

  Future<void> updateRoomStatus(String roomId, String newStatus) async {
    final res = await http.put(
      Uri.parse('$apiBase/rooms/$roomId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': newStatus}),
    );
    if (res.statusCode == 200) {
      setState(() {
        _roomsFuture = fetchRooms();
      });
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Room status updated successfully'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update room status')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _roomsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final rooms = snapshot.data ?? [];

        // Filter rooms first
        final filtered = rooms.where((r) {
          final name = (r['name'] ?? '').toString().toLowerCase();
          final type = (r['type'] ?? '').toString().toLowerCase();
          final q = query.toLowerCase();
          return query.isEmpty || name.contains(q) || type.contains(q);
        }).toList();

        final grouped = groupRoomsByType(filtered);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => query = v),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search rooms',
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: grouped.keys.length,
                itemBuilder: (context, i) {
                  final type = grouped.keys.elementAt(i);
                  final typeRooms = grouped[type]!;

                  // Calculate counts
                  final total = typeRooms.length;
                  final available = typeRooms
                      .where((r) => r['status'] == 'available')
                      .length;
                  final cleaning = typeRooms
                      .where((r) => r['status'] == 'cleaning')
                      .length;
                  final taken = typeRooms
                      .where((r) => r['status'] == 'taken')
                      .length;

                  // Get common details from first room
                  final firstRoom = typeRooms.first;
                  final price = firstRoom['pricePerNight'];
                  final capacity = firstRoom['capacity'];
                  final bedSize = firstRoom['bedSize'];
                  final amenities = firstRoom['amenities'] as List<dynamic>?;

                  return Card(
                    clipBehavior: Clip.antiAlias,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: Image.asset(
                            _getRoomImage(type),
                            fit: BoxFit.cover,
                          ),
                        ),
                        ExpansionTile(
                          title: Text(
                            type,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('₱$price/night • Sleeps $capacity'),
                              if (bedSize != null)
                                Text(
                                  bedSize.toString(),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              if (amenities != null && amenities.isNotEmpty)
                                Text(
                                  amenities.join(' • '),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  _buildStatusChip(Colors.green, '$available'),
                                  const SizedBox(width: 8),
                                  _buildStatusChip(Colors.amber, '$cleaning'),
                                  const SizedBox(width: 8),
                                  _buildStatusChip(Colors.red, '$taken'),
                                ],
                              ),
                            ],
                          ),
                          children: typeRooms
                              .map((r) => _buildRoomTile(r))
                              .toList(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatusChip(Color color, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildRoomTile(dynamic room) {
    final status = room['status'] ?? 'available';
    Color statusColor;
    switch (status) {
      case 'available':
        statusColor = Colors.green;
        break;
      case 'cleaning':
        statusColor = Colors.amber;
        break;
      case 'taken':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return ListTile(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => SimpleDialog(
            title: Text('Change Status: ${room['name']}'),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  updateRoomStatus(room['_id'], 'available');
                },
                child: const Row(
                  children: [
                    Icon(Icons.circle, color: Colors.green, size: 16),
                    SizedBox(width: 8),
                    Text('Available'),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  updateRoomStatus(room['_id'], 'cleaning');
                },
                child: const Row(
                  children: [
                    Icon(Icons.circle, color: Colors.amber, size: 16),
                    SizedBox(width: 8),
                    Text('Cleaning'),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  updateRoomStatus(room['_id'], 'taken');
                },
                child: const Row(
                  children: [
                    Icon(Icons.circle, color: Colors.red, size: 16),
                    SizedBox(width: 8),
                    Text('Taken'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      leading: CircleAvatar(
        backgroundColor: statusColor.withValues(alpha: 0.2),
        child: Icon(Icons.bed, color: statusColor, size: 20),
      ),
      title: Text(room['name']),
      subtitle: Text(
        status.toString().toUpperCase(),
        style: TextStyle(color: statusColor, fontSize: 12),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Colors.grey,
      ),
    );
  }
}

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});
  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  late Future<List<dynamic>> bookingsFuture;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortOrder = 'newest';

  Future<List<dynamic>> fetchBookings() async {
    final res = await http.get(Uri.parse('$apiBase/bookings'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to load bookings');
  }

  Future<void> deleteBooking(String id) async {
    final res = await http.delete(Uri.parse('$apiBase/bookings/$id'));
    if (res.statusCode != 200) throw Exception('Delete failed');
  }

  @override
  void initState() {
    super.initState();
    bookingsFuture = fetchBookings();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void refresh() {
    setState(() {
      bookingsFuture = fetchBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFF385C),
        foregroundColor: Colors.white,
        onPressed: () async {
          final created = await Navigator.push<Map<String, dynamic>>(
            context,
            MaterialPageRoute(builder: (_) => const CreateBookingPage()),
          );
          if (created != null) refresh();
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search bookings',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                const Icon(Icons.sort, color: Colors.grey, size: 20),
                const SizedBox(width: 8),
                const Text('Sort'),
                const Spacer(),
                DropdownButton<String>(
                  value: _sortOrder,
                  items: const [
                    DropdownMenuItem(
                      value: 'newest',
                      child: Text('Newest first'),
                    ),
                    DropdownMenuItem(
                      value: 'oldest',
                      child: Text('Oldest first'),
                    ),
                  ],
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() => _sortOrder = v);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: bookingsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final bookings = snapshot.data ?? [];

                final filtered = bookings.where((b) {
                  if (b == null) return false;
                  final nameVal = b['customerName'];
                  final name = nameVal != null
                      ? nameVal.toString().toLowerCase()
                      : '';

                  final roomVal = b['room'];
                  String rName = '';
                  if (roomVal is Map) {
                    final rVal = roomVal['name'];
                    if (rVal != null) {
                      rName = rVal.toString().toLowerCase();
                    }
                  }

                  final q = _searchQuery.toLowerCase();
                  return name.contains(q) || rName.contains(q);
                }).toList();

                // Sort by createdAt (default newest first)
                DateTime _coerceDate(dynamic v) {
                  if (v == null) return DateTime.fromMillisecondsSinceEpoch(0);
                  try {
                    if (v is String) return DateTime.parse(v).toLocal();
                    return DateTime.fromMillisecondsSinceEpoch(0);
                  } catch (_) {
                    return DateTime.fromMillisecondsSinceEpoch(0);
                  }
                }

                filtered.sort((a, b) {
                  final ad = _coerceDate(a['createdAt'] ?? a['startDate']);
                  final bd = _coerceDate(b['createdAt'] ?? b['startDate']);
                  final cmp = ad.compareTo(bd);
                  return _sortOrder == 'newest' ? -cmp : cmp;
                });

                if (filtered.isEmpty) {
                  return const Center(child: Text('No bookings found'));
                }
                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final b = filtered[i];
                    DateTime s = DateTime.now();
                    DateTime e = DateTime.now();
                    try {
                      final sd = b['startDate'];
                      if (sd is String) s = DateTime.parse(sd).toLocal();
                    } catch (_) {}
                    try {
                      final ed = b['endDate'];
                      if (ed is String) e = DateTime.parse(ed).toLocal();
                    } catch (_) {}
                    return InkWell(
                      onTap: () async {
                        final updated =
                            await Navigator.push<Map<String, dynamic>>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditBookingPage(booking: b),
                              ),
                            );
                        if (updated != null) refresh();
                      },
                      child: LuxuryBookingCard(booking: b, start: s, end: e),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CreateBookingPage extends StatefulWidget {
  const CreateBookingPage({super.key});
  @override
  State<CreateBookingPage> createState() => _CreateBookingPageState();
}

class _CreateBookingPageState extends State<CreateBookingPage> {
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  List<dynamic> rooms = [];
  String? roomId;
  DateTime? startDate;
  DateTime? endDate;
  bool loading = false;

  Future<void> loadRooms() async {
    final res = await http.get(Uri.parse('$apiBase/rooms'));
    if (res.statusCode == 200) {
      rooms = jsonDecode(res.body);
      setState(() {});
    }
  }

  Future<void> createBooking() async {
    if (roomId == null ||
        startDate == null ||
        endDate == null ||
        nameCtrl.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }
    setState(() => loading = true);

    // Normalize dates to UTC noon to avoid timezone shifts
    final s = DateTime.utc(
      startDate!.year,
      startDate!.month,
      startDate!.day,
      12,
    );
    final e = DateTime.utc(endDate!.year, endDate!.month, endDate!.day, 12);

    final body = jsonEncode({
      'customerName': nameCtrl.text,
      'customerPhone': phoneCtrl.text,
      'room': roomId,
      'startDate': s.toIso8601String(),
      'endDate': e.toIso8601String(),
      'status': 'confirmed',
    });
    final res = await http.post(
      Uri.parse('$apiBase/bookings'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    setState(() => loading = false);
    if (res.statusCode == 201) {
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Booking created successfully'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (!mounted) return;
      Navigator.pop(context, jsonDecode(res.body));
    } else {
      final err = jsonDecode(res.body);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${err['error']}')));
    }
  }

  Future<void> pickStart() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now.add(const Duration(days: 3650)),
      initialDate: startDate ?? now,
    );
    if (picked != null) {
      setState(() => startDate = picked);
    }
  }

  Future<void> pickEnd() async {
    final base = startDate ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      initialDate: endDate ?? base,
    );
    if (picked != null) {
      setState(() => endDate = picked);
    }
  }

  @override
  void initState() {
    super.initState();
    loadRooms();
  }

  @override
  Widget build(BuildContext context) {
    // Sort rooms by name for easier finding
    rooms.sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));

    final roomItems = rooms.map<DropdownMenuItem<String>>((r) {
      final bed = r['bedSize'] != null ? ' (${r['bedSize']})' : '';
      return DropdownMenuItem(
        value: r['_id'],
        child: Text('${r['name']} - ${r['type']}$bed'),
      );
    }).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Create Booking')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Customer Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: roomId,
              items: roomItems,
              onChanged: (v) => setState(() => roomId = v),
              decoration: const InputDecoration(labelText: 'Room'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: pickStart,
                    child: Text(
                      startDate == null
                          ? 'Pick start date'
                          : DateFormat('MMM d, yyyy').format(startDate!),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: pickEnd,
                    child: Text(
                      endDate == null
                          ? 'Pick end date'
                          : DateFormat('MMM d, yyyy').format(endDate!),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFF385C),
                  foregroundColor: Colors.white,
                ),
                onPressed: loading ? null : createBooking,
                child: loading
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Create'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditBookingPage extends StatefulWidget {
  final Map<String, dynamic> booking;
  const EditBookingPage({super.key, required this.booking});
  @override
  State<EditBookingPage> createState() => _EditBookingPageState();
}

class _EditBookingPageState extends State<EditBookingPage> {
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  List<dynamic> rooms = [];
  String? roomId;
  DateTime? startDate;
  DateTime? endDate;
  bool loading = false;
  String status = 'confirmed';

  Future<void> loadRooms() async {
    final res = await http.get(Uri.parse('$apiBase/rooms'));
    if (res.statusCode == 200) {
      rooms = jsonDecode(res.body);
      setState(() {});
    }
  }

  Future<void> saveBooking() async {
    if (roomId == null ||
        startDate == null ||
        endDate == null ||
        nameCtrl.text.isEmpty) {
      return;
    }
    setState(() => loading = true);

    // Normalize dates to UTC noon
    final s = DateTime.utc(
      startDate!.year,
      startDate!.month,
      startDate!.day,
      12,
    );
    final e = DateTime.utc(endDate!.year, endDate!.month, endDate!.day, 12);

    final body = jsonEncode({
      'customerName': nameCtrl.text,
      'customerPhone': phoneCtrl.text,
      'room': roomId,
      'startDate': s.toIso8601String(),
      'endDate': e.toIso8601String(),
      'status': status,
    });
    final res = await http.put(
      Uri.parse('$apiBase/bookings/${widget.booking['_id']}'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    setState(() => loading = false);
    if (res.statusCode == 200) {
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Booking updated successfully'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (!mounted) return;
      Navigator.pop(context, jsonDecode(res.body));
    } else {
      final err = jsonDecode(res.body);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${err['error']}')));
    }
  }

  Future<void> deleteBooking() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Booking'),
        content: const Text('Are you sure you want to delete this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => loading = true);
    final res = await http.delete(
      Uri.parse('$apiBase/bookings/${widget.booking['_id']}'),
    );
    setState(() => loading = false);

    if (res.statusCode == 200) {
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Booking deleted successfully'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (!mounted) return;
      Navigator.pop(context, {'deleted': true});
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to delete')));
    }
  }

  Future<void> pickStart() async {
    final base = startDate ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      initialDate: base,
    );
    if (picked != null) {
      setState(() => startDate = picked);
    }
  }

  Future<void> pickEnd() async {
    final base = startDate ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      initialDate: endDate ?? base,
    );
    if (picked != null) {
      setState(() => endDate = picked);
    }
  }

  @override
  void initState() {
    super.initState();
    final b = widget.booking;
    nameCtrl.text = (b['customerName'] ?? '').toString();
    phoneCtrl.text = (b['customerPhone'] ?? '').toString();
    status = (b['status'] ?? 'confirmed').toString();
    try {
      startDate = DateTime.parse(b['startDate']).toLocal();
      endDate = DateTime.parse(b['endDate']).toLocal();
    } catch (_) {}
    final r = b['room'];
    if (r is Map<String, dynamic>) {
      roomId = r['_id']?.toString();
    } else if (r != null) {
      roomId = r.toString();
    }
    loadRooms();
  }

  @override
  Widget build(BuildContext context) {
    rooms.sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));
    final roomItems = rooms.map<DropdownMenuItem<String>>((r) {
      final bed = r['bedSize'] != null ? ' (${r['bedSize']})' : '';
      return DropdownMenuItem(
        value: r['_id'],
        child: Text('${r['name']} - ${r['type']}$bed'),
      );
    }).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Booking')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Customer Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: roomId,
              items: roomItems,
              onChanged: (v) => setState(() => roomId = v),
              decoration: const InputDecoration(labelText: 'Room'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: pickStart,
                    child: Text(
                      startDate == null
                          ? 'Pick start date'
                          : DateFormat('MMM d, yyyy').format(startDate!),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: pickEnd,
                    child: Text(
                      endDate == null
                          ? 'Pick end date'
                          : DateFormat('MMM d, yyyy').format(endDate!),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                if (widget.booking['_id'] != null)
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                      onPressed: loading ? null : deleteBooking,
                      child: const Text('Delete'),
                    ),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFF385C),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: loading ? null : saveBooking,
                    child: loading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save Changes'),
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

class LuxuryBookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  final DateTime start;
  final DateTime end;

  const LuxuryBookingCard({
    super.key,
    required this.booking,
    required this.start,
    required this.end,
  });

  @override
  Widget build(BuildContext context) {
    final room = booking['room'] ?? {};
    final roomName = room['name'] ?? 'Unknown Room';
    final roomType = room['type'] ?? '';
    final days = end.difference(start).inDays;
    final totalPrice = (room['pricePerNight'] ?? 0) * days;
    DateTime createdAt = start;
    final c = booking['createdAt'];
    if (c is String && c.isNotEmpty) {
      try {
        createdAt = DateTime.parse(c).toLocal();
      } catch (_) {}
    } else if (c is int) {
      try {
        createdAt = DateTime.fromMillisecondsSinceEpoch(c).toLocal();
      } catch (_) {}
    } else {
      final oid = booking['_id'];
      if (oid is String && oid.length >= 8) {
        try {
          final tsHex = oid.substring(0, 8);
          final seconds = int.parse(tsHex, radix: 16);
          createdAt = DateTime.fromMillisecondsSinceEpoch(
            seconds * 1000,
          ).toLocal();
        } catch (_) {}
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        roomName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (roomType.isNotEmpty)
                        Text(
                          roomType,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF385C).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '₱$totalPrice',
                    style: const TextStyle(
                      color: Color(0xFFFF385C),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24, color: Color(0xFFFF385C)),
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(booking['customerName'] ?? 'No Name'),
                const Spacer(),
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${DateFormat('MMM d').format(start)} - ${DateFormat('MMM d').format(end)}',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Created ${DateFormat('MMM d, yyyy h:mm a').format(createdAt)}',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
