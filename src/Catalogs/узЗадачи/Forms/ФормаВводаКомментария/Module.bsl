
&НаКлиенте
Процедура КомандаОК(Команда)
	ПараметрыЗакрытия = Новый Структура();
	ПараметрыЗакрытия.Вставить("КлючСтроки",КлючСтроки);
	ПараметрыЗакрытия.Вставить("Комментарий",Комментарий);
	ПараметрыЗакрытия.Вставить("Автор",Автор);
	ПараметрыЗакрытия.Вставить("ДатаКомментария",ДатаКомментария);
	ПараметрыЗакрытия.Вставить("Выполнено",Выполнено);
	ПараметрыЗакрытия.Вставить("ЭтоДобавлениеКомментария",ЭтоДобавлениеКомментария);
	Закрыть(ПараметрыЗакрытия);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("ЭтоДобавлениеКомментария") Тогда
		ДатаКомментария = ТекущаяДата();
		Автор = Пользователи.ТекущийПользователь();
		ЭтоДобавлениеКомментария = Истина;
	Иначе
		КлючСтроки = Параметры.КлючСтроки;
		Комментарий = Параметры.Комментарий;
		Автор = Параметры.Автор;
		ДатаКомментария = Параметры.ДатаКомментария;
		Выполнено = Параметры.Выполнено;
	Конецесли;
	
	УстановитьВидимостьДоступность();
	
	ВыполнитьЛокализацию();
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступность()
	Элементы.Комментарий.ТолькоПросмотр = Истина;
	Если Автор = Пользователи.ТекущийПользователь() Тогда
		Элементы.Комментарий.ТолькоПросмотр = Ложь;
	Конецесли;
КонецПроцедуры 

&НаСервере
Процедура ВыполнитьЛокализацию()
	МассивКодовСообщений = Новый Массив();
	МассивКодовСообщений.Добавить(49); //ОК
	МассивКодовСообщений.Добавить(50); //Выполнено
	МассивКодовСообщений.Добавить(51); //ДатаКомментария
	МассивКодовСообщений.Добавить(52); //Автор
	
	РегистрыСведений.узСловарь.ВыполнитьЛокализацию(Элементы,МассивКодовСообщений);
	
КонецПроцедуры 
