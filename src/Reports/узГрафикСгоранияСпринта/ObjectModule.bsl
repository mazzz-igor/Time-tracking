
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЭлементыПользовательскихНастроек = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы;
	ПараметрСпринт = Новый ПараметрКомпоновкиДанных("Спринт");
	
	Для Каждого ПользовательскаяНастройка Из ЭлементыПользовательскихНастроек Цикл 
		Если ПользовательскаяНастройка.Параметр = ПараметрСпринт Тогда 
			ЗначениеПараметраСпринт = ПользовательскаяНастройка.Значение;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ТекстОшибки = "";
	
	Если Не ЗначениеЗаполнено(ЗначениеПараметраСпринт.ДатаНачала) Тогда 
		ТекстОшибки = ТекстОшибки + "Не заполнена дата начала спринта!";
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ЗначениеПараметраСпринт.ДатаОкончания) Тогда 
		ТекстОшибки = ТекстОшибки + Символы.ПС + "Не заполнена дата окончания спринта!";
	КонецЕсли;
	
	ПроверитьДанныеКалендаря(ЗначениеПараметраСпринт, ТекстОшибки);
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда 
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ТекстОшибки;
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Сообщить();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьДанныеКалендаря(Спринт, ТекстОшибки)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ДанныеПроизводственногоКалендаря.Дата КАК ДатаКалендаря
	|ИЗ
	|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаря
	|ГДЕ
	|	ДанныеПроизводственногоКалендаря.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания");
	
	Запрос.УстановитьПараметр("ДатаНачала",Спринт.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания",Спринт.ДатаОкончания);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Выборка.Следующий();
	
	Если Выборка.Количество() = 0 Тогда 
		ТекстОшибки = ТекстОшибки + Символы.ПС + "Не заполнен регламентированный календарь!";
	КонецЕсли;
	
КонецПроцедуры

