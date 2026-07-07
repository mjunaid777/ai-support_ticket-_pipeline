SQL Commands:

CREATE TABLE support_tickets (
    Ticket_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100),
    Customer_Email VARCHAR(150),
    Customer_Age INT,
    Customer_Gender VARCHAR(50),
    Product_Purchased VARCHAR(150),
    Date_of_Purchase DATE,
    Ticket_Type VARCHAR(100),
    Ticket_Subject VARCHAR(255),
    Ticket_Description TEXT,
    Ticket_Status VARCHAR(50),
    Resolution TEXT,
    Ticket_Priority VARCHAR(50),
    Ticket_Channel VARCHAR(50),
    First_Response_Time VARCHAR(100),
    Time_to_Resolution VARCHAR(100),
    Customer_Satisfaction_Rating VARCHAR(10), 
    Churn_Risk_Score INT,
    Core_Issue VARCHAR(100)
);

2nd query:

WITH Product_Risk_Metrics AS (
    SELECT 
        Product_Purchased,
        COUNT(Ticket_ID) AS Total_Tickets,
        AVG(Churn_Risk_Score) AS Avg_AI_Churn_Score,
        
        AVG(CAST(NULLIF(TRIM(Customer_Satisfaction_Rating), '') AS NUMERIC)) AS Avg_CSAT,
        
        SUM(CASE WHEN Core_Issue = 'Hardware' THEN 1 ELSE 0 END) AS Hardware_Issues,
        SUM(CASE WHEN Core_Issue = 'Software Bug' THEN 1 ELSE 0 END) AS Software_Bugs
    FROM support_tickets
    GROUP BY Product_Purchased
)
SELECT 
    Product_Purchased,
    Total_Tickets,
    ROUND(Avg_AI_Churn_Score, 2) AS AI_Churn_Score,
    ROUND(Avg_CSAT, 2) AS CSAT_Score,
    Hardware_Issues,
    Software_Bugs
FROM Product_Risk_Metrics
WHERE Total_Tickets > 5 -- Filtering out outliers
ORDER BY AI_Churn_Score DESC;