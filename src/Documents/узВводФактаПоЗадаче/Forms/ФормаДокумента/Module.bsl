
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Задача") Тогда 
		Объект.Задача = Параметры.Задача;
	КонецЕсли;
	
	Если Параметры.Свойство("Исполнитель") Тогда 
		Объект.Исполнитель = Параметры.Исполнитель;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("узВводФактаПоЗадачеЗаписан");
КонецПроцедуры


