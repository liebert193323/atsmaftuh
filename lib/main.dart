import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Custom PageTransitionBuilder untuk animasi slide
class SlideTransitionBuilder extends PageTransitionsBuilder {
  const SlideTransitionBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(1.0, 0.0); // Mulai dari kanan layar
    const end = Offset.zero;
    const curve = Curves.easeInOut;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    var offsetAnimation = animation.drive(tween);

    return SlideTransition(position: offsetAnimation, child: child);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Warna cream yang lembut
    const Color primaryCream = Color(0xFFF5F5DC); // Warna cream dasar
    const Color lightCream = Color(0xFFFDFDF6); // Cream lebih terang
    const Color darkCream = Color(0xFFE0D8B0); // Cream lebih gelap untuk aksen

    return MaterialApp(
      title: 'Flutter Praktikum',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primaryColor: primaryCream,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryCream,
          primary: darkCream, // Untuk app bar dan elemen utama
          secondary: Color(0xFF8B7E5E), // Warna aksen yang kontras
          surface: Colors.white,
          background: lightCream, // Warna latar belakang
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: darkCream, // Warna tombol
            foregroundColor: Colors.black87, // Warna teks tombol
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: darkCream, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: Colors.grey),
          floatingLabelStyle: TextStyle(color: darkCream),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: SlideTransitionBuilder(),
            TargetPlatform.iOS: SlideTransitionBuilder(),
            TargetPlatform.linux: SlideTransitionBuilder(),
            TargetPlatform.macOS: SlideTransitionBuilder(),
            TargetPlatform.windows: SlideTransitionBuilder(),
          },
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: darkCream, // Warna app bar
          foregroundColor: Colors.black87, // Warna teks app bar
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/thank-you': (context) => const ThankYouScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Validasi format email
  bool _isValidEmail(String email) {
    return email.contains('@') && email.contains('.');
  }

  void _showSubmitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Informasi'),
        content: Text(
          'Halo, ${_nameController.text}! Email Anda adalah ${_emailController.text}.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Tutup dialog
              // Berpindah ke halaman terima kasih dengan animasi slide
              Navigator.pushNamed(
                context,
                '/thank-you',
                arguments: _nameController.text,
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Menentukan apakah layar cukup lebar untuk tampilan dua kolom
    final isWideScreen = MediaQuery.of(context).size.width > 600;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter Praktikum',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        color: theme.colorScheme.background,
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (isWideScreen) {
                      // Tampilan dua kolom untuk layar lebar (tablet)
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Form Registrasi',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Field Nama
                              Expanded(
                                child: TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    labelText: 'Nama',
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Nama tidak boleh kosong';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Field Email
                              Expanded(
                                child: TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Email tidak boleh kosong';
                                    }
                                    if (!_isValidEmail(value)) {
                                      return 'Format email tidak valid';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _showSubmitDialog();
                              }
                            },
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      // Tampilan satu kolom untuk layar kecil (smartphone)
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Form Registrasi',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Field Nama
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Nama',
                              prefixIcon: Icon(
                                Icons.person,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          // Field Email
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(
                                Icons.email,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email tidak boleh kosong';
                              }
                              if (!_isValidEmail(value)) {
                                return 'Format email tidak valid';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _showSubmitDialog();
                              }
                            },
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Menerima data nama yang dikirim dari halaman sebelumnya
    final username =
        ModalRoute.of(context)!.settings.arguments as String? ?? 'Pengguna';
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Terima Kasih',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        color: theme.colorScheme.background,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: theme.colorScheme.secondary,
              size: 100,
            ),
            const SizedBox(height: 20),
            Text(
              'Terima kasih telah mengisi form, $username!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Kembali ke Form',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}