﻿Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Модифицированность = Ложь;
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	Если ПараметрСсылка <> Неопределено Тогда
		Объект = ПараметрСсылка;
		ОбновитьТипЗначенияСсылки();
		//ЭлементыФормы.Объект.ТолькоПросмотр = Истина;
		ОбновитьНайденныеСсылки(ирОбщий.БыстрыйМассивЛкс(Объект));
	КонецЕсли;
	
КонецПроцедуры

Процедура ДействияФормыОбновить(Кнопка)
	
	ТекущиеДанные = Неопределено;
	Если ЭлементыФормы.НайденныеСсылки.ТекущаяСтрока <> Неопределено Тогда 
		ТекущиеДанные = ЭлементыФормы.НайденныеСсылки.ТекущаяСтрока.Данные;
	КонецЕсли;
	ОбновитьНайденныеСсылки(ирОбщий.БыстрыйМассивЛкс(Объект));
    НоваяСтрока = НайденныеСсылки.Найти(ТекущиеДанные, "Данные");
	Если НоваяСтрока <> Неопределено Тогда
		ЭлементыФормы.НайденныеСсылки.ТекущаяСтрока = НоваяСтрока;
	КонецЕсли;
	
КонецПроцедуры

Процедура НайденныеСсылкиПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Ячейки = ОформлениеСтроки.Ячейки;
	Если Лев(ДанныеСтроки.Метаданные, 15) = "РегистрСведений" Тогда
		Ячейки.Данные.Текст = ЗначениеИзСтрокиВнутр(Ячейки.Данные.Текст);
	КонецЕсли;
	Ячейки.КартинкаСсылки.ОтображатьКартинку = Истина;
	Если ДанныеСтроки.КартинкаСсылки > -1 Тогда 
		Ячейки.КартинкаСсылки.ИндексКартинки = ДанныеСтроки.КартинкаСсылки;
	КонецЕсли;

КонецПроцедуры

Процедура ДействияФормыОПодсистеме(Кнопка)
	
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтотОбъект);
	
КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельНовоеОкно(Кнопка)
	
	ирОбщий.ОткрытьНовоеОкноОбработкиЛкс(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбъектОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	ирОбщий.ПолеВвода_ОкончаниеВводаТекстаЛкс(Элемент, Текст, Значение, СтандартнаяОбработка, , Истина);
	
КонецПроцедуры

Процедура КоманднаяПанельНайденныеСсылкиРедакторОбъектаБД(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.НайденныеСсылки.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ОткрытьСсылающийсяОбъектВРедактореОбъектаБД(ТекущаяСтрока);
	
КонецПроцедуры

Процедура ОбъектПриИзменении(Элемент)
	
	// Антибаг платформы 8.2.16 http://partners.v8.1c.ru/forum/thread.jsp?id=1077270#1077270
	Элемент.Значение = Элемент.Значение;
	
	НайденныеСсылки.Очистить();
	ОбновитьТипЗначенияСсылки();
	Если ТипЗнч(Объект) = Тип("Строка") Тогда
		Возврат;
	КонецЕсли; 
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, Метаданные().Имя);
	
КонецПроцедуры

Процедура ОбновитьТипЗначенияСсылки()

	Если ТипЗнч(Объект) = Тип("Строка") Тогда
		ЭтаФорма.ТипОбъекта = Тип("Неопределено");
	Иначе
		ЭтаФорма.ТипОбъекта = Метаданные.НайтиПоТипу(ТипЗнч(Объект)).ПолноеИмя();
	КонецЕсли; 

КонецПроцедуры

Процедура ДействияФормыМенеджерТабличногоПоля(Кнопка)
	
	 ирОбщий.ПолучитьФормуЛкс("Обработка.ирМенеджерТабличногоПоля.Форма",, ЭтаФорма, ).УстановитьСвязь(ЭлементыФормы.НайденныеСсылки);

КонецПроцедуры

Процедура НайденныеСсылкиВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если ВыбраннаяСтрока <> Неопределено Тогда
		Если ТипЗнч(Элемент.ТекущиеДанные.Данные) = Тип("Строка") Тогда 
			Ссылка = ЗначениеИзСтрокиВнутр(ВыбраннаяСтрока.Данные);
		Иначе
			Ссылка = ВыбраннаяСтрока.Данные;
		КонецЕсли;
		ирОбщий.ОткрытьСсылкуИзРезультатаПоискаСсылокЛкс(Ссылка, ВыбраннаяСтрока.Метаданные);
	КонецЕсли; ;
	
КонецПроцедуры

Процедура ДействияФормыКонсольКомпоновки(Кнопка)
	
	КонсольКомпоновокДанных = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Отчет.ирКонсольКомпоновокДанных");
	#Если _ Тогда
		КонсольКомпоновокДанных = Отчеты.ирКонсольКомпоновокДанных.Создать();
	#КонецЕсли
    КонсольКомпоновокДанных.ОткрытьПоТаблицеЗначений(НайденныеСсылки.Выгрузить());
	
КонецПроцедуры

Процедура ДействияФормыОтборБезЗначенияВТекущейКолонке(Кнопка)
	
	ирОбщий.ТабличноеПоле_ОтборБезЗначенияВТекущейКолонке_КнопкаЛкс(ЭлементыФормы.НайденныеСсылки);

КонецПроцедуры

Процедура ОбъектНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, Метаданные().Имя);

КонецПроцедуры

Процедура ОбъектОчистка(Элемент, СтандартнаяОбработка)
	
	Элемент.Значение = "";	
	ОбновитьТипЗначенияСсылки();
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ОбъектНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	Если ТипЗнч(Элемент.Значение) = Тип("Строка") Тогда 
		ирОбщий.ВыбратьТипСсылкиВПолеВводаЛкс(Элемент, СтандартнаяОбработка);
	КонецЕсли; 

КонецПроцедуры

Процедура ОбъектОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Элемент.Значение = ВыбранноеЗначение;
	Если ТипЗнч(Элемент.Значение) <> ТипЗнч(ВыбранноеЗначение) Тогда
		ВыбранноеЗначение = "";
	КонецЕсли; 
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Строка") Тогда
		Элемент.Значение = Неопределено; // Если это не сделать, то ссылка будет преобразована к строковому типу
	КонецЕсли; 
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПоискСсылокНаОбъект.Форма.Форма");

ЭтотОбъект.Объект = "";