﻿&НаСервере
Процедура ПроверитьВерсию(Знач Версия)
	
	Версии = СтрРазделить(Версия, ".");
	
	Если Версии.Количество() = 0 Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Неканоническое представление версии формата обмена: <%1>.'"), Версия);
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Функция РазложитьФорматОбмена(Знач ФорматОбмена)
	
	//Результат = Новый Структура("БазовыйФормат, Версия");
	//
	//ЭлементыФормата = СтрРазделить(ФорматОбмена, "/");
	//
	//Если ЭлементыФормата.Количество() = 0 Тогда
	//	ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Неканоническое имя формата обмена <%1>'"), ФорматОбмена);
	//КонецЕсли;
	//
	//Результат.Версия = ЭлементыФормата[ЭлементыФормата.ВГраница()];
	//
	//ПроверитьВерсию(Результат.Версия);
	//
	//ЭлементыФормата.Удалить(ЭлементыФормата.ВГраница());
	//
	//Результат.БазовыйФормат = СтрСоединить(ЭлементыФормата, "/");
	//
	//Возврат Результат;
	Результат = Новый Структура("БазовыйФормат, Версия");
	ЭлементыФормата = СтрРазделить(ФорматОбмена, "/");
	Если ЭлементыФормата.Количество() = 0 Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Неканоническое имя формата обмена <%1>'"), ФорматОбмена);
	КонецЕсли; 
	Результат.Версия = ЭлементыФормата[ЭлементыФормата.ВГраница()];
	//ПроверитьВерсию(Результат.Версия); 
	ЭлементыФормата.Удалить(ЭлементыФормата.ВГраница());
	Результат.БазовыйФормат = СтрСоединить(ЭлементыФормата, "/"); 
	Возврат Результат;
КонецФункции


