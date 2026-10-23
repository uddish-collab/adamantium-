select
  table_name,
  jsonb_agg(
    jsonb_build_object(
      'column', column_name,
      'type', data_type,
      'nullable', is_nullable,
      'default', column_default
    )
    order by ordinal_position
  ) as columns
from information_schema.columns
where table_schema = 'public'
group by table_name
order by table_name;