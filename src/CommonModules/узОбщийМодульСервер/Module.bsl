
Процедура ОтправитьПисьмо(ДопПараметры) Экспорт
	
	ВажностьЗадачи = ДопПараметры.ВажностьЗадачи;
	ТекстПисьма = ДопПараметры.ТекстПисьма;
	ТемаПисьма = ДопПараметры.ТемаПисьма;

	ТЗАдресаЭлектроннойПочты = ПолучитьТЗАдресаЭлектроннойПочты(ДопПараметры);
	
	ТекПользователь = Пользователи.ТекущийПользователь();
	ДокОбъект = Документы.ЭлектронноеПисьмоИсходящее.СоздатьДокумент();	
	ДокОбъект.Дата = ТекущаяДата();
	ДокОбъект.Автор = ТекПользователь;
	
	ДокОбъект.Важность = ПолучитьВажностьДляПисьма(ВажностьЗадачи);
	
	ДокОбъект.Кодировка = "UTF-8";
	ДокОбъект.Ответственный = ТекПользователь;
	//+ #102 Дзеса Ігор
	ДокОбъект.ОтправительПредставление = "1с: Управление задачами";
	//- #102 Дзеса Ігор
	ДокОбъект.СтатусПисьма = ПредопределенноеЗначение("Перечисление.СтатусыИсходящегоЭлектронногоПисьма.Исходящее");
	ДокОбъект.Текст = ТекстПисьма;
	ДокОбъект.Тема = ТемаПисьма;
	ДокОбъект.ТипТекста = ПредопределенноеЗначение("Перечисление.ТипыТекстовЭлектронныхПисем.ПростойТекст");
	ДокОбъект.УчетнаяЗапись = ПредопределенноеЗначение("Справочник.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты");
	
	Если ДопПараметры.Свойство("УчетнаяЗапись") Тогда
		ДокОбъект.УчетнаяЗапись = ДопПараметры.УчетнаяЗапись;
		//+ №102 Дзеса Ігор
		//ДокОбъект.ОтправительПредставление = ДокОбъект.УчетнаяЗапись.Наименование;
		//- №102 Дзеса Ігор
	Конецесли;
	//+ №102 Дзеса Ігор
	ДокОбъект.ОтправительПредставление = ДокОбъект.УчетнаяЗапись.Наименование;
	//- №102 Дзеса Ігор
	
	ЭтоОтправкаКонтрагентам = Ложь;
	Если ДопПараметры.Свойство("ЭтоОтправкаКонтрагентам")
		И ДопПараметры.ЭтоОтправкаКонтрагентам Тогда
		ЭтоОтправкаКонтрагентам = Истина;
	Конецесли;
	
	Если ДопПараметры.Свойство("Задача") Тогда
		ДокОбъект.Предмет = ДопПараметры.Задача;
	Конецесли; 	
	
	пУдалятьПослеОтправки = Истина;
	Если ЭтоОтправкаКонтрагентам Тогда
		пУдалятьПослеОтправки = Ложь;
	Конецесли;
	
	ДокОбъект.УдалятьПослеОтправки = пУдалятьПослеОтправки;
	
	//ДокОбъект.ДатаКогдаОтправить = ;
	
	Для каждого СтрокаТЗАдресаЭлектроннойПочты из ТЗАдресаЭлектроннойПочты цикл
		АдресЭлектроннойПочты = СтрокаТЗАдресаЭлектроннойПочты.АдресЭлектроннойПочты;
		ПользовательКому = СтрокаТЗАдресаЭлектроннойПочты.Пользователь;
		
		СтрокаПолучателиПисьма = ДокОбъект.ПолучателиПисьма.Добавить();
		СтрокаПолучателиПисьма.Адрес         = АдресЭлектроннойПочты;
		СтрокаПолучателиПисьма.Представление = ""+ПользовательКому+" <"+АдресЭлектроннойПочты+">";
		СтрокаПолучателиПисьма.Контакт       = ПользовательКому;
	Конеццикла;
	ДокОбъект.СформироватьПредставленияКонтактов();
	ДокОбъект.Записать();
	
	Если ДопПараметры.Свойство("Задача") Тогда
		пМассивВзаимодействий = Новый Массив();
		пМассивВзаимодействий.Добавить(ДокОбъект.Ссылка);
		
		ВзаимодействияВызовСервера.УстановитьПредметДляМассиваВзаимодействий(
			пМассивВзаимодействий,
			ДопПараметры.Задача);
	Конецесли;
	
КонецПроцедуры 

Функция ПолучитьТЗАдресаЭлектроннойПочты(ДопПараметры)
	Перем ТЗАдресаЭлектроннойПочты;
	
	Если ДопПараметры.Свойство("ТЗАдресаЭлектроннойПочты") Тогда
		ТЗАдресаЭлектроннойПочты = ДопПараметры.ТЗАдресаЭлектроннойПочты;
		Возврат ТЗАдресаЭлектроннойПочты;
	Конецесли;	

	Если ДопПараметры.Свойство("МассивПользователейКому") Тогда
		МассивПользователей = ДопПараметры.МассивПользователейКому;
	Иначе		
		МассивПользователей = Новый Массив();
		МассивПользователей.Добавить(ДопПараметры.ПользовательКому);
	Конецесли;
	
	ТЗАдресаЭлектроннойПочты = ПолучитьТЗАдресаЭлектроннойПочтыПоМассивуПользователей(МассивПользователей);	
	
	Для каждого СтрокаТЗАдресаЭлектроннойПочты из ТЗАдресаЭлектроннойПочты цикл
		ПользовательКому = СтрокаТЗАдресаЭлектроннойПочты.Пользователь;
		Если НЕ ЗначениеЗаполнено(СтрокаТЗАдресаЭлектроннойПочты.АдресЭлектроннойПочты) Тогда
			
			пТекстСообщения = узОбщийМодульСервер.ПолучитьТекстСообщения(
				"Ошибка! при отправке письма не удалось получить адреса электронной почты для [%1]","2");
			пТекстСообщения = СтрШаблон(пТекстСообщения,ПользовательКому);
			Сообщить(пТекстСообщения);			

		Конецесли;
	Конеццикла;	

	Возврат ТЗАдресаЭлектроннойПочты;
КонецФункции 

