# 1cWinCtrl - внешняя компонента 1С 

Предназначена для управления окнами Windows

Возможности компоненты:
- Получение списка окон и списка процессов
- Управление размерами и положением окна
- Получение снимка окна

### Свойства

- ТекущееОкно (CurrentWindow)
- АктивноеОкно (ActiveWindow)
- ИдентификаторПроцесса (ProcessId)

### Методы

- НайтиКлиентТестирования (FindTestClient)
- ПолучитьСписокПроцессов (GetProcessList)
- ПолучитьДанныеПроцесса (GetProcessInfo)
- ПолучитьСписокОкон (GetWindowList)
- УстановитьРазмерОкна (SetWindowSize)
- УстановитьПозициюОкна (SetWindowPos)
- РазрешитьИзменятьРазмер (EnableResizing)
- ПолучитьСнимокЭкрана (TakeScreenshot)
- ПолучитьСнимокОкна (CaptureWindow)
- ПолучитьЗаголовок (GetWindowText)
- УстановитьЗаголовок (SetWindowText)
- АктивироватьОкно (ActivateWindow)
- РаспахнутьОкно (MaximixeWindow)
- РазвернутьОкно (RestoreWindow)
- СвернутьОкно (MinimizeWindow)

### Сборка проекта

Готовая сборка внешней компоненты находится 
в файле /Example/Templates/SetWindow/Ext/Template.bin

Порядок самостоятельной сборки внешней компоненты из исходников:
1. Для сборки компоненты необходимо установить Visual Studio Community 2019.
2. Чтобы работала сборка примера обработки EPF надо установить OneScript версии 1.0.20 или выше.
3. Для запуска сборки из исходников надо запустить ./Compile.bat.

***

# Документация

## Свойства

## Методы

### НайтиКлиентТестирования(НомерПорта) / FindTestClient

Возвращает дескриптор главного окна клиента тестирования 1С по номеру порта, 
который был указан в командной строке при запуске приложения.

Параметры
- НомерПорта (обязательный), Тип: Целое число

Тип позвращаемого значения: Целое число
- Дескриптор найденного окна клиента тестирования
- Нулевое значение, если клиент тестирования не найден




