select to_char(inserted_at, 'YYYY-ww') kw, count(distinct subscriber_id) from issue_link_trackings
group by kw
order by kw