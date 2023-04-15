#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// Работа с этим регистром сведений допускается только через менеджер записи.
// Так обеспечивается режим обновления существующих записей.
// Добавлять записи в этот регистр наборами записей запрещено,
// т.к. при этом будут утеряны настройки, не попавшие в набор записей.

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьПризнакНачальнойВыгрузкиДанных(Знач УзелИнформационнойБазы) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтруктураЗаписи = Новый Структура;
	СтруктураЗаписи.Вставить("УзелИнформационнойБазы", УзелИнформационнойБазы);
	СтруктураЗаписи.Вставить("НачальнаяВыгрузкаДанных", Истина);
	СтруктураЗаписи.Вставить("НомерОтправленногоНачальнаяВыгрузкаДанных",
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(УзелИнформационнойБазы, "НомерОтправленного") + 1);
	
	ОбновитьЗапись(СтруктураЗаписи);
	
КонецПроцедуры

Процедура СнятьПризнакНачальнойВыгрузкиДанных(Знач УзелИнформационнойБазы, Знач НомерПринятого) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ОбщиеНастройкиУзловИнформационныхБаз");
		ЭлементБлокировки.УстановитьЗначение("УзелИнформационнойБазы", УзелИнформационнойБазы);
		Блокировка.Заблокировать();
		
		ТекстЗапроса = "
		|ВЫБРАТЬ 1
		|ИЗ
		|	РегистрСведений.ОбщиеНастройкиУзловИнформационныхБаз КАК ОбщиеНастройкиУзловИнформационныхБаз
		|ГДЕ
		|	ОбщиеНастройкиУзловИнформационныхБаз.УзелИнформационнойБазы = &УзелИнформационнойБазы
		|	И ОбщиеНастройкиУзловИнформационныхБаз.НачальнаяВыгрузкаДанных
		|	И ОбщиеНастройкиУзловИнформационныхБаз.НомерОтправленногоНачальнаяВыгрузкаДанных <= &НомерПринятого
		|	И ОбщиеНастройкиУзловИнформационныхБаз.НомерОтправленногоНачальнаяВыгрузкаДанных <> 0
		|";
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("УзелИнформационнойБазы", УзелИнформационнойБазы);
		Запрос.УстановитьПараметр("НомерПринятого", НомерПринятого);
		Запрос.Текст = ТекстЗапроса;
		
		Если Не Запрос.Выполнить().Пустой() Тогда
			
			СтруктураЗаписи = Новый Структура;
			СтруктураЗаписи.Вставить("УзелИнформационнойБазы", УзелИнформационнойБазы);
			СтруктураЗаписи.Вставить("НачальнаяВыгрузкаДанных", Ложь);
			СтруктураЗаписи.Вставить("НомерОтправленногоНачальнаяВыгрузкаДанных", 0);
			
			ОбновитьЗапись(СтруктураЗаписи);
			
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Функция УстановленПризнакНачальнойВыгрузкиДанных(Знач УзелИнформационнойБазы) Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	1 КАК Поле1
	|ИЗ
	|	РегистрСведений.ОбщиеНастройкиУзловИнформационныхБаз КАК ОбщиеНастройкиУзловИнформационныхБаз
	|ГДЕ
	|	ОбщиеНастройкиУзловИнформационныхБаз.УзелИнформационнойБазы = &УзелИнформационнойБазы
	|	И ОбщиеНастройкиУзловИнформационныхБаз.НачальнаяВыгрузкаДанных";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("УзелИнформационнойБазы", УзелИнформационнойБазы);
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Не Запрос.Выполнить().Пустой();
КонецФункции

Процедура ЗафиксироватьВыполнениеКорректировкиИнформацииСопоставленияБезусловно(УзелИнформационнойБазы) Экспорт
	
	СтруктураЗаписи = Новый Структура;
	СтруктураЗаписи.Вставить("УзелИнформационнойБазы", УзелИнформационнойБазы);
	СтруктураЗаписи.Вставить("ВыполнитьКорректировкуИнформацииСопоставления", Ложь);
	
	ОбновитьЗапись(СтруктураЗаписи);
	
КонецПроцедуры

