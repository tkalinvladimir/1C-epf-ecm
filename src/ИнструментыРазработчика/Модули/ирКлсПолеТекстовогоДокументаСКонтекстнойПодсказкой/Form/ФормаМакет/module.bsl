﻿Перем ирПортативный Экспорт;
Перем ирОбщий Экспорт;
Перем ирСервер Экспорт;
Перем ирКэш Экспорт;
Перем ирПривилегированный Экспорт;

Перем ПолеТекстовогоДокументаСКонтекстнойПодсказкой;

// @@@.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
Процедура КлсПолеТекстовогоДокументаСКонтекстнойПодсказкойНажатие(Кнопка)
	
	ПолеТекстовогоДокументаСКонтекстнойПодсказкой.Нажатие(Кнопка);
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Отказ = Истина;
	Сообщить("Эта обработка - класс. Она не предназначена для непосредственного использования.");
	
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

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой.Форма.ФормаМакет");
