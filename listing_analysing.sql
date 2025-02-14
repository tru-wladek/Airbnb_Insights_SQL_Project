
-- Which Hosts Have the Most Listings, and Where Are They Located?
WITH HostNeighborhoods AS (
    SELECT 
        host_id, 
        neighbourhood_cleansed, 
        COUNT(*) AS listing_count,
        ROW_NUMBER() OVER (PARTITION BY host_id ORDER BY COUNT(*) DESC) AS rn
    FROM listings_prepared
    GROUP BY host_id, neighbourhood_cleansed
)
SELECT 
    l.host_id, 
    l.host_name, 
    COUNT(*) AS total_listings, 
    hn.neighbourhood_cleansed AS most_listings_neighbourhood
FROM listings_prepared l
JOIN HostNeighborhoods hn 
    ON l.host_id = hn.host_id AND hn.rn = 1
GROUP BY l.host_id, l.host_name, hn.neighbourhood_cleansed
ORDER BY total_listings DESC;

-- What property types generate the highest revenue? (based on the assumption that all unavailiable dates are booked)

SELECT property_type, AVG(price * (365 - availability_365)) AS avg_revenue
FROM listings_prepared
GROUP BY property_type
ORDER BY avg_revenue DESC;

-- What is the most common property type in each neighbourhood
WITH RankedProperties AS (
    SELECT 
        neighbourhood_cleansed,
        property_type,
        COUNT(*) AS property_count,
        RANK() OVER (PARTITION BY neighbourhood_cleansed ORDER BY COUNT(*) DESC) AS rnk
    FROM listings_prepared
    GROUP BY neighbourhood_cleansed, property_type
)
SELECT neighbourhood_cleansed, property_type, property_count
FROM RankedProperties
WHERE rnk = 1
order by property_count desc;

-- Which listings are underpriced compared to the neighborhood average?

WITH NeighbourhoodAvg AS (
    SELECT neighbourhood_cleansed, AVG(price) AS avg_price_neighbourhood
    FROM listings_prepared
    GROUP BY neighbourhood_cleansed 
)
SELECT l.id, l.neighbourhood_cleansed, l.price, n.avg_price_neighbourhood
FROM listings_prepared l
JOIN NeighbourhoodAvg n ON l.neighbourhood_cleansed = n.neighbourhood_cleansed
WHERE l.price < (0.5 * n.avg_price_neighbourhood)  
-- Listings priced 50% below average
ORDER BY l.price ASC;

-- same query but it counts the number of underpriced listings for each neighbourhood.  
WITH NeighbourhoodAvg AS (
    SELECT 
        neighbourhood_cleansed, 
        AVG(price) AS avg_price_neighbourhood
    FROM listings_prepared
    GROUP BY neighbourhood_cleansed
)
SELECT 
    l.neighbourhood_cleansed, 
    COUNT(l.id) AS underpriced_listings
FROM listings_prepared l
JOIN NeighbourhoodAvg n 
    ON l.neighbourhood_cleansed = n.neighbourhood_cleansed
WHERE l.price < (0.5 * n.avg_price_neighbourhood)  -- Listings priced 50% below average
GROUP BY l.neighbourhood_cleansed
ORDER BY underpriced_listings DESC;

-- what are the hosts that highest repeatance of the word "dirty" in their reviews?
WITH DirtyComments AS (
    SELECT 
        r.listing_id, 
        l.host_id, 
        l.host_name, 
        COUNT(*) AS dirty_comment_count
    FROM reviews r
    JOIN listings_prepared l ON r.listing_id = l.id
    WHERE LOWER(r.comments) LIKE '%dirty%' 
       OR LOWER(r.comments) LIKE '%sucio%'  -- Spanish (sucio)
       OR LOWER(r.comments) LIKE '%sale%'  -- French (sale)
       OR LOWER(r.comments) LIKE '%schmutzig%' -- German (schmutzig)
       OR LOWER(r.comments) LIKE '%sporco%' -- Italian (sporco)
    GROUP BY r.listing_id, l.host_id, l.host_name
)
SELECT TOP 10
    host_id, 
    host_name,
    SUM(dirty_comment_count) AS total_dirty_comments, 
    COUNT(DISTINCT listing_id) AS affected_listings
FROM DirtyComments
GROUP BY host_id, host_name
ORDER BY total_dirty_comments DESC;