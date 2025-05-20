# Medi Survey AI

Medi Survey AI, doktorlar ve kiracılar için geliştirilmiş bir mobil uygulamadır. Uygulama, doktorların hastalarını yönetmesine ve formları doldurmasına olanak sağlar. Kiracılar ise doktorları ve dosyaları yönetebilir.

## Özellikler

- Doktor ve kiracı girişi
- Doktorlar için:
  - Hasta yönetimi
  - Form yönetimi
- Kiracılar için:
  - Doktor yönetimi
  - Dosya yönetimi
- Güvenli kimlik doğrulama
- Kullanıcı dostu arayüz

## Kurulum

1. Flutter SDK'yı yükleyin (https://flutter.dev/docs/get-started/install)
2. Projeyi klonlayın:
   ```bash
   git clone https://github.com/yourusername/medi_surveyai.git
   ```
3. Bağımlılıkları yükleyin:
   ```bash
   flutter pub get
   ```
4. Uygulamayı çalıştırın:
   ```bash
   flutter run
   ```

## Geliştirme

### Proje Yapısı

```
lib/
  ├── core/
  │   └── network/
  │       └── dio_client.dart
  ├── models/
  │   └── user_model.dart
  ├── services/
  │   └── auth_service.dart
  ├── views/
  │   ├── splash_view.dart
  │   ├── login_view.dart
  │   ├── register_view.dart
  │   ├── home_view.dart
  │   ├── settings_view.dart
  │   ├── doctors_view.dart
  │   ├── patients_view.dart
  │   ├── forms_view.dart
  │   └── files_view.dart
  └── main.dart
```

### Kullanılan Teknolojiler

- Flutter
- Dio (HTTP client)
- Flutter Secure Storage

## Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Daha fazla bilgi için `LICENSE` dosyasına bakın.
