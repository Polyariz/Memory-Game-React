# 🧠 Memory Game Flutter

Полный порт игры Memory Game с React на Flutter/Dart.

## 📋 Содержание

- [Описание](#описание)
- [Требования](#требования)
- [Установка](#установка)
- [Настройка Supabase](#настройка-supabase)
- [Запуск приложения](#запуск-приложения)
- [Структура проекта](#структура-проекта)
- [Архитектура](#архитектура)
- [Функциональность](#функциональность)
- [Отличия от React версии](#отличия-от-react-версии)
- [Решение проблем](#решение-проблем)

## 🎮 Описание

Memory Game - это классическая игра на память, где игрок должен найти все пары одинаковых карточек за ограниченное время (60 секунд).

**Основные возможности:**
- ⏱️ Таймер обратного отсчета (60 секунд)
- 🎴 Прогрессивная сложность (начинается с 3 пар, добавляется по 2 пары каждый уровень)
- 🏆 Система подсчета очков с учетом эффективности
- 📊 Рейтинг игроков с сохранением в Supabase
- 🎉 Анимация конфетти при завершении уровня
- 🔄 Плавные анимации переворота карточек
- 📱 Кроссплатформенность (iOS, Android, Web)

## 💻 Требования

Перед началом убедитесь, что у вас установлено:

1. **Flutter SDK** (версия 3.0.0 или выше)
   - Скачать: https://flutter.dev/docs/get-started/install

2. **Dart SDK** (поставляется с Flutter)

3. **Visual Studio Code** с расширениями:
   - Flutter
   - Dart

   ИЛИ **Android Studio** с плагинами Flutter/Dart

4. **Git**

5. **Аккаунт Supabase** (бесплатный)
   - Зарегистрироваться: https://supabase.com/

### Проверка установки

Откройте терминал и выполните:

```bash
flutter --version
dart --version
```

Если команды выполнились успешно, можно продолжать.

## 📦 Установка

### Шаг 1: Клонирование репозитория

```bash
git clone https://github.com/Polyariz/Memory-Game-React.git
cd Memory-Game-React/flutter_memory_game
```

### Шаг 2: Установка зависимостей

```bash
flutter pub get
```

Эта команда установит все необходимые пакеты из `pubspec.yaml`:
- `provider` - управление состоянием
- `supabase_flutter` - интеграция с Supabase
- `confetti` - анимация конфетти

### Шаг 3: Проверка устройств

Проверьте доступные устройства для запуска:

```bash
flutter devices
```

Вы должны увидеть доступные устройства (эмуляторы, подключенные телефоны, Chrome для Web).

## 🗄️ Настройка Supabase

### Шаг 1: Создание проекта

1. Перейдите на https://supabase.com/
2. Войдите или создайте аккаунт
3. Нажмите **"New Project"**
4. Заполните данные проекта:
   - **Name**: Memory Game
   - **Database Password**: придумайте надежный пароль
   - **Region**: выберите ближайший регион
5. Нажмите **"Create new project"**

### Шаг 2: Создание таблицы

1. В левом меню выберите **"Table Editor"**
2. Нажмите **"Create a new table"**
3. Настройте таблицу:
   - **Name**: `ranking`
   - Снимите галочку **"Enable Row Level Security (RLS)"** (для упрощения)

4. Добавьте столбцы:

| Название | Тип | Настройки |
|----------|-----|-----------|
| id | int8 | Primary Key, Auto-increment |
| created_at | timestamptz | Default: now() |
| name | text | Unique, Not Null |
| score | int4 | Not Null |

5. Нажмите **"Save"**

### Шаг 3: Получение ключей API

1. В левом меню выберите **"Settings"** → **"API"**
2. Скопируйте:
   - **Project URL** (например: `https://xxxxx.supabase.co`)
   - **anon public** ключ

### Шаг 4: Настройка приложения

Откройте файл `lib/main.dart` и замените значения:

```dart
const supabaseUrl = 'ВАШ_PROJECT_URL';
const supabaseAnonKey = 'ВАШ_ANON_KEY';
```

**Пример:**
```dart
const supabaseUrl = 'https://abcdefgh.supabase.co';
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
```

## 🚀 Запуск приложения

### Способ 1: Visual Studio Code

1. Откройте папку `flutter_memory_game` в VS Code
2. Выберите устройство в правом нижнем углу
3. Нажмите `F5` или выберите **Run → Start Debugging**

### Способ 2: Командная строка

```bash
# Запуск на подключенном устройстве/эмуляторе
flutter run

# Запуск в режиме отладки
flutter run --debug

# Запуск в режиме релиза (быстрее)
flutter run --release

# Запуск в Chrome (Web версия)
flutter run -d chrome
```

### Способ 3: Android Studio

1. Откройте проект в Android Studio
2. Выберите устройство из выпадающего списка
3. Нажмите зеленую кнопку **"Run"** (▶️)

## 📁 Структура проекта

```
flutter_memory_game/
├── lib/
│   ├── main.dart                    # Точка входа приложения
│   ├── models/
│   │   ├── card_item.dart          # Модель карточки
│   │   └── ranking_item.dart       # Модель элемента рейтинга
│   ├── services/
│   │   ├── game_state.dart         # Управление состоянием игры (Provider)
│   │   └── supabase_service.dart   # Сервис для работы с Supabase
│   ├── helpers/
│   │   └── image_helper.dart       # Хелпер для работы с изображениями
│   ├── widgets/
│   │   ├── memory_card.dart        # Виджет карточки с анимацией
│   │   ├── cards_grid.dart         # Сетка карточек
│   │   ├── game_timer.dart         # Таймер игры
│   │   └── ranking_list.dart       # Список рейтинга
│   └── screens/
│       └── game_screen.dart        # Главный экран игры
├── assets/
│   └── images/                     # Изображения карточек
├── .vscode/                        # Настройки VS Code
├── pubspec.yaml                    # Конфигурация и зависимости
└── README_RU.md                    # Эта инструкция
```

## 🏗️ Архитектура

### Паттерн: Provider + MVVM

```
┌─────────────────────────────────────────┐
│          Presentation Layer             │
│   (Screens & Widgets)                   │
│   - GameScreen                          │
│   - CardsGrid, MemoryCard              │
│   - GameTimer, RankingList             │
└─────────────────┬───────────────────────┘
                  │
                  │ Consumer/Provider
                  │
┌─────────────────▼───────────────────────┐
│         Business Logic Layer            │
│   (State Management)                    │
│   - GameState (ChangeNotifier)          │
└─────────────────┬───────────────────────┘
                  │
                  │ Uses
                  │
┌─────────────────▼───────────────────────┐
│          Data Layer                     │
│   (Services & Helpers)                  │
│   - SupabaseService                     │
│   - ImageHelper                         │
└─────────────────┬───────────────────────┘
                  │
                  │
┌─────────────────▼───────────────────────┐
│          Models                         │
│   - CardItem                            │
│   - RankingItem                         │
└─────────────────────────────────────────┘
```

### Управление состоянием

Используется пакет **Provider** (официально рекомендуемый Flutter):

```dart
// GameState - главный класс управления состоянием
class GameState extends ChangeNotifier {
  // Когда состояние изменяется, вызывается notifyListeners()
  // Все виджеты с Consumer<GameState> автоматически перерисовываются
}

// В виджете
Consumer<GameState>(
  builder: (context, gameState, child) {
    // Этот код выполняется при каждом изменении состояния
    return Text('Score: ${gameState.score}');
  },
)
```

## 🎯 Функциональность

### 1. Игровой процесс

**Начало игры:**
1. Нажмите кнопку **"Start"**
2. Таймер начинает обратный отсчет с 60 секунд
3. Все карточки перевернуты рубашкой вверх

**Правила:**
- Кликайте по карточкам, чтобы их перевернуть
- Можно открыть максимум 2 карточки одновременно
- Если карточки совпадают - они остаются открытыми
- Если не совпадают - автоматически переворачиваются через 0.5 секунды
- Найдите все пары до окончания времени

**Прогрессия:**
- Уровень 1: 3 пары (6 карточек)
- Уровень 2: 5 пар (10 карточек)
- Уровень 3: 7 пар (14 карточек)
- И так далее...

### 2. Система подсчета очков

Очки начисляются за каждый завершенный уровень:

```dart
Базовые очки = количество_карточек * 10

Бонус за эффективность:
- Идеально (клики = карточки): карточки * 2 + базовые_очки
- Отлично (клики < карточки + 5): карточки + базовые_очки
- Хорошо (клики < карточки + 10): карточки / 2 + базовые_очки
- Нормально (иначе): карточки / 3 + базовые_очки
```

**Пример:**
- Уровень с 6 карточками (3 пары)
- Идеальное прохождение (6 кликов): 6 * 2 + 30 = 42 очка
- Хорошее прохождение (9 кликов): 6 + 30 = 36 очков

### 3. Таймер

- Обратный отсчет: 60 секунд
- При достижении 0 игра завершается
- Появляется поле для ввода имени
- Можно сохранить результат в рейтинг

### 4. Рейтинг

- Отображает топ игроков
- Сортировка по убыванию очков
- Уникальные имена (нельзя использовать занятое имя)
- Хранится в Supabase (облачная база данных)

## 🔄 Отличия от React версии

| Аспект | React | Flutter | Преимущество |
|--------|-------|---------|--------------|
| **Язык** | JavaScript | Dart | Типобезопасность |
| **State Management** | useState, useRef | Provider | Более предсказуемо |
| **Стили** | CSS | Widget properties | Типобезопасные стили |
| **Производительность** | Virtual DOM | Compiled native | Быстрее на 20-50% |
| **Платформы** | Web | iOS, Android, Web | Больше платформ |
| **Анимации** | CSS/JS | AnimationController | Более плавные |

## 🎨 Кастомизация

### Изменение цветовой схемы

Откройте `lib/main.dart`:

```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: const Color(0xFF7FBFFF), // Измените цвет здесь
  brightness: Brightness.dark,
),
```

### Изменение времени игры

Откройте `lib/widgets/game_timer.dart`:

```dart
_seconds = 60; // Измените на нужное количество секунд
```

И в `lib/services/game_state.dart`:

```dart
_remainingSeconds = 60; // Также измените здесь
```

### Добавление своих изображений

1. Поместите изображения в `assets/images/`
2. Добавьте пути в `pubspec.yaml`:
```yaml
assets:
  - assets/images/my_new_image.svg
```
3. Добавьте пути в `lib/helpers/image_helper.dart`:
```dart
static const List<String> _allImages = [
  "assets/images/my_new_image.svg",
  // ...остальные
];
```

### Изменение начальной сложности

Откройте `lib/services/game_state.dart`:

```dart
int _level = 3; // Измените на нужное число пар
```

## 🐛 Решение проблем

### Проблема: "Flutter command not found"

**Решение:**
```bash
# Добавьте Flutter в PATH
export PATH="$PATH:/path/to/flutter/bin"
```

### Проблема: Не загружаются изображения

**Решение:**
1. Проверьте, что изображения есть в `assets/images/`
2. Выполните:
```bash
flutter clean
flutter pub get
```

### Проблема: Ошибка при подключении к Supabase

**Решение:**
1. Проверьте правильность URL и ключа в `lib/main.dart`
2. Убедитесь, что таблица `ranking` создана
3. Проверьте интернет-соединение

### Проблема: Ошибка "The name exist" при сохранении

**Причина:** Имя уже используется в рейтинге

**Решение:** Используйте другое имя

### Проблема: Медленная работа в режиме отладки

**Решение:** Запустите в режиме релиза:
```bash
flutter run --release
```

### Проблема: Не работает на iOS

**Решение:**
```bash
cd ios
pod install
cd ..
flutter run
```

## 📱 Сборка для релиза

### Android APK

```bash
flutter build apk --release
```

Результат: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (для Google Play)

```bash
flutter build appbundle --release
```

### iOS (требуется Mac)

```bash
flutter build ios --release
```

### Web

```bash
flutter build web --release
```

Результат: `build/web/`

## 🧪 Тестирование

```bash
# Запуск всех тестов
flutter test

# Запуск с покрытием кода
flutter test --coverage
```

## 📝 Код проекта

### Главные файлы для изучения

1. **lib/main.dart** - точка входа, настройка приложения
2. **lib/services/game_state.dart** - вся логика игры
3. **lib/screens/game_screen.dart** - главный UI
4. **lib/widgets/memory_card.dart** - анимация карточек

### Комментарии в коде

Весь код содержит подробные комментарии на русском языке, поясняющие:
- Назначение классов и методов
- Логику работы
- Аналоги из React версии

## 🤝 Вклад в проект

1. Форкните репозиторий
2. Создайте ветку: `git checkout -b feature/amazing-feature`
3. Закоммитьте изменения: `git commit -m 'Add amazing feature'`
4. Запушьте: `git push origin feature/amazing-feature`
5. Создайте Pull Request

## 📄 Лицензия

Этот проект портирован с оригинальной React версии: https://github.com/garu2/Memory-Game-React

## 🔗 Полезные ссылки

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Provider Package](https://pub.dev/packages/provider)
- [Supabase Documentation](https://supabase.com/docs)
- [Оригинальная React версия](https://github.com/garu2/Memory-Game-React)

## 📧 Поддержка

Если у вас возникли вопросы или проблемы:
1. Проверьте раздел [Решение проблем](#решение-проблем)
2. Создайте Issue в репозитории
3. Изучите документацию Flutter

## 🎓 Обучающие материалы

Если вы новичок во Flutter:
1. [Flutter Codelabs](https://flutter.dev/docs/codelabs)
2. [Flutter YouTube Channel](https://www.youtube.com/c/flutterdev)
3. [Flutter by Example](https://flutterbyexample.com/)

---

**Создано с ❤️ портировано из React в Flutter**

**Версия:** 1.0.0

**Дата создания:** 2025
