﻿Перем ирПортативный Экспорт;
Перем ирОбщий Экспорт;
Перем ирСервер Экспорт;
Перем ирКэш Экспорт;
Перем ирПривилегированный Экспорт;

// Обновляет доступные колонки и значения колонок на странице "Обработка".
//
// Параметры:
//  Нет.
//
Процедура НастроитьПостроительОтчета()
	
	ЭлементыФормы.ПолеВыбораКолонки.СписокВыбора.Очистить();
	Если СвязанноеТабличноеПоле = Неопределено Тогда
		Возврат;
	КонецЕсли;
	НастройкиПостроителя = ПостроительОтчета.ПолучитьНастройки();
	НастройкиКомпоновки = Компоновщик.ПолучитьНастройки();
	
	СписокСоВсемиКолонками = СвязанноеТабличноеПоле.Значение;
	ТипСписка = ТипЗнч(СвязанноеТабличноеПоле.Значение);
	ОбъектМД = Метаданные.НайтиПоТипу(ТипСписка);
	Если ОбъектМД <> Неопределено Тогда
		Попытка
			ЕстьКолонки = СписокСоВсемиКолонками.Колонки;
		Исключение
			ЕстьКолонки = Неопределено;
		КонецПопытки;
		Если ЕстьКолонки <> Неопределено Тогда
			// Такой прием нужен для получения всех колонок списка
			МассивФрагментов = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(ОбъектМД.ПолноеИмя());
			Если МассивФрагментов.Количество() = 2 Тогда
				лТабличноеПоле = ЭлементыФормы.Добавить(Тип("ТабличноеПоле"),
					ирКэш.Получить().ПолучитьИдентификаторИзПредставления(Новый УникальныйИдентификатор), Ложь);
				лТабличноеПоле.ТипЗначения = Новый ОписаниеТипов(МассивФрагментов[0] + "Список." + МассивФрагментов[1]);
				СписокСоВсемиКолонками = лТабличноеПоле.Значение;
				КолонкиСписка = СписокСоВсемиКолонками.Колонки;
				лТабличноеПоле.СоздатьКолонки();
				лКомпоновщик = ирКэш.ПолучитьКомпоновщикТаблицыМетаданныхЛкс(ОбъектМД.ПолноеИмя());
				#Если _ Тогда
				    лКомпоновщик = Новый КомпоновщикНастроекКомпоновкиДанных;
				#КонецЕсли
				Для Каждого ДоступноеПоле Из лКомпоновщик.Настройки.ДоступныеПоляВыбора.Элементы Цикл
					Если ДоступноеПоле.Папка Тогда
						Продолжить;
					КонецЕсли; 
					Попытка
						КолонкиСписка.Добавить("" + ДоступноеПоле.Поле, Ложь);
					Исключение
					КонецПопытки;
				КонецЦикла;
				ЭлементыФормы.Удалить(лТабличноеПоле);
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	
	ПостроительОтчета.ИсточникДанных = Новый ОписаниеИсточникаДанных(СписокСоВсемиКолонками);
	Если ТипИсточника <> "Список" Тогда 
		Если Ложь
			Или Не СвязанноеТабличноеПоле.Видимость
			Или Не СвязанноеТабличноеПоле.Доступность
			Или СвязанноеТабличноеПоле.ТолькоПросмотр
		Тогда
			ПостроительОтчета.ДоступныеПоля.Очистить();
			Возврат;
		КонецЕсли;
	КонецЕсли;
	Для Каждого ДоступноеПоле Из ПостроительОтчета.ДоступныеПоля Цикл
		ДоступноеПоле.Отбор = Ложь;
		ДоступноеПоле.Представление = ирОбщий.ПолучитьПредставлениеИзИдентификатораЛкс(ДоступноеПоле.Имя);
	КонецЦикла;
	Если Ложь
		Или ТипИсточника = "ТабличнаяЧасть"
		Или ТипИсточника = "НаборЗаписей"
	Тогда
		ПостроительОтчета.ДоступныеПоля.НомерСтроки.Порядок = Ложь;
	КонецЕсли;
	ТекущаяСтрокаПорядка = ЭлементыФормы.ПорядокКомпоновщика.ТекущаяСтрока;
	Если Истина
		И ТекущаяСтрокаПорядка <> Неопределено
		И ТипЗнч(ТекущаяСтрокаПорядка) <> Тип("АвтоЭлементПорядкаКомпоновкиДанных")
	Тогда
		СтароеТекущееПолеПорядка = ТекущаяСтрокаПорядка.Поле;
	КонецЕсли;
	СхемаКомпоновки = ирОбщий.СоздатьСхемуПоПолямНастройкиЛкс(ПостроительОтчета.ДоступныеПоля);
	Компоновщик.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновки));
	Компоновщик.ЗагрузитьНастройки(НастройкиКомпоновки);
	Для Каждого ЭлементПорядка Из Компоновщик.Настройки.Порядок.Элементы Цикл
		Если ЭлементПорядка.Поле = СтароеТекущееПолеПорядка Тогда
			ЭлементыФормы.ПорядокКомпоновщика.ТекущаяСтрока = ЭлементПорядка;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Компоновщик.Восстановить();
	ПостроительОтчета.УстановитьНастройки(НастройкиПостроителя);

	НачальноеКоличество = ПостроительОтчета.ДоступныеПоля.Количество(); 
	Для СчетчикДоступныеПоля = 1 По НачальноеКоличество Цикл
		ДоступноеПоле = ПостроительОтчета.ДоступныеПоля[НачальноеКоличество - СчетчикДоступныеПоля];
		Если ПустаяСтрока(ДоступноеПоле.ПутьКДанным) Тогда 
			// Так и не понял, откуда они берутся
			ПостроительОтчета.ДоступныеПоля.Удалить(ДоступноеПоле);
			Продолжить;
		КонецЕсли;
	КонецЦикла;
	
	// Подготовка страницы "Обработка"
	СоответствиеКолонокДанным = Новый Структура;
	СписокВыбораКолонки = ЭлементыФормы.ПолеВыбораКолонки.СписокВыбора;
	Для Каждого Колонка Из СвязанноеТабличноеПоле.Колонки Цикл
		ДанныеКолонки = Колонка.Данные;
		Если ДанныеКолонки = "" Тогда
			ДанныеКолонки = Колонка.ДанныеФлажка;
		КонецЕсли; 
		Если ДанныеКолонки <> "" Тогда
			СоответствиеКолонокДанным.Вставить(ДанныеКолонки, Колонка.Имя);
			ДоступноеПолеКолонки = ПостроительОтчета.ДоступныеПоля.Найти(ДанныеКолонки);
			Если ДоступноеПолеКолонки = Неопределено Тогда
				// Сюда попадает по крайней мере "ВидДокумента"
				Продолжить;
			КонецЕсли;
			//ПостроительОтчета.ДоступныеПоля[ДанныеКолонки].Имя = Колонка.Имя;
			Если Не ПустаяСтрока(Колонка.ТекстШапки) Тогда
				ДоступноеПолеКолонки.Представление = Колонка.ТекстШапки;
			КонецЕсли;
			Если Не ирОбщий.ЛиИнтерактивноДоступнаяКолонкаЛкс(Колонка) Тогда
				Продолжить;
			КонецЕсли; 
			// **** Поля выбора пока не поддерживаются
			Если ТипЗнч(Колонка.ЭлементУправления) = Тип("ПолеВыбора") Тогда
				Продолжить;
			КонецЕсли;
			СписокВыбораКолонки.Добавить(ДоступноеПолеКолонки.Имя, Колонка.ТекстШапки);
		КонецЕсли;
	КонецЦикла;
	
	Если СписокВыбораКолонки.Количество() = 0 Тогда
		НовоеПолеДляОбработки = Неопределено;
	Иначе
		ЭлементСпискаВыбраннойКолонки = СписокВыбораКолонки.НайтиПоЗначению(ПолеВыбораКолонки);
		Если ЭлементСпискаВыбраннойКолонки <> Неопределено Тогда 
			НовоеПолеДляОбработки = ЭлементСпискаВыбраннойКолонки.Значение;
		Иначе
			НовоеПолеДляОбработки = СписокВыбораКолонки[0].Значение;
			Если СвязанноеТабличноеПоле.ТекущаяКолонка <> Неопределено Тогда
				ДанныеКолонки = СвязанноеТабличноеПоле.ТекущаяКолонка.Данные;
				ЭлементСпискаТекущейКолонки = СписокВыбораКолонки.НайтиПоЗначению(ДанныеКолонки);
				Если ЭлементСпискаТекущейКолонки <> Неопределено Тогда 
					НовоеПолеДляОбработки = ЭлементСпискаТекущейКолонки.Значение;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Если ПолеВыбораКолонки <> НовоеПолеДляОбработки Тогда
		ирОбщий.ИнтерактивноЗаписатьВЭлементУправленияЛкс(ЭлементыФормы.ПолеВыбораКолонки, НовоеПолеДляОбработки, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры // НастроитьПостроительОтчета()

// Закрывает связанные формы выбора. 
//
// Параметры:
//  Нет.
//
Процедура ЗакрытьФормыВыбора()

	Для Каждого ФормаВыбора Из СозданныеФормыВыбора Цикл
		Если ФормаВыбора.Открыта() Тогда 
			ФормаВыбора.Закрыть();
			ФормаВыбора = Неопределено;
		КонецЕсли;
	КонецЦикла;
	СозданныеФормыВыбора.Очистить();

КонецПроцедуры // ЗакрытьФормыВыбора()

// Проверяет возможность соединения с табличным полем и устанавливает связь с его отбором.
//
// Параметры:
//  *пТабличноеПоле – ТабличноеПоле, *Неопределено – новое табличное поле для установки связи;
//  *пЛиТолькоПроверить - Булево, *Ложь - признак выполнения только проверки на возможность.
//
// Возвращаемое значение:
//  Истина       – Булево – связь можно установить;
//  Ложь         – Булево – связь нельзя установить.
//
Функция УстановитьСвязь(пТабличноеПоле = Неопределено, пЛиТолькоПроверить = Ложь) Экспорт

	Если пТабличноеПоле = Неопределено Тогда
		пТабличноеПоле = СвязанноеТабличноеПоле;
	КонецЕсли;
	Попытка
		ЗначениеТабличногоПоля = пТабличноеПоле.Значение;
	Исключение
		// Форма-владелец табличного поля уже была закрыта
		Если пТабличноеПоле = СвязанноеТабличноеПоле Тогда 
			ЭлементыФормы.ОсновнаяПанель.Страницы.Отбор.Видимость     = Ложь;
			ЭлементыФормы.ОсновнаяПанель.Страницы.Порядок.Видимость   = Ложь;
			ЭлементыФормы.ОсновнаяПанель.Страницы.Обработка.Видимость = Ложь;
			ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок, , , ": ");
			Соединитель[0].Текст = "Перетащите эту ячейку на нужное табличное поле";
			ЗакрытьФормыВыбора();
		КонецЕсли;
		Возврат Ложь;
	КонецПопытки;
	ТипИсточника = "";
	ОтборТабличногоПоля = Неопределено;
	НастройкаОтбораТабличногоПоля = Неопределено;
	ПорядокТабличногоПоля = Неопределено;
	НастройкаПорядкаТабличногоПоля = Неопределено;
	СтруктураТипа = ирКэш.Получить().ПолучитьСтруктуруТипаИзЗначения(ЗначениеТабличногоПоля);
	Если СтруктураТипа.ИмяОбщегоТипа = "ТаблицаЗначений" Тогда 
		ТипИсточника = "ТаблицаЗначений";
	ИначеЕсли СтруктураТипа.ИмяОбщегоТипа = "ДеревоЗначений" Тогда 
		ТипИсточника = "ДеревоЗначений";
	Иначе
		Если Найти(СтруктураТипа.ИмяОбщегоТипа, "<Имя табличной части>") > 0 Тогда 
			ТипИсточника = "ТабличнаяЧасть";
			ОтборТабличногоПоля = пТабличноеПоле.ОтборСтрок;
			НастройкаОтбораТабличногоПоля = пТабличноеПоле.НастройкаОтбораСтрок;
		ИначеЕсли Найти(СтруктураТипа.ИмяОбщегоТипа, "НаборЗаписей.") > 0 Тогда
			ТипИсточника = "НаборЗаписей";
			ОтборТабличногоПоля = пТабличноеПоле.ОтборСтрок;
			НастройкаОтбораТабличногоПоля = пТабличноеПоле.НастройкаОтбораСтрок;
		ИначеЕсли Найти(СтруктураТипа.ИмяОбщегоТипа, "Список.") > 0 Тогда 
			ТипИсточника = "Список";
			ОтборТабличногоПоля = ЗначениеТабличногоПоля.Отбор;
			НастройкаОтбораТабличногоПоля = пТабличноеПоле.НастройкаОтбора;
			ПорядокТабличногоПоля = ЗначениеТабличногоПоля.Порядок;
			НастройкаПорядкаТабличногоПоля = пТабличноеПоле.НастройкаПорядка;
		КонецЕсли;
	КонецЕсли;
	
	Если ТипИсточника = "" Тогда 
		Возврат Ложь;
	КонецЕсли;
	Если Не пЛиТолькоПроверить Тогда  
		УстановитьПорядок = пТабличноеПоле <> СвязанноеТабличноеПоле;
		СвязанноеТабличноеПоле = пТабличноеПоле;
		Отбор = ОтборТабличногоПоля;
		Порядок = ПорядокТабличногоПоля;
		НастройкаОтбора = НастройкаОтбораТабличногоПоля;
		
		Для Каждого ЭлементОтбора Из Отбор Цикл
			Если ЭлементОтбора.Использование Тогда
				Продолжить;
			КонецЕсли;
			Если ЭлементОтбора.ТипЗначения.СодержитТип(Тип("Строка")) Тогда
				ЭлементОтбора.ВидСравнения = ВидСравнения.Содержит;
			КонецЕсли;
		КонецЦикла;
		НастроитьПостроительОтчета();
		Если УстановитьПорядок Тогда 
			ирОбщий.ТрансформироватьПорядокВПорядокКомпоновкиЛкс(Компоновщик.Настройки.Порядок, Порядок);
		КонецЕсли;
        ВидимостьОтбора = (Отбор.Количество() > 0);
		ЭлементыФормы.ОсновнаяПанель.Страницы.Отбор.Видимость = ВидимостьОтбора;
		ВидимостьОбработки = Ложь;
		ВидимостьПорядка = (ПостроительОтчета.ДоступныеПоля.Количество() > 0);
		Если Ложь
			Или ТипИсточника = "ТабличнаяЧасть"
			Или ТипИсточника = "НаборЗаписей"
			Или ТипИсточника = "ТаблицаЗначений"
			Или ТипИсточника = "ДеревоЗначений"
		Тогда
			Если Ложь
				Или СвязанноеТабличноеПоле.ТолькоПросмотр
				Или Не СвязанноеТабличноеПоле.ИзменятьПорядокСтрок
				Или (Истина
					И ТипЗнч(ЭтаФорма.ВладелецФормы) = Тип("Форма")
					И ЭтаФорма.ВладелецФормы.ТолькоПросмотр)
			Тогда
				ВидимостьПорядка = Ложь;
			КонецЕсли;
			ВидимостьОбработки = (ЭлементыФормы.ПолеВыбораКолонки.СписокВыбора.Количество() > 0);
		КонецЕсли;
		ЭлементыФормы.ОсновнаяПанель.Страницы.Обработка.Видимость = ВидимостьОбработки;
		ЭлементыФормы.ОсновнаяПанель.Страницы.Порядок.Видимость = ВидимостьПорядка;
		
		ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок, , СвязанноеТабличноеПоле.Имя, ": ");
		Соединитель[0].Текст = "" + ТипЗнч(СвязанноеТабличноеПоле.Значение) + " (двойной клик обновляет связь)";
		Если ВидимостьОтбора Тогда 
			УправлениеИерархиейТабличногоПоля();
			Если Не Открыта() Тогда
				ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.Отбор;
			КонецЕсли;
		КонецЕсли;
		//СтараяТекущаяСтраница = ЭтаФорма.ЭлементыФормы.ОсновнаяПанель.ТекущаяСтраница;
		//ЭтаФорма.ЭлементыФормы.ОсновнаяПанель.ТекущаяСтраница = СтараяТекущаяСтраница;
		Если УстановитьПорядок Тогда
			ЗакрытьФормыВыбора();
			ЭлементыФормы.Отбор.ТекущаяКолонка = ЭлементыФормы.Отбор.Колонки.Значение;
			Если СвязанноеТабличноеПоле.ТекущаяКолонка <> Неопределено Тогда
				ДанныеКолонки = СвязанноеТабличноеПоле.ТекущаяКолонка.Данные;
				Если Не ЗначениеЗаполнено(ДанныеКолонки) Тогда
					ДанныеКолонки = СвязанноеТабличноеПоле.ТекущаяКолонка.ДанныеФлажка;
				КонецЕсли; 
				Если Истина
					И (Ложь
						Или ТипИсточника = "ТаблицаЗначений"
						Или ТипИсточника = "ДеревоЗначений")
					И Не ЗначениеЗаполнено(ДанныеКолонки)
				Тогда
					ДанныеКолонки = СвязанноеТабличноеПоле.ТекущаяКолонка.ДанныеКартинки;
				КонецЕсли; 
				ТекущиЭлементПорядка = Компоновщик.Настройки.ДоступныеПоляПорядка.НайтиПоле(Новый ПолеКомпоновкиДанных(ДанныеКолонки));
				Если ТекущиЭлементПорядка <> Неопределено Тогда
					ЭлементыФормы.ДоступныеПоляПорядка.ТекущаяСтрока = ТекущиЭлементПорядка;
				КонецЕсли;
				ТекущиЭлементОтбора = Отбор.Найти(ДанныеКолонки);
				Если ТекущиЭлементОтбора <> Неопределено Тогда
					ЭлементыФормы.Отбор.ТекущаяСтрока = ТекущиЭлементОтбора;
					// Не работает почему то
					//ЭлементыФормы.Отбор.ИзменитьСтроку();
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Если Не Открыта() Тогда
		Открыть();
	Иначе
		Активизировать();
	КонецЕсли;
	Возврат Истина;

