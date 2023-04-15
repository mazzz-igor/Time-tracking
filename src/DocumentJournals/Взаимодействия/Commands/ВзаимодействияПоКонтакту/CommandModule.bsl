
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Контакт", ПараметрКоманды);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ТипВзаимодействия", "Контакт");
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", СтруктураОтбора);
	ПараметрыФормы.Вставить("ДополнительныеПараметры", ДополнительныеПараметры);
	
	
	ОткрытьФорму(
		"ЖурналДокументов.Взаимодействия.Форма.ФормаСпискаПараметрическая",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Источник.КлючУникальности,
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти
