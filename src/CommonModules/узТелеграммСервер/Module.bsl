
Функция ПолучитьМассивПолучателей(МассивПользователейКому) Экспорт
	
	МассивПолучателейТелеграмм = Новый Массив();
	
	Для Каждого пПользователь из МассивПользователейКому Цикл
		
		Если НЕ пПользователь.узИспользоватьРассылкуЧерезТелеграмм Тогда
			Продолжить;
		Конецесли;
		
		Если НЕ ЗначениеЗаполнено(пПользователь.узИДПользователяТелеграмм) Тогда
			Продолжить;
		Конецесли;
		
		НастройкаТелеграмм = Новый Структура();
		НастройкаТелеграмм.Вставить("ИД",пПользователь.узИДПользователяТелеграмм);
		НастройкаТелеграмм.Вставить("узИДПользователяТелеграмм",пПользователь.узИДПользователяТелеграмм);
		НастройкаТелеграмм.Вставить("Пользователь",пПользователь);
		
		МассивПолучателейТелеграмм.Добавить(НастройкаТелеграмм);
		
	КонецЦикла;
	
	Возврат МассивПолучателейТелеграмм;
	
	//Вернуть = Новый Массив;
	//
	//спПользователи = Новый СписокЗначений;
	//спПользователи.ЗагрузитьЗначения(МассивПользователейКому);
	//
	//Запрос = Новый Запрос;
	//Запрос.УстановитьПараметр("Пользователи", спПользователи);
	//Запрос.Текст = ПолучитьМассивПолучателей_ТекстЗапроса();
	//
	//тзДанные = Запрос.Выполнить().Выгрузить();
	//
	//Для Каждого стрТЗ из тзДанные Цикл
	//	
	//	Вернуть.Добавить(Новый Структура("ИД, Пользователь", стрТЗ.ИД, стрТЗ.Пользователь));
	//	
	//КонецЦикла;
	//
	//Возврат Вернуть;
	
КонецФункции

Функция Удалить_ПолучитьМассивПолучателей_ТекстЗапроса() 
	//Возврат "
	//|ВЫБРАТЬ
	//|	ПользователиДополнительныеРеквизиты.Ссылка КАК Пользователь,
	//|	ПользователиДополнительныеРеквизиты.Значение,
	//|	ПользователиДополнительныеРеквизиты.Свойство.Заголовок КАК Свойство
	//|ПОМЕСТИТЬ ВТ_Все
	//|ИЗ
	//|	Справочник.Пользователи.ДополнительныеРеквизиты КАК ПользователиДополнительныеРеквизиты
	//|ГДЕ
	//|	ПользователиДополнительныеРеквизиты.Ссылка В(&Пользователи)
	//|	И (ПользователиДополнительныеРеквизиты.Свойство.Заголовок = ""Телеграмм_ИД""
	//|			ИЛИ ПользователиДополнительныеРеквизиты.Свойство.Заголовок = ""Телеграмм_Отключить"")
	//|;
	//|
	//|////////////////////////////////////////////////////////////////////////////////
	//|ВЫБРАТЬ
	//|	ВТ_Все.Пользователь,
	//|	ВТ_Все.Значение КАК ИД,
	//|	NULL КАК Отключить
	//|ПОМЕСТИТЬ ВТ_Раздельно
	//|ИЗ
	//|	ВТ_Все КАК ВТ_Все
	//|ГДЕ
	//|	ВТ_Все.Свойство = ""Телеграмм_ИД""
	//|
	//|ОБЪЕДИНИТЬ ВСЕ
	//|
	//|ВЫБРАТЬ
	//|	ВТ_Все.Пользователь,
	//|	NULL,
	//|	ВТ_Все.Значение
	//|ИЗ
	//|	ВТ_Все КАК ВТ_Все
	//|ГДЕ
	//|	ВТ_Все.Свойство = ""Телеграмм_Отключить""
	//|;
	//|
	//|////////////////////////////////////////////////////////////////////////////////
	//|ВЫБРАТЬ
	//|	ВТ_Раздельно.Пользователь,
	//|	МАКСИМУМ(ВТ_Раздельно.ИД) КАК ИД,
	//|	МАКСИМУМ(ВТ_Раздельно.Отключить) КАК Отключить
	//|ПОМЕСТИТЬ ВТ_Групп
	//|ИЗ
	//|	ВТ_Раздельно КАК ВТ_Раздельно
	//|
	//|СГРУППИРОВАТЬ ПО
	//|	ВТ_Раздельно.Пользователь
	//|;
	//|
	//|////////////////////////////////////////////////////////////////////////////////
	//|ВЫБРАТЬ
	//|	ВТ_Все.Пользователь,
	//|	ЕСТЬNULL(ВТ_Групп.ИД, """") КАК ИД,
	//|	ЕСТЬNULL(ВТ_Групп.Отключить, ЛОЖЬ) КАК Отключить
	//|ПОМЕСТИТЬ ВТ_Данные
	//|ИЗ
	//|	ВТ_Все КАК ВТ_Все
	//|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Групп КАК ВТ_Групп
	//|		ПО ВТ_Все.Пользователь = ВТ_Групп.Пользователь
	//|;
	//|
	//|////////////////////////////////////////////////////////////////////////////////
	//|ВЫБРАТЬ
	//|	ВТ_Данные.Пользователь,
	//|	ВТ_Данные.ИД,
	//|	ВТ_Данные.Отключить
	//|ИЗ
	//|	ВТ_Данные КАК ВТ_Данные
	//|ГДЕ
	//|	НЕ ВТ_Данные.ИД = """"
	//|	И ВТ_Данные.Отключить = ЛОЖЬ	
	//|";
