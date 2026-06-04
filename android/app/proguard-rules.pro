# CameraX kütüphanelerini koru
-keep class androidx.camera.core.** { *; }
-keep class androidx.camera.camera2.** { *; }
-keep class androidx.camera.lifecycle.** { *; }
-keep class androidx.camera.view.** { *; }

# Kendi yazdığın CameraManager sınıfını koru (Paket adını kontrol et)
# Eğer paket adın com.example.irisense ise:
-keep class com.example.irisense.CameraManager { *; }

# Hataları görmezden gel
-dontwarn androidx.camera.**
-dontwarn javax.annotation.**