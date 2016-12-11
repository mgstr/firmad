drop type if exists company_info cascade;

-- this type copies 'company' table except for 'ft' column that is used for full text search
create type company_info as (
    name text,
    id integer,
    kmkr text,
    state text,
    address text,
    location_code text,
    location_text text,
    location_index text
);

-- find first 10 companies that match query
create or replace function find_company(q text)
returns setof company_info as $$
begin
    return query
        select
            name,id,kmkr,state,address,location_code,location_text,location_index
        from
            company
        where
            ft @@ to_tsquery('estonian', q)
        limit
            10;
    return;
end
$$ language plpgsql;

-- count number of companies that match query
create or replace function count_companies(q text)
returns integer as $$
begin
    return (
        select
            count(*)
        from
            company
        where
            ft @@ to_tsquery('estonian', q)
    );
end
$$ language plpgsql;