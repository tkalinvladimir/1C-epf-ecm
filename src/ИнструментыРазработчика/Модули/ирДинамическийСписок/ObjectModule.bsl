﻿Перем ирПортативный Экспорт;
Перем ирОбщий Экспорт;
Перем ирСервер Экспорт;
Перем ирКэш Экспорт;
Перем ирПривилегированный Экспорт;

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