Процедура ЗафиксироватьВыполнениеКорректировкиИнформацииСопоставления(УзелИнформационнойБазы, НомерОтправленного) Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ 1
	|ИЗ
	|	РегистрСведений.ОбщиеНастройкиУзловИнформационныхБаз КАК ОбщиеНастройкиУзловИнформационныхБаз
	|ГДЕ
	|	ОбщиеНастройкиУзловИнформационныхБаз.УзелИнформационнойБазы = &УзелИнформационнойБазы
	|	И ОбщиеНастройкиУзловИнформационныхБаз.ВыполнитьКорректировкуИнформацииСопоставления
	|	И ОбщиеНастройкиУзловИнформационныхБаз.НомерОтправленного <= &НомерОтправленного
	|	И ОбщиеНастройкиУзловИнформационныхБаз.НомерОтправленного <> 0
	|";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("УзелИнформационнойБазы", УзелИнформационнойБазы);
	Запрос.УстановитьПараметр("НомерОтправленного", НомерОтправленного);
	Запрос.Текст = ТекстЗапроса;
	
	Если Не Запрос.Выполнить().Пустой() Тогда
		
		СтруктураЗаписи = Новый Структура;
		СтруктураЗаписи.Вставить("УзелИнформационнойБазы", УзелИнформационнойБазы);
		СтруктураЗаписи.Вставить("ВыполнитьКорректировкуИнформацииСопоставления", Ложь);
		
		ОбновитьЗапись(СтруктураЗаписи);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьНеобходимостьВыполненияКорректировкиИнформацииСопоставленияДляВсехУзловИнформационнойБазы() Экспорт
	
	Для Каждого ИмяПланаОбмена Из ОбменДаннымиПовтИсп.ПланыОбменаБСП() Цикл
		
		Если ОбменДаннымиПовтИсп.ЭтоПланОбменаРаспределеннойИнформационнойБазы(ИмяПланаОбмена) Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого Узел Из ОбменДаннымиСервер.УзлыПланаОбмена(ИмяПланаОбмена) Цикл
			
			СтруктураЗаписи = Новый Структура;
			СтруктураЗаписи.Вставить("УзелИнформационнойБазы", Узел);
			СтруктураЗаписи.Вставить("ВыполнитьКорректировкуИнформацииСопоставления", Истина);
			
			ОбновитьЗапись(СтруктураЗаписи);
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Функция НеобходимоВыполнитьКорректировкуИнформацииСопоставления(УзелИнформационнойБазы, НомерОтправленного) Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ 1
	|ИЗ
	|	РегистрСведений.ОбщиеНастройкиУзловИнформационныхБаз КАК ОбщиеНастройкиУзловИнформационныхБаз
	|ГДЕ
	|	  ОбщиеНастройкиУзловИнформационныхБаз.УзелИнформационнойБазы = &УзелИнформационнойБазы
	|	И ОбщиеНастройкиУзловИнформационныхБаз.ВыполнитьКорректировкуИнформацииСопоставления
	|";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("УзелИнформационнойБазы", УзелИнформационнойБазы);
	Запрос.Текст = ТекстЗапроса;
	
	Результат = Не Запрос.Выполнить().Пустой();
	
	Если Результат Тогда
		
		СтруктураЗаписи = Новый Структура;
		СтруктураЗаписи.Вставить("УзелИнформационнойБазы", УзелИнформационнойБазы);
		СтруктураЗаписи.Вставить("ВыполнитьКорректировкуИнформацииСопоставления", Истина);
		СтруктураЗаписи.Вставить("НомерОтправленного", НомерОтправленного);
		
		ОбновитьЗапись(СтруктураЗаписи);
		
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Процедура УстановитьПризнакОтправкиДанных(Знач Получатель) Экспорт
	
	Если Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураЗаписи = Новый Структура;
	СтруктураЗаписи.Вставить("УзелИнформационнойБазы", Получатель);
	СтруктураЗаписи.Вставить("ВыполнитьОтправкуДанных", Истина);
	
	ОбновитьЗапись(СтруктураЗаписи);
	
КонецПроцедуры

