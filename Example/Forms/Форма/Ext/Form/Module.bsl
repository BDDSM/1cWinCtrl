﻿&НаКлиенте
Перем ВнешняяКомпонента;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МакетКомпоненты = РеквизитФормыВЗначение("Объект").ПолучитьМакет("SetWindow");
	МестоположениеКомпоненты = ПоместитьВоВременноеХранилище(МакетКомпоненты, УникальныйИдентификатор);
	
	ЗапретитьИзменятьРазмер = Истина;
	РазмерПоГоризонтали = 1280;
	РазмерПоВертикали = 960;
	ПортПодключения = 48000;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	//МестоположениеКомпоненты = "C:\1CVanessa\1cWinCtrl\bin64\WindowsControlWin64.dll";
	//Файл = Новый Файл(МестоположениеКомпоненты);
	//
	//Если Файл.Существует() Тогда 
	//	НачатьПодключениеВнешнейКомпоненты(
	//		Новый ОписаниеОповещения("ПодключениеВнешнейКомпонентыЗавершение", ЭтаФорма, Истина),
	//		МестоположениеКомпоненты, "SetWindow", ТипВнешнейКомпоненты.Native
	//	); 
	//КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьКомпоненту(Команда)

	ОписаниеОповещения = Новый ОписаниеОповещения("УстановкаВнешнейКомпонентыЗавершение", ЭтаФорма, Ложь);
	НачатьУстановкуВнешнейКомпоненты(ОписаниеОповещения, МестоположениеКомпоненты);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьКомпоненту(Команда)

	НачатьПодключениеВнешнейКомпоненты(
		Новый ОписаниеОповещения("ПодключениеВнешнейКомпонентыЗавершение", ЭтаФорма, Ложь),
		МестоположениеКомпоненты, "SetWindow", ТипВнешнейКомпоненты.Native
	); 
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключениеВнешнейКомпонентыЗавершение(Подключение, ДополнительныеПараметры) Экспорт
	
	Если Подключение Тогда
		ВнешняяКомпонента = Новый("AddIn.SetWindow.WindowsControl");
	Иначе
		ОписаниеОповещения = Новый ОписаниеОповещения("УстановкаВнешнейКомпонентыЗавершение", ЭтаФорма, Ложь);
		НачатьУстановкуВнешнейКомпоненты(ОписаниеОповещения, МестоположениеКомпоненты);
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура УстановкаВнешнейКомпонентыЗавершение(ДополнительныеПараметры) Экспорт
	
	ПодключитьКомпоненту(Неопределено);
	
КонецПроцедуры	

&НаКлиенте
Функция ПрочитатьСтрокуJSON(ТекстJSON)
	
	ЧтениеJSON = Новый ЧтениеJSON();
	ЧтениеJSON.УстановитьСтроку(ТекстJSON);
	Возврат ПрочитатьJSON(ЧтениеJSON);
	
КонецФункции

