﻿
Процедура КоманднаяПанель1КонсольЗапросов(Кнопка)
	
	Если Не ЗначениеЗаполнено(ЭлементыФормы.ТекстСМетаданными.ПолучитьТекст()) Тогда
		ОбновитьЗапрос();
	КонецЕсли; 
	ТекстЗапроса = ЭлементыФормы.ТекстСМетаданными.ПолучитьТекст();
	Если Не ЗначениеЗаполнено(ТекстЗапроса) Тогда
		Возврат;
	КонецЕсли;
	Если ЭтоТекстSDBL Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = ТекстЗапроса;
		Для Каждого СтрокаПараметра Из Параметры Цикл
			Запрос.Параметры.Вставить(СтрокаПараметра.Имя, СтрокаПараметра.Значение);
		КонецЦикла;
		ирОбщий.ОтладитьЛкс(Запрос);
	Иначе
		//СоединениеADO = ПодключенияИис.ПолучитьСоединениеADOПоСсылкеИис(Инфобаза.ИнфобазаСУБД,, Ложь);
		СоединениеADO = Новый COMОбъект("ADODB.Connection");
        ирОбщий.ОтладитьЛкс(СоединениеADO,, ТекстЗапроса);
	КонецЕсли;
	
КонецПроцедуры

Процедура КоманднаяПанель1ОбновитьЗапрос(Кнопка)
	
	ОбновитьЗапрос();
	
КонецПроцедуры

Процедура ОбновитьЗапрос()
	
	Если ЭтоТекстSDBL Тогда
		ТипСУБД = "";
	Иначе
		ТипСУБД = "1";
	КонецЕсли; 
	СтруктураЗапроса = ПолучитьСтруктуруЗапросаИзТекстаБД(ЭлементыФормы.ТекстБД.ПолучитьТекст(), ТипСУБД, ПересобратьТекст);
	ЭлементыФормы.ТекстСМетаданными.УстановитьТекст(СтруктураЗапроса.Текст);
	ЭтаФорма.Параметры = СтруктураЗапроса.Параметры;
	ЭтаФорма.Таблицы = СтруктураЗапроса.Таблицы;

КонецПроцедуры

Процедура ПриОткрытии()
	
	ОбновитьЗапрос();
	
КонецПроцедуры

Процедура ПанельОсновнаяПриСменеСтраницы(Элемент = Неопределено, ТекущаяСтраница = Неопределено)
	
	Если Не ЗначениеЗаполнено(ЭлементыФормы.ТекстСМетаданными.ПолучитьТекст()) Тогда
		Если ЭлементыФормы.ПанельОсновная.ТекущаяСтраница = ЭлементыФормы.ПанельОсновная.Страницы.ТекстСМетаданными Тогда
			ОбновитьЗапрос();
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПараметрыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Колонка = Элемент.Колонки.ЗначениеSDBL Тогда
		ирОбщий.НайтиПоказатьСтрокуВПолеТекстовогоДокументаЛкс(ЭтаФорма, ЭлементыФормы.ТекстСМетаданными, ВыбраннаяСтрока.ЗначениеSDBL);
	Иначе
		ОткрытьЗначение(ВыбраннаяСтрока.Значение);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ирОбщий.ОбновитьЗаголовкиСтраницПанелейЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ТаблицыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ИмяСтраницы = ЭлементыФормы.ПанельОсновная.ТекущаяСтраница.Имя;
	Если ирОбщий.СтрокиРавныЛкс(ИмяСтраницы, "ТекстБД") Тогда
		Подстрока = ВыбраннаяСтрока.ИмяБД;
	Иначе
		Подстрока = ВыбраннаяСтрока.ИмяМета;
	КонецЕсли; 
	ирОбщий.НайтиПоказатьСтрокуВПолеТекстовогоДокументаЛкс(ЭтаФорма, ЭлементыФормы[ИмяСтраницы], Подстрока);
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ТипСУБДПриИзменении(Элемент)
	
	ОбновитьЗапрос();
	
КонецПроцедуры

Процедура КоманднаяПанель1НовоеОкно(Кнопка)
	
	Форма = ПолучитьФорму("КонверторВМета",, Новый УникальныйИдентификатор);
	Форма.Открыть();

КонецПроцедуры

Процедура ДействияФормыПеревести(Кнопка)
	
	ОбновитьЗапрос();
	ЭлементыФормы.ПанельОсновная.ТекущаяСтраница = ЭлементыФормы.ПанельОсновная.Страницы.ТекстСМетаданными;
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирАнализТехножурнала.Форма.КонверторВМета");
ТипСУБД = "";