Процедура СнятьПризнакОтправкиДанных(Знач Получатель) Экспорт
	
	Если Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыполнитьОтправкуДанных(Получатель) Тогда
		
		СтруктураЗаписи = Новый Структура;
		СтруктураЗаписи.Вставить("УзелИнформационнойБазы", Получатель);
		СтруктураЗаписи.Вставить("ВыполнитьОтправкуДанных", Ложь);
		
		ОбновитьЗапись(СтруктураЗаписи);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ВыполнитьОтправкуДанных(Знач Получатель) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ОбщиеНастройкиУзловИнформационныхБаз.ВыполнитьОтправкуДанных КАК ВыполнитьОтправкуДанных
	|ИЗ
	|	РегистрСведений.ОбщиеНастройкиУзловИнформационныхБаз КАК ОбщиеНастройкиУзловИнформационныхБаз
	|ГДЕ
	|	ОбщиеНастройкиУзловИнформационныхБаз.УзелИнформационнойБазы = &Получатель";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Получатель", Получатель);
	Запрос.Текст = ТекстЗапроса;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.ВыполнитьОтправкуДанных = Истина;
	
КонецФункции

Процедура УстановитьВерсиюКорреспондента(Знач Корреспондент, Знач Версия) Экспорт
	
	Если Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(Версия) Тогда
		Версия = "0.0.0.0";
	КонецЕсли;
	
	Если ВерсияКорреспондента(Корреспондент) <> СокрЛП(Версия) Тогда
		
		СтруктураЗаписи = Новый Структура;
		СтруктураЗаписи.Вставить("УзелИнформационнойБазы", Корреспондент);
		СтруктураЗаписи.Вставить("ВерсияКорреспондента", СокрЛП(Версия));
		
		ОбновитьЗапись(СтруктураЗаписи);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ВерсияКорреспондента(Знач Корреспондент) Экспорт
	
	Если Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат "0.0.0.0";
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ОбщиеНастройкиУзловИнформационныхБаз.ВерсияКорреспондента КАК ВерсияКорреспондента
	|ИЗ
	|	РегистрСведений.ОбщиеНастройкиУзловИнформационныхБаз КАК ОбщиеНастройкиУзловИнформационныхБаз
	|ГДЕ
	|	ОбщиеНастройкиУзловИнформационныхБаз.УзелИнформационнойБазы = &Корреспондент";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Корреспондент", Корреспондент);
	Запрос.Текст = ТекстЗапроса;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат "0.0.0.0";
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Результат = СокрЛП(Выборка.ВерсияКорреспондента);
	
	Если ПустаяСтрока(Результат) Тогда
		Результат = "0.0.0.0";
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Процедура УстановитьПризнакНастройкаЗавершена(УзелОбмена) Экспорт
	
	СтруктураЗаписи = Новый Структура;
	СтруктураЗаписи.Вставить("УзелИнформационнойБазы", УзелОбмена);
	СтруктураЗаписи.Вставить("НастройкаЗавершена",     Истина);
	
	ОбновитьЗапись(СтруктураЗаписи);
	
КонецПроцедуры

Функция НастройкаЗавершена(УзелОбмена) Экспорт
	
	Результат = Ложь;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ОбщиеНастройкиУзловИнформационныхБаз.НастройкаЗавершена КАК НастройкаЗавершена
	|ИЗ
	|	РегистрСведений.ОбщиеНастройкиУзловИнформационныхБаз КАК ОбщиеНастройкиУзловИнформационныхБаз
	|ГДЕ
	|	ОбщиеНастройкиУзловИнформационныхБаз.УзелИнформационнойБазы = &УзелОбмена");
	Запрос.УстановитьПараметр("УзелОбмена", УзелОбмена);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат = Выборка.НастройкаЗавершена;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура УстановитьПризнакНачальныйОбразСоздан(УзелОбмена) Экспорт
	
	СтруктураЗаписи = Новый Структура;
	СтруктураЗаписи.Вставить("УзелИнформационнойБазы", УзелОбмена);
	СтруктураЗаписи.Вставить("НачальныйОбразСоздан",   Истина);
	
	ОбновитьЗапись(СтруктураЗаписи);
	
