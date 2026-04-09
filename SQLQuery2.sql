
Populate 'ticket_created_at' in Feedback Table
This query updates the feedback table by matching the ticket_id. 
sql
UPDATE feedback f
JOIN tickets t ON f.ticket_id = t.id
SET f.ticket_created_at = t.created_at;
2. Outlet-wise Ticket Count (Created & Closed)
a. Same Day Closure
This query counts tickets where the closure date is the same as the creation date, grouped by outlet. 
sql
SELECT 
    t.outlet_id,
    COUNT(*) AS total_same_day_closed
FROM tickets t
WHERE DATE(t.created_at) = DATE(t.closed_at)
GROUP BY t.outlet_id;
b. Same Hour of the Same Day Closure 
This query counts tickets where both the day and hour of closure match the creation time, grouped by outlet. 
Atlassian Community
Atlassian Community
sql
SELECT 
    t.outlet_id,
    COUNT(*) AS total_same_hour_closed
FROM tickets t
WHERE DATE(t.created_at) = DATE(t.closed_at)
  AND HOUR(t.created_at) = HOUR(t.closed_at)
GROUP BY t.outlet_id;