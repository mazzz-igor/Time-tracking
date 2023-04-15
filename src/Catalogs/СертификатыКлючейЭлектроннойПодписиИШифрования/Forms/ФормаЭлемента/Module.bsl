#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЭлектроннаяПодписьСлужебный.НастроитьПояснениеВводаПароля(ЭтотОбъект,
		Элементы.УсиленнаяЗащитаЗакрытогоКлюча.Имя);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	Если Метаданные.Обработки.Найти("ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата") <> Неопределено Тогда
		ОбработкаЗаявлениеНаВыпускНовогоКвалифицированногоСертификата =
			ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(
				"Обработка.ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата");
		ОбработкаЗаявлениеНаВыпускНовогоКвалифицированногоСертификата.ПриСозданииНаСервере(
			Объект, ОткрытьЗаявление);
		ИмяФормыЗаявления = "Обработка.ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата.Форма.ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата";
		ВозможноОткрытьЗаявление = Истина;
	КонецЕсли;
	
	ЕстьОрганизации = Не Метаданные.ОпределяемыеТипы.Организация.Тип.СодержитТип(Тип("Строка"));
	ПриСозданииНаСервереПриЧтенииНаСервере();
	
	Если Элементы.АвтоПоляИзДанныхСертификата.Видимость Тогда
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "НестандартныйСертификат");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Отказ = Истина;
		СтандартныеПодсистемыКлиент.УстановитьХранениеФормы(ЭтотОбъект, Истина);
		ПодключитьОбработчикОжидания("ОбработчикОжиданияДобавитьСертификат", 0.1, Истина);
		Возврат;
		
	ИначеЕсли ОткрытьЗаявление Тогда
		Отказ = Истина;
		СтандартныеПодсистемыКлиент.УстановитьХранениеФормы(ЭтотОбъект, Истина);
		ПодключитьОбработчикОжидания("ОбработчикОжиданияОткрытьЗаявление", 0.1, Истина);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если АдресСертификата <> Неопределено Тогда
		ПриСозданииНаСервереПриЧтенииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_СертификатыКлючейЭлектроннойПодписиИШифрования", Новый Структура, Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// Проверка уникальности наименования.
	Если Не Элементы.Наименование.ТолькоПросмотр Тогда
		ЭлектроннаяПодписьСлужебный.ПроверитьУникальностьПредставления(
			Объект.Наименование, Объект.Ссылка, "Объект.Наименование", Отказ);
	КонецЕсли;
	
	Если ТипЗнч(ПараметрыРеквизитов) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого КлючИЗначение Из ПараметрыРеквизитов Цикл
		ИмяРеквизита = КлючИЗначение.Ключ;
		Свойства     = КлючИЗначение.Значение;
		
		Если Не Свойства.ПроверкаЗаполнения
		 Или ЗначениеЗаполнено(Объект[ИмяРеквизита]) Тогда
			
			Продолжить;
		КонецЕсли;
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Поле %1 не заполнено.'"),
			Элементы[ИмяРеквизита].Заголовок);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, ИмяРеквизита,, Отказ);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьАвтозаполняемыеРеквизиты(Команда)
	
	Показать = Не Элементы.ФормаПоказатьАвтозаполняемыеРеквизиты.Пометка;
	
	Элементы.ФормаПоказатьАвтозаполняемыеРеквизиты.Пометка = Показать;
	Элементы.АвтоПоляИзДанныхСертификата.Видимость = Показать;
	
	Если ЕстьОрганизации Тогда
		Элементы.Организация.Видимость = Показать;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДанныеСертификата(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ОткрытиеИзФормыЭлементаСертификата");
	ПараметрыФормы.Вставить("АдресСертификата", АдресСертификата);
	
	ОткрытьФорму("ОбщаяФорма.Сертификат", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьЗаявлениеПоКоторомуБылПолученСертификат(Команда)
	
	Если ВозможноОткрытьЗаявление Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("СертификатСсылка", Объект.Ссылка);
		ОткрытьФорму(ИмяФормыЗаявления, ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСертификат(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Сертификат еще не записан.'"));
		Возврат;
	КонецЕсли;
	
	Если Модифицированность И Не Записать() Тогда
		Возврат;
	КонецЕсли;
	
	ЭлектроннаяПодписьКлиент.ПроверитьСертификатСправочника(Объект.Ссылка,
		Новый Структура("БезПодтверждения", Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьДанныеСертификатаВФайл(Команда)
	
	ЭлектроннаяПодписьСлужебныйКлиент.СохранитьСертификат(Неопределено, АдресСертификата);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатОтозван(Команда)
	
	Объект.Отозван = Не Объект.Отозван;
	Элементы.ФормаСертификатОтозван.Пометка = Объект.Отозван;
	
	Если Объект.Отозван Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'После записи отменить отзыв будет невозможно.'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииНаСервереПриЧтенииНаСервере()
	
	Если Метаданные.Обработки.Найти("ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата") <> Неопределено Тогда
		ОбработкаЗаявлениеНаВыпускНовогоКвалифицированногоСертификата =
			ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(
				"Обработка.ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата");
		ОбработкаЗаявлениеНаВыпускНовогоКвалифицированногоСертификата.ПриСозданииНаСервереПриЧтенииНаСервере(
			Объект, Элементы);
	КонецЕсли;
	
	ДвоичныеДанныеСертификата = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
		Объект.Ссылка, "ДанныеСертификата").Получить();
	
	Если ТипЗнч(ДвоичныеДанныеСертификата) = Тип("ДвоичныеДанные") Тогда
		Сертификат = Новый СертификатКриптографии(ДвоичныеДанныеСертификата);
		Если ЗначениеЗаполнено(АдресСертификата) Тогда
			ПоместитьВоВременноеХранилище(ДвоичныеДанныеСертификата, АдресСертификата);
		Иначе
			АдресСертификата = ПоместитьВоВременноеХранилище(ДвоичныеДанныеСертификата, УникальныйИдентификатор);
		КонецЕсли;
		ЭлектроннаяПодписьКлиентСервер.ЗаполнитьОписаниеДанныхСертификата(ОписаниеДанныхСертификата, Сертификат);
	Иначе
		АдресСертификата = "";
		Элементы.ПоказатьДанныеСертификата.Доступность  = Ложь;
		Элементы.ФормаПроверитьСертификат.Доступность = ЗначениеЗаполнено(ДвоичныеДанныеСертификата);
		Элементы.ФормаСохранитьДанныеСертификатаВФайл.Доступность = Ложь;
		Элементы.АвтоПоляИзДанныхСертификата.Видимость = Истина;
		Элементы.ФормаПоказатьАвтозаполняемыеРеквизиты.Пометка = Истина;
		Если ЗначениеЗаполнено(ДвоичныеДанныеСертификата) Тогда
			// Поддержка отображения основных свойств нестандартных сертификатов (система iBank2).
			ЭлектроннаяПодписьКлиентСервер.ЗаполнитьОписаниеДанныхСертификата(ОписаниеДанныхСертификата, Объект);
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ФормаСертификатОтозван.Пометка = Объект.Отозван;
	Если Объект.Отозван Тогда
		Элементы.ФормаСертификатОтозван.Доступность = Ложь;
	КонецЕсли;
	
	Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		Если Объект.Добавил      <> Пользователи.ТекущийПользователь()
		   И Объект.Пользователь <> Пользователи.ТекущийПользователь() Тогда
			// Обычный пользователь может изменять только свои сертификаты.
			ТолькоПросмотр = Истина;
		Иначе
			// Обычный пользователь не может изменить права доступа.
			Элементы.Добавил.ТолькоПросмотр = Истина;
			Если Объект.Добавил <> Пользователи.ТекущийПользователь() Тогда
				// Обычный пользователь не может изменять реквизит Пользователь,
				// если не он добавил сертификат.
				Элементы.Пользователь.ТолькоПросмотр = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ЕстьОрганизации = Не Метаданные.ОпределяемыеТипы.Организация.Тип.СодержитТип(Тип("Строка"));
	Элементы.Организация.Видимость = ЕстьОрганизации;
	
	Если Не ЗначениеЗаполнено(АдресСертификата) Тогда
		Возврат; // Сертификат = Неопределено.
	КонецЕсли;
	
	СвойстваСубъекта = ЭлектроннаяПодписьКлиентСервер.СвойстваСубъектаСертификата(Сертификат);
	Если СвойстваСубъекта.Фамилия <> Неопределено Тогда
		Элементы.Фамилия.ТолькоПросмотр = Истина;
	КонецЕсли;
	Если СвойстваСубъекта.Имя <> Неопределено Тогда
		Элементы.Имя.ТолькоПросмотр = Истина;
	КонецЕсли;
	Если СвойстваСубъекта.Отчество <> Неопределено Тогда
		Элементы.Отчество.ТолькоПросмотр = Истина;
	КонецЕсли;
	Если СвойстваСубъекта.Организация <> Неопределено Тогда
		Элементы.Фирма.ТолькоПросмотр = Истина;
	КонецЕсли;
	Если СвойстваСубъекта.Должность <> Неопределено Тогда
		Элементы.Должность.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	ПараметрыРеквизитов = Неопределено;
	ЭлектроннаяПодписьСлужебный.ПередНачаломРедактированияСертификатаКлюча(
		Объект.Ссылка, Сертификат, ПараметрыРеквизитов);
	
	Для каждого КлючИЗначение Из ПараметрыРеквизитов Цикл
		ИмяРеквизита = КлючИЗначение.Ключ;
		Свойства     = КлючИЗначение.Значение;
		
		Если Не Свойства.Видимость Тогда
			Элементы[ИмяРеквизита].Видимость = Ложь;
			
		ИначеЕсли Свойства.ТолькоПросмотр Тогда
			Элементы[ИмяРеквизита].ТолькоПросмотр = Истина
		КонецЕсли;
		Если Свойства.ПроверкаЗаполнения Тогда
			Элементы[ИмяРеквизита].АвтоОтметкаНезаполненного = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Элементы.АвтоПоляИзДанныхСертификата.Видимость =
		    Не Элементы.Фамилия.ТолькоПросмотр   И Не ЗначениеЗаполнено(Объект.Фамилия)
		Или Не Элементы.Имя.ТолькоПросмотр       И Не ЗначениеЗаполнено(Объект.Имя)
		Или Не Элементы.Отчество.ТолькоПросмотр  И Не ЗначениеЗаполнено(Объект.Отчество);
	
	Элементы.ФормаПоказатьАвтозаполняемыеРеквизиты.Пометка =
		Элементы.АвтоПоляИзДанныхСертификата.Видимость;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияДобавитьСертификат()
	
	СтандартныеПодсистемыКлиент.УстановитьХранениеФормы(ЭтотОбъект, Ложь);
	
	ПараметрыСоздания = Новый Структура;
	ПараметрыСоздания.Вставить("ВЛичныйСписок", Истина);
	ПараметрыСоздания.Вставить("Организация", Объект.Организация);
	ПараметрыСоздания.Вставить("СкрытьЗаявление", Ложь);
	
	ЭлектроннаяПодписьСлужебныйКлиент.ДобавитьСертификат(ПараметрыСоздания);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияОткрытьЗаявление()
	
	СтандартныеПодсистемыКлиент.УстановитьХранениеФормы(ЭтотОбъект, Ложь);
	
	Если ВозможноОткрытьЗаявление Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("СертификатСсылка", Объект.Ссылка);
		ОткрытьФорму(ИмяФормыЗаявления, ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
