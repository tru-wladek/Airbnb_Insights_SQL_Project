drop table #TempQuartiles;
WITH Quartiles AS (
    SELECT 
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY price) OVER () AS Q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY price) OVER () AS Q3
    FROM listings_prepared
)
SELECT TOP 1 Q1, Q3, (Q3 - Q1) AS IQR
INTO #TempQuartiles  -- Store in a temporary table
FROM Quartiles;

-- selecting the rows to be changed to null
SELECT l.*
FROM listings_prepared l
JOIN #TempQuartiles t ON 1=1
WHERE l.price < (t.Q1 - 1.5 * (t.IQR))
   OR l.price > (t.Q3 + 1.5 * (t.IQR))
Order by price desc;

-- updating outlier prices to null
UPDATE listings_prepared
SET price = NULL
WHERE price < (
    SELECT Q1 - 1.5 * IQR FROM #TempQuartiles
) 
OR price > (
    SELECT Q3 + 1.5 * IQR FROM #TempQuartiles
);

-- Updating all null price values to an average of the same neighbourhood
WITH AveragePrices AS (
    SELECT l2.neighbourhood_cleansed, 
           AVG(l2.price) AS avg_price
    FROM listings_prepared l2
    WHERE l2.price IS NOT NULL
    GROUP BY l2.neighbourhood_cleansed
)
UPDATE la
SET la.price = ap.avg_price
FROM listings_prepared la
LEFT JOIN AveragePrices ap
    ON la.neighbourhood_cleansed = ap.neighbourhood_cleansed
WHERE la.price IS NULL;


--Additionally
-- filling in null ratings values with the average of the same host's other ratings 
update listings_prepared
set review_scores_rating = (
    select avg(tt.review_scores_rating)
    from listings_prepared tt
    where tt.host_id=listings_prepared.host_id
    AND tt.review_scores_rating IS NOT NULL
)
where review_scores_rating is null;

-- filling in the remaining null values with the average of the same heighbourhood 
UPDATE la
SET review_scores_rating = nb_avg.avg_rating
FROM listings_prepared la
JOIN (
    SELECT neighbourhood_cleansed, AVG(review_scores_rating) AS avg_rating
    FROM listings_prepared
    WHERE review_scores_rating IS NOT NULL
    GROUP BY neighbourhood_cleansed
) nb_avg
ON la.neighbourhood_cleansed = nb_avg.neighbourhood_cleansed
WHERE la.review_scores_rating IS NULL;