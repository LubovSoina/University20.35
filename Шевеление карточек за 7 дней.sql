select distinct pta.external_type              as                                                              action_type,
                pta.id                         as                                                              actionID,
                date(pta.server_creation_time) as                                                              date_of_action,

                c.title                        as                                                              context,
                с.id as contextID,
                t.title                        as                                                              team,
                t.id                           as                                                              teamID,
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
where cc.id in (142, 146, 132, 130, 153, 135, 145, 139, 166, 140, 167, 144, 147, 131, 175)
  and date(pta.server_creation_time) between DATE_SUB(CURDATE(), interval 7 day) and CURDATE()
