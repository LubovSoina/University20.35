lect distinct col.type                         'тип коллекции',
                col.title                        'название колекции',
                col.description                  'описание коллекции',
                cg.title                         'название группы',
                cg.description                   'описание группы',
                obg.description                  'описание объекта',
                group_concat(distinct toolTitle) 'инструменты',
                o.title                          'название объекта',
                o.url                            'ссылка',
                ty.title                         'тип объекта',
                ss.feedback,
                ss.rating,
                ss.like,
                ss.dislike,
                ss.favourite,
                ss.click,
                count(distinct log.untiID) 'аудитория'
from ple.step_collection col
         left join ple.step_collection_group cg on col.uuid = cg.collectionUuid
         left join ple.step_collection_object obg on cg.uuid = obg.collectionGroupUuid
         left join ple.step_collection_tool ct on ct.collectionUuid = col.uuid
         left join rall.object o on obg.objectUuid = o.uuid
         left join rall.type ty on o.typeID = ty.id
         left join ple.step_tracker_statistics ss on ss.objectUuid = o.uuid
         left join ple.step_user_tracker_log log on log.objectUuid = o.uuid
left join ple.step_step_relation rel on rel.objectUuid=o.uuid
left join ple.step_step st on rel.stepUuid = st.uuid
where col.showToAll = 1
group by col.type, col.title, col.description, cg.title, obg.description, o.title, o.url, ty.title