КонецФункции // УстановитьСвязь()

Процедура УправлениеИерархиейТабличногоПоля()

	Если Истина
		И ЭтаФорма.ЭлементыФормы.ОсновнаяПанель.Страницы.Отбор.Видимость
		И ЭлементыФормы.КоманднаяПанельОтбор.Кнопки.Режимы.Кнопки.ОтключатьИерархическийРежим.Пометка
	Тогда 
		Попытка 
			СвязанноеТабличноеПоле.Дерево = Ложь;
			СвязанноеТабличноеПоле.ИерархическийПросмотр = Ложь;
		Исключение
		КонецПопытки;
	КонецЕсли;

КонецПроцедуры // УправлениеИерархиейТабличногоПоля()

Процедура СоединительВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	УстановитьСвязь();
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	КнопкаТолькоДоступныеЭлементы = ЭлементыФормы.КоманднаяПанельОтбор.Кнопки.Режимы.Кнопки.ТолькоДоступныеЭлементы;
	КнопкаТолькоДоступныеЭлементы.Доступность = РольДоступна("ирРазработчик");
	ТолькоДоступныеЭлементы     = ВосстановитьЗначение("УниверсальныйОтбор_ТолькоДоступныеЭлементы");
	Если ТолькоДоступныеЭлементы <> Неопределено Тогда
		КнопкаТолькоДоступныеЭлементы.Пометка = ТолькоДоступныеЭлементы Или Не КнопкаТолькоДоступныеЭлементы.Доступность;
	КонецЕсли;
	ОтключатьИерархическийРежим = ВосстановитьЗначение("УниверсальныйОтбор_ОтключатьИерархическийРежим");
	Если ОтключатьИерархическийРежим <> Неопределено Тогда
		ЭлементыФормы.КоманднаяПанельОтбор.Кнопки.Режимы.Кнопки.ОтключатьИерархическийРежим.Пометка = ОтключатьИерархическийРежим;
	КонецЕсли;
	УправлениеИерархиейТабличногоПоля();
	
	Если СвязанноеТабличноеПоле = Неопределено Тогда
		Если ТипЗнч(КлючУникальности) = Тип("Форма") Тогда 
			//УстановитьСвязь(ЛксПолучитьТабличноеПолеСписок(КлючУникальности));
		ИначеЕсли ТипЗнч(КлючУникальности) = Тип("ТабличноеПоле") Тогда 
			УстановитьСвязь(КлючУникальности);
		Иначе
			УстановитьСвязь();
		КонецЕсли;
	Иначе
		Если СвязанноеТабличноеПоле.ТекущаяКолонка <> Неопределено Тогда
			ПолеВыбораКолонки = СвязанноеТабличноеПоле.ТекущаяКолонка.Имя;
			КП_УстановитьЗначениеПолучитьИзТекущейЯчейки();
		Иначе
			ПолеВыбораКолонки = Неопределено;
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

