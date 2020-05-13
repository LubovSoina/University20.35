select distinct col.type                         'тип коллекции',
                col.title                        'название колекции',
                col.description                  'описание коллекции',
                cg.title                         'название группы',

                cg.description                   'описание группы',
                obg.description                  'описание объекта',
                group_concat(distinct toolTitle) 'инструменты',
                o.title                          'название объекта',
                o.url                            'ссылка',
                ty.title                         'тип объекта'
from ple.step_collection col
         left join ple.step_collection_group cg on col.uuid = cg.collectionUuid
         left join ple.step_collection_object obg on cg.uuid = obg.collectionGroupUuid
         left join ple.step_collection_tool ct on ct.collectionUuid = col.uuid
         left join rall.object o on obg.objectUuid = o.uuid
         left join rall.type ty on o.typeID = ty.id
group by col.type, col.title, col.description, cg.title, obg.description, o.title, o.url, ty.title