КонецПроцедуры

Функция НачальныйОбразСоздан(УзелОбмена) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ИСТИНА КАК НачальныйОбразСоздан
	|ИЗ
	|	РегистрСведений.ОбщиеНастройкиУзловИнформационныхБаз КАК ОбщиеНастройкиУзловИнформационныхБаз
	|ГДЕ
	|	ОбщиеНастройкиУзловИнформационныхБаз.УзелИнформационнойБазы = &УзелОбмена
	|	И ОбщиеНастройкиУзловИнформационныхБаз.НачальныйОбразСоздан");
	Запрос.УстановитьПараметр("УзелОбмена", УзелОбмена);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Возврат Выборка.Следующий();
	
КонецФункции

Процедура ОбновитьПрефиксы(УзелОбмена, Префикс = "", ПрефиксКорреспондента = "") Экспорт
	
	ЕстьПрефикс = Ложь;
	
	СтруктураЗаписи = Новый Структура;
	СтруктураЗаписи.Вставить("УзелИнформационнойБазы", УзелОбмена);
	
	Если ЗначениеЗаполнено(Префикс) Тогда
		СтруктураЗаписи.Вставить("Префикс", Префикс);
		ЕстьПрефикс = Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПрефиксКорреспондента) Тогда
		СтруктураЗаписи.Вставить("ПрефиксКорреспондента", ПрефиксКорреспондента);
		ЕстьПрефикс = Истина;
	КонецЕсли;
	
	Если ЕстьПрефикс Тогда
		ОбновитьЗапись(СтруктураЗаписи);
	КонецЕсли;
	
КонецПроцедуры

Функция ПрефиксыУзла(УзелОбмена) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Префикс", "");
	Результат.Вставить("ПрефиксКорреспондента", "");
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ОбщиеНастройкиУзловИнформационныхБаз.Префикс КАК Префикс,
	|	ОбщиеНастройкиУзловИнформационныхБаз.ПрефиксКорреспондента КАК ПрефиксКорреспондента
	|ИЗ
	|	РегистрСведений.ОбщиеНастройкиУзловИнформационныхБаз КАК ОбщиеНастройкиУзловИнформационныхБаз
	|ГДЕ
	|	ОбщиеНастройкиУзловИнформационныхБаз.УзелИнформационнойБазы = &УзелИнформационнойБазы");
	Запрос.УстановитьПараметр("УзелИнформационнойБазы", УзелОбмена);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(Результат, Выборка);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ПоместитьСообщениеДляСопоставленияДанных(УзелОбмена, ИдентификаторСообщения) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтруктураЗаписи = Новый Структура;
	СтруктураЗаписи.Вставить("УзелИнформационнойБазы",          УзелОбмена);
	СтруктураЗаписи.Вставить("СообщениеДляСопоставленияДанных", ИдентификаторСообщения);
	
	ОбновитьЗапись(СтруктураЗаписи);
	
КонецПроцедуры

// Процедура обновляет запись в регистре по переданным значениям структуры.
//
Процедура ОбновитьЗапись(СтруктураЗаписи)
	
	ОбменДаннымиСервер.ОбновитьЗаписьВРегистрСведений(СтруктураЗаписи, "ОбщиеНастройкиУзловИнформационныхБаз");
	
КонецПроцедуры