КонецФункции 

Процедура ВыполнитьРассылку(ДопПараметры) Экспорт

	ТокенБота = Константы.узТелеграмм_ТокенБота.Получить();
	Если Не ЗначениеЗаполнено(ТокенБота) Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ДопПараметры.Свойство("МассивПользователейКому") Тогда
		Если ДопПараметры.Свойство("ПользовательКому") Тогда
			МассивПользователейКому = Новый Массив();
			МассивПользователейКому.Добавить(ДопПараметры.ПользовательКому);
			ДопПараметры.Вставить("МассивПользователейКому",МассивПользователейКому);
		Конецесли;
	Конецесли;
	
	МассивПользователейДляОтправки = ПолучитьМассивПолучателей(ДопПараметры.МассивПользователейКому);
	
	Если МассивПользователейДляОтправки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	
	// +++ Григорьев  12.12.2018
	//ТекстПисьма = СтрЗаменить(ДопПараметры.ТекстПисьма, "#", "");
	ТекстПисьма = ЗаменитьЗарезервированныеСимволы(ДопПараметры.ТекстПисьма);
	// --- Григорьев  12.12.2018
	
	ВТДопПараметры = Новый Структура();
	Для каждого ЭлДопПараметры из ДопПараметры Цикл
		ВТДопПараметры.Вставить(ЭлДопПараметры.Ключ, ЭлДопПараметры.Значение);		
	КонецЦикла;
	
	ВТДопПараметры.Вставить("МассивПользователейДляОтправки",МассивПользователейДляОтправки);
	ВТДопПараметры.Вставить("ТекстПисьма",ТекстПисьма);
	ВТДопПараметры.Вставить("ТокенБота",ТокенБота);
	
	ИспользоватьПроксиДляОтправки = Справочники.узКонстанты.ПолучитьЗначениеКонстанты(
		"ТелеграммИспользоватьПроксиДляОтправки",Тип("Булево"),Ложь,Истина,Истина);
	
	Если ИспользоватьПроксиДляОтправки Тогда
		ВыполнитьРассылку_ЧерезПрокси(ВТДопПараметры);
	Иначе
		ВыполнитьРассылку_БезПрокси(ВТДопПараметры);
	Конецесли;
	
КонецПроцедуры

Процедура ВыполнитьРассылку_ЧерезПрокси(ДопПараметры)
	
	МассивПользователейДляОтправки = ДопПараметры.МассивПользователейДляОтправки;
	ТекстПисьма = ДопПараметры.ТекстПисьма;
	ТемаПисьма = ДопПараметры.ТемаПисьма;
	
	пОбработка = Обработки.узРаботаСТелеграм.Создать();
	пОбработка.ОтправитьСообщениеTelegram(ТекстПисьма, МассивПользователейДляОтправки);
	
КонецПроцедуры 

