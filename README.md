# Smart Wallet - iOS Trading App

<div align="center">
  <img src="https://img.shields.io/badge/iOS-15.0+-blue.svg" alt="iOS Version">
  <img src="https://img.shields.io/badge/Swift-5.0+-orange.svg" alt="Swift Version">
  <img src="https://img.shields.io/badge/SwiftUI-Required-green.svg" alt="SwiftUI">
  <img src="https://img.shields.io/badge/Architecture-MVVM%20+%20Coordinator-lightgrey.svg" alt="Architecture">
</div>

## 📱 Описание

**Smart Wallet** - это современное iOS приложение для торговли акциями и отслеживания финансовых рынков. Приложение предоставляет пользователям возможность отслеживать рыночные индексы, управлять портфелем акций, читать финансовые новости и анализировать графики в реальном времени.

## ✨ Основные возможности

### 🏠 Главная страница (Home)
- **Рыночные индексы**: Отслеживание основных мировых индексов (S&P 500, NASDAQ, Dow Jones, Nikkei 225, FTSE)
- **Интерактивные графики**: Детальные графики с возможностью выбора временных интервалов (1д, 3м, 6м, 1г)
- **Поиск акций**: Быстрый поиск акций по символу или названию компании
- **Реальное время**: Обновление данных в реальном времени

### 👁️ Список наблюдения (Watchlist)
- **Персональный список**: Добавление интересующих акций в список наблюдения
- **Быстрый доступ**: Удобный просмотр избранных акций
- **Динамическое обновление**: Автоматическое обновление цен и изменений

### 📊 Портфолио (Snaps)
- **Управление портфелем**: Отслеживание общего баланса и прибыли
- **Инвестиционные возможности**: Показ доступных средств для инвестиций
- **Детальная аналитика**: Анализ каждой позиции в портфеле
- **Управление средствами**: Добавление средств и сброс аккаунта

### 📰 Новости (News)
- **Финансовые новости**: Актуальные новости финансового рынка
- **Детальный просмотр**: Полные статьи с изображениями
- **Категоризация**: Структурированный просмотр новостей

## 🏗️ Архитектура

Приложение построено с использованием современной архитектуры **MVVM + Coordinator Pattern**:

### 📁 Структура проекта

```
grdWrk/
├── Application/           # Основные файлы приложения
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   └── Assets.xcassets/
├── Coordinator/           # Координаторы навигации
│   ├── AppCoordinator.swift
│   ├── grdWrkCoordinator.swift
│   └── CrowTraderCoordinator.swift
├── Model/                 # Модели данных
│   ├── StockData.swift
│   ├── BalanceItem.swift
│   ├── NewsData.swift
│   └── CoreDataController.swift
├── View/                  # SwiftUI представления
│   ├── MainPageView.swift
│   ├── WatchListView.swift
│   ├── SnapsListView.swift
│   ├── NewsListView.swift
│   └── styles/
├── ViewModels/            # ViewModels для MVVM
│   ├── MainScreenViewModel.swift
│   ├── WatchListViewModel.swift
│   ├── SnapsViewModel.swift
│   └── NewsScreenViewModel.swift
├── Networking/            # Сетевой слой
│   ├── APIManaging.swift
│   ├── StockDataRouter.swift
│   └── NewsDataRouter.swift
├── Services/              # Бизнес-логика
│   ├── BalanceService.swift
│   └── StockItemService.swift
└── DependencyInjection/   # Внедрение зависимостей
    └── DIContainer.swift
```

### 🔧 Технологический стек

- **UI Framework**: SwiftUI
- **Архитектура**: MVVM + Coordinator Pattern
- **Сетевое взаимодействие**: URLSession + Async/Await
- **Локальное хранение**: Core Data
- **Внедрение зависимостей**: Custom DI Container
- **API**: Yahoo Finance API
- **Графики**: SwiftUI Charts

## 🚀 Установка и запуск

### Требования

- iOS 15.0+
- Xcode 14.0+
- Swift 5.0+

### Шаги установки

1. **Клонирование репозитория**
   ```bash
   git clone https://github.com/your-username/grkWkrk.git
   cd grkWkrk
   ```

2. **Открытие проекта**
   ```bash
   open grdWrk.xcodeproj
   ```

