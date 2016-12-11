drop table if exists company;

-- use temp table structure, to match the CSV structure
create table company (
    nimi text,
    ariregistri_kood integer primary key,
    kmkr_nr text,
    ettevotja_staatus nchar(1),
    ettevotja_staatus_tekstina text,
    ettevotja_aadress text,
    asukoht_ettevotja_aadressis text,
    asukoha_ehak_kood text,
    asukoha_ehak_tekstina text,
    indeks_ettevotja_aadressis text,
    ads_adr_id text,
    ads_ads_oid text,
    ads_normaliseeritud_taisaadress text,
    teabesysteemi_link text
);

-- don't use copy SQL command since it runs on the server, but file is located locally!
\copy company from '/import/ettevotja_rekvisiidid.csv' with csv delimiter ';' header;

-- drop unused fields
alter table company drop column ettevotja_staatus;
alter table company drop column ettevotja_aadress;
alter table company drop column ads_adr_id;
alter table company drop column ads_ads_oid;
alter table company drop column ads_normaliseeritud_taisaadress;
alter table company drop column teabesysteemi_link;

-- rename fields
alter table company rename column nimi to name;
alter table company rename column ariregistri_kood to id;
alter table company rename column kmkr_nr to kmkr;
alter table company rename column ettevotja_staatus_tekstina to state;
alter table company rename column asukoht_ettevotja_aadressis to address;
alter table company rename column asukoha_ehak_kood to location_code;
alter table company rename column asukoha_ehak_tekstina to location_text;
alter table company rename column indeks_ettevotja_aadressis to location_index;

-- add column for full text search
alter table company add column ft tsvector;
update company set ft = to_tsvector('estonian', coalesce(name,'') || ' ' || coalesce(address,'') || ' ' || coalesce(location_text,'') || ' ' || coalesce(location_index,''));

-- index table
create index if not exists company_name on company using btree (name);
create index if not exists company_ft on company using gin(ft);
