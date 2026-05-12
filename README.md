# EffectiveMobileToDo

Тестовое iOS-приложение для управления списком задач.

## Стек

- Swift
- UIKit
- VIPER
- CoreData
- URLSession
- GCD
- XCTest

## Возможности

- Загрузка списка задач из DummyJSON API при первом запуске
- Локальное сохранение задач в CoreData
- Восстановление задач после повторного запуска приложения
- Добавление новой задачи
- Редактирование существующей задачи
- Удаление задачи
- Изменение статуса выполнения задачи
- Поиск по названию и описанию задачи

## Архитектура

Приложение построено с использованием VIPER.

### TodoList module

- View: `TodoListViewController`
- Interactor: `TodoListInteractor`
- Presenter: `TodoListPresenter`
- Entity: `TodoTask`
- Router: `TodoListRouter`

### TodoEditor module

- View: `TodoEditorViewController`
- Interactor: `TodoEditorInteractor`
- Presenter: `TodoEditorPresenter`
- Entity: `TodoTask`
- Router: `TodoEditorRouter`

## Хранение данных

Данные сохраняются в CoreData.  
При первом запуске приложение загружает список задач из `https://dummyjson.com/todos`, сохраняет их локально и дальше использует локальное хранилище.

## Многопоточность

Сетевой запрос выполняется асинхронно через `URLSession`.  
Операции с CoreData выполняются через background context.  
Обновление интерфейса выполняется на main thread.

## Тесты

Добавлены unit-тесты для основных компонентов приложения:

- `TodoListInteractorTests`
- `TodoEditorPresenterTests`

## Запуск

1. Открыть проект в Xcode.
2. Выбрать схему `EffectiveMobileToDo`.
3. Запустить приложение через `Cmd + R`.
