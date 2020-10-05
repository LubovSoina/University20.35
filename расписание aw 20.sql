with activity_authors as (select aa.activityID,
                                 group_concat(au.title separator ', ') as activity_authors
                          from labs.activity_author aa
                                   left join labs.author au on aa.authorID = au.id
                          group by aa.activityID
),
     event_authors as (
         select ea.eventID,
                group_concat(au.title separator ', ') as activity_authors
         from labs.event_author ea
                  left join labs.author au on ea.authorID = au.id
         group by ea.eventID
     ),
     reflex as (
         select e.id                       as e_id,
                count(distinct ufa.userID) as user_feedback
         FROM labs.user_feedback_answer ufa
                  left join labs.event e on e.id = ufa.eventID
         where ufa.value is not null
            or ufa.data is not null
         group by e.id
     ),
     checkin as (
         select e.id           as e_id,
                sum(c.checkin) as checkins
         from labs.checkin c
                  left join labs.event e on e.id = c.eventID
         group by e.id
     ),
     attendance as ( #Посещаемость
         select e.id              as e_id,
                sum(c.attendance) as attendance
         from labs.checkin c
                  left join labs.event e on e.id = c.eventID
         group by e.id
     ),
     recorded as ( #Записано людей
         select r.id                       as r_ID,
                count(distinct uar.userID) as users
         from labs.user_activity_request uar
                  left join labs.run r on r.id = uar.runID
         where uar.status = 'approved'
         group by r.id
     )
select distinct c.id                                   as contextID,
                c.title                                as context_title,
                dd.title                                  department,
                a.id                                   as activityID,
                a.title                                as activity_title,
                a.description                          as 'Описание активности',
                a.short                                as 'Короткое описание',
                a.createDT                             as 'Дата создания активности',
                theme.title                               'Тема активности',
                aa.activity_authors                    as 'Авторы активности',
                ty.title                               as 'Тип активности',
                a.type_access                          as 'Тип доступа',
                group_concat(distinct tag.guid)        as 'Доступ по тегам',
                group_concat(distinct tag1.guid)          'Автозапись по тегам',
                a.sizeMin                                 'Минимальная вместимость активности',
                a.sizeMax                                 'Максимальная вместимость активности',
                r.id                                   as runID,
                r.startRequest                         as startRequest,
                r.endRequest                           as endRequest,
                e.id                                   as eventID,
                e.title                                as 'Название мероприятия',
                e.description                          as 'Описание мероприятия',
                e.createDT                             as 'Дата создания мероприятия',
                place.capacity                         as 'Вместимость мероприятия',
                plt.title                              as 'типа места',
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

         inner join (select *
                     from labs.context_activity ca
                     where ca.contextID in
                           (297, 332, 335, 346, 298, 299, 300, 301, 333, 302, 303, 304, 305, 306, 307, 334, 308, 339,
                            336, 285, 309, 310, 311, 312, 313, 337, 314, 315, 316, 317, 318, 319, 341, 320, 321, 322,
                            323,
                            324, 331, 338, 325, 326, 340, 327, 328, 329, 330, 343, 285, 286, 290, 287)) ca
                    on ca.activityID = a.id

         left join labs.run r on r.activityID = a.id
         left join labs.event e on e.runID = r.id
         left join labs.place on place.id = e.placeID
         left join labs.place_type plt on place.typeID = plt.id
         left join labs.context c on ca.contextID = c.id
         left join labs.context_department cd on c.id = cd.contextID
         left join labs.department dd on cd.departmentID = dd.id
         left join labs.timeslot t on t.id = e.timeslotID
         left join labs.activity_type at on a.id = at.activityID
         left join labs.type ty on at.typeID = ty.id
         left join activity_authors aa on aa.activityID = a.id
         left join event_authors ea on e.id = ea.eventID
         left join reflex ref on ref.e_id = e.id
         left join checkin ch on ch.e_id = e.id
         left join attendance att on att.e_id = e.id
         left join recorded rec on rec.r_ID = r.id
         left join labs.activity_access_tag atag on a.id = atag.activityID
         left join labs.activity_tag atag1 on a.id = atag1.activityID
         left join labs.tag tag1 on atag1.tagID = tag1.id
         left join labs.tag tag on atag.tagID = tag.id
         left join labs.activity_theme atheme on a.id = atheme.activityID
         left join labs.theme theme on atheme.themeID = theme.id
where e.isDeleted = 0
  and a.isDeleted = 0
  and r.isDeleted = 0
group by c.id, c.title, a.id, a.title, a.description, a.short, a.createDT, aa.activity_authors, ty.title, a.type_access,
         r.id, r.startRequest, r.endRequest, e.id, e.title, e.description, e.createDT, place.capacity, date(t.startDT),
         timediff(time(t.startDT), '-03:00:00'), date(t.endDT), timediff(time(t.endDT), '-03:00:00'),
         ea.activity_authors, r.isRequest, a.requestType, rec.users, ch.checkins, att.attendance, ref.user_feedback
