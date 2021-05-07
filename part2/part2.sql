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

SELECT
    u.created_at AS monthly_cohort
    , (100 * COUNT(u.user_id) / (SELECT COUNT(*) FROM users)) AS percent_users
FROM users u
JOIN exercises e ON u.user_id = e.user_id
WHERE u.created_at == e.exercise_completion_date
GROUP BY
    u.user_id
    , u.created_at;


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

SELECT pr.organization_name AS organization, AVG(ph.score) AS avg_score
FROM Phq9 ph
JOIN Providers pr ON ph.provider_id = pr.provider_id
GROUP BY pr.organization_name
ORDER BY avg_score DESC
LIMIT 5;