Процедура ОтборЗначениеНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	Если Не ЭтаФорма.ЭлементыФормы.КоманднаяПанельОтбор.Кнопки.Режимы.Кнопки.НеЗакрыватьФормыПриВыборе.Пометка Тогда
		Возврат;
	КонецЕсли;
	АдресРазмещенияЗначения = Новый Структура;
	АдресРазмещенияЗначения.Вставить("ИмяЭлементОтбора", ЭлементыФормы.Отбор.ТекущаяСтрока.Имя);
	Если ТипЗнч(Элемент) = Тип("Строка") Тогда 
		АдресРазмещенияЗначения.Вставить("ИмяЗначения", Элемент);
	Иначе
		АдресРазмещенияЗначения.Вставить("ИмяЗначения", ЭлементыФормы.Отбор.ТекущаяКолонка.Имя);
	КонецЕсли;
	
	Если ЭлементыФормы.Отбор.ТекущаяСтрока[АдресРазмещенияЗначения.ИмяЗначения] = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	МенеджерТипаЗначения = ирОбщий.ПолучитьМенеджерЛкс(ЭлементыФормы.Отбор.ТекущаяСтрока.Значение);
	Если МенеджерТипаЗначения = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	ФормаВыбораЗначения = МенеджерТипаЗначения.ПолучитьФормуВыбора(, ЭтаФорма, ЗначениеВСтрокуВнутр(АдресРазмещенияЗначения));
	
	Если НЕ ФормаВыбораЗначения.Открыта() Тогда
		ФормаВыбораЗначения.РазрешитьСоединятьОкно = Истина;
		ФормаВыбораЗначения.СоединяемоеОкно = Истина;
		ФормаВыбораЗначения.РазрешитьСостояниеПрикрепленное = Истина;
		ФормаВыбораЗначения.ПоложениеПрикрепленногоОкна = ЭтаФорма.ПоложениеПрикрепленногоОкна;
		ФормаВыбораЗначения.ПоложениеПрикрепленногоОкна = ВариантПрикрепленияОкна.Низ;
		ФормаВыбораЗначения.СостояниеОкна = ВариантСостоянияОкна.Прикрепленное;
		ФормаВыбораЗначения.РазрешитьСостояниеОбычное = Ложь;
		ФормаВыбораЗначения.ЗакрыватьПриВыборе = Ложь;
		ФормаВыбораЗначения.РежимВыбора = Истина;
		ФормаВыбораЗначения.НачальноеЗначениеВыбора = ЭлементыФормы.Отбор.ТекущиеДанные.Значение;
		ФормаВыбораЗначения.Открыть();
		ФормаВыбораЗначения.Заголовок = "[" + ЭлементыФормы.Отбор.ТекущаяСтрока.Представление + "] " 
		                              + ФормаВыбораЗначения.Заголовок;
		ФормаВыбораЗначения.КлючУникальности = ЗначениеВСтрокуВнутр(АдресРазмещенияЗначения);
		СозданныеФормыВыбора.Добавить(ФормаВыбораЗначения);
	Иначе
		ФормаВыбораЗначения.Активизировать();
	КонецЕсли;
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ОбработкаВыбора(ЗначениеВыбора, Источник)
	
	Если ТипЗнч(ЗначениеВыбора) = Тип("Структура") Тогда
		Если ЗначениеВыбора.Свойство("Формула") Тогда
			Формула = ЗначениеВыбора.Формула;
			Возврат;
		КонецЕсли;
	КонецЕсли; 
	АдресРазмещенияЗначения = ЗначениеИзСтрокиВнутр(Источник.КлючУникальности);
	ИмяЭлементаОтбора = "";
	ИмяЗначения = "";
	АдресРазмещенияЗначения.Свойство("ИмяЭлементОтбора", ИмяЭлементаОтбора);
	АдресРазмещенияЗначения.Свойство("ИмяЗначения",      ИмяЗначения);
	Отбор[ИмяЭлементаОтбора][ИмяЗначения] = ЗначениеВыбора;
	Если НЕ Отбор[ИмяЭлементаОтбора].Использование Тогда 
		Отбор[ИмяЭлементаОтбора].Использование = Истина;
	КонецЕсли;
	ЭлементыФормы.Отбор.ТекущаяСтрока = Отбор[ИмяЭлементаОтбора];
	
