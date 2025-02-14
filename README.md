# 🏡 Airbnb Mallorca Data Analysis – SQL Project

# Introduction

Having traveled to Mallorca multiple times and actively used Airbnb for renting properties, I became curious about the trends shaping the island’s short-term rental market. This curiosity led me to analyze Airbnb data, uncover pricing strategies, and extract valuable insights for both hosts and property managers.

For this project, I used the latest dataset from Inside Airbnb, which includes over 16,000 listings across Mallorca. While the raw dataset contained numerous columns, I focused on the most impactful factors influencing pricing and demand.

My SQL Queries? Check them out here:
- Cleansing: [link_1](https://github.com/tru-wladek/Airbnb_Insights_SQL_Project/blob/main/listing_cleansing.sql)
- Analyzing: [link_2](https://github.com/tru-wladek/Airbnb_Insights_SQL_Project/blob/main/listing_analysing.sql)

Get raw Airbnb DATA HERE:
- listings: https://data.insideairbnb.com/spain/islas-baleares/mallorca/2024-12-14/data/listings.csv.gz
- reviews: https://data.insideairbnb.com/spain/islas-baleares/mallorca/2024-12-14/data/reviews.csv.gz


# The questions I wanted to answer through my SQL queries were 

1.  🏙️ **What hosts has the most listings and in which neighbourhood?**
    
2.  🏡 **What property types generate the highest revenue?** (Approximately due to lack of revenue data😉)
    
3.  📍 **What is the most common property type in each neighborhood?**
    
4.  💰 **Which listings are underpriced compared to the neighborhood average?**
    
5.  🧼 **If I wanted to sell cleaning services, how would I identify hosts struggling with cleanliness issues?**
    

By answering these questions, I was able to **highlight pricing trends, demand patterns, and business opportunities** for hosts and service providers.

# Tools Used

For data cleaning, analysis, and visualization, I used:

*   **SQL** – The core tool for querying, cleaning, and analyzing Airbnb data.
    
*   **Azure Data Studio** – A powerful database management system, ideal for handling large Airbnb datasets.
    
*   **Excel** – Used for initial **Exploratory Data Analysis (EDA)** and minor cleaning before deeper analysis.
    
*   **Tableau** – Created an interactive visualization to map listings and identify key insights.
    

# Cleaning the Data 🛠️

After an initial EDA, I quickly noticed significant inconsistencies in the **price** column:

*   **Missing Values**: About **1,000 listings** had no price data.
    
*   **Extreme Outliers**: Several hosts listed properties at **€9,999 per night**, which is unrealistic—even for luxury properties.  **Skewed Data** like this could distort insights, especially when using aggregate functions like AVG() or SUM().
    

🔍 **Identifying and Handling Outliers with IQR**

To detect outliers, I used the **Interquartile Range (IQR)** method, which flags values that are significantly lower or higher than most of the data. Here's how it works:

1.  **Find the quartiles** (Q1 = 25th percentile, Q3 = 75th percentile).
    
2.  **Calculate IQR** (Interquartile Range): IQR = Q3 - Q1.
    
3.  **Define Outlier Boundaries**:
    
    *   Any value **below** Q1 - 2 \* IQR is too low.
        
    *   Any value **above** Q3 + 2 \* IQR is too high.
        

💡 **SQL Solution**: I first calculated Q1 & Q3, stored them in a temporary table, and then replaced extreme values with NULL.

📌 **Filling in Missing Prices**

Now that outliers were removed, I needed to replace all NULL values with **more reasonable estimates**. Instead of filling them randomly, I took the **average price of properties in the same neighborhood**.

✅ **Final Result**

*   **Before:** Prices ranged from **€8** to an unrealistic **€9,999**.
    
*   **After:** Normalized prices range from **€8 to €650**, providing a much cleaner dataset for analysis.
    

|price\_range|count\_before|count\_after|
|---|---|---|
|null|939|-|
|0-999|15168|16862|
|1000-1999|445|-|
|2000-2999|66|-|
|3000-3999|29|-|
|4000-4999|3|-|
|5000-5999|4|-|
|6000-6999|1|-|
|7000-7999|1|-|
|9000-9999|202|-|
|10000-10999|4|-|

Table representing number of listings in price ranges before and after cleaning

# 📊 Analyzing the Cleansed Data

After cleaning the dataset, I focused on answering key business questions that provide valuable insights for Airbnb hosts, investors, and even service providers. Here’s a breakdown of my approach and findings:

## 1️⃣ Which Hosts Have the Most Listings, and Where Are They Located?

This query identifies the **largest Airbnb operators** by counting the number of properties each host manages. Additionally, it determines **which neighborhood** each host has the most listings in.

📌 **Findings:**

*   The **top 10 hosts** each manage **over 100 properties**.
    
*   **Homerti** is the **largest** operator, with **803 properties**!
    
*   The **most popular areas for large-scale hosts** are **Pollença and Alcúdia**, indicating these neighborhoods attract major property managers.
    

|host\_id|host\_name|total\_listings|most\_listings\_neighbourhood|
|---|---|---|---|
|80839530|Homerti|803|Alcúdia|
|97222654|Best Holiday Homes Limited|239|Pollença|
|205496849|Holidu|238|Pollença|
|65697804|Ideal Property Mallorca|228|Alcúdia|
|66176030|Smilevillas|184|Santanyí|
|122491844|Sealand Villas|178|Pollença|
|156144596|Mallorca Villa Selection|171|Alcúdia|
|285670200|Holidu|169|Pollença|
|80636743|Foravila|143|Santa Margalida|
|76875955|Team FiveStarsHome|142|Pollença|

Table representing hosts with most listings and their key locations

Additionally, I created a **Tableau visualization** to analyze property price intensity across Mallorca and uncover **geographical insights**. The data reveals that while **bookings are concentrated along the south coast**, the **highest prices** are found in the **Pollenca area in the north**. This suggests **high competition** in luxury rentals there, making it challenging for new entrants to compete with **experienced professionals**.
![Sheet 2-2](https://github.com/user-attachments/assets/35c18720-bef0-448d-89f1-6bfac1211e4b)

The **density map represents** the distribution of property prices across Mallorca

## 2️⃣ Which Property Types Generate the Highest Revenue?**

Since Airbnb doesn’t provide direct revenue data nor the booking data so I estimated **annual revenue** based on: **(Price per night) × (365 - Available dates)**assuming unavailable dates = booked nights

📌 **Findings:**

*   The most profitable property types are **luxury stays** such as **private lodges, entire villas, and cottages**, generating **€38K – €80K annually**.
    
*   Additionally, **hotel rooms** earn around **€35K per year**, showing that even simpler accommodations can be lucrative.
    

|property\_type|avg\_revenue|
|---|---|
|Private room in nature lodge|79935|
|Tower|57768|
|Private room in serviced apartment|52802|
|Private room in cottage|49540|
|Entire cottage|46032|
|Entire villa|45138|
|Room in heritage hotel|42471|
|Entire chalet|41809|
|Room in serviced apartment|40464|
|Room in bed and breakfast|38139|
|Room in hotel|34184|
|Earthen home|33436|
|Entire home|33427|

Table representing estimated revenue by property type

## 3️⃣ What Is the Most Common Property Type in Each Neighborhood?

This query determines the **dominant property type** in different areas of Mallorca.

📌 **Findings:**

*   **Pollença** has the most **entire villas (1,466 properties)**, making it the island’s top location for villa rentals.
    
*   The rest of the island follows a similar trend, with **entire homes and villas dominating most neighborhoods**.
    
|neighbourhood\_cleansed|property\_type|property\_count|
|---|---|---|
|Pollença|Entire villa|1466|
|Palma de Mallorca|Entire rental unit|545|
|Alcúdia|Entire rental unit|458|
|Santanyí|Entire villa|302|
|Manacor|Entire home|287|
|Santa Margalida|Entire home|250|
|Llucmajor|Entire home|223|
|Campos|Entire home|203|
|Capdepera|Entire rental unit|195|
|Felanitx|Entire villa|192|
|Sóller|Entire home|167|
|Artà|Entire home|165|
|Calvià|Entire rental unit|159|
|Muro|Entire home|151|
|Sa Pobla|Entire villa|128|

Table representing the most common property types by neighborhood

## 4️⃣ Which Listings Are Underpriced Compared to the Neighborhood Average?

I defined **"underpriced" listings** as properties listed **50% below** the average price in their neighborhood. This helps potential investors find **hidden gems** and allows hosts to adjust pricing strategies.

📌 **Findings:**

*   **Palma de Mallorca** has the highest number of underpriced listings (**~500 properties**).
    
*   **Pollença and Alcúdia** follow with **~300 underpriced properties** each.
    

This suggests that while these areas are popular, **some hosts may be pricing their listings too low**, potentially missing out on higher profits.

|neighbourhood\_cleansed|underpriced\_listings|
|---|---|
|Palma de Mallorca|406|
|Pollença|291|
|Alcúdia|276|
|Santanyí|151|
|Llucmajor|123|
|Felanitx|118|
|Manacor|117|
|Capdepera|115|
|Calvià|109|
|Santa Margalida|106|

Table representing underpriced listings compared to the neighborhood average

## 5️⃣ How Can I Identify Hosts Struggling with Cleanliness Issues?

To **sell cleaning services**, I needed to find hosts with **recurring cleanliness complaints**. The approach:
✅ Joined Airbnb reviews with listings 
✅ Filtered for keywords like "dirty" in **multiple languages (English, Spanish, French, German, Italian).
✅ Ranked hosts by the number of negative comments

📌 **Findings:**

*   **Homerti**, the largest host, has **87 affected listings** and **105 total complaints**.
    
*   However, **some small hosts have major cleaning issues**, e.g.:
    
    *   **Xesca** (2 listings) → **67 negative cleaning reviews**
        
    *   **Biel** (1 listing) → **40 negative cleaning reviews**
        

These hosts could **benefit from professional cleaning services**, making them potential **business opportunities**.

|host\_id|host\_name|total\_dirty\_comments|affected\_listings|
|---|---|---|---|
|80839530|Homerti|105|87|
|6040504|Xesca|67|2|
|122491844|Sealand Villas|51|42|
|54165641|Biel|40|1|
|6219005|Aina&Margarita|33|1|
|118877724|Bernardo|32|3|
|104655996|Cristina|31|20|
|65697804|Ideal Property Mallorca|25|25|
|37414184|Antònia|25|1|
|66720757|Sio|24|3|

Table representing hosts with the greatest number of "dirty" comments

# 📌 Insights & Key Takeaways

*   **Airbnb in Mallorca is dominated by large-scale property managers**, especially in **Pollença and Alcúdia**.
    
*   Property managers dominate Mallorca’s Airbnb market, especially in **Pollença and Alcúdia,** highlighting opportunities for B2B services like property management tools.
    
*   **Luxury rentals generate the highest revenue (€38K–€80K/year)**, suggesting that hosts should invest in premium accommodations to maximize profits.
    
*   The most common property type is **entire homes**, with **Pollenca (1,466 villas) and Palma (545 rentals)** leading, indicating strong demand for full-home experiences.
    
*   **Over 500 underpriced listings in Palma and 300+ in Pollenca & Alcudia** create an opportunity for investors to buy and reprice properties for better returns.
    
*   Cleaning issues are widespread opening the door for professional cleaning services targeted at struggling hosts.
    

# 🚧 Challenges I Faced

Working with this Airbnb dataset came with its fair share of hurdles. Here are the biggest challenges I encountered:

* **Inconsistent and messy data** – The dataset had missing values, formatting inconsistencies, and errors that required significant **data cleaning and standardization** before analysis.

* **Handling outliers and missing crucial data** – Some listings had extreme price values (€9,999 per night) or were missing essential details like pricing, which could distort the results. I had to carefully **identify and handle these outliers** while filling in gaps with meaningful estimations.

* **Making up with revenue estimations** – Since Airbnb doesn’t provide direct revenue figures nor booking details, I had to make reasonable assumptions about **availability and pricing** while keeping my calculations as close to reality as possible.

# 📚 Things I Learned

This project was a deep dive into SQL, data analysis, and problem-solving. Here are my biggest takeaways:

* **Thinking critically about business logic in data analysis** – Beyond writing SQL queries, I learned to **frame data insights in a way that provides value to hosts, investors, and service providers**, making the analysis more actionable.

* **Refining my approach to data cleaning** – Cleaning data wasn't just about removing errors—it was about making strategic decisions on **how to handle missing values, normalize data, and maintain consistency**.

* **Mastering WITH clauses for temporary table maneuvers** – Using **CTEs** made my queries cleaner and easier to manage, especially when dealing with multi-step calculations.

* **Identifying and handling outliers systematically** – I applied **Interquartile Range (IQR) methods** to detect and adjust extreme values, ensuring my analysis wasn't skewed.
