#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	АдресныйКлассификаторСлужебный.ПроверитьНачальноеЗаполнение(); // Инициализация списка регионов
	АутентификацияВыполнена = ДанныеАутентификацииСайтаСохранены();
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоМобильныйКлиент() Тогда // Временное решение для работы в мобильном клиенте, будет удалено в следующих версиях
		
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Авто;
		
		Элементы.Переместить(Элементы.ОК, Элементы.ФормаКоманднаяПанель);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ВариантыАктуализации", "ВидПереключателя", ВидПереключателя.Переключатель);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если ВариантыАктуализации = 0 Тогда
		Если НЕ АутентификацияВыполнена Тогда
			// Проходим через форму авторизации принудительно.
			Оповещение = Новый ОписаниеОповещения("ПослеЗапросаАутентификации", ЭтотОбъект);
			АдресныйКлассификаторКлиент.АвторизоватьНаСайтеПоддержкиПользователей(Оповещение, ЭтотОбъект);
			Возврат;
		Иначе
			УстановитьКонстанту();
			Закрыть();
		КонецЕсли;
	Иначе
		Закрыть();
		УстановитьКонстанту();
		АдресныйКлассификаторКлиент.ЗагрузитьАдресныйКлассификатор();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеЗапросаАутентификации(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		УстановитьКонстанту();
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеАутентификацииСайтаСохранены()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей") Тогда
		МодульИнтернетПоддержкаПользователей = ОбщегоНазначения.ОбщийМодуль("ИнтернетПоддержкаПользователей");
		Возврат МодульИнтернетПоддержкаПользователей.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки();
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

&НаСервереБезКонтекста
Функция УстановитьКонстанту()
	
	Константы.ИсточникДанныхАдресногоКлассификатора.Установить("Авто");
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	АдресныйКлассификаторКлиент.ЗагрузитьАдресныйКлассификатор();
	Закрыть();
КонецПроцедуры

#КонецОбласти
