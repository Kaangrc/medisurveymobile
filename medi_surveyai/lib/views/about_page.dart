import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hakkımızda'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [const Color(0xFF1F2A40), const Color(0xFF2E7C67)]
                : [const Color(0xFF334155), const Color(0xFF4CCEAC)],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // TopBar would go here
              // You'll need to create a TopBarOfMarketing widget

              // Hero Section
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 48.0,
                ),
                child: Column(
                  children: [
                    // About Us Section
                    _buildSectionTitle("Hakkımızda"),
                    _buildSectionDescription(
                        "MediSurvey AI olarak, sağlık sektöründe dijital dönüşümün öncüsü olmayı hedefliyoruz. Modern teknolojilerle desteklenen platformumuz, sağlık hizmetlerini daha verimli ve erişilebilir kılıyor."),
                    const SizedBox(height: 48),

                    // Values Section
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: _getCrossAxisCount(context),
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 0.8,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildValueCard(
                          icon: Icons.medical_services,
                          title: "Misyonumuz",
                          description:
                              "Sağlık hizmetlerini dijitalleştirerek, hasta takibini ve tedavi süreçlerini daha verimli hale getirmek.",
                        ),
                        _buildValueCard(
                          icon: Icons.visibility,
                          title: "Vizyonumuz",
                          description:
                              "Sağlık sektöründe dijital dönüşümün öncüsü olarak, global ölçekte hizmet veren bir teknoloji şirketi olmak.",
                        ),
                        _buildValueCard(
                          icon: Icons.rocket_launch,
                          title: "Hedeflerimiz",
                          description:
                              "Yapay zeka ve modern teknolojilerle sağlık hizmetlerini geliştirmek ve herkes için erişilebilir kılmak.",
                        ),
                        _buildValueCard(
                          icon: Icons.people,
                          title: "Değerlerimiz",
                          description:
                              "Yenilikçilik, güvenilirlik, şeffaflık ve hasta odaklı yaklaşım temel değerlerimizi oluşturur.",
                        ),
                      ],
                    ),
                    const SizedBox(height: 64),

                    // Team Section
                    _buildSectionTitle("Ekibimiz"),
                    const SizedBox(height: 32),
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: _getTeamCrossAxisCount(context),
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 0.8,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildTeamMemberCard(
                          name: "Dr. Ahmet Yılmaz",
                          role: "Kurucu & CEO",
                          description:
                              "20 yıllık tıp ve teknoloji deneyimi ile sağlık sektöründe dijital dönüşümün öncülerinden.",
                        ),
                        _buildTeamMemberCard(
                          name: "Ayşe Kaya",
                          role: "Teknoloji Direktörü",
                          description:
                              "Yapay zeka ve makine öğrenimi alanında uzman, 15 yıllık yazılım geliştirme deneyimi.",
                        ),
                        _buildTeamMemberCard(
                          name: "Mehmet Demir",
                          role: "Ürün Müdürü",
                          description:
                              "Kullanıcı deneyimi ve ürün geliştirme konusunda uzman, sağlık teknolojileri alanında 10 yıllık tecrübe.",
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Stats Section
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.03),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 48.0,
                    horizontal: 24.0,
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.spaceAround,
                    spacing: 20,
                    runSpacing: 30,
                    children: [
                      _buildStatCard("5+", "Yıllık Deneyim"),
                      _buildStatCard("50+", "Uzman Çalışan"),
                      _buildStatCard("1000+", "Mutlu Müşteri"),
                      _buildStatCard("24/7", "Destek"),
                    ],
                  ),
                ),
              ),

              // Footer would go here
              // You'll need to create a Footer widget
            ],
          ),
        ),
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 1100) return 4;
    if (width > 700) return 2;
    return 1;
  }

  int _getTeamCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 1100) return 3;
    if (width > 700) return 2;
    return 1;
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSectionDescription(String description) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        description,
        style: const TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildValueCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return _buildAnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              size: 48,
              color: const Color(0xFF4CCEAC),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 40,
            height: 3,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4CCEAC), Color(0xFF70D8FF)],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMemberCard({
    required String name,
    required String role,
    required String description,
  }) {
    return _buildAnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 40,
            height: 3,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4CCEAC), Color(0xFF70D8FF)],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            role,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF4CCEAC),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      width: 180,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) {
              return const LinearGradient(
                colors: [Color(0xFF4CCEAC), Color(0xFF70D8FF)],
              ).createShader(bounds);
            },
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