&НаКлиенте
Процедура ПолучитьСписокПроцессов(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПолученСписокПроцессов", ЭтотОбъект);
	ВнешняяКомпонента.НачатьВызовПолучитьСписокПроцессов(ОписаниеОповещения, "1cv8");
	
КонецПроцедуры

&НаКлиенте
Процедура ПолученСписокПроцессов(РезультатВызова, ПараметрыВызова, ДополнительныеПараметры) Экспорт
	
	Данные = ПрочитатьСтрокуJSON(РезультатВызова);
	Если ТипЗнч(Данные) = Тип("Массив") Тогда
		СписокПроцессов.Очистить();
		Для каждого Стр из Данные Цикл
			НоваяСтр = СписокПроцессов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтр, Стр);
			НоваяСтр.CreationDate = Дата(Лев(Стр.CreationDate, 14));
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура ПолучитьДанныеПроцесса(Команда)
	
	ТекущиеДанные = Элементы.СписокПроцессов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда Возврат КонецЕсли;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПолученыДанныеПроцесса", ЭтотОбъект);
	ВнешняяКомпонента.НачатьВызовПолучитьДанныеПроцесса(ОписаниеОповещения, ТекущиеДанные.ProcessId);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолученыДанныеПроцесса(РезультатВызова, ПараметрыВызова, ДополнительныеПараметры) Экспорт
	
	Данные = ПрочитатьСтрокуJSON(РезультатВызова);
	Если ТипЗнч(Данные) = Тип("Структура") Тогда
		ДанныеПроцесса.Очистить();
		Для каждого КлючЗначение из Данные Цикл
			НоваяСтр = ДанныеПроцесса.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтр, КлючЗначение);
		КонецЦикла;
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаДанныеПроцесса;
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура ПолучитьСписокОкон(Команда)

	ОписаниеОповещения = Новый ОписаниеОповещения("ПолученСписокОкон", ЭтотОбъект);
	ВнешняяКомпонента.НачатьВызовПолучитьСписокОкон(ОписаниеОповещения);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПолученоТекущееОкно", ЭтотОбъект);
	ВнешняяКомпонента.НачатьПолучениеТекущееОкно(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолученСписокОкон(РезультатВызова, ПараметрыВызова, ДополнительныеПараметры) Экспорт
	
	Данные = ПрочитатьСтрокуJSON(РезультатВызова);
	Если ТипЗнч(Данные) = Тип("Массив") Тогда
		СписокОкон.Очистить();
		Для каждого Стр из Данные Цикл
			ЗаполнитьЗначенияСвойств(СписокОкон.Добавить(), Стр);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура ПолученоТекущееОкно(Значение, ДополнительныеПараметры) Экспорт
	
	Для каждого Стр из СписокОкон.НайтиСтроки(Новый Структура("hwnd", Значение)) Цикл
		Элементы.СписокОкон.ТекущаяСтрока = Стр.ПолучитьИдентификатор();
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОконПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.СписокОкон.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ДескрипторОкна = 0;
		ЗаголовокОкна = "";
	Иначе
		ДескрипторОкна = ТекущиеДанные.hwnd;
		ЗаголовокОкна = ТекущиеДанные.text;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРазмер(ПозицияПоГоризонтали, ПозицияПоВертикали, РазмерПоГоризонтали, РазмерПоВертикали)

	Если ДескрипторОкна = 0 Тогда 
		ДескрипторОкна = ВнешняяКомпонента.ТекущееОкно; 
	КонецЕсли;
	
	ВнешняяКомпонента.УстановитьРазмерОкна(ДескрипторОкна, РазмерПоГоризонтали, РазмерПоВертикали);
	ВнешняяКомпонента.УстановитьПозициюОкна(ДескрипторОкна, ПозицияПоГоризонтали, ПозицияПоВертикали);
	ВнешняяКомпонента.РазрешитьИзменятьРазмер(ДескрипторОкна, НЕ ЗапретитьИзменятьРазмер);
	ВнешняяКомпонента.АктивироватьОкно(ДескрипторОкна);
	
КонецПроцедуры

#Область ТипичныеРазмерыОкон

&НаКлиенте
Процедура ПроизвольныйРазмер(Команда)

	УстановитьРазмер(ПозицияПоГоризонтали, ПозицияПоВертикали, РазмерПоГоризонтали, РазмерПоВертикали);
	
КонецПроцедуры

&НаКлиенте
Процедура Размер800х600(Команда)
	УстановитьРазмер(0, 0, 800, 600);
КонецПроцедуры

&НаКлиенте
Процедура Размер960х720(Команда)
	УстановитьРазмер(0, 0, 960, 720);
КонецПроцедуры

&НаКлиенте
Процедура Размер1024х768(Команда)
	УстановитьРазмер(0, 0, 1024, 768);
КонецПроцедуры

&НаКлиенте
Процедура Размер1280х960(Команда)
	УстановитьРазмер(0, 0, 1280, 960);
КонецПроцедуры

&НаКлиенте
Процедура Широкий960х540(Команда)
	УстановитьРазмер(0, 0, 960, 540);
КонецПроцедуры

&НаКлиенте
Процедура Широкий1024х576(Команда)
	УстановитьРазмер(0, 0, 1024, 576);
КонецПроцедуры

&НаКлиенте
Процедура Широкий1280х720(Команда)
	УстановитьРазмер(0, 0, 1280, 720);
КонецПроцедуры

&НаКлиенте
Процедура Широкий1600х900(Команда)
	УстановитьРазмер(0, 0, 1600, 900);
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура СделатьСнимок(Команда)
	
	ДвоичныеДанные = ВнешняяКомпонента.ПолучитьСнимокОкна(ДескрипторОкна);
	ДанныеКартинки = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаКартинка;
	
КонецПроцедуры

&НаКлиенте
Процедура СнимокЭкрана(Команда)

	ДвоичныеДанные = ВнешняяКомпонента.ПолучитьСнимокЭкрана(0);
	ДанныеКартинки = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаКартинка;
	
КонецПроцедуры

&НаКлиенте
Процедура СнимокОкна(Команда)
	
	ДвоичныеДанные = ВнешняяКомпонента.ПолучитьСнимокЭкрана(1);
	ДанныеКартинки = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаКартинка;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗаголовокОкна(Команда)

	НовыйЗаголовок = Строка(Новый УникальныйИдентификатор);
	ВнешняяКомпонента.НачатьВызовУстановитьЗаголовок(Новый ОписаниеОповещения, ДескрипторОкна, НовыйЗаголовок);
	
КонецПроцедуры

&НаКлиенте
Процедура Активировать(Команда)
	
	ВнешняяКомпонента.НачатьВызовАктивироватьОкно(Новый ОписаниеОповещения, ДескрипторОкна);
	
КонецПроцедуры

&НаКлиенте
Процедура Распахнуть(Команда)

	ВнешняяКомпонента.НачатьВызовРаспахнутьОкно(Новый ОписаниеОповещения, ДескрипторОкна);
	
КонецПроцедуры

&НаКлиенте
Процедура Свернуть(Команда)
	
	ВнешняяКомпонента.НачатьВызовСвернутьОкно(Новый ОписаниеОповещения, ДескрипторОкна);
	
КонецПроцедуры

&НаКлиенте
Процедура Развернуть(Команда)

	ВнешняяКомпонента.НачатьВызовРазвернутьОкно(Новый ОписаниеОповещения, ДескрипторОкна);
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиКлиентТестирования(Команда)

	Перем ДанныеПроцесса;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПолученКлиентТестирования", ЭтотОбъект);
	ВнешняяКомпонента.НачатьВызовНайтиКлиентТестирования(ОписаниеОповещения, ПортПодключения, ДанныеПроцесса);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолученКлиентТестирования(РезультатВызова, ПараметрыВызова, ДополнительныеПараметры) Экспорт
	
	ДескрипторОкна = РезультатВызова;
	
	Если ТипЗнч(ПараметрыВызова) = Тип("Массив") Тогда
		Если ПараметрыВызова.Количество() > 1 Тогда
			Данные = ПрочитатьСтрокуJSON(ПараметрыВызова[1]);
			Если ТипЗнч(Данные) = Тип("Структура") Тогда
				ДанныеПроцесса.Очистить();
				Для каждого КлючЗначение из Данные Цикл
					НоваяСтр = ДанныеПроцесса.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтр, КлючЗначение);
				КонецЦикла;
				Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаДанныеПроцесса;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры	
