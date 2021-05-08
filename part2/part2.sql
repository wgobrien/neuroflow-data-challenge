/*

 William O'Brien

 ----------------------
 NeuroFlow Data Project
 Part 2
 ----------------------

 Written in MySQL.

*/

/*

 +------------+     +--------------------------+
 | users      |     | exercises                |
 +------------+     +--------------------------+
 | user_id    |     | exercise_id              |
 | created_at |     | user_id                  |
 +------------+     | exercise_completion_date |
                    +--------------------------+

*/

-- 1] How many users completed an exercise in their first month per monthly cohort?
-- Result: YEAR MONTH | X%

SELECT
    DATE_FORMAT(u.created_at, '%Y %M') AS cohort_month
    , (100 * COUNT(*) / (SELECT COUNT(*) FROM users)) AS percent_users
FROM users u
JOIN exercises e
    ON u.user_id = e.user_id
    AND DATE_FORMAT(u.created_at, '%Y %M') ==  DATE_FORMAT(e.exercise_completion_date, '%Y %M')
GROUP BY 1;


-- 2] How many users completed a given amount of exercises?

SELECT
    user_count.num_exercises
    , COUNT(*)
FROM
    --subquery returns number of exercises completed by each user
    (SELECT e.user_id AS id, COUNT(e.exercise_id) as num_exercises
    FROM exercises e
    GROUP BY e.user_id) user_count
GROUP BY user_count.num_exercises;


/*

 +-------------------+     +------------------+
 | Providers         |     | Phq9             |
 +-------------------+     +------------------+
 | provider_id       |     | patient_id       |
 | organization_id   |     | provider_id      |
 | organization_name |     | score            |
 +-------------------+     | datetime_created |
                           +------------------+

*/

-- 3] Which organizations have the most severe patient population?

SELECT
    pr.organization_name AS organization
    , AVG(ph.score) AS avg_score
FROM Phq9 ph
JOIN Providers pr ON ph.provider_id = pr.provider_id
GROUP BY pr.organization_name
ORDER BY 2 DESC
LIMIT 5;
