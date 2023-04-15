#Область ПрограммныйИнтерфейс

// Выполняет обработку тела сообщения из канала в соответствии с алгоритмом текущего канала сообщений.
//
// Параметры:
//  КаналСообщений - Строка - идентификатор канала сообщений, из которого получено сообщение.
//  ТелоСообщения - Произвольный - тело сообщения, полученное из канала, которое подлежит обработке.
//  Отправитель - ПланОбменаСсылка.ОбменСообщениями - конечная точка, которая является отправителем сообщения.
//
Процедура ОбработатьСообщение(Знач КаналСообщений, Знач ТелоСообщения, Знач Отправитель) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если РаботаВМоделиСервисаПовтИсп.ЭтоРазделеннаяКонфигурация() Тогда
		РазделенныйМодуль = ОбщегоНазначения.ОбщийМодуль("СообщенияВМоделиСервисаРазделениеДанных");
	КонецЕсли;
	
	// Чтение сообщения
	ТипСообщения = СообщенияВМоделиСервиса.ТипСообщенияПоИмениКанала(КаналСообщений);
	Сообщение = СообщенияВМоделиСервиса.ПрочитатьСообщениеИзНетипизированногоТела(ТелоСообщения);
	
	СообщенияВМоделиСервиса.ЗаписатьСобытиеНачалоОбработки(Сообщение);
	
	Попытка
		
		Если РаботаВМоделиСервисаПовтИсп.ЭтоРазделеннаяКонфигурация() Тогда
			РазделенныйМодуль.ПриНачалеОбработкиСообщения(Сообщение, Отправитель);
		КонецЕсли;
		
		СообщенияВМоделиСервисаПереопределяемый.ПриНачалеОбработкиСообщения(Сообщение, Отправитель);
		
		// Получение и выполнение обработчика интерфейса сообщений.
		Обработчик = ПолучитьОбработчикКаналаСообщенийСервиса(КаналСообщений);
		Если Обработчик <> Неопределено Тогда
			
			СообщениеОбработано = Ложь;
			Обработчик.ОбработатьСообщениеМоделиСервиса(Сообщение, Отправитель, СообщениеОбработано);
			
		Иначе
			
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось определить обработчик канала сообщений в модели сервиса %1'"), КаналСообщений);
			
		КонецЕсли;
		
		Если РаботаВМоделиСервисаПовтИсп.ЭтоРазделеннаяКонфигурация() Тогда
			РазделенныйМодуль.ПослеОбработкиСообщения(Сообщение, Отправитель, СообщениеОбработано);
		КонецЕсли;
		
		СообщенияВМоделиСервисаПереопределяемый.ПослеОбработкиСообщения(Сообщение, Отправитель, СообщениеОбработано);
		
	Исключение
		
		Если РаботаВМоделиСервисаПовтИсп.ЭтоРазделеннаяКонфигурация() Тогда
			РазделенныйМодуль.ПриОшибкеОбработкиСообщения(Сообщение, Отправитель);
		КонецЕсли;
		
		СообщенияВМоделиСервисаПереопределяемый.ПриОшибкеОбработкиСообщения(Сообщение, Отправитель);
		
		ВызватьИсключение;
		
	КонецПопытки;
	
	СообщенияВМоделиСервиса.ЗаписатьСобытиеОкончаниеОбработки(Сообщение);
	
	Если НЕ СообщениеОбработано Тогда
		
		СообщенияВМоделиСервиса.ОшибкаНеизвестноеИмяКанала(КаналСообщений);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьОбработчикКаналаСообщенийСервиса(КаналСообщений)
	
	ОбработчикиИнтерфейсов = ИнтерфейсыСообщенийВМоделиСервиса.ПолучитьОбработчикиИнтерфейсовПринимаемыхСообщений();
	
	Для Каждого ОбработчикИнтерфейса Из ОбработчикиИнтерфейсов Цикл
		
		ОбработчикиКаналовИнтерфейса  = Новый Массив();
		ОбработчикИнтерфейса.ОбработчикиКаналовСообщений(ОбработчикиКаналовИнтерфейса);
		
		Для Каждого ОбработчикКаналаИнтерфейса Из ОбработчикиКаналовИнтерфейса Цикл
			
			Пакет = ОбработчикКаналаИнтерфейса.Пакет();
			БазовыйТип = ОбработчикКаналаИнтерфейса.БазовыйТип();
			
			ИменаКаналов = ИнтерфейсыСообщенийВМоделиСервиса.ПолучитьКаналыПакета(Пакет, БазовыйТип);
			
			Для Каждого ИмяКанала Из ИменаКаналов Цикл
				Если ИмяКанала = КаналСообщений Тогда
					
					Возврат ОбработчикКаналаИнтерфейса;
					
				КонецЕсли;
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецФункции

#КонецОбласти
