
#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Копирование
		И Не Группа Тогда
		
		ТекущиеДанные = Элементы.Список.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			
			Отказ = Истина;
			НовыйЭлементСсылка = ВыполнитьКопированиеЭлемента(ТекущиеДанные.Ссылка);
			Если НовыйЭлементСсылка <> Неопределено Тогда
				ОткрытьФорму("Справочник.ШаблоныАнкет.Форма.ФормаЭлемента",Новый Структура("Ключ",НовыйЭлементСсылка));
				Элементы.Список.Обновить();
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ВыполнитьКопированиеЭлемента(ЭлементКопирования)
	
	НачатьТранзакцию();
	Попытка
	
		ШаблонАнкетыОбъект = Справочники.ШаблоныАнкет.СоздатьЭлемент();
		
		ЗаполнитьЗначенияСвойств(ШаблонАнкетыОбъект,ЭлементКопирования,"ПометкаУдаления,Наименование,Заголовок,Вступление,Заключение");
		ШаблонАнкетыОбъект.УстановитьСсылкуНового(Справочники.ШаблоныАнкет.ПолучитьСсылку());
		ШаблонАнкетыОбъект.РедактированиеШаблонаЗавершено = Ложь;
		ШаблонАнкетыОбъект.Записать();
		
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	ВопросыШаблонаАнкеты.Ссылка КАК Ссылка,
		|	ВопросыШаблонаАнкеты.ПометкаУдаления,
		|	ВопросыШаблонаАнкеты.Предопределенный,
		|	ВопросыШаблонаАнкеты.Владелец,
		|	ВопросыШаблонаАнкеты.Родитель,
		|	ВопросыШаблонаАнкеты.ЭтоГруппа,
		|	ВопросыШаблонаАнкеты.Код КАК Код,
		|	ВопросыШаблонаАнкеты.Наименование,
		|	ВопросыШаблонаАнкеты.Обязательный,
		|	ВопросыШаблонаАнкеты.ТипВопроса,
		|	ВопросыШаблонаАнкеты.ТипТабличногоВопроса,
		|	ВопросыШаблонаАнкеты.ЭлементарныйВопрос,
		|	ВопросыШаблонаАнкеты.РодительВопрос,
		|	ВопросыШаблонаАнкеты.Подсказка КАК Подсказка,
		|	ВопросыШаблонаАнкеты.СпособОтображенияПодсказки КАК СпособОтображенияПодсказки,
		|	ВопросыШаблонаАнкеты.СоставТабличногоВопроса.(
		|		ЭлементарныйВопрос КАК ЭлементарныйВопрос,
		|		НомерСтроки
		|	),
		|	ВопросыШаблонаАнкеты.ПредопределенныеОтветы.(
		|		ЭлементарныйВопрос КАК ЭлементарныйВопрос,
		|		Ответ,
		|		НомерСтроки
		|	),
		|	ВопросыШаблонаАнкеты.СоставКомплексногоВопроса.(
		|		ЭлементарныйВопрос КАК ЭлементарныйВопрос,
		|		НомерСтроки
		|	),
		|	ВопросыШаблонаАнкеты.Формулировка
		|ИЗ
		|	Справочник.ВопросыШаблонаАнкеты КАК ВопросыШаблонаАнкеты
		|ГДЕ
		|	ВопросыШаблонаАнкеты.Владелец = &ШаблонАнкеты
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка ИЕРАРХИЯ,
		|	Код";
		
		Запрос.УстановитьПараметр("ШаблонАнкеты", ЭлементКопирования);
		
		Результат = Запрос.Выполнить();
		
		Выборка = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
		ДобавитьЭлементыСправочникаВопросыШаблонаАнкеты(ШаблонАнкетыОбъект.Ссылка, Выборка);
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		Возврат Неопределено;
		
	КонецПопытки;
	
	Возврат ШаблонАнкетыОбъект.Ссылка;
	
КонецФункции

&НаСервере
Процедура ДобавитьЭлементыСправочникаВопросыШаблонаАнкеты(Ссылка, Выборка, Родитель = Неопределено)
	
	ВопросыСУсловием = Новый Соответствие;
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ЭтоГруппа Тогда
			
			НовыйЭлемент = Справочники.ВопросыШаблонаАнкеты.СоздатьГруппу();
			ЗаполнитьЗначенияСвойств(НовыйЭлемент,Выборка,"Наименование,Код,Формулировка");
			
		Иначе
			
			НовыйЭлемент = Справочники.ВопросыШаблонаАнкеты.СоздатьЭлемент();
			
			СсылкаНового = Справочники.ВопросыШаблонаАнкеты.ПолучитьСсылку();
			НовыйЭлемент.УстановитьСсылкуНового(СсылкаНового);
			
			ЗаполнитьЗначенияСвойств(НовыйЭлемент,Выборка,,"Владелец,Родитель,СоставТабличногоВопроса,ПредопределенныеОтветы,СоставКомплексногоВопроса,Код,РодительВопрос");
			СоставТабличногоВопроса = Выборка.СоставТабличногоВопроса.Выгрузить();
			СоставТабличногоВопроса.Сортировать("НомерСтроки Возр");
			НовыйЭлемент.СоставТабличногоВопроса.Загрузить(СоставТабличногоВопроса);
			ПредопределенныеОтветы = Выборка.ПредопределенныеОтветы.Выгрузить();
			ПредопределенныеОтветы.Сортировать("НомерСтроки Возр");
			НовыйЭлемент.ПредопределенныеОтветы.Загрузить(ПредопределенныеОтветы);
			СоставКомплексногоВопроса = Выборка.СоставКомплексногоВопроса.Выгрузить();
			СоставКомплексногоВопроса.Сортировать("НомерСтроки Возр");
			НовыйЭлемент.СоставКомплексногоВопроса.Загрузить(СоставКомплексногоВопроса);
			
			Если Выборка.ТипВопроса = Перечисления.ТипыВопросовШаблонаАнкеты.ВопросСУсловием Тогда
				ВопросыСУсловием.Вставить(Выборка.Ссылка,СсылкаНового);
			КонецЕсли;
			
			Если НЕ Выборка.РодительВопрос.Пустая() Тогда
				НовыйЭлемент.РодительВопрос = ВопросыСУсловием.Получить(Выборка.РодительВопрос);
			КонецЕсли;
			
		КонецЕсли;
		
		НовыйЭлемент.Владелец = Ссылка;
		НовыйЭлемент.Родитель = ?(Родитель = Неопределено,Справочники.ВопросыШаблонаАнкеты.ПустаяСсылка(),Родитель);
		НовыйЭлемент.Записать();
		
		ПодчиненнаяВыборка = Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
		Если ПодчиненнаяВыборка.Количество() > 0 Тогда
			ДобавитьЭлементыСправочникаВопросыШаблонаАнкеты(Ссылка,ПодчиненнаяВыборка,НовыйЭлемент.Ссылка);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