#Область ОбработчикиОбновления

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра             = "РегистрСведений.ОбщиеНастройкиУзловИнформационныхБаз";
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("ПланыОбменаМассив",                 Новый Массив);
	ПараметрыЗапроса.Вставить("ДополнительныеСвойстваПланаОбмена", "");
	ПараметрыЗапроса.Вставить("РезультатВоВременнуюТаблицу",       Истина);
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ЗапросУзлыОбмена = Новый Запрос(ОбменДаннымиСервер.ТекстЗапросаПланыОбменаДляМонитора(ПараметрыЗапроса, Ложь));
	ЗапросУзлыОбмена.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	ЗапросУзлыОбмена.Выполнить();
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПланыОбменаКонфигурации.УзелИнформационнойБазы КАК УзелИнформационнойБазы
	|ИЗ
	|	ПланыОбменаКонфигурации КАК ПланыОбменаКонфигурации
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОбщиеНастройкиУзловИнформационныхБаз КАК ОбщиеНастройкиУзловИнформационныхБаз
	|		ПО (ОбщиеНастройкиУзловИнформационныхБаз.УзелИнформационнойБазы = ПланыОбменаКонфигурации.УзелИнформационнойБазы)
	|ГДЕ
	|	ПланыОбменаКонфигурации.УзелИнформационнойБазы <> НЕОПРЕДЕЛЕНО
	|	И (ОбщиеНастройкиУзловИнформационныхБаз.УзелИнформационнойБазы ЕСТЬ NULL
	|			ИЛИ НЕ ОбщиеНастройкиУзловИнформационныхБаз.НастройкаЗавершена
	|				И ОбщиеНастройкиУзловИнформационныхБаз.Префикс = """"
	|				И ОбщиеНастройкиУзловИнформационныхБаз.ПрефиксКорреспондента = """")");
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	ДополнитьТаблицуОбработаннымиУзламиРИБ(Результат);
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Результат, ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ДополнитьТаблицуОбработаннымиУзламиРИБ(ТаблицаУзлы)
	
	Запрос = Новый Запрос;
	
	ЕстьПланыОбменаРИБ = Ложь;
	
	Для Каждого ИмяПланаОбмена Из ОбменДаннымиПовтИсп.ПланыОбменаБСП() Цикл
		Если Не ОбменДаннымиПовтИсп.ЭтоПланОбменаРаспределеннойИнформационнойБазы(ИмяПланаОбмена) Тогда
			Продолжить;
		КонецЕсли;
		ЕстьПланыОбменаРИБ = Истина;
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ТаблицаПланаОбмена.Ссылка КАК УзелИнформационнойБазы,
		|	ТаблицаПланаОбмена.Код КАК КодУзла,
		|	ОбщиеНастройкиУзловИнформационныхБаз.ПрефиксКорреспондента КАК ПрефиксКорреспондента
		|ИЗ
		|	#ТаблицаПланаОбмена КАК ТаблицаПланаОбмена
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ОбщиеНастройкиУзловИнформационныхБаз КАК ОбщиеНастройкиУзловИнформационныхБаз
		|		ПО (ОбщиеНастройкиУзловИнформационныхБаз.УзелИнформационнойБазы = ТаблицаПланаОбмена.Ссылка)
		|ГДЕ
		|	НЕ ТаблицаПланаОбмена.ЭтотУзел
		|	И ОбщиеНастройкиУзловИнформационныхБаз.НастройкаЗавершена
		|	И ОбщиеНастройкиУзловИнформационныхБаз.НачальныйОбразСоздан
		|	И ОбщиеНастройкиУзловИнформационныхБаз.ПрефиксКорреспондента = """"";
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ТаблицаПланаОбмена", "ПланОбмена." + ИмяПланаОбмена);
		
		Если Не ПустаяСтрока(Запрос.Текст) Тогда
			Запрос.Текст = Запрос.Текст + "
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|";
		КонецЕсли;
		
		Запрос.Текст = Запрос.Текст + ТекстЗапроса;
		
	КонецЦикла;
	
	Если Не ЕстьПланыОбменаРИБ Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		КодУзла = СокрЛП(Выборка.КодУзла);
		
		Если КодУзла <> Выборка.КодУзла
			И СтрДлина(КодУзла) = 2
			И ПустаяСтрока(Выборка.ПрефиксКорреспондента) Тогда
			
			СтрокаУзлы = ТаблицаУзлы.Добавить();
			СтрокаУзлы.УзелИнформационнойБазы = Выборка.УзелИнформационнойБазы;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ОбработкаЗавершена = Истина;
	
	МетаданныеРегистра    = Метаданные.РегистрыСведений.ОбщиеНастройкиУзловИнформационныхБаз;
	ПолноеИмяРегистра     = МетаданныеРегистра.ПолноеИмя();
	ПредставлениеРегистра = МетаданныеРегистра.Представление();
	ПредставлениеОтбора   = НСтр("ru = 'УзелИнформационнойБазы = ""%1""'");
	
	ДополнительныеПараметрыВыборкиДанныхДляОбработки = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыВыборкиДанныхДляОбработки();
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьИзмеренияНезависимогоРегистраСведенийДляОбработки(
		Параметры.Очередь, ПолноеИмяРегистра, ДополнительныеПараметрыВыборкиДанныхДляОбработки);
	
	Обработано = 0;
	Проблемных = 0;
	
	Пока Выборка.Следующий() Цикл
		
		Попытка
			
			ОбновитьОбщиеНастройкиКорреспондента(Выборка.УзелИнформационнойБазы);
			Обработано = Обработано + 1;
			
		Исключение
			
			Проблемных = Проблемных + 1;
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обработать набор записей регистра ""%1"" с отбором %2 по причине:
				|%3'"), ПредставлениеРегистра, ПредставлениеОтбора, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеРегистра, , ТекстСообщения);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Если Не ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяРегистра) Тогда
		ОбработкаЗавершена = Ложь;
	КонецЕсли;
	
	Если Обработано = 0 И Проблемных <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедуре РегистрыСведений.ОбщиеНастройкиУзловИнформационныхБаз.ОбработатьДанныеДляПереходаНаНовуюВерсию не удалось обработать некоторые записи узлов обмена (пропущены): %1'"), 
			Проблемных);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,
			, ,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедура РегистрыСведений.ОбщиеНастройкиУзловИнформационныхБаз.ОбработатьДанныеДляПереходаНаНовуюВерсию обработала очередную порцию записей: %1'"),
			Обработано));
	КонецЕсли;
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

Процедура ОбновитьОбщиеНастройкиКорреспондента(УзелИнформационнойБазы) Экспорт
	
	Если Не ЗначениеЗаполнено(УзелИнформационнойБазы) Тогда
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.УзелИнформационнойБазы.Установить(УзелИнформационнойБазы);
		
		ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей);
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ОбщиеНастройкиУзловИнформационныхБаз");
		ЭлементБлокировки.УстановитьЗначение("УзелИнформационнойБазы", УзелИнформационнойБазы);
		
		Блокировка.Заблокировать();
		
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.УзелИнформационнойБазы.Установить(УзелИнформационнойБазы);
		
		НаборЗаписей.Прочитать();
		
		Если НаборЗаписей.Количество() > 0 Тогда
			ТекущаяЗапись = НаборЗаписей[0];
		Иначе
			ТекущаяЗапись = НаборЗаписей.Добавить();
			ТекущаяЗапись.УзелИнформационнойБазы = УзелИнформационнойБазы;
		КонецЕсли;
		
		НастройкаЗавершенаДоИзменения = ТекущаяЗапись.НастройкаЗавершена;
		
		ТекущаяЗапись.НастройкаЗавершена = Истина;
		
		Если ОбменДаннымиПовтИсп.ЭтоУзелРаспределеннойИнформационнойБазы(УзелИнформационнойБазы)
			И Не УзелИнформационнойБазы = ПланыОбмена.ГлавныйУзел() Тогда
			ТекущаяЗапись.НачальныйОбразСоздан = Истина;
		КонецЕсли;
		
		Если ОбменДаннымиПовтИсп.ЭтоУзелРаспределеннойИнформационнойБазы(УзелИнформационнойБазы)
			И НастройкаЗавершенаДоИзменения Тогда
			КодЭтогоУзла = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбменДаннымиПовтИсп.ПолучитьЭтотУзелПланаОбмена(
				ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(УзелИнформационнойБазы)), "Код");
			Если КодЭтогоУзла <> СокрЛП(КодЭтогоУзла) Тогда
				ТекущаяЗапись.Префикс = "";
			КонецЕсли;
		КонецЕсли;
		
		Если ПустаяСтрока(ТекущаяЗапись.ПрефиксКорреспондента) Тогда
			КодУзла = СокрЛП(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(УзелИнформационнойБазы, "Код"));
			Если СтрДлина(КодУзла) = 2 Тогда
				ТекущаяЗапись.ПрефиксКорреспондента = КодУзла;
			КонецЕсли;
		КонецЕсли;
			
		ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли