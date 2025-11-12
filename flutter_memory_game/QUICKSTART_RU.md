# 🚀 Быстрый старт - Memory Game Flutter

## Минимальная инструкция для запуска

### 1️⃣ Требования

- Flutter SDK (скачать: https://flutter.dev/docs/get-started/install)
- Visual Studio Code с расширением Flutter
- Аккаунт Supabase (https://supabase.com/)

### 2️⃣ Установка (5 минут)

```bash
# Перейдите в директорию проекта
cd flutter_memory_game

# Установите зависимости
flutter pub get
```

### 3️⃣ Настройка Supabase (5 минут)

1. Создайте проект на https://supabase.com/
2. Создайте таблицу `ranking`:
   - `id` (int8, primary key, auto-increment)
   - `name` (text, unique, not null)
   - `score` (int4, not null)
   - `created_at` (timestamptz, default: now())

3. Получите ключи: Settings → API
4. Откройте `lib/main.dart` и замените:
   ```dart
   const supabaseUrl = 'ВАШ_URL';
   const supabaseAnonKey = 'ВАШ_КЛЮЧ';
   ```

### 4️⃣ Запуск

```bash
# Запустите приложение
flutter run
```

ИЛИ нажмите `F5` в VS Code

---

## 🎮 Как играть

1. Нажмите **Start**
2. Кликайте по карточкам, чтобы найти пары
3. У вас 60 секунд
4. При завершении введите имя и сохраните результат

---

## 📚 Полная документация

Смотрите [README_RU.md](README_RU.md) для подробной инструкции

---

## 🆘 Проблемы?

**Не работает Supabase?**
- Проверьте URL и ключ в `lib/main.dart`
- Убедитесь, что таблица создана

**Не загружаются изображения?**
```bash
flutter clean
flutter pub get
flutter run
```

**Медленно работает?**
```bash
flutter run --release
```

---

**Готово! Наслаждайтесь игрой! 🎉**
