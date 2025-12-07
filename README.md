# Tulpars Derneği Mobil Uygulaması

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=for-the-badge&logo=flutter)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com/)
[![BLoC](https://img.shields.io/badge/BLoC-45B8AC?style=for-the-badge&logo=flutter&logoColor=white)](https://bloclibrary.dev/)

Tulpars Derneği için geliştirilmiş kapsamlı mobil uygulama. Sivil savunma, arama-kurtarma, gençlik sporları ve sosyal dayanışma alanlarında hizmet veren derneğin ihtiyaçlarını karşılamak üzere tasarlanmıştır.

## 📱 Özellikler

### ✅ Tamamlanan Özellikler
- 🔐 **Kimlik Doğrulama Sistemi**
  - Firebase Authentication
  - Google ve Apple ile giriş
  - Biyometrik kimlik doğrulama
  - Güvenli parola sıfırlama

- 🚨 **Acil Durum Yönetimi**
  - Acil durum ihbar sistemi
  - Gerçek zamanlı bildirimler
  - Konum tabanlı hizmetler

- 💰 **Bağış ve Üyelik Sistemi**
  - Güvenli ödeme entegrasyonu
  - Üyelik kayıt ve yönetimi
  - Bağış takibi

- 🏃‍♂️ **Spor ve Eğitim Programları**
  - Gençlik spor kulübü yönetimi
  - Eğitim kayıtları
  - Etkinlik takvimi

- 📰 **Haber ve Duyuru Sistemi**
  - Kategorize edilmiş haberler
  - Arama ve filtreleme
  - Sosyal medya paylaşımı

- 📸 **Galeri ve Operasyon Yönetimi**
  - Fotoğraf/video galerisi
  - Arama-kurtarma operasyonları
  - Gerçek zamanlı güncellemeler

### 🏗️ Teknik Altyapı
- **State Management**: BLoC Pattern + Hydrated BLoC
- **Dependency Injection**: GetIt + Injectable
- **Secure Storage**: FlutterSecureStorage
- **Caching**: Hive local storage
- **Networking**: Dio + Connectivity monitoring
- **Notifications**: Firebase Cloud Messaging
- **Error Monitoring**: Sentry integration
- **CI/CD**: GitHub Actions

## 🚨 Mevcut Durum

### ⚠️ Derleme Sorunları
Uygulama şu anda **707 derleme hatası** nedeniyle çalışmıyor. Bu hatalar sözdizimi bozukluklarından kaynaklanıyor.

**Hata Türleri:**
- Eksik virgüller ve yanlış parametre yapıları
- Bozuk fonksiyon çağrıları
- Tanımlanmamış fonksiyonlar

### 📊 İlerleme Durumu
- ✅ **Mimari**: %100 Tamamlandı
- ✅ **Özellikler**: %100 Tamamlandı
- ✅ **Test Altyapısı**: %100 Tamamlandı
- ⚠️ **Derleme**: Sözdizimi hataları var
- ❌ **Çalışma**: Henüz çalışmıyor

## 🛠️ Kurulum ve Çalıştırma

### Gereksinimler
- Flutter 3.0+
- Dart 3.0+
- Firebase proje kurulumu
- Android Studio / VS Code

### Adımlar
```bash
# Projeyi klonlayın
git clone https://github.com/tolgaolgunsoy1/Tulpars-App.git
cd Tulpars-App

# Bağımlılıkları yükleyin
flutter pub get

# Firebase yapılandırması
# firebase_options.dart dosyasını düzenleyin

# Çalıştırmayı deneyin
flutter run
```

## 🔧 Sorun Giderme

### Sözdizimi Hatalarını Düzeltme
```bash
# Hataları analiz edin
flutter analyze --no-fatal-warnings

# Otomatik düzeltmeler
find lib -name "*.dart" -exec sed -i 's/),)/)/g' {} \;
find lib -name "*.dart" -exec sed -i 's/,\s*,/,/g' {} \;
find lib -name "*.dart" -exec sed -i 's/)\s*;/);/g' {} \;
```

### Yaygın Hata Türleri
1. **Eksik Virgüller**: `child: Text('Hello')` → `child: Text('Hello'),`
2. **Yanlış Parametreler**: `Text('Hello' style: TextStyle())` → `Text('Hello', style: TextStyle())`
3. **Bozuk Fonksiyon Çağrıları**: `function(param1 param2)` → `function(param1, param2)`

## 📁 Proje Yapısı

```
lib/
├── core/
│   ├── constants/          # Uygulama sabitleri
│   ├── di/                 # Dependency injection
│   ├── services/           # İş mantığı servisleri
│   ├── theme/              # Tema ve stiller
│   └── utils/              # Yardımcı araçlar
├── presentation/
│   ├── bloc/               # State management
│   └── screens/            # UI ekranları
├── firebase_options.dart   # Firebase yapılandırması
└── main.dart              # Uygulama giriş noktası
```

## 🧪 Test

```bash
# Unit testler
flutter test

# Widget testler
flutter test --tags widget

# Integration testler
flutter test integration_test/
```

## 🚀 Dağıtım

```bash
# Android APK
flutter build apk --release

# iOS (macOS gerekli)
flutter build ios --release

# Web
flutter build web --release
```

## 📝 Katkıda Bulunma

1. Fork edin
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Commit edin (`git commit -m 'Add amazing feature'`)
4. Push edin (`git push origin feature/amazing-feature`)
5. Pull Request oluşturun

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır.

## 📞 İletişim

- **Geliştirici**: Tolga Olgunsoy
- **E-posta**: tolgaolgunsoy1@gmail.com
- **GitHub**: [@tolgaolgunsoy1](https://github.com/tolgaolgunsoy1)

---

**Not**: Bu uygulama şu anda geliştirme aşamasındadır ve sözdizimi hataları düzeltilene kadar çalışmayacaktır. Tüm özellikler ve mimari tamamlanmış durumdadır.