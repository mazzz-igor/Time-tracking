
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Задача") Тогда
		пОбъект = РеквизитФормыВЗначение("Объект"); 
		пОбъект.Заполнить(Параметры.Задача);
		ЗначениеВРеквизитФормы(пОбъект,"Объект");		
	Конецесли;
	Если Объект.Ссылка.Пустая() Тогда
		Объект.Автор = Пользователи.ТекущийПользователь();
		Объект.ДатаСоздания = ТекущаяДата();		
	Конецесли;
	УстановитьВидимостьДоступность();
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступность()
	
КонецПроцедуры 

&НаКлиенте
Процедура ВопросПриИзменении(Элемент)
	Объект.Наименование = Объект.Вопрос;
КонецПроцедуры
