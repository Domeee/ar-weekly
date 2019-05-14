select to_char(inserted_at, 'YYYY-ww') kw, count(*) from sign_ups
group by kw
order by kw