КонецПроцедуры

Процедура ОтборВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Ложь
		ИЛИ НастройкаОтбора[ВыбраннаяСтрока.Имя].Доступность
		ИЛИ НЕ ЭлементыФормы.КоманднаяПанельОтбор.Кнопки.Режимы.Кнопки.ТолькоДоступныеЭлементы.Пометка
	Тогда
		Если Колонка.Имя = "Имя" Тогда
			//МетаданныеТипа = ирОбщий.ПолучитьМетаданныеЛкс(ВыбраннаяСтрока.Значение);
			//Если МетаданныеТипа <> Неопределено Тогда 
			//	ОтборЗначениеНачалоВыбора("Значение", Ложь);
			//	СтандартнаяОбработка = Ложь;
			//ИначеЕсли ТипЗнч(ВыбраннаяСтрока.Значение) = Тип("Булево") Тогда 
			//	Если ВыбраннаяСтрока.Использование Тогда 
			//		ВыбраннаяСтрока.Значение = Не ВыбраннаяСтрока.Значение;
			//	КонецЕсли;
			//	ВыбраннаяСтрока.Использование = Истина;
			//	СтандартнаяОбработка = Ложь;
			//КонецЕсли;
			ВыбраннаяСтрока.ВидСравнения = ирОбщий.ПолучитьИнвертированныйВидСравненияЛкс(ВыбраннаяСтрока.ВидСравнения);
		ИначеЕсли Колонка.Имя = "ПолучитьИзТекущейСтроки" Тогда
			Если СвязанноеТабличноеПоле.ТекущаяСтрока <> Неопределено Тогда
				Попытка
					ЗначениеЯчейки = СвязанноеТабличноеПоле.ТекущиеДанные[ВыбраннаяСтрока.Имя];
				Исключение
				КонецПопытки;
				Попытка
					ЗначениеЯчейки = СвязанноеТабличноеПоле.ТекущаяСтрока[ВыбраннаяСтрока.Имя];
				Исключение
				КонецПопытки;
				Если ТипЗнч(ВыбраннаяСтрока.Значение) = Тип("СписокЗначений") Тогда
					Если ВыбраннаяСтрока.Значение.НайтиПоЗначению(ЗначениеЯчейки) = Неопределено Тогда 
						ВыбраннаяСтрока.Значение.Добавить(ЗначениеЯчейки);
						ВыбраннаяСтрока.Использование = Ложь;
						ВыбраннаяСтрока.Использование = Истина;
					КонецЕсли;
				Иначе
					ирОбщий.ИнтерактивноЗаписатьВКолонкуТабличногоПоляЛкс(Элемент, Элемент.Колонки.Значение, ЗначениеЯчейки);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура СоединительНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("СоединительУниверсальногоОтбора");
	СтруктураПараметров.Вставить("Форма", ЭтаФорма);
	ПараметрыПеретаскивания.Значение = СтруктураПараметров;
	
