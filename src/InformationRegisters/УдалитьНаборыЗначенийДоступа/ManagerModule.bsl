#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Обработчик обновления информационной базы.
Функция ПереместитьДанныеВНовыйРегистр() Экспорт
	
	ЗапросНаличияДанных = Новый Запрос;
	ЗапросНаличияДанных.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЗначениеИстина
	|ИЗ
	|	РегистрСведений.УдалитьНаборыЗначенийДоступа КАК УдалитьНаборыЗначенийДоступа";
	
	Если ЗапросНаличияДанных.Выполнить().Пустой() Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если НЕ УправлениеДоступом.ОграничиватьДоступНаУровнеЗаписей() Тогда
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Записать();
	КонецЕсли;
	
	ТипыОбъектов = УправлениеДоступомСлужебныйПовтИсп.ТипыОбъектовВПодпискахНаСобытия(
		"ЗаписатьНаборыЗначенийДоступа", Истина);
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("ТипыОбъектов", ТипыОбъектов);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 10000
	|	УдалитьНаборыЗначенийДоступа.Объект
	|ИЗ
	|	РегистрСведений.УдалитьНаборыЗначенийДоступа КАК УдалитьНаборыЗначенийДоступа
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ИдентификаторыОбъектовМетаданных КАК Идентификаторы
	|		ПО (ТИПЗНАЧЕНИЯ(УдалитьНаборыЗначенийДоступа.Объект) = ТИПЗНАЧЕНИЯ(Идентификаторы.ЗначениеПустойСсылки))
	|			И (Идентификаторы.ЗначениеПустойСсылки В (&ТипыОбъектов))";
	
	Выборка = Запрос.Выполнить().Выбрать();
	НаборСтарыхЗаписей = СоздатьНаборЗаписей();
	НаборНовыхЗаписей = РегистрыСведений.НаборыЗначенийДоступа.СоздатьНаборЗаписей();
	
	ЗапросПроверки = Новый Запрос;
	ЗапросПроверки.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЗначениеИстина
	|ИЗ
	|	РегистрСведений.НаборыЗначенийДоступа КАК НаборыЗначенийДоступа
	|ГДЕ
	|	НаборыЗначенийДоступа.Объект = &Объект";
	
	Пока Выборка.Следующий() Цикл
		НаборСтарыхЗаписей.Отбор.Объект.Установить(Выборка.Объект);
		НаборНовыхЗаписей.Отбор.Объект.Установить(Выборка.Объект);
		ЗапросПроверки.УстановитьПараметр("Объект", Выборка.Объект);
		НаборНовыхЗаписей.Очистить();
		НовыеНаборы = УправлениеДоступом.ТаблицаНаборыЗначенийДоступа();
		
		МетаданныеОбъекта = Выборка.Объект.Метаданные();
		ОбъектСНаборами = МетаданныеОбъекта.ТабличныеЧасти.Найти("НаборыЗначенийДоступа") <> Неопределено;
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.НаборыЗначенийДоступа");
		ЭлементБлокировки.УстановитьЗначение("Объект", Выборка.Объект);
		Если ОбъектСНаборами Тогда
			ЭлементБлокировки = Блокировка.Добавить(МетаданныеОбъекта.ПолноеИмя());
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Объект);
		КонецЕсли;
		
		НачатьТранзакцию();
		Попытка
			Блокировка.Заблокировать();
			Если ЗапросПроверки.Выполнить().Пустой() Тогда
				НаборСтарыхЗаписей.Прочитать();
				УточнениеЗаполнено = Ложь;
				ЗаполнитьНовыеНаборыОбъекта(НаборСтарыхЗаписей, НовыеНаборы, УточнениеЗаполнено);
				Если УточнениеЗаполнено И ОбъектСНаборами Тогда
					Объект = Выборка.Объект.ПолучитьОбъект();
					Объект.НаборыЗначенийДоступа.Загрузить(НовыеНаборы);
					ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
				КонецЕсли;
				УправлениеДоступомСлужебный.ПодготовитьНаборыЗначенийДоступаКЗаписи(
					Выборка.Объект, НовыеНаборы, Истина);
				НаборНовыхЗаписей.Загрузить(НовыеНаборы);
				НаборНовыхЗаписей.Записать();
			КонецЕсли;
			НаборСтарыхЗаписей.Очистить();
			НаборСтарыхЗаписей.Записать();
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
	КонецЦикла;
	
	Если Выборка.Количество() < 10000 Тогда
		
		Если НЕ ЗапросНаличияДанных.Выполнить().Пустой() Тогда
			НаборЗаписей = СоздатьНаборЗаписей();
			НаборЗаписей.Записать();
		КонецЕсли;
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Управление доступом.Заполнение данных для ограничения доступа'",
				 ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Информация,
			,
			,
			НСтр("ru = 'Завершен перенос данных из регистра УдалитьНаборыЗначенийДоступа.'"),
			РежимТранзакцииЗаписиЖурналаРегистрации.Транзакционная);
	Иначе
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Управление доступом.Заполнение данных для ограничения доступа'",
				 ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Информация,
			,
			,
			НСтр("ru = 'Выполнен шаг переноса данных из регистра УдалитьНаборыЗначенийДоступа.'"),
			РежимТранзакцииЗаписиЖурналаРегистрации.Транзакционная);
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Процедура ЗаполнитьНовыеНаборыОбъекта(СтарыеЗаписи, НовыеНаборы, УточнениеЗаполнено)
	
	ДействующиеНаборы = Новый Соответствие;
	
	Для каждого СтараяСтрока Из СтарыеЗаписи Цикл
		Если СтараяСтрока.Чтение Или СтараяСтрока.Изменение Тогда
			ДействующиеНаборы.Вставить(СтараяСтрока.НомерНабора, Истина);
		КонецЕсли;
	КонецЦикла;
	
	ВозможныеПрава = УправлениеДоступомСлужебныйПовтИсп.ВозможныеПраваДляНастройкиПравОбъектов();
	ТипыВладельцевНастроекПрав = ВозможныеПрава.ПоТипамСсылок;
	
	Для каждого СтараяСтрока Из СтарыеЗаписи Цикл
		Если ДействующиеНаборы.Получить(СтараяСтрока.НомерНабора) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		НоваяСтрока = НовыеНаборы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтараяСтрока, "НомерНабора, ЗначениеДоступа, Чтение, Изменение");
		
		Если СтараяСтрока.ВидДоступа = ПланыВидовХарактеристик.УдалитьВидыДоступа.ПустаяСсылка() Тогда
			Если СтараяСтрока.ЗначениеДоступа = Неопределено Тогда
				НоваяСтрока.ЗначениеДоступа = Перечисления.ДополнительныеЗначенияДоступа.ДоступЗапрещен;
			Иначе
				НоваяСтрока.ЗначениеДоступа = Перечисления.ДополнительныеЗначенияДоступа.ДоступРазрешен;
			КонецЕсли;
		
		ИначеЕсли СтараяСтрока.ВидДоступа = ПланыВидовХарактеристик.УдалитьВидыДоступа.ПравоЧтения
		      ИЛИ СтараяСтрока.ВидДоступа = ПланыВидовХарактеристик.УдалитьВидыДоступа.ПравоИзменения
		      ИЛИ СтараяСтрока.ВидДоступа = ПланыВидовХарактеристик.УдалитьВидыДоступа.ПравоДобавления Тогда
			
			Если ТипЗнч(СтараяСтрока.ЗначениеДоступа) <> Тип("СправочникСсылка.ИдентификаторыОбъектовМетаданных") Тогда
				Если Метаданные.НайтиПоТипу(ТипЗнч(СтараяСтрока.ЗначениеДоступа)) = Неопределено Тогда
					НоваяСтрока.ЗначениеДоступа = Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка();
				Иначе
					НоваяСтрока.ЗначениеДоступа =
						ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ТипЗнч(СтараяСтрока.ЗначениеДоступа));
				КонецЕсли;
			КонецЕсли;
			
			Если СтараяСтрока.ВидДоступа = ПланыВидовХарактеристик.УдалитьВидыДоступа.ПравоЧтения Тогда
				НоваяСтрока.Уточнение = Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка();
			Иначе
				НоваяСтрока.Уточнение = НоваяСтрока.ЗначениеДоступа;
			КонецЕсли;
			
		ИначеЕсли ТипыВладельцевНастроекПрав.Получить(ТипЗнч(СтараяСтрока.ЗначениеДоступа)) <> Неопределено Тогда
			
			НоваяСтрока.Уточнение = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ТипЗнч(СтараяСтрока.Объект));
		КонецЕсли;
		
		Если ЗначениеЗаполнено(НоваяСтрока.Уточнение) Тогда
			УточнениеЗаполнено = Истина;
		КонецЕсли;
	КонецЦикла;
	
	УправлениеДоступом.ДобавитьНаборыЗначенийДоступа(
		НовыеНаборы, УправлениеДоступом.ТаблицаНаборыЗначенийДоступа(), Ложь, Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли