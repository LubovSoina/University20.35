with activity_authors as (select aa.activityID,                                            #Найдем авторов активностей
                                 group_concat(au.title separator ', ') as activity_authors #Cгруппируем их в одну строку так как у одного мероприятий может быть несколько авторов
                          from labs.activity_author aa
                                   left join labs.author au on aa.authorID = au.id
                          group by aa.activityID
),
     event_authors as ( #Найдем авторов мероприятий
         select ea.eventID,
                group_concat(au.title separator ', ') as activity_authors #Сгруппируем их в одну строку так как у одного мероприятий может быть несколько авторов
         from labs.event_author ea
                  left join labs.author au on ea.authorID = au.id
         group by ea.eventID
     )
select distinct tr.title,tr.id trackid,
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
                br.title                               as block_result_title,
                b.title                                as block_title,
                br.meta,
                br.format,
                ea.activity_authors                    as 'Авторы мероприятия',
                r.isRequest                            as isRequest,
                a.requestType                          as 'Тип записи'

from labs.activity a
         left join labs.activity_track atr on a.id = atr.activityID
         left join labs.track tr on atr.trackID = tr.id
         left join labs.context_track ct on ct.trackID = tr.id
    left join labs.context c on ct.contextID=c.id
         left join labs.run r on r.activityID = a.id
         left join labs.event e on e.runID = r.id
         left join labs.place on place.id = e.placeID
         left join labs.timeslot t on t.id = e.timeslotID
         left join labs.activity_type at on a.id = at.activityID
         left join labs.type ty on at.typeID = ty.id
         left join activity_authors aa on aa.activityID = a.id
         left join event_authors ea on e.id = ea.eventID
         left join labs.block b on e.id = b.eventID
         left join labs.block_result br on b.id = br.blockID

where tr.id in (206, 207, 208, 209, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221)
  and e.isDeleted = 0
  and a.isDeleted = 0
  and r.isDeleted = 0 and c.id = 252