КонецПроцедуры

Процедура ОтборПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ЭлементУравленияОтбором = НастройкаОтбора.Найти(ДанныеСтроки.Имя);
	Если ЭлементУравленияОтбором <> Неопределено Тогда
		Если Истина
			И НЕ ЭлементУравленияОтбором.Доступность
			И ЭлементыФормы.КоманднаяПанельОтбор.Кнопки.Режимы.Кнопки.ТолькоДоступныеЭлементы.Пометка
		Тогда
			ОформлениеСтроки.ЦветТекста = Новый Цвет(80, 80, 80);
			Для Каждого Ячейка Из ОформлениеСтроки.Ячейки Цикл
				Ячейка.ТолькоПросмотр = Истина;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	Если ТипЗнч(ДанныеСтроки.Значение) = Тип("Булево") Тогда
		ОформлениеСтроки.Ячейки.Значение.ОтображатьФлажок = Истина;
		ОформлениеСтроки.Ячейки.Значение.УстановитьФлажок(ДанныеСтроки.Значение);
	КонецЕсли; 
	ОформлениеСтроки.Ячейки.ПолучитьИзТекущейСтроки.УстановитьТекст("<<");
	ирОбщий.ТабличноеПоле_ОтобразитьПиктограммыТиповЛкс(ОформлениеСтроки, "Значение");
		
КонецПроцедуры

