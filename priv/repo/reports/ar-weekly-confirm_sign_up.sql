select to_char(inserted_at, 'YYYY-ww') kw, count(*) from subscribers
group by kw
order by kw