# for full text search we need to prepare 'estonian' locale, since english locale uses stop words like 'as'
create text search dictionary estonian (template = pg_catalog.simple);
create text search configuration estonian (copy = english);
alter text search configuration estonian alter mapping for asciihword,asciiword,hword,hword_asciipart,hword_part,word with simple;