Функция ПолучитьТЗАдресаЭлектроннойПочтыПоМассивуПользователей(МассивПользователей) 
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПользователиКонтактнаяИнформация.Ссылка КАК Пользователь,
	|	ПользователиКонтактнаяИнформация.АдресЭП КАК АдресЭлектроннойПочты
	|ИЗ
	|	Справочник.Пользователи.КонтактнаяИнформация КАК ПользователиКонтактнаяИнформация
	|ГДЕ
	|	ПользователиКонтактнаяИнформация.Ссылка В(&МассивПользователей)
	|	И ПользователиКонтактнаяИнформация.Тип = &Тип
	|	И ПользователиКонтактнаяИнформация.Вид = &Вид
	|";
	
	Запрос.УстановитьПараметр("Вид", ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.EmailПользователя"));
	Запрос.УстановитьПараметр("МассивПользователей", МассивПользователей);
	Запрос.УстановитьПараметр("Тип", ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты"));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТЗАдресаЭлектроннойПочты = РезультатЗапроса.Выгрузить();
	Возврат ТЗАдресаЭлектроннойПочты;
КонецФункции 

Функция ПолучитьТЗАдресаЭлектроннойПочтыПоМассивуКонтрагентов(МассивКонтрагентов) Экспорт 
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	узКонтрагентыКонтактнаяИнформация.Ссылка КАК Пользователь,
	|	узКонтрагентыКонтактнаяИнформация.АдресЭП КАК АдресЭлектроннойПочты
	|ИЗ
	|	Справочник.узКонтрагенты.КонтактнаяИнформация КАК узКонтрагентыКонтактнаяИнформация
	|ГДЕ
	|	узКонтрагентыКонтактнаяИнформация.Ссылка В(&МассивКонтрагентов)
	|	И узКонтрагентыКонтактнаяИнформация.Тип = &Тип
	|	И узКонтрагентыКонтактнаяИнформация.Вид = &Вид";
	
	Запрос.УстановитьПараметр("Вид", ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.узEmailКонтрагенты"));
	Запрос.УстановитьПараметр("МассивКонтрагентов", МассивКонтрагентов);
	Запрос.УстановитьПараметр("Тип", ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты"));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТЗАдресаЭлектроннойПочты = РезультатЗапроса.Выгрузить();
	Возврат ТЗАдресаЭлектроннойПочты;
КонецФункции 

Процедура узЗагрузкаИзмененийИзХранилища() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.узЗагрузкаИзмененийИзХранилища);	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	узКонфигурации.Ссылка КАК Конфигурация,
	|	узКонфигурации.ПолучатьИзмененияИзХранилища
	|ИЗ
	|	Справочник.узКонфигурации КАК узКонфигурации
	|ГДЕ
	|	узКонфигурации.ПолучатьИзмененияИзХранилища
	|	И НЕ узКонфигурации.ПометкаУдаления";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	Конецесли;
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		пКонфигурация = Выборка.Конфигурация;
		
		ОбрОбъект = Обработки.узЗагрузкаИзмененийИзХранилища.Создать();
		ОбрОбъект.Конфигурация = пКонфигурация;
		ОбрОбъект.ВерсияС = Справочники.узИсторияКонфигураций.ПолучитьПоследнююЗагруженнуюВерсию(пКонфигурация);
		РезультатФункции = ОбрОбъект.ЗагрузитьИзмененияИзХранилища();
		
		пТекстСообщения = узОбщийМодульСервер.ПолучитьТекстСообщения("Загружены изменения для конфигурации [%1] с версии [%2]","3");
		пТекстСообщения = СтрШаблон(пТекстСообщения,пКонфигурация,ОбрОбъект.ВерсияС);
		Сообщить(пТекстСообщения);			
		
	КонецЦикла;
КонецПроцедуры

Функция узОткрыватьСправочникЗадачиПриНачалеРаботыСистемы() Экспорт
	пТекущийПользователь = Пользователи.ТекущийПользователь();
	Возврат пТекущийПользователь.узОткрыватьСправочникЗадачиПриНачалеРаботыСистемы;
КонецФункции 

Функция узОткрыватьКанбанДоскуПриНачалеРаботыСистемы() Экспорт
	пТекущийПользователь = Пользователи.ТекущийПользователь();
	Возврат пТекущийПользователь.узОткрыватьКанбанДоскуПриНачалеРаботыСистемы;
КонецФункции

// Производит запись в служебных регистр информации о наличии заметки по предмету.
//
// Параметры совпадают с параметрами обработчика при записи у элемента справочника.
Процедура узПроверитьНаличиеЗаметокПоПредметуПриЗаписи(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда 
		Возврат; 
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ЗначениеЗаполнено(Источник.Предмет) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Заметки.Ссылка
	|ИЗ
	|	Справочник.Заметки КАК Заметки
	|ГДЕ
	|	Заметки.Предмет = &Предмет
	|	И Заметки.Автор = &Пользователь
	|	И Заметки.ПометкаУдаления = ЛОЖЬ";
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Предмет", Источник.Предмет);
	Запрос.УстановитьПараметр("Пользователь", Источник.Автор);
	Выборка = Запрос.Выполнить().Выбрать();
	ЕстьЗаметки = Выборка.Количество() > 0;

	НаборЗаписей = РегистрыСведений.узНаличиеЗаметокПоПредмету.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Автор.Установить(Источник.Автор);
	НаборЗаписей.Отбор.Предмет.Установить(Источник.Предмет);
	
	Если ЕстьЗаметки Тогда 
		Если НаборЗаписей.Количество() = 0 Тогда
			НоваяЗапись = НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяЗапись, Источник);
			НоваяЗапись.ЕстьЗаметки = Истина;				
		Иначе
			Для Каждого Запись Из НаборЗаписей Цикл
				Запись.ЕстьЗаметки = Истина;
			КонецЦикла;
		КонецЕсли;
	Иначе
		НаборЗаписей.Очистить();
	КонецЕсли;

	НаборЗаписей.Записать();
КонецПроцедуры

Функция ПолучитьHTMLMarkdown(ЗНАЧ ТекстСодержания) Экспорт
	Перем HTMLMarkdown;
	
	ТекстСодержания = СтрЗаменить(ТекстСодержания,Символы.ПС,"\n"); 
	ТекстСодержания = СтрЗаменить(ТекстСодержания,"'",""""); //&quot	
	
	узМакетHTML = ПолучитьОбщийМакет("узМакетHTML");
	узМакетJS = ПолучитьОбщийМакет("узМакетJS");
	узМакетCSS = ПолучитьОбщийМакет("узМакетCSS");
	
	ТекстСкриптаJS = узМакетJS.ПолучитьТекст();
	ТекстCSSМакет = узМакетCSS.ПолучитьТекст();	
	
	HTMLMarkdown = узМакетHTML.ПолучитьТекст();
	HTMLMarkdown = СтрЗаменить(HTMLMarkdown,"...ТекстJS...",ТекстСкриптаJS);
	HTMLMarkdown = СтрЗаменить(HTMLMarkdown,"...ТекстCSS...",ТекстCSSМакет);
	HTMLMarkdown = СтрЗаменить(HTMLMarkdown,"...ТекстHTML...",ТекстСодержания);	
	
	Возврат HTMLMarkdown;
КонецФункции

Функция ПолучитьПользователяПоПользователюХранилища(ПользовательХранилища) Экспорт
	Перем пПользователь;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Пользователи.Ссылка
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|ГДЕ
		|	Пользователи.узПользовательХранилища = &ПользовательХранилища
		|	И Пользователи.Недействителен = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("ПользовательХранилища", ПользовательХранилища);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат пПользователь;
	Конецесли;
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		пПользователь = Выборка.Ссылка;	
	КонецЦикла;
	
	Возврат пПользователь;
КонецФункции 

Процедура узСообщить(ТекстРусский, КодСообщения) Экспорт
	ТекстСообщения = ПолучитьТекстСообщения(ТекстРусский, КодСообщения);
	Сообщить(ТекстСообщения);
КонецПроцедуры 

Функция ПолучитьТекстСообщения(ТекстРусский, КодСообщения) Экспорт
	Возврат РегистрыСведений.узСловарь.ПолучитьТекстСообщения(ТекстРусский, КодСообщения);
КонецФункции

Функция ПолучитьСтруктуруСообщений(МассивКодовСообщений) Экспорт                          
	Возврат РегистрыСведений.узСловарь.ПолучитьСтруктуруСообщений(МассивКодовСообщений);
КонецФункции 

Функция ПолучитьНастройкиДляСозданияФайлаДляЗадачи(Задача,Каталог) Экспорт
	РезультатФункции = Новый Структура();
	
	Массив = Новый Массив;
	
	ИмяДляЗадачи = СобратьНазваниеДляПапки(Задача.Наименование, Задача.Код);
	Массив.Добавить(ИмяДляЗадачи);
	
	ЗаполнитьМассивИерархии(Задача, Массив);
	
	Разделитель = ПолучитьРазделительПутиКлиента();
	ПолныйПутьЗадачи = "";
	
	Для Каждого СтрокаМассива ИЗ Массив Цикл	
		ПолныйПутьЗадачи = СтрокаМассива + Разделитель + ПолныйПутьЗадачи;	
	КонецЦикла;	
	
	//ВызватьИсключение "Еще доделать";
	//to do Организовать выбор своего файла шаблона
	//Выбор расширения из шаблона
	
	ПолныйПутьЗадачи = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(Каталог) + ПолныйПутьЗадачи;
	
	НастройкиШаблонаДляЗадачи = ПолучитьНастройкиШаблонаДляЗадачи();
	ШаблонПоУмолчанию = НастройкиШаблонаДляЗадачи.ШаблонПоУмолчанию;
	Расширение = НастройкиШаблонаДляЗадачи.Расширение;
	
	ИмяДляФайлаЗадачи = ПолныйПутьЗадачи + ИмяДляЗадачи + Расширение;
	
	РезультатФункции.Вставить("ИмяДляФайлаЗадачи", ИмяДляФайлаЗадачи);
	РезультатФункции.Вставить("ШаблонПоУмолчанию", ШаблонПоУмолчанию);
	РезультатФункции.Вставить("ПолныйПутьЗадачи", ПолныйПутьЗадачи);
	
	Возврат РезультатФункции;
	
КонецФункции	

Функция ПолучитьНастройкиШаблонаДляЗадачи() 
	РезультатФункции = Новый Структура();
	
	ШаблонДляЗадачи = ПредопределенноеЗначение("Справочник.узШаблоны.ШаблонДляЗадачи");
	Если ШаблонДляЗадачи.ИспользоватьШаблонУказанныйВручную Тогда
		ШаблонПоУмолчанию = ШаблонДляЗадачи.ФайлШаблонаХранилищеЗначений.Получить();	
		Расширение = ШаблонДляЗадачи.Расширение;
	Иначе
		Расширение = ".docx";
		ШаблонПоУмолчанию = Справочники.узШаблоны.ПолучитьМакет("ШаблонПоУмолчанию");			
	КонецЕсли;
	
	РезультатФункции.Вставить("ШаблонПоУмолчанию",ШаблонПоУмолчанию);
	РезультатФункции.Вставить("Расширение",Расширение);
	
	Возврат РезультатФункции;
КонецФункции 

Процедура ЗаполнитьМассивИерархии(Задача, Массив)
	
	Если Задача.ЭтоОсновнаяЗадача Тогда
		НазваниеДляПапки = СобратьНазваниеДляПапки(Задача.Наименование, Задача.Код);
		Массив.Добавить(НазваниеДляПапки);
	Конецесли;

	пРодитель = Задача.Родитель;
	
	Если ЗначениеЗаполнено(пРодитель) Тогда
		ЗаполнитьМассивИерархии(пРодитель, Массив);
	КонецЕсли;	
		
КонецПроцедуры	

Функция СобратьНазваниеДляПапки(ЗНАЧ Наименование, ЗНАЧ Код)
	Код = ""+Формат(Код,"ЧГ=0");
	
	Шаблон = "#%1 %2";
	
	СокращенноеНаименование = ПолучитьСокращенноеНаименованиеЗадачи(Наименование);	
	
	ОбработанноеНаименование = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(СокращенноеНаименование, "");
	Результат = СтрШаблон(Шаблон, Код, ОбработанноеНаименование);
		
	Возврат Результат;

КонецФункции

Функция ПолучитьСокращенноеНаименованиеЗадачи(НаименованиеЗадачи) 
	Перем СокращенноеНаименование;
	
	МассивПодстрок = СтрРазделить(НаименованиеЗадачи," ");
	КоличествоСлов = МассивПодстрок.Количество();
	
	ДлинаОдногоСлова = 30;
	ДлинаСокращенногоНаименования = 100;
	
	СокращенноеНаименование = "";
	Для каждого пСлово из МассивПодстрок цикл
		СловоДляНаименования = пСлово;
		
		Если СтрДлина(СловоДляНаименования) > ДлинаОдногоСлова Тогда
			СловоДляНаименования = Лев(пСлово,ДлинаОдногоСлова) + "."; 
		Конецесли;
		
		СокращенноеНаименование = СокращенноеНаименование + СловоДляНаименования + " ";
	Конеццикла;
	
	СокращенноеНаименование = Лев(СокращенноеНаименование,ДлинаСокращенногоНаименования);
	СокращенноеНаименование = СокрЛП(СокращенноеНаименование);
	
	Возврат СокращенноеНаименование;
КонецФункции 

Функция ЗначениеРеквизитаОбъекта(Ссылка, Реквизит) Экспорт
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, Реквизит);
КонецФункции

#Область ПрограммноеДобавлениеЭлементовНаФорму

Процедура ДобавитьРеквизитыНаФорму(Форма, ТекущийОбъект) Экспорт
	ТипЗнчОбъект = ТипЗнч(ТекущийОбъект);
	
	Если ТипЗнчОбъект = Тип("СправочникОбъект.УчетныеЗаписиЭлектроннойПочты") Тогда
		ДобавитьРеквизитыНаФорму_УчетныеЗаписиЭлектроннойПочты(Форма, ТекущийОбъект);
	ИначеЕсли ТипЗнчОбъект = Тип("СправочникОбъект.ПравилаОбработкиЭлектроннойПочты") Тогда
		ДобавитьРеквизитыНаФорму_ПравилаОбработкиЭлектроннойПочты(Форма, ТекущийОбъект);			
	Иначе
		ВызватьИсключение "Ошибка! нет алгоритма ДобавитьРеквизитыНаФорму для "+ТекущийОбъект;
	Конецесли;
	
КонецПроцедуры

Процедура ДобавитьРеквизитыНаФорму_УчетныеЗаписиЭлектроннойПочты(Форма, ТекущийОбъект)
	пЭлементыФормы = Форма.Элементы;
	
	ГруппаНаФорме = ДобавитьГруппуНаФорму("узГруппаДополнительно",пЭлементыФормы,пЭлементыФормы.Шапка);
	
	ДобавитьРеквизитНаФорму_ПолеФлажка("узСоздаватьЗадачуПриПолученииПисьма", пЭлементыФормы,ГруппаНаФорме);
	ДобавитьРеквизитНаФорму_ПолеФлажка("узИспользоватьДляОтправкиКотрагентам", пЭлементыФормы,ГруппаНаФорме);	
	ДобавитьРеквизитНаФорму_ПолеВвода("узСозданнуюЗадачуПомещатьВВеткуЗадач", пЭлементыФормы,ГруппаНаФорме);		
	ДобавитьРеквизитНаФорму_ПолеВвода("узСтатусДляЗадачи", пЭлементыФормы,ГруппаНаФорме);	
	
	ГруппаНаФорме.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
КонецПроцедуры  

Процедура ДобавитьРеквизитыНаФорму_ПравилаОбработкиЭлектроннойПочты(Форма, ТекущийОбъект)
	пЭлементыФормы = Форма.Элементы;
	
	ГруппаНаФорме = ДобавитьГруппуНаФорму("узГруппаДополнительно",пЭлементыФормы,Форма);
	
	ДобавитьРеквизитНаФорму_ПолеФлажка("узНеСоздаватьЗадачуПриПолученииПисьма", пЭлементыФормы,ГруппаНаФорме);
	ДобавитьРеквизитНаФорму_ПолеВвода("узСозданнуюЗадачуПомещатьВВеткуЗадач", пЭлементыФормы,ГруппаНаФорме);		
	ДобавитьРеквизитНаФорму_ПолеВвода("узСтатусДляЗадачи", пЭлементыФормы,ГруппаНаФорме);
	
	ГруппаНаФорме.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	пЭлементыФормы.Переместить(ГруппаНаФорме,Форма,пЭлементыФормы.КомпоновщикНастроекНастройкиОтбор);
КонецПроцедуры 

Функция ДобавитьСтраницу_узДополнительно(пЭлементыФормы,ИмяГруппы_Страницы)
	
	ИмяСтраницы_узДополнительно = "узСтраницаДополнительно";
	
	пСтраница_узДополнительно = пЭлементыФормы.Вставить(ИмяСтраницы_узДополнительно,Тип("ГруппаФормы"),пЭлементыФормы[ИмяГруппы_Страницы]);
	пСтраница_узДополнительно.Вид = ВидГруппыФормы.Страница;
	пСтраница_узДополнительно.Заголовок = "Дополнительно";
	
	Возврат ИмяСтраницы_узДополнительно;
КонецФункции

Функция ДобавитьГруппуНаФорму(ИмяРеквизита, пЭлементыФормы, пРодительЭлемента) 
	Перем пГруппаНаФорме;
	
	пГруппаНаФорме = пЭлементыФормы.Вставить(ИмяРеквизита,Тип("ГруппаФормы"),пРодительЭлемента);
	//пГруппаНаФорме.Отображение = 
	пГруппаНаФорме.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	пГруппаНаФорме.Заголовок = "Дополнительно (подсистема управление задачами)";
	
	Возврат пГруппаНаФорме;
	
КонецФункции 

Процедура ДобавитьРеквизитНаФорму_ПолеВвода(ИмяРеквизита, пЭлементыФормы,пРодительЭлемента)
	
	пЭлементПоле = пЭлементыФормы.Вставить(ИмяРеквизита,Тип("ПолеФормы"),
		пРодительЭлемента,Неопределено);
		
	пЭлементПоле.Вид = ВидПоляФормы.ПолеВвода;
	пЭлементПоле.ПутьКДанным = "Объект." + ИмяРеквизита;
	
КонецПроцедуры  

Процедура ДобавитьРеквизитНаФорму_ПолеФлажка(ИмяРеквизита, пЭлементыФормы,пРодительЭлемента)
	
	пЭлементПоле = пЭлементыФормы.Вставить(ИмяРеквизита,Тип("ПолеФормы"),
		пРодительЭлемента,Неопределено);
		
	пЭлементПоле.Вид = ВидПоляФормы.ПолеФлажка;
	пЭлементПоле.ПутьКДанным = "Объект." + ИмяРеквизита;
	
КонецПроцедуры 

Процедура ДобавитьРеквизитыНаФормуСписка(Форма, ИмяМетаданных) Экспорт
	
	Если ИмяМетаданных = ИмяМетаданных_УчетныеЗаписиЭлектроннойПочты() Тогда
		ДобавитьРеквизитыНаФормуСписка_УчетныеЗаписиЭлектроннойПочты(Форма);	
		
	ИначеЕсли ИмяМетаданных = ИмяМетаданных_ПравилаОбработкиЭлектроннойПочты() Тогда
		ДобавитьРеквизитыНаФормуСписка_ПравилаОбработкиЭлектроннойПочты(Форма);
		
	Иначе
		ВызватьИсключение "Ошибка! Нет алгоритма ДобавитьРеквизитыНаФормуСписка "+ИмяМетаданных;	
	Конецесли;
	
	
КонецПроцедуры 

Функция ИмяМетаданных_УчетныеЗаписиЭлектроннойПочты() Экспорт 
	Возврат "Справочник_УчетныеЗаписиЭлектроннойПочты";
КонецФункции 

Функция ИмяМетаданных_ПравилаОбработкиЭлектроннойПочты() Экспорт 
	Возврат "Справочник_ПравилаОбработкиЭлектроннойПочты";
КонецФункции

Процедура ДобавитьРеквизитыНаФормуСписка_УчетныеЗаписиЭлектроннойПочты(Форма)
	пЭлементыФормы = Форма.Элементы;
	
	пЭлементПоле_узСоздаватьЗадачуПриПолученииПисьма = пЭлементыФормы.Вставить(
		"СсылкаузСоздаватьЗадачуПриПолученииПисьма",Тип("ПолеФормы"),пЭлементыФормы.Список,Неопределено);
	пЭлементПоле_узСоздаватьЗадачуПриПолученииПисьма.Вид = ВидПоляФормы.ПолеВвода;
	пЭлементПоле_узСоздаватьЗадачуПриПолученииПисьма.ПутьКДанным = "Список.Ссылка.узСоздаватьЗадачуПриПолученииПисьма";
	
	пЭлементПоле_узСозданнуюЗадачуПомещатьВВеткуЗадач = пЭлементыФормы.Вставить(
		"СсылкаузСозданнуюЗадачуПомещатьВВеткуЗадач",Тип("ПолеФормы"),пЭлементыФормы.Список,Неопределено);
	пЭлементПоле_узСозданнуюЗадачуПомещатьВВеткуЗадач.Вид = ВидПоляФормы.ПолеВвода;
	пЭлементПоле_узСозданнуюЗадачуПомещатьВВеткуЗадач.ПутьКДанным = "Список.Ссылка.узСозданнуюЗадачуПомещатьВВеткуЗадач";
	
	
КонецПроцедуры 

Процедура ДобавитьРеквизитыНаФормуСписка_ПравилаОбработкиЭлектроннойПочты(Форма)
	пЭлементыФормы = Форма.Элементы;
	
	пЭлементПоле_узНеСоздаватьЗадачуПриПолученииПисьма = пЭлементыФормы.Вставить(
		"СсылкаузНеСоздаватьЗадачуПриПолученииПисьма",Тип("ПолеФормы"),пЭлементыФормы.Список,Неопределено);
	пЭлементПоле_узНеСоздаватьЗадачуПриПолученииПисьма.Вид = ВидПоляФормы.ПолеФлажка;
	пЭлементПоле_узНеСоздаватьЗадачуПриПолученииПисьма.ПутьКДанным = "Список.Ссылка.узНеСоздаватьЗадачуПриПолученииПисьма";
	
	пЭлементПоле_узСозданнуюЗадачуПомещатьВВеткуЗадач = пЭлементыФормы.Вставить(
		"СсылкаузСозданнуюЗадачуПомещатьВВеткуЗадач",Тип("ПолеФормы"),пЭлементыФормы.Список,Неопределено);
	пЭлементПоле_узСозданнуюЗадачуПомещатьВВеткуЗадач.Вид = ВидПоляФормы.ПолеВвода;
	пЭлементПоле_узСозданнуюЗадачуПомещатьВВеткуЗадач.ПутьКДанным = "Список.Ссылка.узСозданнуюЗадачуПомещатьВВеткуЗадач";
	
	
КонецПроцедуры 

#КонецОбласти

Процедура ЗаполнитьПредметВПисьме_ЗадачаПоТемеПисьма(УчетнаяЗапись,ПисьмоОбъект,ИнтернетСообщение) Экспорт
	
	Если НЕ УчетнаяЗапись.узСоздаватьЗадачуПриПолученииПисьма Тогда
		Возврат;
	Конецесли;
	
	НастройкиИзПравилОбработки = ОпределитьНастройкиИзПравилОбработки(УчетнаяЗапись,ПисьмоОбъект.Ссылка);
	
	Если НастройкиИзПравилОбработки.ЕстьДопНастройкиИзПравилОбработки 
		И НастройкиИзПравилОбработки.узНеСоздаватьЗадачуПриПолученииПисьма Тогда
		Возврат;
	Конецесли;
	
	узСозданнуюЗадачуПомещатьВВеткуЗадач = УчетнаяЗапись.узСозданнуюЗадачуПомещатьВВеткуЗадач;
	узСтатусДляЗадачи = УчетнаяЗапись.узСтатусДляЗадачи;
	
	Если НастройкиИзПравилОбработки.ЕстьДопНастройкиИзПравилОбработки Тогда
		Если ЗначениеЗаполнено(НастройкиИзПравилОбработки.узСозданнуюЗадачуПомещатьВВеткуЗадач) Тогда
			узСозданнуюЗадачуПомещатьВВеткуЗадач = НастройкиИзПравилОбработки.узСозданнуюЗадачуПомещатьВВеткуЗадач;	
		Конецесли;
		Если ЗначениеЗаполнено(НастройкиИзПравилОбработки.узСтатусДляЗадачи) Тогда
			узСтатусДляЗадачи = НастройкиИзПравилОбработки.узСтатусДляЗадачи;	
		Конецесли;		
	Конецесли;
	
	Если НЕ ЗначениеЗаполнено(узСозданнуюЗадачуПомещатьВВеткуЗадач) Тогда
		узСозданнуюЗадачуПомещатьВВеткуЗадач = Неопределено;
	Конецесли;
	Если НЕ ЗначениеЗаполнено(узСтатусДляЗадачи) Тогда
		узСтатусДляЗадачи = Неопределено;
	Конецесли;	
	
	пЗадача = Неопределено;
	пКонтрагент = Неопределено;
	
	ТипЗнчОтправительКонтакт = ТипЗнч(ПисьмоОбъект.ОтправительКонтакт);
	Если ЗначениеЗаполнено(ПисьмоОбъект.ОтправительКонтакт)
		И ТипЗнчОтправительКонтакт = Тип("СправочникСсылка.узКонтрагенты") Тогда
		пКонтрагент = ПисьмоОбъект.ОтправительКонтакт; 	
	Иначе
		пКонтрагент = API.GetKontragent(ПисьмоОбъект.ОтправительАдрес);
		ПисьмоОбъект.ОтправительКонтакт = пКонтрагент;
	Конецесли;
	
	Если НЕ ЗначениеЗаполнено(пКонтрагент) Тогда
		пКонтрагент = API.CreateKontragent(ПисьмоОбъект.ОтправительПредставление,ПисьмоОбъект.ОтправительАдрес);
	Конецесли;
	
	МассивНомеровЗадач = ПолучитьМассивНомеровЗадачИзТекста(ПисьмоОбъект.Тема);
	Если МассивНомеровЗадач.Количество() > 0 Тогда
		НомемПервойЗадачи = МассивНомеровЗадач[0];
		пЗадача = API.GetTask(НомемПервойЗадачи);
	Конецесли;	
	
	Если НЕ ЗначениеЗаполнено(пЗадача) Тогда
		пТекстHTML = ПисьмоОбъект.ТекстHTML;
		
		НомерКартинки = 1;
		ВложениеСтруктура = Новый Структура();
		Для Каждого ЭлементВложения Из ИнтернетСообщение.Вложения Цикл
			// + #165 Александр { [13.05.2019]
			Если ТипЗнч(ЭлементВложения.Данные) = Тип("ИнтернетПочтовоеСообщение") Тогда
				Продолжить;
			КонецЕсли;
			// - #165 } +++ [13.05.2019]
			
			пКартинка = Новый Картинка(ЭлементВложения.Данные);
			ИмяКартинки = "img"+НомерКартинки+"_"+Формат(ТекущаяДата(),"ДФ=ddMMyyyy_hhmmss");
			пТекстHTML = СтрЗаменить(пТекстHTML,"cid:"+ЭлементВложения.Идентификатор,ИмяКартинки);
			
			ВложениеСтруктура.Вставить(ИмяКартинки,пКартинка);
			
			НомерКартинки = НомерКартинки + 1;
		КонецЦикла;
		
		пЗадача = API.CreateTask(ПисьмоОбъект.Тема, ПисьмоОбъект.Текст,пТекстHTML,узСтатусДляЗадачи
			,узСозданнуюЗадачуПомещатьВВеткуЗадач,пКонтрагент,ВложениеСтруктура);
	Конецесли;
	
	ПисьмоОбъект.Предмет = пЗадача;
	
	//МассивВзаимодействий = Новый Массив();
	//МассивВзаимодействий.Добавить(ПисьмоОбъект.Ссылка);
	//ВзаимодействияВызовСервера.УстановитьПредметДляМассиваВзаимодействий(МассивВзаимодействий,
	//	пЗадача, Истина);
	
	//ВызватьИсключение "Что еще надо сделать";
	////ПолучитьНомерЗадачиИзТемы
	////Получить Контрагента по Email
	////Получить текст задачи с учетом HTML
	////Если не нашли задачу по номеру, тогда создаем новую
	////Создавать письмо о регистрации задачи для Контрагента
	////API.CreateTask();	
КонецПроцедуры 

Функция ОпределитьНастройкиИзПравилОбработки(УчетнаяЗапись,Письмо)
	
	РезультатФункции = Новый Структура();
	РезультатФункции.Вставить("ЕстьДопНастройкиИзПравилОбработки",Ложь);
	РезультатФункции.Вставить("узНеСоздаватьЗадачуПриПолученииПисьма",Ложь);
	РезультатФункции.Вставить("узСозданнуюЗадачуПомещатьВВеткуЗадач",Неопределено);
	РезультатФункции.Вставить("узСтатусДляЗадачи",Неопределено);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ПравилаОбработкиЭлектроннойПочты.Владелец КАК УчетнаяЗапись,
	|	ПравилаОбработкиЭлектроннойПочты.КомпоновщикНастроек,
	|	ПравилаОбработкиЭлектроннойПочты.ПомещатьВПапку
	|	,ПравилаОбработкиЭлектроннойПочты.узНеСоздаватьЗадачуПриПолученииПисьма
	|	,ПравилаОбработкиЭлектроннойПочты.узСозданнуюЗадачуПомещатьВВеткуЗадач
	|	,ПравилаОбработкиЭлектроннойПочты.узСтатусДляЗадачи
	|ИЗ
	|	Справочник.ПравилаОбработкиЭлектроннойПочты КАК ПравилаОбработкиЭлектроннойПочты
	|ГДЕ
	|	ПравилаОбработкиЭлектроннойПочты.Владелец = &УчетнаяЗапись
	|	И (НЕ ПравилаОбработкиЭлектроннойПочты.ПометкаУдаления)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПравилаОбработкиЭлектроннойПочты.РеквизитДопУпорядочивания
	|";
	
	Запрос.УстановитьПараметр("УчетнаяЗапись", УчетнаяЗапись);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат РезультатФункции;	
	КонецЕсли;	
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		пУсловиеВыполнено = ВыполненоУсловиеИзПравилОбработки(Выборка,УчетнаяЗапись,Письмо); 
		
		Если пУсловиеВыполнено Тогда
			РезультатФункции.ЕстьДопНастройкиИзПравилОбработки = Истина;
			РезультатФункции.узНеСоздаватьЗадачуПриПолученииПисьма = Выборка.узНеСоздаватьЗадачуПриПолученииПисьма;
			РезультатФункции.узСозданнуюЗадачуПомещатьВВеткуЗадач = Выборка.узСозданнуюЗадачуПомещатьВВеткуЗадач;
			РезультатФункции.узСтатусДляЗадачи = Выборка.узСтатусДляЗадачи;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат РезультатФункции;
	
КонецФункции

Функция ВыполненоУсловиеИзПравилОбработки(Выборка,УчетнаяЗапись,Письмо)
	пУсловиеВыполнено = Ложь;
	
	МассивПисем = Новый Массив();
	МассивПисем.Добавить(Письмо);
	
	СхемаПравилаОбработки = 
		Справочники.ПравилаОбработкиЭлектроннойПочты.ПолучитьМакет("СхемаПравилаОбработкиЭлектроннойПочты");
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаПравилаОбработки));
	КомпоновщикНастроек.ЗагрузитьНастройки(Выборка.КомпоновщикНастроек.Получить());
	КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		КомпоновщикНастроек.Настройки.Отбор, "Ссылка", МассивПисем, ВидСравненияКомпоновкиДанных.ВСписке);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		КомпоновщикНастроек.Настройки.Отбор,
		"Ссылка.УчетнаяЗапись",
		УчетнаяЗапись,
		ВидСравненияКомпоновкиДанных.Равно);
	
	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(
		СхемаПравилаОбработки,
		КомпоновщикНастроек.ПолучитьНастройки(),
		,,
		Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ТекстЗапроса = МакетКомпоновкиДанных.НаборыДанных.ОсновнойНаборДанных.Запрос;
	ЗапросПравило = Новый Запрос(ТекстЗапроса);
	Для каждого Параметр Из МакетКомпоновкиДанных.ЗначенияПараметров Цикл
		ЗапросПравило.Параметры.Вставить(Параметр.Имя, Параметр.Значение);
	КонецЦикла;
	
	РезультатПисьма = ЗапросПравило.Выполнить();
	Если Не РезультатПисьма.Пустой() Тогда
		пУсловиеВыполнено = Истина;
	КонецЕсли;	
	
	Возврат пУсловиеВыполнено;
КонецФункции 

Функция ПолучитьМассивЗадачИзТекста(Текст) Экспорт 
	
	МассивНомеровЗадач = ПолучитьМассивНомеровЗадачИзТекста(Текст);
	
	МассивЗадач = ПолучитьМассивЗадачПоНомерамЗадач(МассивНомеровЗадач);
	
	Возврат МассивЗадач;
	
КонецФункции

Функция ПолучитьМассивНомеровЗадачИзТекста(Текст) Экспорт

	МассивНомеровЗадач = Новый Массив();
	
	ЧислоУказанныхЗадач = СтрЧислоВхождений(Текст, "#");
	Если ЧислоУказанныхЗадач = 0 Тогда
		Возврат МассивНомеровЗадач;
	Конецесли;
	
	Для НомерВхождения = 1 По ЧислоУказанныхЗадач Цикл
		
		ПозРешетка = СтрНайти(Текст, "#",,,НомерВхождения);
		ТекстНомерЗадачи = "#";
		НомерЗадачи = "";
		
		НомерСимвола = ПозРешетка + 1;
		Символ = Сред(Текст,НомерСимвола,1);
		Пока 48<= КодСимвола(Символ)  
			И  КодСимвола(Символ) <= 57 Цикл
			
			НомерЗадачи = НомерЗадачи + Символ;
			НомерСимвола = НомерСимвола + 1;
			Символ = Сред(Текст,НомерСимвола,1);
		Конеццикла;

		НомерЗадачи = СокрЛП(НомерЗадачи);
		
		Если НЕ ЗначениеЗаполнено(НомерЗадачи) Тогда
			Продолжить;
		Конецесли;
		
		НомерЗадачи = Число(НомерЗадачи);
		
		Если МассивНомеровЗадач.Найти(НомерЗадачи) = Неопределено Тогда
			МассивНомеровЗадач.Добавить(НомерЗадачи);
		Конецесли;
	КонецЦикла;	
	
	Возврат МассивНомеровЗадач;	

КонецФункции 

Функция ПолучитьМассивЗадачПоНомерамЗадач(МассивНомеровЗадач) Экспорт

	МассивЗадач = Новый Массив();
	
	Для каждого НомерЗадачи Из МассивНомеровЗадач Цикл
		
		СсылкаНаЗадачу = Справочники.узЗадачи.НайтиПоКоду(НомерЗадачи);
		Если НЕ ЗначениеЗаполнено(СсылкаНаЗадачу) Тогда
			Продолжить;
		Конецесли;
		
		МассивЗадач.Добавить(СсылкаНаЗадачу);
		
	КонецЦикла;	
	
	Возврат МассивЗадач;
КонецФункции 

Процедура ОтправитьУведомлениеПередЗаписьюВходящегоПисьма(Источник) Экспорт
	//Возврат;
	пЗадача = Источник.Предмет;
	
	Если НЕ ЗначениеЗаполнено(пЗадача) Тогда
		Возврат;
	Конецесли;
	
	Если НЕ Источник.ДополнительныеСвойства.Свойство("узОтправитьУведомлениеОВходящемПисьме") Тогда
		Возврат;
	Конецесли;
	
	СобытияВИстории = Новый Структура();
	СобытияВИстории.Вставить("СтарыйИсполнитель",пЗадача.Исполнитель);
	СобытияВИстории.Вставить("СтарыйСтатус",пЗадача.Статус);
	СобытияВИстории.Вставить("УчетнаяЗапись",Источник.УчетнаяЗапись);
	
	ТЗСобытияВИсторииДляУведомлений = Новый ТаблицаЗначений;
	ТЗСобытияВИсторииДляУведомлений.Колонки.Добавить("ВидСобытия",Новый ОписаниеТипов("ПеречислениеСсылка.узВидыСобытий"));
	ТЗСобытияВИсторииДляУведомлений.Колонки.Добавить("МассивИзмененнийПоКомментариям",Новый ОписаниеТипов("Массив"));
	
	ВидСобытия = ПредопределенноеЗначение("Перечисление.узВидыСобытий.ВходящееПисьмо");
	
	СтрокаТЗСобытияВИсторииДляУведомлений = ТЗСобытияВИсторииДляУведомлений.Добавить();
	СтрокаТЗСобытияВИсторииДляУведомлений.ВидСобытия = ВидСобытия;
	СтрокаТЗСобытияВИсторииДляУведомлений.МассивИзмененнийПоКомментариям = Новый Массив();
	
	СобытияВИстории.Вставить("ТЗСобытияВИсторииДляУведомлений",ТЗСобытияВИсторииДляУведомлений);	
	
	ЗадачаОбъект = пЗадача.ПолучитьОбъект();
	ЗадачаОбъект.ОтправитьУведомлениеНаПочту(СобытияВИстории);

КонецПроцедуры

Процедура узФормированиеФайлаЛистаЗадач() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.узЗагрузкаИзмененийИзХранилища);		
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	узКонфигурации.Ссылка,
	|	узКонфигурации.ФормироватьФайлЛистЗадачВКаталогеЛокальногоРепозитория,
	|	узКонфигурации.КаталогДляВыгрузкиФайлаЛистаЗадач
	|ИЗ
	|	Справочник.узКонфигурации КАК узКонфигурации
	|ГДЕ
	|	узКонфигурации.ФормироватьФайлЛистЗадачВКаталогеЛокальногоРепозитория";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	Конецесли;
	
	ВыборкаПоКонфигурациям = РезультатЗапроса.Выбрать();
	
	ДатаПоследнейВыгрузкиФайлаЛистаЗадач = Справочники.узКонстанты.ПолучитьЗначениеКонстанты(
		"ДатаПоследнейВыгрузкиФайлаЛистаЗадач",Тип("Дата"),,Ложь);
				
	Если НЕ ЗначениеЗаполнено(ДатаПоследнейВыгрузкиФайлаЛистаЗадач) Тогда		
		Справочники.узКонстанты.УстановитьЗначениеКонстанты("ДатаПоследнейВыгрузкиФайлаЛистаЗадач",Дата(1,1,1));		
		ДатаПоследнейВыгрузкиФайлаЛистаЗадач = Дата(1,1,1);
	Конецесли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	узЗадачи.Ссылка,
	|	узЗадачи.ДатаПоследнегоИзменения
	|ИЗ
	|	Справочник.узЗадачи КАК узЗадачи
	|ГДЕ
	|	узЗадачи.ДатаПоследнегоИзменения >= &ДатаПоследнейВыгрузкиФайлаЛистаЗадач";
	
	Запрос.УстановитьПараметр("ДатаПоследнейВыгрузкиФайлаЛистаЗадач", ДатаПоследнейВыгрузкиФайлаЛистаЗадач);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	Конецесли;
	
	Пока ВыборкаПоКонфигурациям.Следующий() Цикл
		пПапкаДляВыгрузки = ВыборкаПоКонфигурациям.КаталогДляВыгрузкиФайлаЛистаЗадач;
		
		пОбработка = Обработки.узФормированиеФайлаСоСпискомЗадач.Создать();
		пОбработка.ПапкаДляВыгрузки = пПапкаДляВыгрузки;		
		// +++ # 124 79Vlad  10.10.2018		
		пОбработка.узКонфигурация = ВыборкаПоКонфигурациям.Ссылка;		
		// --- # 124 79Vlad  10.10.2018
		пОбработка.СформироватьФайл();		

		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Сформирован файл в папку "+пОбработка.ПапкаДляВыгрузки+"\ListTasks.txt";
		Сообщение.Сообщить();
	КонецЦикла;
	
	Справочники.узКонстанты.УстановитьЗначениеКонстанты("ДатаПоследнейВыгрузкиФайлаЛистаЗадач",ДатаПоследнейВыгрузкиФайлаЛистаЗадач);	
КонецПроцедуры


// +++ 79Vlad  06.02.2019
Функция ПолучитьТЗПользователейПоАдресуЭлектроннойПочты(АдресЭлектроннойПочты, ТочноеСоответсвие = Истина) Экспорт
	
	АдресЭлектроннойПочты = СокрЛП(АдресЭлектроннойПочты);
	Если НЕ ТочноеСоответсвие Тогда
		АдресЭлектроннойПочты = "%" + СокрЛП(АдресЭлектроннойПочты) + "%";
	КонецЕсли; 
	
																							
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПользователиКонтактнаяИнформация.Ссылка КАК Пользователь,
	|	ПользователиКонтактнаяИнформация.АдресЭП КАК АдресЭлектроннойПочты,
	|	ПользователиКонтактнаяИнформация.Ссылка.узАвтоматическиСтановитьсяИсполнителемЕслиПрислалПисьмо  КАК АвтоматическиСтановитьсяИсполнителемЕслиПрислалПисьмо
	|ИЗ
	|	Справочник.Пользователи.КонтактнаяИнформация КАК ПользователиКонтактнаяИнформация
	|ГДЕ
	|	ПользователиКонтактнаяИнформация.АдресЭП ПОДОБНО &АдресЭлектроннойПочты
	|	И ПользователиКонтактнаяИнформация.Тип = &Тип
	|	И ПользователиКонтактнаяИнформация.Вид = &Вид";
	
	Запрос.УстановитьПараметр("Вид", ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.EmailПользователя"));
	Запрос.УстановитьПараметр("АдресЭлектроннойПочты", АдресЭлектроннойПочты);
	Запрос.УстановитьПараметр("Тип", ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты"));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТЗПользователей = РезультатЗапроса.Выгрузить();
	Возврат ТЗПользователей;
КонецФункции // --- 79Vlad  06.02.2019

Процедура узСозданиеТекущихДелПоРегламенту(ТекРегламентноеДело = Неопределено) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ТекРегламентноеДело) Тогда
		ТекстСообщения = "Ошибка! Не заполнен параметр ТекРегламентноеДело в узСозданиеТекущихДелПоРегламенту";
		ЗаписьЖурналаРегистрации("log_DeloReglament", УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);				
		Возврат;
	Конецесли;
	
	//ТекстСообщения = "ТипЗначения " + ТипЗнч(МассивТекРегламентныхДел)
	//	+ " ТекРегламентноеДело ["+ МассивТекРегламентныхДел +"]"
	//	;
	//ЗаписьЖурналаРегистрации("log_DeloReglament", УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);				
	
	Справочники.узТекущиеДела.СоздатьТекущееДелоПоРегламентномуДелу(ТекРегламентноеДело);		
	
КонецПроцедуры

Функция ПолучитьВажностьДляПисьма(ВажностьЗадачи)
	Перем пВажностьДляПисьма;
	
	пВажностьПисьмаОбычная = ПредопределенноеЗначение("Перечисление.ВариантыВажностиВзаимодействия.Обычная");
	
	пВажностьДляПисьма = пВажностьПисьмаОбычная;
	
	Если НЕ ЗначениеЗаполнено(ВажностьЗадачи) Тогда
		пВажностьДляПисьма = пВажностьПисьмаОбычная;
		Возврат пВажностьДляПисьма;
	Конецесли;
	
	ТипЗнчВажностьЗадачи = ТипЗнч(ВажностьЗадачи); 
	
	Если ТипЗнчВажностьЗадачи = Тип("ПеречислениеСсылка.ВариантыВажностиВзаимодействия") Тогда
		
		пВажностьДляПисьма = ВажностьЗадачи;
		
	ИначеЕсли ТипЗнчВажностьЗадачи = Тип("ПеречислениеСсылка.ВариантыВажностиЗадачи") Тогда
		
		пВажностьДляПисьма = ПредопределенноеЗначение("Перечисление.ВариантыВажностиВзаимодействия."+ВажностьЗадачи);
		
	ИначеЕсли ТипЗнчВажностьЗадачи = Тип("СправочникСсылка.узВариантыВажностиЗадачи") Тогда
		
		пВариантВажностиВзаимодействия = ВажностьЗадачи.ВариантВажностиВзаимодействия; 
		Если ЗначениеЗаполнено(пВариантВажностиВзаимодействия) Тогда
			пВажностьДляПисьма = пВариантВажностиВзаимодействия;
		Иначе
			пВажностьДляПисьма = ПредопределенноеЗначение("Перечисление.ВариантыВажностиВзаимодействия."+ВажностьЗадачи);
		Конецесли;	
		
	Конецесли;

	Если НЕ ЗначениеЗаполнено(пВажностьДляПисьма) Тогда
		пВажностьДляПисьма = пВажностьПисьмаОбычная;
	Конецесли;
	
	Возврат пВажностьДляПисьма;
КонецФункции 
