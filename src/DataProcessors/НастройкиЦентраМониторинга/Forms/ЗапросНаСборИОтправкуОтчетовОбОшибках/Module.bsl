
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерейтиКНастройкамНажатие(Элемент)
	Закрыть();
	ОткрытьФорму("Обработка.НастройкиЦентраМониторинга.Форма.НастройкиЦентраМониторинга");
КонецПроцедуры

&НаКлиенте
Процедура Да(Команда)
	НовыеПараметры = Новый Структура("ОтправлятьФайлыДампов", 1);
	УстановитьПараметрыЦентраМониторинга(НовыеПараметры);
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура Нет(Команда)
	НовыеПараметры = Новый Структура("ОтправлятьФайлыДампов", 0);
	НовыеПараметры.Вставить("РезультатОтправки", Нстр("ru = 'Пользователь отказал в предоставлении полных дампов.'"));
	УстановитьПараметрыЦентраМониторинга(НовыеПараметры);
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура УстановитьПараметрыЦентраМониторинга(НовыеПараметры)
	ЦентрМониторингаСлужебный.УстановитьПараметрыЦентраМониторингаВнешнийВызов(НовыеПараметры);
КонецПроцедуры

#КонецОбласти

