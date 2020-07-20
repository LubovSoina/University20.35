select u.id,u.title, count(distinct json_unquote(json_extract(j.data,'$.data.data.card.shortLink'))) cards
from people.journal j
         left join people.team_user tu on tu.userID = j.creatorID
         left join people.team t on tu.teamID = t.id
left join people.university u on t.universityID = u.id
where j.typeID = 8 and j.createDT>'2020-04-01'
  and t.universityID in (27,
275,
41,
117,
10,
127,
212,
121,
283,
12,
290
) and j.title ='Создал карточку'
group by u.id, u.title