Процедура КоманднаяПанельОтборТолькоДоступныеЭлементы(Кнопка)
	
	Кнопка.Пометка = НЕ Кнопка.Пометка;
	ЭлементыФормы.Отбор.ОбновитьСтроки();
	
КонецПроцедуры

Процедура КоманднаяПанельПорядокПрименить(Кнопка)
	
	Если Не УстановитьСвязь() Тогда 
		Возврат;
	КонецЕсли;
	СтрокаПорядка = ирОбщий.ПолучитьСтрокуПорядкаКомпоновкиЛкс(Компоновщик.Настройки.Порядок);
	Если СвязанноеТабличноеПоле.Значение <> Неопределено Тогда 
		Если Ложь
			Или ТипИсточника = "ТаблицаЗначений"
			Или ТипИсточника = "ТабличнаяЧасть"
		Тогда
			Если СтрокаПорядка <> "" Тогда
				СвязанноеТабличноеПоле.Значение.Сортировать(СтрокаПорядка);
			КонецЕсли;
		ИначеЕсли Ложь
			Или ТипИсточника = "НаборЗаписей"
		Тогда
			Если СтрокаПорядка <> "" Тогда
				ТаблицаНабора = СвязанноеТабличноеПоле.Значение.Выгрузить();
				ТаблицаНабора.Сортировать(СтрокаПорядка);
				СвязанноеТабличноеПоле.Значение.Загрузить(ТаблицаНабора);
			КонецЕсли;
		ИначеЕсли ТипИсточника = "ДеревоЗначений" Тогда
			Если СтрокаПорядка <> "" Тогда
				СвязанноеТабличноеПоле.Значение.Строки.Сортировать(СтрокаПорядка, Истина);
			КонецЕсли;
		Иначе
			Если СтрокаПорядка <> "" Тогда
				Порядок.Установить(СтрокаПорядка);
			Иначе
				Порядок.Очистить();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура КоманднаяПанельОтборОтключатьИерархическийРежим(Кнопка)
	
	Кнопка.Пометка = НЕ Кнопка.Пометка;
	УправлениеИерархиейТабличногоПоля();
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	СохранитьЗначение("УниверсальныйОтбор_ТолькоДоступныеЭлементы",
	                  ЭлементыФормы.КоманднаяПанельОтбор.Кнопки.Режимы.Кнопки.ТолькоДоступныеЭлементы.Пометка);
	СохранитьЗначение("УниверсальныйОтбор_ОтключатьИерархическийРежим",
	                  ЭлементыФормы.КоманднаяПанельОтбор.Кнопки.Режимы.Кнопки.ОтключатьИерархическийРежим.Пометка);
	ЗакрытьФормыВыбора();
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	ЭлементыФормы.Соединитель.Шапка = Истина;
	
КонецПроцедуры

Процедура ЗначенияКолонокКолонкаПриИзменении(Элемент)
	
	Колонка = СвязанноеТабличноеПоле.Колонки.Найти(ЭлементыФормы.ЗначенияКолонок.ТекущиеДанные.Колонка);
	Если Колонка <> Неопределено Тогда
		ЭлементыФормы.ЗначенияКолонок.ТекущиеДанные.ТипКолонки = Колонка.ЭлементУправления.ТипЗначения;
		ЭлементыФормы.ЗначенияКолонок.ТекущиеДанные.Значение = Колонка.ЭлементУправления.ТипЗначения.ПривестиЗначение(
			ЭлементыФормы.ЗначенияКолонок.ТекущиеДанные.Значение);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаВыполнить(Кнопка)
	
	Если ПолеВыбораКолонки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если Не УстановитьСвязь() Тогда 
		Возврат;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ПолеВыбораКолонки) Тогда
		Возврат;
	КонецЕсли;
	Если ЭлементыФормы.ПанельОбработки.ТекущаяСтраница = ЭлементыФормы.ПанельОбработки.Страницы.Формула Тогда
		Если Формула = "" Тогда
			Возврат;
		КонецЕсли;
		ЗначенияПараметров = Новый Структура();
		Для Каждого СтрокаПараметра Из Параметры Цикл
			ЗначенияПараметров.Вставить(СтрокаПараметра.Имя, СтрокаПараметра.Значение);
		КонецЦикла;
		Для Каждого ДоступноеПоле Из ПостроительОтчета.ДоступныеПоля Цикл
			ЗначенияПараметров.Вставить(ДоступноеПоле.Имя);
		КонецЦикла;
		лЗначениеОбработки = Новый Структура();
		лЗначениеОбработки.Вставить("Параметры", ЗначенияПараметров);
		лЗначениеОбработки.Вставить("Формула", Формула);
	Иначе
		лЗначениеОбработки = ЗначениеОбработки;
	КонецЕсли;
	
	ИмяКолонки = СоответствиеКолонокДанным[ПолеВыбораКолонки];
	Колонка = СвязанноеТабличноеПоле.Колонки[ИмяКолонки];
	ирОбщий.УстановитьЗначениеВКолонкеТабличногоПоляТЧИлиТЗЛкс(СвязанноеТабличноеПоле, лЗначениеОбработки,
		ЭтаФорма, ТипИсточника, Колонка, ТолькоВыделенныеСтроки, ИнтерактивноеУстановка);
	
КонецПроцедуры

Процедура ПорядокКомпоновщикаВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Колонка = Элемент.Колонки.ТипУпорядочивания Тогда 
		Если ВыбраннаяСтрока.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр Тогда
			ВыбраннаяСтрока.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Убыв;
		Иначе
			ВыбраннаяСтрока.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
		КонецЕсли;
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
		
КонецПроцедуры

//Процедура ДоступныеПоляПорядкаВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
//	
//	ПостроительОтчета.Порядок.Добавить(ВыбраннаяСтрока.ПутьКДанным);
//	
//КонецПроцедуры

//Процедура ДоступныеКолонкиВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
//	
//	ПостроительОтчета.Отбор.Добавить(ВыбраннаяСтрока.ПутьКДанным);
//	
//КонецПроцедуры

