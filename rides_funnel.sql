WITH rides_funnel_status AS (
SELECT user_id
FROM ride_requests
GROUP BY user_id
),

total_users AS (
SELECT
  ad.platform AS platform,
  s.age_range AS age_range,
  ad.download_ts::DATE AS download_date,
  COUNT(DISTINCT rs.user_id) AS total_users_ride_requested,
  COUNT(DISTINCT rr.ride_id) AS number_of_rides_requested,
  COUNT(DISTINCT CASE WHEN rr.accept_ts IS NOT NULL THEN rr.user_id END) AS rides_accepted_by_driver_user,
  COUNT(DISTINCT CASE WHEN accept_ts IS NOT NULL THEN rr.ride_id END) AS rides_accepted_by_driver,
  COUNT(DISTINCT CASE WHEN rr.dropoff_ts IS NOT NULL THEN rr.user_id END) AS unique_users_completed_ride,
  COUNT(DISTINCT CASE WHEN dropoff_ts IS NOT NULL THEN r.ride_id END) AS completed_rides,
  COUNT(DISTINCT CASE WHEN t.charge_status = 'Approved' THEN rr.user_id END) AS number_of_users_made_payments,
  COUNT(DISTINCT CASE WHEN t.charge_status = 'Approved' THEN rr.ride_id END) AS number_of_rides_payment_success,
  COUNT(DISTINCT r.user_id) AS number_of_users_left_reviews,
  COUNT(DISTINCT r.ride_id) AS number_of_rides_received_reviews
FROM app_downloads ad
LEFT JOIN signups s ON ad.app_download_key = s.session_id
LEFT JOIN rides_funnel_status rs ON s.user_id = rs.user_id
LEFT JOIN ride_requests rr ON s.user_id = rr.user_id
LEFT JOIN transactions t ON t.ride_id = rr.ride_id
LEFT JOIN reviews r ON r.user_id = s.user_id
--WHERE s.age_range IS NOT NULL
GROUP BY platform, age_range,download_date
),

funnel_steps AS (
  SELECT
    1 AS funnel_step,
    'ride_requested' AS funnel_name,
     platform,
     age_range,
     download_date,
    CAST(total_users_ride_requested AS BIGINT) AS user_count,
    CAST(number_of_rides_requested AS BIGINT) AS ride_count
  FROM total_users

  UNION

  SELECT
    2 AS funnel_step,
    'ride_accepted' AS funnel_name,
     platform,
     age_range,
     download_date,
    CAST(rides_accepted_by_driver_user AS BIGINT) AS user_count,
    CAST(rides_accepted_by_driver AS BIGINT) AS ride_count
  FROM total_users

  UNION 

  SELECT
    3 AS funnel_step,
    'ride_completed' AS funnel_name,
     platform,
     age_range,
     download_date,
    CAST(unique_users_completed_ride AS BIGINT) AS user_count,
    CAST(completed_rides AS BIGINT) AS ride_count
  FROM total_users

  UNION  

  SELECT
    4 AS funnel_step,
    'payment' AS funnel_name,
    platform,
    age_range,
    download_date,
    CAST(number_of_users_made_payments AS BIGINT) AS user_count,
    CAST(number_of_rides_payment_success AS BIGINT) AS ride_count
  FROM total_users

  UNION

  SELECT
    5 AS funnel_step,
    'review' AS funnel_name,
    platform,
    age_range,
    download_date,
    CAST(number_of_users_left_reviews AS BIGINT) AS user_count,
    CAST(number_of_rides_received_reviews AS BIGINT) AS ride_count
  FROM total_users  
)
 
SELECT *
FROM funnel_steps
ORDER BY funnel_steps ASC;