&НаСервере
Процедура ОткрытьФайлЗагрузки(КомпонентыОбмена, ИмяФайлаОбмена) Экспорт
	ЭтоОбменЧерезПланОбмена = КомпонентыОбмена.ЭтоОбменЧерезПланОбмена;
	ЧтениеXML = Новый ЧтениеXML; 
	НомерИтерации = 0; 
	КомпонентыОбмена.ФлагОшибки = Истина; 
	Пока НомерИтерации = 0 Цикл 
		НомерИтерации = 1; 
		Попытка 
			ЧтениеXML.ОткрытьФайл(ИмяФайлаОбмена); 
			ЧтениеXML.Прочитать();
			// Message
		Исключение
			СтрокаСообщенияОбОшибке = НСтр("ru = 'Ошибка при загрузке данных: %1'"); 
			СтрокаСообщенияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщенияОбОшибке, ОписаниеОшибки()); 
			ОбменДаннымиXDTOСервер.ЗаписатьВПротоколВыполнения(КомпонентыОбмена, СтрокаСообщенияОбОшибке); 
			Прервать; 
		КонецПопытки; 
		Если (ЧтениеXML.ТипУзла <> ТипУзлаXML.НачалоЭлемента Или ЧтениеXML.ЛокальноеИмя <> "Message") Тогда 
			Если ОбменДаннымиXDTOСервер.СообщениеОтНеобновленнойНастройки(ЧтениеXML) Тогда 
				СтрокаСообщенияОбОшибке = НСтр("ru = 'Получение данных от |источника, в котором не выполнено |обновление настройки синхронизации данных. Необходимо:'") + Символы.ПС + НСтр("ru = '1) Выполнить повторную | синхронизацию данных через некоторое время.'") + Символы.ПС + НСтр("ru = '2) Выполнить синхронизацию | данных на стороне источника, после этого |повторно выполнить синхронизацию данных в этой |информационной базе.'") + Символы.ПС + НСтр("ru = '(1 - для вида транспорта | Через интернет, 2 - для вида транспорта Другое)'"); 
				ОбменДаннымиXDTOСервер.ЗаписатьВПротоколВыполнения(КомпонентыОбмена, СтрокаСообщенияОбОшибке); 
			Иначе 
				ОбменДаннымиXDTOСервер.ЗаписатьВПротоколВыполнения(КомпонентыОбмена, 9); 
			КонецЕсли; 
			Прервать; 
		КонецЕсли; 
		ЧтениеXML.Прочитать(); 
		// Header 
		Если ЧтениеXML.ТипУзла <> ТипУзлаXML.НачалоЭлемента Или ЧтениеXML.ЛокальноеИмя <> "Header" 
			Тогда ОбменДаннымиXDTOСервер.ЗаписатьВПротоколВыполнения(КомпонентыОбмена, 9); 
			Прервать; 
		КонецЕсли; 
		Header = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML, ФабрикаXDTO.Тип("http://www.1c.ru/SSL/Exchange/Message", "Header")); 
		Если ЧтениеXML.ТипУзла <> ТипУзлаXML.НачалоЭлемента Или ЧтениеXML.ЛокальноеИмя <> "Body" Тогда
			ОбменДаннымиXDTOСервер.ЗаписатьВПротоколВыполнения(КомпонентыОбмена, 9); 
			Прервать; 
		КонецЕсли; 
		КомпонентыОбмена.XMLСхема = Header.Format; 
		ФорматОбмена = РазложитьФорматОбмена(Header.Format); 
		КомпонентыОбмена.ВерсияФорматаОбмена = "1.0"; 
		КомпонентыОбмена.МенеджерОбмена = МенеджерОбменаЧерезУниверсальныйФормат; 
		ЧтениеXML.Прочитать(); 
		// Body 
		КомпонентыОбмена.ФлагОшибки = Ложь; 
	КонецЦикла; 
	Если КомпонентыОбмена.ФлагОшибки Тогда 
		ЧтениеXML.Закрыть(); 
	Иначе 
		КомпонентыОбмена.Вставить("ФайлОбмена", ЧтениеXML); 
	КонецЕсли;
	//ЭтоОбменЧерезПланОбмена = КомпонентыОбмена.ЭтоОбменЧерезПланОбмена;
	//
	//ЧтениеXML = Новый ЧтениеXML;
	//
	//НомерИтерации = 0;
	//КомпонентыОбмена.ФлагОшибки = Истина;
	//Пока НомерИтерации = 0 Цикл
	//	
	//	НомерИтерации = 1;
	//	
	//	Попытка
	//		ЧтениеXML.ОткрытьФайл(ИмяФайлаОбмена);
	//		ЧтениеXML.Прочитать(); // Message
	//		КомпонентыОбмена.Вставить("ФайлОбмена", ЧтениеXML);
	//	Исключение
	//		
	//		СтрокаСообщенияОбОшибке = НСтр("ru = 'Ошибка при загрузке данных: %1'");
	//		СтрокаСообщенияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщенияОбОшибке, ОписаниеОшибки());
	//		ОбменДаннымиXDTOСервер.ЗаписатьВПротоколВыполнения(КомпонентыОбмена, СтрокаСообщенияОбОшибке);
	//		Прервать;
	//		
	//	КонецПопытки;
	//	
	//	Если (ЧтениеXML.ТипУзла <> ТипУзлаXML.НачалоЭлемента
	//		Или ЧтениеXML.ЛокальноеИмя <> "Message") Тогда
	//		Если ОбменДаннымиXDTOСервер.СообщениеОтНеобновленнойНастройки(ЧтениеXML) Тогда
	//			СтрокаСообщенияОбОшибке = НСтр("ru = 'Получение данных от источника, в котором не выполнено
	//				|обновление настройки синхронизации данных. Необходимо:'")
	//				+ Символы.ПС + НСтр("ru = '1) Выполнить повторную синхронизацию данных через некоторое время.'")
	//				+ Символы.ПС + НСтр("ru = '2) Выполнить синхронизацию данных на стороне источника, после этого 
	//				|повторно выполнить синхронизацию данных в этой информационной базе.'")
	//				+ Символы.ПС + НСтр("ru = '(1 - для вида транспорта Через интернет, 2 - для вида транспорта Другое)'");
	//			ОбменДаннымиXDTOСервер.ЗаписатьВПротоколВыполнения(КомпонентыОбмена, СтрокаСообщенияОбОшибке);
	//		Иначе
	//			ОбменДаннымиXDTOСервер.ЗаписатьВПротоколВыполнения(КомпонентыОбмена, 9);
	//		КонецЕсли;
	//		Прервать;
	//	КонецЕсли;
	//	
	//	ЧтениеXML.Прочитать(); // Header
	//	Если ЧтениеXML.ТипУзла <> ТипУзлаXML.НачалоЭлемента
	//		Или ЧтениеXML.ЛокальноеИмя <> "Header" Тогда
	//		ОбменДаннымиXDTOСервер.ЗаписатьВПротоколВыполнения(КомпонентыОбмена, 9);
	//		Прервать;
	//	КонецЕсли;
	//	
	//	Header = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML, ФабрикаXDTO.Тип("http://www.1c.ru/SSL/Exchange/Message", "Header"));
	//	Если ЧтениеXML.ТипУзла <> ТипУзлаXML.НачалоЭлемента
	//		Или ЧтениеXML.ЛокальноеИмя <> "Body" Тогда
	//		ОбменДаннымиXDTOСервер.ЗаписатьВПротоколВыполнения(КомпонентыОбмена, 9);
	//		Прервать;
	//	КонецЕсли;
	//	
	//	КомпонентыОбмена.XMLСхема = Header.Format;
	//	
	//	ФорматОбмена = РазложитьФорматОбмена(Header.Format);
	//	КомпонентыОбмена.ВерсияФорматаОбмена = ФорматОбмена.Версия;
	//	//КомпонентыОбмена.МенеджерОбмена      = МенеджерОбменаВерсииФормата(КомпонентыОбмена.УзелКорреспондента,
	//	//                                                                   КомпонентыОбмена.ВерсияФорматаОбмена);
	//	КомпонентыОбмена.МенеджерОбмена = МенеджерОбменаЧерезУниверсальныйФормат;
	//	
	//	
	//	
	//	ЧтениеXML.Прочитать(); // Body
	//	
	//	КомпонентыОбмена.ФлагОшибки = Ложь;
	//	
	//КонецЦикла;
	//
	//Если КомпонентыОбмена.ФлагОшибки Тогда
	//	ЧтениеXML.Закрыть();
	//Иначе
	//	КомпонентыОбмена.Вставить("ФайлОбмена", ЧтениеXML);
	//КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаОбменаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Режим = РежимДиалогаВыбораФайла.Открытие;
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	Фильтр = НСтр("ru = 'Файл обмена'; en = 'Файл обмена'")
	+ "(*xml)|*xml";
	ДиалогОткрытияФайла.Расширение = "xml";
	
	ДиалогОткрытияФайла.Фильтр = Фильтр;
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = "Укажите файл обмена";
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		Объект.ИмяФайлаОбмена = ДиалогОткрытияФайла.ПолноеИмяФайла;
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЗагрузкуНаСервере()
	КомпонентыОбмена = ОбменДаннымиXDTOСервер.ИнициализироватьКомпонентыОбмена("Получение");
	//КомпонентыОбмена.КлючСообщенияЖурналаРегистрации = КлючСообщенияЖурналаРегистрации;
	//КомпонентыОбмена.УзелКорреспондента = УзелОбменаЗагрузкаДанных; 
	КомпонентыОбмена.ЭтоОбменЧерезПланОбмена = Ложь; 
	КомпонентыОбмена.ВедениеПротоколаДанных.ВыводВПротоколИнформационныхСообщений = Ложь;
	РежимЗагрузкиДанных = "ЗагрузкаВИнформационнуюБазу"; 
	КомпонентыОбмена.СостояниеОбменаДанными.ДатаНачала = ТекущаяДатаСеанса();
	Если ПустаяСтрока(Объект.ИмяФайлаОбмена) Тогда 
		ОбменДаннымиXDTOСервер.ЗаписатьВПротоколВыполнения(КомпонентыОбмена, 15); 
		ОбменДаннымиXDTOСервер.ЗавершитьВедениеПротоколаОбмена(КомпонентыОбмена); 
		Возврат; 
	КонецЕсли; 
	//Если ПродолжитьПриОшибке Тогда 
	// ИспользоватьТранзакции = Ложь; 
	// КомпонентыОбмена.ИспользоватьТранзакции = Ложь; 
	//КонецЕсли; 
	ОткрытьФайлЗагрузки(КомпонентыОбмена, Объект.ИмяФайлаОбмена); 
	Если КомпонентыОбмена.ФлагОшибки Тогда 
		ОбменДаннымиXDTOСервер.ЗавершитьВедениеПротоколаОбмена(КомпонентыОбмена); 
		Возврат; 
	КонецЕсли; 
	РезультатПодсчетаДанныхКЗагрузке = ОбменДаннымиСервер.РезультатПодсчетаДанныхКЗагрузке(Объект.ИмяФайлаОбмена, Истина); 
	КомпонентыОбмена.Вставить("РазмерФайлаСообщенияОбмена", РезультатПодсчетаДанныхКЗагрузке.РазмерФайлаСообщенияОбмена); 
	КомпонентыОбмена.Вставить("КоличествоОбъектовКЗагрузке", РезультатПодсчетаДанныхКЗагрузке.КоличествоОбъектовКЗагрузке); 
	ОбменДаннымиXDTOСервер.ИнициализироватьТаблицыПравилОбмена(КомпонентыОбмена); 
	Попытка 
		ОбменДаннымиXDTOСервер.ПроизвестиЧтениеДанных(КомпонентыОбмена);
	Исключение 
		СтрокаСообщения = НСтр("ru = 'Ошибка при загрузке данных: %1'"); 
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, ОписаниеОшибки());
		ОбменДаннымиXDTOСервер.ЗаписатьВПротоколВыполнения(КомпонентыОбмена, СтрокаСообщения,,,,,Истина); 
		КомпонентыОбмена.ФлагОшибки = Истина; 
	КонецПопытки; 
	ОбменДаннымиXDTOСервер.УдалитьВременныеОбъектыСозданныеПоСсылкам(КомпонентыОбмена); 
	КомпонентыОбмена.ФайлОбмена.Закрыть();
	//Если Не КомпонентыОбмена.ФлагОшибки Тогда 
	//
	ОбменДаннымиXDTOСервер.ЗавершитьВедениеПротоколаОбмена(КомпонентыОбмена);
	//ОбменДаннымиXDTOСервер.ИнициализироватьВедениеПротоколаОбмена(КомпонентыОбмена, ИмяФайлаПротоколаОбмена);
	//КомпонентыОбмена = ОбменДаннымиXDTOСервер.ИнициализироватьКомпонентыОбмена("Получение");
	////КомпонентыОбмена.КлючСообщенияЖурналаРегистрации = КлючСообщенияЖурналаРегистрации;
	////КомпонентыОбмена.УзелКорреспондента = УзелОбменаЗагрузкаДанных;
	//КомпонентыОбмена.ЭтоОбменЧерезПланОбмена = Ложь;
	//
	//КомпонентыОбмена.ВедениеПротоколаДанных.ВыводВПротоколИнформационныхСообщений = Ложь;
	//РежимЗагрузкиДанных = "ЗагрузкаВИнформационнуюБазу";
	//
	//КомпонентыОбмена.СостояниеОбменаДанными.ДатаНачала = ТекущаяДатаСеанса();
	//
	////ОбменДаннымиXDTOСервер.ИнициализироватьВедениеПротоколаОбмена(КомпонентыОбмена, ИмяФайлаПротоколаОбмена);
	//
	//Если ПустаяСтрока(Объект.ИмяФайлаОбмена) Тогда
	//	ОбменДаннымиXDTOСервер.ЗаписатьВПротоколВыполнения(КомпонентыОбмена, 15);
	//	//ОбменДаннымиXDTOСервер.ЗавершитьВедениеПротоколаОбмена(КомпонентыОбмена);
	//	Возврат;
	//КонецЕсли;
	//
	////Если ПродолжитьПриОшибке Тогда
	////	ИспользоватьТранзакции = Ложь;
	////	КомпонентыОбмена.ИспользоватьТранзакции = Ложь;
	////КонецЕсли;
	//
	//ОткрытьФайлЗагрузки(КомпонентыОбмена, Объект.ИмяФайлаОбмена);
	//
	//Если КомпонентыОбмена.ФлагОшибки Тогда
	//	//ОбменДаннымиXDTOСервер.ЗавершитьВедениеПротоколаОбмена(КомпонентыОбмена);
	//	Если КомпонентыОбмена.Свойство("ФайлОбмена") Тогда
	//		КомпонентыОбмена.ФайлОбмена.Закрыть();
	//	КонецЕсли;
	//	Возврат;
	//КонецЕсли;
	//
	//РезультатПодсчетаДанныхКЗагрузке = ОбменДаннымиСервер.РезультатПодсчетаДанныхКЗагрузке(Объект.ИмяФайлаОбмена, Истина);
	//КомпонентыОбмена.Вставить("РазмерФайлаСообщенияОбмена", РезультатПодсчетаДанныхКЗагрузке.РазмерФайлаСообщенияОбмена);
	//КомпонентыОбмена.Вставить("КоличествоОбъектовКЗагрузке", РезультатПодсчетаДанныхКЗагрузке.КоличествоОбъектовКЗагрузке);
	//
	//ОбменДаннымиXDTOСервер.ИнициализироватьТаблицыПравилОбмена(КомпонентыОбмена);
	//
	//Попытка
	//	ОбменДаннымиXDTOСервер.ПроизвестиЧтениеДанных(КомпонентыОбмена);
	//Исключение
	//	
	//	СтрокаСообщения = НСтр("ru = 'Ошибка при загрузке данных: %1'");
	//	СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, ОписаниеОшибки());
	//	ОбменДаннымиXDTOСервер.ЗаписатьВПротоколВыполнения(КомпонентыОбмена, СтрокаСообщения,,,,,Истина);
	//	КомпонентыОбмена.ФлагОшибки = Истина;
	//КонецПопытки;
	//
	//ОбменДаннымиXDTOСервер.УдалитьВременныеОбъектыСозданныеПоСсылкам(КомпонентыОбмена);
	//
	//КомпонентыОбмена.ФайлОбмена.Закрыть();
	//
	//Если Не КомпонентыОбмена.ФлагОшибки Тогда
	//	
	//	//// Запишем информацию о номере входящего сообщения.
	//	//ОбъектУзла = УзелОбменаЗагрузкаДанных.ПолучитьОбъект();
	//	//ОбъектУзла.НомерПринятого = КомпонентыОбмена.НомерВходящегоСообщения;
	//	//ОбъектУзла.ДополнительныеСвойства.Вставить("ПолучениеСообщенияОбмена");
	//	//ОбъектУзла.Записать();
	//	СообщениеПользователю = Новый СообщениеПользователю;	
	//	СообщениеПользователю.Текст = "Загрузка выполнена успешно!";
	//	СообщениеПользователю.Сообщить();

	//КонецЕсли;
	//
	////ОбменДаннымиXDTOСервер.ЗавершитьВедениеПротоколаОбмена(КомпонентыОбмена);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗагрузку(Команда)
	ВыполнитьЗагрузкуНаСервере();
КонецПроцедуры
