﻿
&НаКлиенте
Процедура ИмяФайлаОбменаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	//ДиалогВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	//ДиалогВыборФайла.Заголовок = "Укажите файл обмена";
	//ДиалогВыборФайла.Фильтр = "Файл обмена(*.xml)|*.xml";
	//
	//Если ДиалогВыборФайла.Выбрать() Тогда
	//	Объект.ИмяФайлаОбмена = ДиалогВыборФайла.ПолноеИмяФайла;	
	//КонецЕсли;	
	
	Режим = РежимДиалогаВыбораФайла.Сохранение;
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
Процедура ВыполнитьВыгрузкуНаСервере()
	
	КомпонентыОбмена = ОбменДаннымиXDTOСервер.ИнициализироватьКомпонентыОбмена("Отправка"); 
	КомпонентыОбмена.ЭтоОбменЧерезПланОбмена = Ложь; 
	КомпонентыОбмена.ВедениеПротоколаДанных.ВыводВПротоколИнформационныхСообщений = Ложь;
	
	#Область НастройкаКомпонентовОбменаНаРаботуСУзлом 
	КомпонентыОбмена.ВерсияФорматаОбмена = "1.0"; 
	ФорматОбмена = "http://v8.1c.ru/edi/edi_stnd/EnterpriseData/1.0"; 
	КомпонентыОбмена.XMLСхема = ФорматОбмена; 
	КомпонентыОбмена.МенеджерОбмена = МенеджерОбменаЧерезУниверсальныйФормат; 
	ОбменДаннымиXDTOСервер.ИнициализироватьТаблицыПравилОбмена(КомпонентыОбмена); 
	#КонецОбласти 
	
	КомпонентыОбмена.ПараметрыКонвертации.ДатаПолученияОстатков = Объект.ДатаПолученияОстатков;
	
	// Открываем файл обмена 
	ОбменДаннымиXDTOСервер.ОткрытьФайлВыгрузки(КомпонентыОбмена, Объект.ИмяФайлаОбмена);
	
	Если КомпонентыОбмена.ФлагОшибки Тогда 
		КомпонентыОбмена.ФайлОбмена = Неопределено;
		Возврат; 
	КонецЕсли; 
	
	Правила = Новый ТаблицаЗначений;
	Правила.Колонки.Добавить("ИмяПОД");
	Правила.Колонки.Добавить("ИмяОбъекта");
	ТекСтрокаПравила = Правила.Добавить(); 
	ТекСтрокаПравила.ИмяПОД = "Документ_ОстаткиНаличка_Отправка";
	
	КомпонентыОбмена.СценарийВыгрузки = Правила; 
	// ВЫГРУЗКА ДАННЫХ 
	Попытка 
		ОбменДаннымиXDTOСервер.ПроизвестиВыгрузкуДанных(КомпонентыОбмена);
	Исключение 
		ОбменДаннымиXDTOСервер.ЗаписатьВПротоколВыполнения(КомпонентыОбмена, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КомпонентыОбмена.ФайлОбмена = Неопределено; 
		Возврат;
	КонецПопытки; 
	
	КомпонентыОбмена.ФайлОбмена.Закрыть(); 
	ОбменДаннымиXDTOСервер.ЗавершитьВедениеПротоколаОбмена(КомпонентыОбмена);
	
	Если НЕ КомпонентыОбмена.ФлагОшибки Тогда
		СообщениеПользователю = Новый СообщениеПользователю;	
		СообщениеПользователю.Текст = "Выгрузка выполнена успешно!";
		СообщениеПользователю.Сообщить();
	КонецЕсли;
	
	////ПолеОбработкаДляЗагрузкиДанных = ОбработкаДляЗагрузкиДанных;                                    
	//	
	//	КомпонентыОбмена = ОбменДаннымиXDTOСервер.ИнициализироватьКомпонентыОбмена("Отправка");
	//	
	//	КомпонентыОбмена.ВедениеПротоколаДанных.ВыводВПротоколИнформационныхСообщений = Ложь;
	//	//КомпонентыОбмена.КлючСообщенияЖурналаРегистрации = КлючСообщенияЖурналаРегистрации;
	//	
	//	#Область НастройкаКомпонентовОбменаНаРаботуСУзлом
	//	//КомпонентыОбмена.УзелКорреспондента = УзелДляОбмена;
	//	
	//	////КомпонентыОбмена.ВерсияФорматаОбмена = ОбменДаннымиXDTOСервер.ВерсияФорматаОбменаПриВыгрузке(УзелДляОбмена);
	//	   КомпонентыОбмена.ВерсияФорматаОбмена =  "1.0";
	//	   
	//	////ФорматОбмена = ОбменДаннымиXDTOСервер.ФорматОбмена(
	//	////	УзелДляОбмена, КомпонентыОбмена.ВерсияФорматаОбмена);
	//	ФорматОбмена = "http://v8.1c.ru/edi/edi_stnd/EnterpriseData/1.0";
	
	//	КомпонентыОбмена.XMLСхема = ФорматОбмена;
	//	
	//	//КомпонентыОбмена.МенеджерОбмена = ОбменДаннымиXDTOСервер.МенеджерОбменаВерсииФормата(
	//	//	УзелДляОбмена, КомпонентыОбмена.ВерсияФорматаОбмена);
	//	КомпонентыОбмена.МенеджерОбмена = МенеджерОбменаЧерезУниверсальныйФормат;
	//	
	//	//КомпонентыОбмена.ТаблицаПравилаРегистрацииОбъектов = ОбменДаннымиXDTOСервер.ПравилаРегистрацииОбъектов(УзелДляОбмена);
	//	//КомпонентыОбмена.СвойстваУзлаПланаОбмена = ОбменДаннымиXDTOСервер.СвойстваУзлаПланаОбмена(УзелДляОбмена);
	//	
	//	ОбменДаннымиXDTOСервер.ИнициализироватьТаблицыПравилОбмена(КомпонентыОбмена);
	//	#КонецОбласти
	//	КомпонентыОбмена.ЭтоОбменЧерезПланОбмена = Ложь;
	//	КомпонентыОбмена.СценарийВыгрузки = Новый ТаблицаЗначений;
	//	КомпонентыОбмена.СценарийВыгрузки.Колонки.Добавить("ИмяПОД");
	//	ТекСтр = КомпонентыОбмена.СценарийВыгрузки.Добавить();
	//	ТекСтр.ИмяПОД = "Документ_ОстаткиНаличка_Отправка"; 
	//	ТекСтр = КомпонентыОбмена.СценарийВыгрузки.Добавить();
	//	ТекСтр.ИмяПОД = "Справочник_Валюта_ПроизвольныйАлгоритм"; 	
	//	ТекСтр = КомпонентыОбмена.СценарийВыгрузки.Добавить();
	//	ТекСтр.ИмяПОД = "Справочник_Организации_ПроизвольныйАлгоритм"; 
	//	//ОбменДаннымиXDTOСервер.ИнициализироватьВедениеПротоколаОбмена(КомпонентыОбмена, ИмяФайлаПротоколаОбмена);
	//	
	//	// Открываем файл обмена
	//	ОбменДаннымиXDTOСервер.ОткрытьФайлВыгрузки(КомпонентыОбмена, Объект.ИмяФайлаОбмена);
	//	
	//	Если КомпонентыОбмена.ФлагОшибки Тогда
	//		КомпонентыОбмена.ФайлОбмена = Неопределено;
	//		//ОбменДаннымиXDTOСервер.ЗавершитьВедениеПротоколаОбмена(КомпонентыОбмена);
	//		Возврат;
	//	КонецЕсли;
	//	
	//	// ВЫГРУЗКА ДАННЫХ
	//	Попытка
	//		ОбменДаннымиXDTOСервер.ПроизвестиВыгрузкуДанных(КомпонентыОбмена);
	//	Исключение
	//		//Если КомпонентыОбмена.ЭтоОбменЧерезПланОбмена Тогда
	//		//	РазблокироватьДанныеДляРедактирования(УзелДляОбмена);
	//		//КонецЕсли;
	//		ОбменДаннымиXDTOСервер.ЗаписатьВПротоколВыполнения(КомпонентыОбмена, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	//		//ОбменДаннымиXDTOСервер.ЗавершитьВедениеПротоколаОбмена(КомпонентыОбмена);
	//		КомпонентыОбмена.ФайлОбмена = Неопределено;
	//		Возврат;
	//	КонецПопытки;
	//	
	//	//Если ЭтоОбменЧерезВнешнееСоединение() Тогда
	//	//	ДанныеВыгрузкиXML = КомпонентыОбмена.ФайлОбмена.Закрыть();
	//	//	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
	//	//	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	//	//	ТекстовыйДокумент.ДобавитьСтроку(ДанныеВыгрузкиXML);
	//	//	ТекстовыйДокумент.Записать(ИмяВременногоФайла,,Символы.ПС);
	//	////Иначе
	//		КомпонентыОбмена.ФайлОбмена.Закрыть();
	//	//КонецЕсли;
	//	//ОбменДаннымиXDTOСервер.ЗавершитьВедениеПротоколаОбмена(КомпонентыОбмена);
	//	
	//	//Если ЭтоОбменЧерезВнешнееСоединение() Тогда
	//	//	ОбработкаДляЗагрузкиДанных().ИмяФайлаОбмена = ИмяВременногоФайла;
	//	//	ОбработкаДляЗагрузкиДанных().ВыполнитьЗагрузкуДанных();
	//	//КонецЕсли;
	//	
	//	Если НЕ КомпонентыОбмена.ФлагОшибки Тогда
	//		СообщениеПользователю = Новый СообщениеПользователю;	
	//		СообщениеПользователю.Текст = "Выгрузка выполнена успешно!";
	//		СообщениеПользователю.Сообщить();
	//	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьВыгрузку(Команда)
	ВыполнитьВыгрузкуНаСервере();
КонецПроцедуры
