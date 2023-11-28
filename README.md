# Metrocar Funnel Analysis

## Programs used and Process
For this project I first explored and analysed the data by performing various SQL queries in Beekeeper Studio, the data relevant to the project was extracted and then visualized the data in Tableau where some further analysis was performed. Thereafter a report was compiled as well as a Tableau Story created, and the findings in answer to the key business questions were presented to the Stakeholders.

## Motivation
To identify dropoff points and determine optimisation opportunities to increase revenue, userbase, and customer retention for the Metrocar Rideshare Platform. 

## Table of Contents
1. Project Report
2. SQL Queries

## Metrocar Funnel 
The customer funnel for Metrocar typically includes the following stages:

1. **App Download:** A user downloads the Metrocar app from the App Store or Google Play Store.
2. **Signup:** The user creates an account in the Metrocar app, including their name, email, phone number, and payment information.
3. **Request Ride:** The user opens the app and requests a ride by entering their pickup location, destination, and ride capacity (2 to 6 riders).
4. **Driver Acceptance:** A nearby driver receives the ride request and accepts the ride.
5. **Ride:** The driver arrives at the pickup location, and the user gets in the car and rides to their destination.
6. **Payment:** After the ride, the user is charged automatically through the app, and a receipt is sent to their email.
7. **Review:** The user is prompted to rate their driver and leave a review of their ride experience.

## Business Questions per the Stakeholders
1. What steps of the funnel should we research and improve? Are there any specific drop-off points preventing users from completing their first ride?

2. Metrocar currently supports 3 different platforms: ios, android, and web. To recommend where to focus our marketing budget for the upcoming year, what insights can we make based on the platform?

3. What age groups perform best at each stage of our funnel? Which age group(s) likely contain our target customers?

4. Surge pricing is the practice of increasing the price of goods or services when there is the greatest demand for them. If we want to adopt a price-surging strategy, what does the distribution of ride requests look like throughout the day?

5. What part of our funnel has the lowest conversion rate? What can we do to improve this part of the funnel?

## Dataset Structure:
You can find a description of each table and its columns below.

**app_downloads:** contains information about app downloads
* app_download_key: unique id of an app download
* platform: ios, android or web
* download_ts: download timestamp

**signups:** contains information about new user signups
* user_id: primary id for a user
* session_id: id of app download
* signup_ts: signup timestamp
* age_range: the age range the user belongs to

**ride_requests:** contains information about rides
* ride_id: primary id for a ride
* user_id: foreign key to user (requester)
* driver_id: foreign key to driver
* request_ts: ride request timestamp
* accept_ts: driver accept timestamp
* pickup_location: pickup coordinates
* destination_location: destination coordinates
* pickup_ts: pickup timestamp
* dropoff_ts: dropoff timestamp
* cancel_ts: ride cancel timestamp (accept, pickup and dropoff timestamps may be null)

**transactions:** contains information about financial transactions based on completed rides:
* ride_id: foreign key to ride
* purchase_amount_usd: purchase amount in USD
* charge_status: approved, cancelled
* transaction_ts: transaction timestamp

**reviews:** contains information about driver reviews once rides are completed
* review_id: primary id of review
* ride_id: foreign key to ride
* driver_id: foreign key to driver
* user_id: foreign key to user (requester)
* rating: rating from 0 to 5
* review: text (free) response given by user/requester
