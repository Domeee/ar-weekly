select to_char(inserted_at, 'YYYY-ww') kw, count(*) from subscribers
where is_active = false
group by kw
order by kw