//// Процедура - обработчик события "Перетаскивание" всех элементов формы типа ТабличноеПоле
////
//Процедура ЛксТабличноеПолеПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Колонка)

//	ЛксПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Колонка);
//	Выполнить(ЛксПолучитьСтароеДействиеФормы(ЭтаФорма, "Перетаскивание", Элемент.Имя));

//КонецПроцедуры // ЛксТабличноеПолеПеретаскивание()

//// Процедура - обработчик события "ПроверкаПеретаскивания" всех элементов формы типа ТабличноеПоле
////
//Процедура ЛксТабличноеПолеПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Колонка)

//	ЛксПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Колонка);
//	Выполнить(ЛксПолучитьСтароеДействиеФормы(ЭтаФорма, "ПроверкаПеретаскивания", Элемент.Имя));	

//КонецПроцедуры // ЛксТабличноеПолеПроверкаПеретаскивания()

//// Процедура - обработчик события "ОкончаниеПеретаскивания" всех элементов формы типа ТабличноеПоле
////
//Процедура ЛксТабличноеПолеОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
//	
//	ЛксОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка);
//	//Выполнить(ЛксПолучитьСтароеДействиеФормы(ЭтаФорма, "ОкончаниеПеретаскивания", Элемент.Имя));
//	
//КонецПроцедуры

Процедура КоманднаяПанельОбработкаРедактировать(Кнопка)
	
	
КонецПроцедуры

Процедура ПараметрыПередУдалением(Элемент, Отказ)

	Если Найти(Формула, "лПараметры." + Элемент.ТекущиеДанные.Имя) > 0 Тогда 
		Отказ = Истина;
		Сообщить("Параметр используется в формуле. Удаление невозможно");
	КонецЕсли;

КонецПроцедуры

Процедура ПараметрыИмяПриИзменении(Элемент)
	
	//Если ПустаяСтрока(ЭлементыФормы.Параметры.ТекущиеДанные.Представление) Тогда 
	//	ЭлементыФормы.Параметры.ТекущиеДанные.Представление = ирОбщий.ПолучитьПредставлениеИзИдентификатораЛкс(Элемент.Значение);
	//КонецЕсли;

КонецПроцедуры

Процедура ПараметрыПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)

	Если НЕ ОтменаРедактирования Тогда 
		Попытка
			Пустышка = Новый Структура(Элемент.ТекущиеДанные.Имя);
		Исключение
			Пустышка = Новый Структура;
		КонецПопытки;
		НайденныеСтроки = Параметры.НайтиСтроки(Новый Структура("Имя", Элемент.ТекущиеДанные.Имя));
		Если Ложь
			ИЛИ Пустышка.Количество() = 0
			ИЛИ НайденныеСтроки.Количество() > 1
			ИЛИ (Истина
				И НайденныеСтроки.Количество() = 1
				И НайденныеСтроки[0] <> Элемент.ТекущаяСтрока)
		Тогда 
			Элемент.ТекущиеДанные.Имя = "Параметр" + Параметры.Индекс(Элемент.ТекущаяСтрока);
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ПолеВыбораКолонкиПриИзменении(Элемент)
	
	Если Элемент.Значение = Неопределено Тогда
		ЭлементыФормы.ЗначениеОбработки.ОграничениеТипа = Новый ОписаниеТипов;
		ЭлементыФормы.ЗначениеОбработки.Доступность = Ложь;
	Иначе
		ЭлементыФормы.ЗначениеОбработки.ОграничениеТипа = ПостроительОтчета.ДоступныеПоля[ПолеВыбораКолонки].ТипЗначения;
		ЗначениеОбработки = ЭлементыФормы.ЗначениеОбработки.ОграничениеТипа.ПривестиЗначение(ЗначениеОбработки);
		// **** Здесь возникала ошибка
		ЭлементаУправленияЦели = СвязанноеТабличноеПоле.Колонки[СоответствиеКолонокДанным[Элемент.Значение]].ЭлементУправления;
		Если ЭлементаУправленияЦели <> Неопределено Тогда
			Если Ложь
				Или ТипЗнч(ЭлементаУправленияЦели) = Тип("ПолеВвода")
				Или ТипЗнч(ЭлементаУправленияЦели) = Тип("ПолеВыбора")
			Тогда
				ЭлементыФормы.ЗначениеОбработки.СписокВыбора = ЭлементаУправленияЦели.СписокВыбора;
				Если ТипЗнч(ЭлементаУправленияЦели) = Тип("ПолеВыбора") Тогда 
					ЭлементыФормы.ЗначениеОбработки.РежимВыбораИзСписка = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		ЭлементыФормы.ЗначениеОбработки.Доступность = Истина;
		//СписокВыбора = ЭлементыФормы.ЗначениеОбработки.СписокВыбора;
		//СписокВыбора.Очистить();
		//ИспользованныеЗначения = ;
		//Для Каждого ИспользованноеВКолонкеЗначение Из ИспользованныеЗначения Цикл
		//	СписокВыбора.Добавить(ИспользованноеВКолонкеЗначение);
		//КонецЦикла; 
	КонецЕсли;
	Формула = "";
	
КонецПроцедуры

Процедура ПараметрыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Элемент.Колонки.Имя.ЭлементУправления.ТолькоПросмотр = (Найти(Формула, "лПараметры." + Элемент.ТекущиеДанные.Имя) > 0);
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ПредставлениеОтбора = "" + Отбор;
	Если Не ПустаяСтрока(ПредставлениеОтбора) Тогда
		//ПредставлениеОтбора = "ОТБОР:  " + ПредставлениеОтбора;
	Иначе
		ПредставлениеОтбора = "Без отбора.";
	КонецЕсли;
	ЭлементыФормы.ПредставлениеОтбора.Заголовок = ПредставлениеОтбора;
	ЭлементыФормы.КоманднаяПанельОтбор.Кнопки.ВыключитьВсе.Доступность = Не ПустаяСтрока(ПредставлениеОтбора);

КонецПроцедуры

