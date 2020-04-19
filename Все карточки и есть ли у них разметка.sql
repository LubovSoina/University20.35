select *
from (select c.id                                          as   contextID,
             c.title                                       as   context,
             json_unquote(json_extract(j.data, '$.link'))  as   link,
             json_unquote(json_extract(j.data, '$.level')) as   level,
             json_unquote(json_extract(j.data, '$.sublevel'))   sublevel,
             json_unquote(json_extract(j.data, '$.tool'))       tool,
             json_unquote(json_extract(j.data, '$.model'))      model,
             json_unquote(json_extract(j.data, '$.competence')) competence


      from people.journal j
               left join people.team_user tu on tu.userID = j.userID
               left join people.user_info ui on j.userID=ui.userID 
               left join people.context_team ct on ct.teamID = t.id
               left join people.context c on c.id = ct.contextID
               left join labs.context cc on cc.uuid = c.uuid

      where cc.id in (142, 146, 132, 130, 153, 135, 145, 139, 166, 140, 167, 144, 147, 131, 175)

        and j.typeID = 9
        and j.createDT >= '2019-08-15') Comp


         right join (
    select pta.external_type as                                                                           action,
           pta.id            as                                                                           actionID,
           date(pta.server_creation_time),
           c.title           as                                                                           conext,
           c.id              as                                                                           contextID,
           t.title           as                                                                           team,
           t.id              as                                                                           teamID,

           concat('https://trello.com/c/', json_unquote(json_extract(pta.data, '$.data.card.shortLink'))) card_link
    from pm_trace.pm_trace_action pta
             left join pm_trace.pm_trace_board b on pta.board_id = b.id
             left join pm_trace.pm_trace_project ptp on b.project_id = ptp.id
             left join people.project p on p.guid = ptp.guid
             left join people.project_team pt on p.id = pt.projectID
             left join people.team t on pt.teamID = t.id
             left join people.context_team ct on ct.teamID = t.id
             left join people.context c on c.id = ct.contextID
             left join labs.context cc on cc.uuid = c.uuid
    where cc.id in (142, 146, 132, 130, 153, 135, 145, 139, 166, 140, 167, 144, 147, 131, 175) and pta.external_type='createCard'
) cards on cards.card_link = Comp.link
