select to_char(inserted_at, 'YYYY-ww') kw, count(*) from issue_trackings
group by kw
order by kw