-- Task 1: List all regions along with the number of users assigned to each region.
SELECT r.region_name, COUNT(DISTINCT u.consumer_id) AS num_users
FROM world_regions r
LEFT JOIN user_nodes u ON r.region_id = u.region_id
GROUP BY r.region_name
ORDER BY r.region_name;

-- Task 2: Find the user who made the largest deposit amount and the transaction type for that deposit.
SELECT DISTINCT t.consumer_id, t.transaction_type, t.transaction_amount as largest_deposit
FROM user_transaction t
JOIN user_nodes u ON t.consumer_id = u.consumer_id
WHERE transaction_amount = (
    SELECT MAX(transaction_amount)
    FROM user_transaction
    WHERE transaction_type = 'Deposit'
);

-- Task 3:Calculate the total amount deposited for each user in the "Europe" region.
SELECT u.consumer_id, SUM(transaction_amount) AS total_deposits
FROM user_transaction u
JOIN user_nodes n ON u.consumer_id = n.consumer_id
JOIN world_regions r ON n.region_id = r.region_id
WHERE r.region_name = 'Europe' AND u.transaction_type = 'Deposit'
GROUP BY u.consumer_id;

-- Task 4: Calculate the total number of transactions made by each user in the "United States" region.
SELECT u.consumer_id, count(transaction_amount) AS num_transactions
FROM user_transaction u
JOIN user_nodes n ON u.consumer_id = n.consumer_id
JOIN world_regions r ON n.region_id = r.region_id
WHERE r.region_name = 'United States'
GROUP BY u.consumer_id;

-- Task 5: Calculate the total number of users who made more than 5 transactions.
SELECT consumer_id , COUNT(*) AS num_transactions
FROM user_transaction
GROUP BY consumer_id
HAVING num_transactions > 5;

-- Task 6: Find the regions with the highest number of nodes assigned to them.
SELECT r.region_name, COUNT(u.node_id) AS num_nodes
FROM world_regions r
JOIN user_nodes u ON r.region_id = u.region_id
GROUP BY r.region_name
ORDER BY num_nodes DESC
LIMIT 5;

-- Task 7: Find the user who made the largest deposit amount in the "Australia" region.
SELECT t.consumer_id, MAX(t.transaction_amount) AS largest_deposit
FROM user_transaction t
JOIN user_nodes u ON t.consumer_id = u.consumer_id
JOIN world_regions r ON u.region_id = r.region_id
WHERE r.region_name = "Australia" AND t.transaction_type = "Deposit"
GROUP BY t.consumer_id
ORDER BY largest_deposit DESC
LIMIT 1;

-- Task 8: Calculate the total amount deposited by each user in each region.
SELECT u.consumer_id, r.region_name, SUM(t.transaction_amount) AS total_deposit
FROM user_transaction t
JOIN user_nodes u ON t.consumer_id = u.consumer_id
JOIN world_regions r ON u.region_id = r.region_id
WHERE t.transaction_type = "Deposit"
GROUP BY u.consumer_id, r.region_name
ORDER BY u.consumer_id, r.region_name;

-- Task 9: Retrieve the total number of transactions for each region
SELECT r.region_name, COUNT(*) AS total_transactions
FROM user_transaction t
JOIN user_nodes u ON t.consumer_id = u.consumer_id
JOIN world_regions r ON u.region_id = r.region_id
GROUP BY r.region_name
ORDER BY r.region_name;

-- Task 10: Write a query to find the total deposit amount for each region (region_name) in the user_transaction table. Consider only those transactions where the consumer_id is associated with a valid region in the user_nodes table.
SELECT r.region_name, SUM(t.transaction_amount) AS total_deposit_amount
FROM user_transaction t
INNER JOIN user_nodes u ON t.consumer_id = u.consumer_id
INNER JOIN world_regions r ON u.region_id = r.region_id
WHERE t.transaction_type = 'Deposit'
GROUP BY r.region_name
ORDER BY r.region_name;

-- Task 11: Write a query to find the top 5 consumers who have made the highest total transaction amount (sum of all their deposit transactions) in the user_transaction table.
SELECT t.consumer_id, SUM(t.transaction_amount) AS total_transaction_amount
FROM user_transaction t
WHERE t.transaction_type = 'Deposit'
GROUP BY t.consumer_id
ORDER BY total_transaction_amount DESC
LIMIT 5;

-- Task 12: How many consumers are allocated to each region?
SELECT r.region_id, r.region_name, COUNT(DISTINCT u.consumer_id) AS num_of_customers
FROM user_nodes u
RIGHT JOIN world_regions r ON u.region_id = r.region_id
GROUP BY r.region_id, r.region_name
ORDER BY r.region_id
LIMIT 5;

-- Task 13: What is the unique count and total amount for each transaction type?
SELECT 
    transaction_type,
    COUNT(DISTINCT consumer_id) AS unique_count,
    SUM(transaction_amount) AS total_amount
FROM user_transaction
GROUP BY transaction_type;


-- Task 14: What are the average deposit counts and amounts for each transaction type ('deposit') across all customers, grouped by transaction type?
WITH DepositCTE AS (
    SELECT
        consumer_id,
        SUM(CASE WHEN transaction_type = 'Deposit' THEN 1 ELSE 0 END) AS deposit_count,
        SUM(CASE WHEN transaction_type = 'Deposit' THEN transaction_amount ELSE 0 END) AS deposit_amount
    FROM user_transaction
    GROUP BY consumer_id
)
SELECT
    'deposit' AS transaction_type,
    ROUND(AVG(deposit_count), 0) AS avg_deposit_count,
    ROUND(AVG(deposit_amount), 0) AS avg_deposit_amount
FROM DepositCTE;

-- Task 15:How many transactions were made by consumers from each region?
SELECT r.region_name, COUNT(*) AS transaction_count
FROM user_transaction t
JOIN user_nodes u ON t.consumer_id = u.consumer_id
JOIN world_regions r ON u.region_id = r.region_id
GROUP BY r.region_name
ORDER BY r.region_name;