3. **Настройка API ключей** (если требуется)
   - Откройте `Networking/StockDataRouter.swift`
   - При необходимости добавьте API ключи для Yahoo Finance

4. **Сборка и запуск**
   - Выберите симулятор или устройство
   - Нажмите `Cmd + R` для запуска

## 📊 API интеграция

Приложение использует **Yahoo Finance API** для получения данных:

- **Рыночные данные**: Цены акций, объемы торгов, изменения
- **Поиск акций**: Поиск по символу или названию
- **Графические данные**: Исторические данные для построения графиков
- **Новости**: Финансовые новости и аналитика

### Основные эндпоинты

```swift
// Получение данных графика
StockDataRouter.chart(symbol: String, timeframe: String)

// Поиск акций
StockDataRouter.search(symbol: String)

// Получение новостей
NewsDataRouter.getNews()
```

## 🎨 UI/UX особенности

### Дизайн-система
- **Цветовая схема**: Зеленый акцент (#00FF00) для финансовой тематики
- **Градиенты**: Красивые фоновые градиенты для современного вида
- **Адаптивность**: Поддержка различных размеров экранов
- **Анимации**: Плавные переходы и интерактивные элементы

### Ключевые компоненты
- **SearchField**: Умное поле поиска с автодополнением
- **StockChartView**: Интерактивные графики с SwiftUI Charts
- **LoadingView**: Индикаторы загрузки
- **BackgroundLinearGradient**: Красивые фоновые градиенты

## 🔄 Жизненный цикл приложения

1. **AppDelegate** → Инициализация приложения
2. **AppCoordinator** → Настройка основной навигации
3. **TabController** → Управление табами приложения
4. **ViewModels** → Обработка бизнес-логики
5. **Views** → Отображение пользовательского интерфейса

## 📱 Основные экраны

### Главная страница
- Отображение рыночных индексов
- Интерактивный график выбранной акции
- Поиск акций
- Выбор временных интервалов

### Список наблюдения
- Персональный список акций
- Быстрый поиск и добавление
- Отображение текущих цен

### Портфолио
- Общий баланс и прибыль
- Детализация по позициям
- Управление средствами

### Новости
- Список финансовых новостей
- Детальный просмотр статей
- Изображения и описания

## 🛠️ Разработка

### Добавление новой функциональности

1. **Создание модели** в папке `Model/`
2. **Добавление ViewModel** в папке `ViewModels/`
3. **Создание View** в папке `View/`
4. **Настройка координатора** в папке `Coordinator/`
5. **Добавление в DI контейнер**

### Стили кода

- **SwiftUI**: Использование современных возможностей SwiftUI
- **Async/Await**: Асинхронное программирование
- **MVVM**: Строгое разделение логики и представления
- **Protocol-oriented**: Использование протоколов для абстракции

## 🧪 Тестирование

Проект включает базовую структуру для тестирования:

- **Unit Tests**: `grdWrkTests/`
- **UI Tests**: `grdWrkUITests/`

### Запуск тестов
```bash
# Все тесты
xcodebuild test -project grdWrk.xcodeproj -scheme grdWrk

# Только unit тесты
xcodebuild test -project grdWrk.xcodeproj -scheme grdWrk -only-testing:grdWrkTests
```

## 📄 Лицензия

Этот проект распространяется под лицензией MIT. См. файл `LICENSE` для получения дополнительной информации.

## 👥 Команда

- **Разработчик**: [Ваше имя]
- **Дизайн**: [Дизайнер]
- **Тестирование**: [Тестировщик]

## 🤝 Вклад в проект

1. Форкните репозиторий
2. Создайте ветку для новой функции (`git checkout -b feature/amazing-feature`)
3. Зафиксируйте изменения (`git commit -m 'Add amazing feature'`)
4. Отправьте в ветку (`git push origin feature/amazing-feature`)
5. Откройте Pull Request

## 📞 Контакты

- **Email**: [your-email@example.com]
- **GitHub**: [@your-username]
- **LinkedIn**: [your-linkedin]

---

<div align="center">
  <p>Сделано с ❤️ для iOS разработчиков</p>
  <p>Smart Wallet - Ваш умный финансовый помощник</p>
</div>