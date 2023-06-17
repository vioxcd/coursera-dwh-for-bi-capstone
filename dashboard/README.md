# Dashboarding with Looker Studio

Features the CPI Card dashboard for the specializations capstone and more notes about exercises from the materials (in case I ever feel like trying more dashboards)

Click [here](https://lookerstudio.google.com/s/sMehk36GvWE) to see the dashboard

## Workflow

1. Looking at the dashboard and questions, thinking whether it can be answered by using the data
2. Creating a query that would generate the data for the visualizations  
  From this I learned that there are two types of data that can be processed by Looker: pre-aggregated and usual table forms. I decided to went with the first way, as initially I used the second way and experienced a bit of lag
3. Uploading the data to Google Cloud Storage (with `gsutil`)
4. Importing the data to Looker via GCS connector
5. Creating the visualization for the data
6. Step 2 to 5 is iterative, as I tried to make the dimension looks correct and resembles the examples, and could answer the questions given

## Capstone

### Dashboard 1: Job and Shipment Trends

![Dashboard 1: Job and Shipment Trends](https://github.com/vioxcd/coursera-dwh-for-bi-capstone/assets/31486724/c9cd087d-0c98-4324-b22f-adfdb6d51d5f)

#### Questions

1. How much revenue does a company generate from its job bookings?  
   This question can be answered by looking at the `grand total` rows (bottom) in the *lead generation by location and agent* table

2. How many jobs does each sales agent book?  
   This question can be answered by looking at the `jobs booked` column in the *lead generation by location and agent* table

3. How many jobs have not yet shipped or have only partially shipped?  
   This question can't be answered by using the data, but the *late shipments* table can be used to refer to shipment-related late days

### Dashboard 2: Invoice Trends

![Dashboard 2: Invoice Trends](https://github.com/vioxcd/coursera-dwh-for-bi-capstone/assets/31486724/0d4e797f-dc4c-4217-bef3-37b260276230)

#### Questions

1. Which sales class generate the highest invoice amounts?  
   This question can be answered by looking at the `invoice amount` in the *total invoiced amount by sales class* table

2. How many invoices are generated for a time period?  
   This question can be answered by changing the `date input format` at the top left corner and seeing the *total invoice scorecard* changes

3. What is the total amount invoiced for a time period?  
   This question can be answered by changing the `date input format` at the top left corner and seeing the *total invoice amount scorecard* changes

### Dashboard 3: Financial Performance

![Dashboard 3: Financial Performance](https://github.com/vioxcd/coursera-dwh-for-bi-capstone/assets/31486724/7c2c31f6-9c60-4324-924e-e474f54f5008)

#### Questions

1. Determine the location and the machine which have the highest overall machine
and labor cost. Also determine which location has the lowest budget overhead cost.  
Highest machine and labor cost means it's on the upper-right hand-side of the top chart. Hovering on that point reveals the `location name` dimension that can be looked at. Answer: *Los Angeles*  
Lowest budget overhead is indicated by the color of blue (category 6) in the bottom-left hand-side. Answer: *Vancouver*

2. Which location is seen to have higher forecast amount in comparison to the actual amount on the basis of time period?  
   Forecast is made on year-on-year basis, so it's only right to group them by years. Looking at the bottom graph, there's an input field for `location name` where user can select an option among 12 locations available. After selected, the graph would change to reflect the data for the current location selected.  
   Looking at the graph for each locations to answer the question, **all locations have higher forecast amount in comparison to the actual amount in all time periods**

## More Exercises

As the dataset for the exercises are scattered all around, I've spend extra effort to get them all. Here's some notes about the ones I could find

### Exercise 1: Fertility Rate and Life Expectancy

- [List of country data][kaggle-dataset-countries] from Kaggle. Seems to be a fictitious data. There's 227 countries in here
- [Fertility and life expectancy][kaggle-dataset-fertility-and-life-expentancy] data from Kaggle (World Bank). Covers data for 264 countries for 1960-2016

### Exercise 1: Hawaiian Airlines

- [2015 Flight Delays and Cancellations][kaggle-dataset-flight-delays]

### Exercise 1: Region and Category Analysis

- [Superstore dataset][kaggle-dataset-superstore]. It's kind of different in terms of the region and product category. But, I think it can be made to be a heatmap

### Exercise 2: Canada Price House Index

- [Housing Affordability in Canada][kaggle-dataset-canada-hpi]. Looks okay, but I think the column is messed up and needs to be cleaned up

### Exercise 2: World Emissions

- [CO2 Emissions][eia-gov-emiss-txt]. It's in a txt format that needs to be processed...

### Exercise 3: Private Loans

- [Bank loan interest rate dataset][kaggle-dataset-bank-loan]. It's missing the date field, but I think it can be added later (date is used in the last visualizations). More importantly, it's missing the `credit grade` field. I think I can generate it later, let's see how it goes

### Exercise 4: Mobile Analysis

- [TalkingData Mobile User Demographics][kaggle-dataset-mobile]. I can't seem to find the kind of dataset used in the module, so I'll just make up my own analysis for it. This dataset differs by a large stretch, though. It's used for a classification competition. I wonder if I could do EDA on this?

Update: I think the analysis uses data from Google Analytics. Looker studio has [a template dashboard][ga-template-dashboard] for it. Here's the dataset that I could find, one from [Kaggle][kaggle-dataset-ga] sampled from BQ, and the other from [Google Cloud public dataset][gcp-public-ga-dataset] (the ones in BQ)

### Exercise 5: Restaurant Performance Analysis

Can't find the restaurant dataset that has revenue in them. Bummer.

As an alternative, maybe I can try to do the [Super Store analysis][katie-super-store] (here's the [dataset][kaggle-dataset-super-store] btw), or [Terrorism Hotspot analysis][stratascratch-terrorism-hotspot], or [Maven Unicorn challenge][maven-unicorn-challenge]

[//]: # (Links)

[kaggle-dataset-countries]: https://www.kaggle.com/datasets/fernandol/countries-of-the-world
[kaggle-dataset-fertility-and-life-expentancy]: https://www.kaggle.com/datasets/gemartin/world-bank-data-1960-to-2016
[kaggle-dataset-flight-delays]: https://www.kaggle.com/datasets/usdot/flight-delays
[kaggle-dataset-superstore]: https://www.kaggle.com/datasets/vivek468/superstore-dataset-final
[kaggle-dataset-canada-hpi]: https://www.kaggle.com/competitions/housing-affordability-in-canada
[eia-gov-emiss-txt]: https://www.eia.gov/opendata/index.php#bulk-downloads
[kaggle-dataset-bank-loan]: https://www.kaggle.com/datasets/prashanthsri12/bank-loan-interest-rate-dataset
[kaggle-dataset-mobile]: https://www.kaggle.com/competitions/talkingdata-mobile-user-demographics/
[katie-super-store]: https://github.com/katiehuangx/Super-Store-Analysis
[kaggle-dataset-super-store]: https://www.kaggle.com/datasets/akashkothare/tsf-datasets?select=SampleSuperstore.csv
[stratascratch-terrorism-hotspot]: https://platform.stratascratch.com/data-projects/terrorism-hotspots
[maven-unicorn-challenge]: https://www.mavenanalytics.io/blog/maven-unicorn-challenge
[ga-template-dashboard]: https://lookerstudio.google.com/u/0/navigation/templates
[kaggle-dataset-ga]: https://www.kaggle.com/datasets/bigquery/google-analytics-sample
[gcp-public-ga-dataset]: https://console.cloud.google.com/marketplace/product/obfuscated-ga360-data/obfuscated-ga360-data?project=lexical-script-761
