# ViPER4AndroidFX - Built-in Audio Effects

## Обзор
ViPER4AndroidFX встроен в прошивку Evolution X для Nubia Cerro (NX721J).

Включает:
- **ViPER4AndroidFX.apk** - Приложение для управления аудио эффектами
- **libv4a_re.so** - Audio effect библиотека (ViPERFX RE 8.0)

## Что это?
ViPER4Android - это мощный процессор аудио эффектов, который предоставляет:
- Convolver (импульсные отклики)
- Viper Bass (улучшение басов)
- Viper Clarity (чёткость звука)
- Cure Tech+ (технология очистки звука)
- Equalizer (эквалайзер)
- Reverb (реверберация)
- Headphone Surround (объёмный звук для наушников)
- Analog X (аналоговое моделирование)
- Spectrum Extension (расширение спектра)
- FET Compressor (компрессор)

## Включение/Отключение в сборке

ViPER4AndroidFX контролируется флагом `TARGET_INCLUDE_VIPERFX` в `lineage_cerro.mk`:

```makefile
# Включить ViPER4AndroidFX
TARGET_INCLUDE_VIPERFX := true

# Отключить ViPER4AndroidFX (закомментировать или удалить строку)
# TARGET_INCLUDE_VIPERFX := true
```

## Структура файлов

```
packages/apps/ViPER4AndroidFX/
├── Android.bp                   # Build конфигурация
├── ViPER4AndroidFX.apk         # Prebuilt APK приложения
├── ViPERFX_RE-8.0/             # Исходники audio effect библиотеки
│   ├── src/
│   │   ├── viper/              # Основные эффекты
│   │   │   ├── ViPER.cpp
│   │   │   ├── effects/        # 19 аудио эффектов
│   │   │   └── utils/          # 28 утилит обработки
│   │   └── ViPER4Android.cpp   # Главный класс
│   └── CMakeLists.txt          # Оригинальный CMake
└── README.md                    # Эта документация
```

## Сборка

### Компиляция только ViPER4AndroidFX:
```bash
m ViPER4AndroidFX
```

### Компиляция только библиотеки:
```bash
m libv4a_re
```

### Полная сборка:
```bash
m evolution
```

## Установка в прошивку

### Автоматическая (при сборке):
1. Установлен `TARGET_INCLUDE_VIPERFX := true` в `lineage_cerro.mk`
2. APK устанавливается в `/product/app/ViPER4AndroidFX/`
3. Библиотека устанавливается в `/vendor/lib64/soundfx/libv4a_re.so`
4. Конфигурация в `/vendor/etc/audio/sku_pineapple/audio_effects.xml`

### Проверка установки:
```bash
# Проверить APK
adb shell pm list packages | grep viper

# Проверить библиотеку
adb shell ls -la /vendor/lib64/soundfx/libv4a_re.so

# Проверить конфигурацию
adb shell grep -i v4a /vendor/etc/audio/sku_pineapple/audio_effects.xml
```

## Использование

### После установки прошивки:
1. Откройте приложение **ViPER4AndroidFX**
2. Разрешите необходимые права
3. Включите ViPER4Android
4. Настройте эффекты по своему вкусу

### Рекомендуемые пресеты:
- **Music** - для музыки
- **Movie** - для фильмов
- **Earphone/Headphone** - для наушников
- **Bluetooth** - для Bluetooth устройств

## Технические детали

### Android.bp конфигурация:

#### APK:
- **Тип**: `android_app_import` (prebuilt)
- **Привилегии**: `privileged: false`
- **Раздел**: `product_specific: true`
- **Зависимости**: `required: ["libv4a_re"]`

#### Библиотека:
- **Тип**: `cc_library_shared`
- **Раздел**: `vendor: true`
- **Оптимизация**: `-flto -O3 -DNDEBUG`
- **Путь**: `relative_install_path: "soundfx"`
- **Зависимости**: `liblog`

### Audio Effects UUID:
```
UUID: 90380da3-8536-4744-a6a3-5731970e640f
Effect Name: v4a_standard_fx
Library: libv4a_re.so
```

## Отладка

### Проверить загрузку библиотеки:
```bash
adb logcat | grep -i "viper\|v4a"
```

### Проверить audio effects:
```bash
adb shell dumpsys media.audio_flinger | grep -A 20 "ViPER\|v4a"
```

### Тест воспроизведения:
```bash
# Включить аудио эффект
adb shell settings put system viper4android_enabled 1

# Воспроизвести тестовый звук
adb shell media volume --stream 3 --set 10
```

## Возможные проблемы

### ViPER4AndroidFX не работает:
1. **Проверьте установку библиотеки**:
   ```bash
   adb shell ls -la /vendor/lib64/soundfx/libv4a_re.so
   ```

2. **Проверьте SELinux**:
   ```bash
   adb shell getenforce  # Должно быть Permissive или Enforcing с правильными политиками
   ```

3. **Проверьте logcat**:
   ```bash
   adb logcat | grep -E "AudioFlinger|AudioPolicyService|v4a"
   ```

### Библиотека не загружается:
- Проверьте наличие символов:
  ```bash
  adb shell
  cd /vendor/lib64/soundfx/
  readelf -s libv4a_re.so | grep ViPER
  ```

### APK не установлен:
- Проверьте `TARGET_INCLUDE_VIPERFX` в `lineage_cerro.mk`
- Пересоберите:
  ```bash
  m installclean
  m evolution
  ```

## Исходный код

- **ViPERFX RE**: https://github.com/AndroidAudioMods/ViPERFX_RE
- **Версия**: 8.0
- **Лицензия**: GPL-3.0

## Авторы
- Zhuhang и ViPER520 - оригинальный ViPER4Android
- Martmists и Iscle - reverse-engineering (ViPERFX RE)

## Дополнительная информация

### Производительность:
- Оптимизация: LTO + O3
- Минимальная задержка (low latency)
- Float32 обработка аудио

### Поддерживаемые аудио форматы:
- Все стандартные Android аудио форматы
- Sample rates: 8000-192000 Hz
- Bit depth: 16/24/32-bit

## Связанные файлы

- `device/nubia/cerro/device.mk` - Конфигурация установки
- `device/nubia/cerro/lineage_cerro.mk` - Флаг `TARGET_INCLUDE_VIPERFX`
- `/vendor/etc/audio/sku_pineapple/audio_effects.xml` - Audio effects конфигурация
