  with activity_authors as (select aa.activityID,                            #Найдем авторов активностей
           group_concat(au.title separator ', ') as activity_authors          #Cгруппируем их в одну строку так как у одного мероприятий может быть несколько авторов
    from labs.activity_author aa
             left join labs.author au on aa.authorID = au.id
    group by aa.activityID
),
     event_authors as (                                                       #Найдем авторов мероприятий
         select ea.eventID,
                group_concat(au.title separator ', ') as activity_authors   #Сгруппируем их в одну строку так как у одного мероприятий может быть несколько авторов
         from labs.event_author ea
                  left join labs.author au on ea.authorID = au.id
         group by ea.eventID
     ),
     reflex as (                                                            #Обратная связь
         select e.id                       as e_id,
                count(distinct ufa.userID) as user_feedback                 # Посчтаем сколько людей оставили обратную связь
         FROM labs.user_feedback_answer ufa
                  left join labs.event e on e.id = ufa.eventID             
         where ufa.value is not null                                        # Не учитываем тех, у кого пустые значения в ОС
            or ufa.data is not null
         group by e.id
     ),
     checkin as (                                                           #Чекины
         select e.id           as e_id,
                sum(c.checkin) as checkins
         from labs.checkin c
                  left join labs.event e on e.id = c.eventID
         group by e.id
     ),
     attendance as (                                                        #Посещаемость
         select e.id              as e_id,
                sum(c.attendance) as attendance
         from labs.checkin c
                  left join labs.event e on e.id = c.eventID
         group by e.id
     ),
     recorded as (                                                          #Записано людей
         select r.id                       as r_ID,
                count(distinct uar.userID) as users
         from labs.user_activity_request uar
                  left join labs.run r on r.id = uar.runID
         where uar.status = 'approved'
         group by r.id
     )

select distinct c.id                                   as contextID,
                c.title                                as context_title,
                a.id                                   as activityID,
                a.title                                as activity_title,
                a.description                          as 'Описание активности',
                a.short                                as 'Короткое описание',
                a.createDT                             as 'Дата создания активности',
                aa.activity_authors                    as 'Авторы активности',
                ty.title                               as 'Тип активности',
                r.id                                   as runID,
                r.startRequest                         as startRequest,
                r.endRequest                           as endRequest,
                e.id                                   as eventID,
                e.title                                as 'Название мероприятия',
                e.description                          as 'Описание мероприятия',
                e.createDT                             as 'Дата создания мероприятия',
                place.capacity                         as 'Вместимость мероприятия',
                date(t.startDT)                        as 'Дата начала мероприятия',
                timediff(time(t.startDT), '-03:00:00') as 'Время начала мероприятия',
                date(t.endDT)                          as 'Дата конца мероприятия',
                timediff(time(t.endDT), '-03:00:00')   as 'Время конца мероприятия',
                ea.activity_authors                    as 'Авторы мероприятия',
                r.isRequest                            as isRequest,
                a.requestType                          as 'Тип записи',
                rec.users                              as 'Записано',
                ch.checkins                            as 'Чекинов',
                att.attendance                         as 'Посетило человек по журналу',
                ref.user_feedback                      as 'Человек оставили обратную связь'
from labs.activity a
         left join labs.context_activity ca on ca.activityID = a.id
         left join labs.run r on r.activityID = a.id
         left join labs.event e on e.runID = r.id
         left join labs.place on place.id = e.placeID
         left join labs.context c on ca.contextID = c.id
         left join labs.timeslot t on t.id = e.timeslotID
         left join labs.activity_type at on a.id = at.activityID
         left join labs.type ty on at.typeID = ty.id
         left join activity_authors aa on aa.activityID = a.id
         left join event_authors ea on e.id = ea.eventID
         left join reflex ref on ref.e_id = e.id
         left join checkin ch on ch.e_id = e.id
         left join attendance att on att.e_id = e.id
         left join recorded rec on rec.r_ID = r.id
where c.id in (142, 146, 132, 130, 153, 135, 145, 139, 166, 140, 167, 144, 147, 131, 175)     #Здесь айди контекстов из LABS (!!!), можно добавить (вставить в скобки числа через запятую) 
  and e.isDeleted = 0                                                                         #или убрать (удалить ненужные айди)
  and a.isDeleted = 0
  and r.isDeleted = 0          #Не учитывать удаленные прогоны активности и мероприятия 
order by c.title    