Процедура ВыполнитьРассылку_БезПрокси(ДопПараметры)
	
	МассивПользователейДляОтправки = ДопПараметры.МассивПользователейДляОтправки;
	ТекстПисьма = ДопПараметры.ТекстПисьма;
	ТемаПисьма = ДопПараметры.ТемаПисьма;
	ТокенБота = ДопПараметры.ТокенБота;
	
	Для Каждого элемПолучатель Из МассивПользователейДляОтправки Цикл
		
		Ресурс 		= "bot" + ТокенБота + "/sendMessage?chat_id=" + Формат(элемПолучатель.ИД, "ЧГ=") + "&text=" + ТекстПисьма+"&parse_mode=Markdown&disable_web_page_preview=true";
		//Ресурс 		= "bot" + ТокенБота + "/sendMessage?chat_id=" + Формат(элемПолучатель.ИД, "ЧГ=") + "&text=" + ТекстПисьма+"&disable_web_page_preview=true";
		Соединение  = Новый HTTPСоединение("api.telegram.org", 443,,,,,Новый ЗащищенноеСоединениеOpenSSL());
		ЗапросHTTP 	= Новый HTTPЗапрос(Ресурс);
		Ответ 		= Соединение.Получить(ЗапросHTTP);
		
		Если Не Ответ.КодСостояния = 200 Тогда
			ЗаписьЖурналаРегистрации("Телеграмм.Отправка", УровеньЖурналаРегистрации.Ошибка,,
				, "Не смогли отправить пользователю <"+элемПолучатель.ИД+":"+элемПолучатель.Пользователь+">");
		КонецЕсли;

	КонецЦикла;
	
КонецПроцедуры 


// +++ Григорьев  12.12.2018

////////////////////////////////////////////////////////////////////////////////
//
// Функция ЗаменитьЗарезервированныеСимволы
//
// Описание:
//   Выполняет замену основных зарезервированных символов для протокола URL 
//
// Параметры:
//  ОбрабатываемаяСтрока - <Тип.Строка> - исходная строка для обработки
//
// Возвращаемое значение: 
// 	Результат - <Тип.Строка> - обработанная строка
//
Функция ЗаменитьЗарезервированныеСимволы(ОбрабатываемаяСтрока = Неопределено) Экспорт
	Если ОбрабатываемаяСтрока = Неопределено или НЕ ЗначениеЗаполнено(ОбрабатываемаяСтрока) Тогда
		Возврат ОбрабатываемаяСтрока;
	КонецЕсли; 
	
	пТелеграммИспользоватьЗаменуСимволовВДругуюКодировку = Справочники.узКонстанты.ПолучитьЗначениеКонстанты(
		"ТелеграммИспользоватьЗаменуСимволовВДругуюКодировку",Тип("Булево"),,Истина,Истина);
	
	Если пТелеграммИспользоватьЗаменуСимволовВДругуюКодировку Тогда
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,Символ(37),"%25"); // "%"
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,Символ(33),"%21"); // "!"
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,Символ(34),"%22"); // """  (кавычка)
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,Символ(35),"%23"); // "#" 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,Символ(36),"%24"); // "$"	
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,Символ(38),"%26"); // "&" 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,Символ(39),"%27"); // "'" 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,Символ(42),"%2A"); // "*" 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,Символ(44),"%2C"); // "," 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,Символ(58),"%3A"); // ":" 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,Символ(59),"%3B"); // ";" 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,Символ(60),"%3C"); // "<" 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,Символ(61),"%3D"); // "=" 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,Символ(62),"%3E"); // ">" 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,Символ(63),"%3F"); // "?" 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,Символ(91),"%5B"); // "[" 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,Символ(93),"%5D"); // "]" 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,Символ(94),"%5E"); // "^" 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,Символ(96),"%60"); // "`" 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,Символ(123),"%7B"); // "{" 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,Символ(124),"%7C"); // "|" 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,Символ(125),"%7D"); // "}" 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,Символ(32),"%20"); // " "  (пробел)
	Иначе
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,"%25",Символ(37) ); // "%"
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,"%21",Символ(33) ); // "!"
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,"%22",Символ(34) ); // """  (кавычка)
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,"%23",Символ(35) ); // "#" 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,"%24",Символ(36) ); // "$"	
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,"%26",Символ(38) ); // "&" 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,"%27",Символ(39) ); // "'" 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,"%2A",Символ(42) ); // "*" 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,"%2C",Символ(44) ); // "," 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,"%3A",Символ(58) ); // ":" 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,"%3B",Символ(59) ); // ";" 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,"%3C",Символ(60) ); // "<" 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,"%3D",Символ(61) ); // "=" 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,"%3E",Символ(62) ); // ">" 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,"%3F",Символ(63) ); // "?" 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,"%5B",Символ(91) ); // "[" 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,"%5D",Символ(93) ); // "]" 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,"%5E",Символ(94) ); // "^" 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,"%60",Символ(96) ); // "`" 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,"%7B",Символ(123)); // "{" 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,"%7C",Символ(124)); // "|" 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,"%7D",Символ(125)); // "}" 
		ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока,"%20",Символ(32) ); // " "  (пробел)
	Конецесли;
	
	Возврат ОбрабатываемаяСтрока;
КонецФункции //ЗаменитьЗарезервированныеСимволы
 
// --- Григорьев  12.12.2018



