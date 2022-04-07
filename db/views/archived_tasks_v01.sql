SELECT * FROM tasks
WHERE is_done = true
AND deadline > NOW() - INTERVAL '15 days'
OR is_done = false
AND deadline > NOW() - INTERVAL '30 days'
ORDER BY deadline DESC