Процедура КоманднаяПанельПорядокОчистить(Кнопка)
	
	Компоновщик.Настройки.Порядок.Элементы.Очистить();
	
КонецПроцедуры

Процедура ОтборПриИзмененииФлажка(Элемент, Колонка)
	
	ТекущаяСтрока = Элемент.ТекущаяСтрока;
	ИмяКолонки = Колонка.Имя;
	Если ИмяКолонки = "Значение" Тогда 
		ирОбщий.ИнтерактивноЗаписатьВКолонкуТабличногоПоляЛкс(Элемент, Колонка, Не ТекущаяСтрока[ИмяКолонки], ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

Процедура КоманднаяПанельФормыПереключитьсяВФорму(Кнопка)
	
	РодительскаяФорма = ЭтаФорма.ВладелецФормы;
	Если Ложь
		Или РодительскаяФорма = Неопределено
		Или Не РодительскаяФорма.Открыта() 
	Тогда
		Возврат;
	КонецЕсли; 
	РодительскаяФорма.ТекущийЭлемент = СвязанноеТабличноеПоле;
	РодительскаяФорма.Активизировать();
	
КонецПроцедуры

Процедура КоманднаяПанельОтборВыключитьВсе(Кнопка)
	
	Для Каждого ЭлементОтбора Из Отбор Цикл
		Если ЭлементыФормы.КоманднаяПанельОтбор.Кнопки.Режимы.Кнопки.ТолькоДоступныеЭлементы.Пометка Тогда 
			ЭлементУравленияОтбором = НастройкаОтбора.Найти(ЭлементОтбора.Имя);
			Если Истина
				И ЭлементУравленияОтбором <> Неопределено
				И Не ЭлементУравленияОтбором.Доступность
			Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		ЭлементОтбора.Использование = Ложь;
	КонецЦикла; 
	
КонецПроцедуры

Процедура КоманднаяПанельОтборНеЗакрыватьФормыПриВыборе(Кнопка)
	
	Кнопка.Пометка = Не Кнопка.Пометка;
	
КонецПроцедуры

Процедура ОтборЗначениеОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	ирОбщий.ПолеВвода_ОкончаниеВводаТекстаЛкс(Элемент, Текст, Значение, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОтборЗначениеНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	//Элемент.СписокВыбора.Добавить(СвязанноеТабличноеПоле.ТекущиеДанные[ЭлементыФормы.Отбор.ТекущаяСтрока.Имя]);
	
КонецПроцедуры

Процедура КоманднаяПанельПорядокТолькоДоступныеЭлементы(Кнопка)
	
	Кнопка.Пометка = НЕ Кнопка.Пометка;
	ЭлементыФормы.ПорядокКомпоновщика.ОбновитьСтроки();
	
КонецПроцедуры

Процедура КП_УстановитьЗначениеПолучитьИзТекущейЯчейки(Кнопка = Неопределено)
	
	Если ЗначениеЗаполнено(ПолеВыбораКолонки) Тогда
		Если СвязанноеТабличноеПоле.ТекущиеДанные <> Неопределено Тогда
			ЗначениеОбработки = СвязанноеТабличноеПоле.ТекущиеДанные[СвязанноеТабличноеПоле.Колонки[ПолеВыбораКолонки].Данные];
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ФормулаНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	//Если ПолеВыбораКолонки = Неопределено Тогда
	//	Возврат;
	//КонецЕсли; 
	СтандартнаяОбработка = Ложь;
	ЗначенияПараметров = Новый Структура();
	Для Каждого СтрокаПараметра Из Параметры Цикл
		ЗначенияПараметров.Вставить(СтрокаПараметра.Имя, СтрокаПараметра.Значение);
	КонецЦикла;
	Для Каждого ДоступноеПоле Из ПостроительОтчета.ДоступныеПоля Цикл
		ЗначенияПараметров.Вставить(ДоступноеПоле.Имя, ДоступноеПоле.ТипЗначения.ПривестиЗначение());
	КонецЦикла;
	ОбработкаВводаФормулы = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирВводВыраженияВстроенногоЯзыка");
	#Если _ Тогда
	    ОбработкаВводаФормулы = Обработки.ирВводВыраженияВстроенногоЯзыка.Создать();
	#КонецЕсли
	ОбработкаВводаФормулы.Инициализировать(ЭтаФорма, Элемент.Значение, , , ЗначенияПараметров);
	ФормаВводаВыражения = ОбработкаВводаФормулы.ПолучитьФорму(, ЭтаФорма,);
	ФормаВводаВыражения.Открыть();
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ОтборПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Элемент.Колонки.Значение.ЭлементУправления.КнопкаСпискаВыбора = Истина;
	
КонецПроцедуры

#Если Клиент Тогда
Контейнер = Новый Структура();
Оповестить("ирПолучитьБазовуюФорму", Контейнер);
Если Не Контейнер.Свойство("ирПортативный", ирПортативный) Тогда
	ПолноеИмяФайлаБазовогоМодуля = ВосстановитьЗначение("ирПолноеИмяФайлаОсновногоМодуля");
	ирПортативный = ВнешниеОбработки.ПолучитьФорму(ПолноеИмяФайлаБазовогоМодуля);
КонецЕсли; 
ирОбщий = ирПортативный.ПолучитьОбщийМодульЛкс("ирОбщий");
ирКэш = ирПортативный.ПолучитьОбщийМодульЛкс("ирКэш");
ирСервер = ирПортативный.ПолучитьОбщийМодульЛкс("ирСервер");
ирПривилегированный = ирПортативный.ПолучитьОбщийМодульЛкс("ирПривилегированный");
#КонецЕсли

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирМенеджерТабличногоПоля.Форма.МенеджерТабличногоПоля");

РазрешитьСостояниеОбычное   = Ложь;
РазрешитьСостояниеСвободное = Ложь;
Соединитель.Добавить();
СозданныеФормыВыбора = Новый Массив;
ЗакрыватьПриЗакрытииВладельца = Ложь;
ИнтерактивноеУстановка = Истина;
