# Dashboarding with Looker Studio

Features reproduced exercises from the materials and the CPI Card dashboard capstone

## Capstone

- Dump data from postgres to parquet
- Put it in GCS
- Load it in BQ (there's [free 10 GB][bq-storage-pricing] of storage per month)
- Visualize it in Looker (?)

I wonder if it needs to be processed first...

## Exercises

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

### Exercise 5: Restaurant Performance Analysis

Can't find the restaurant dataset that has revenue in them. Bummer.

As an alternative, maybe I can try to do the [Super Store analysis][katie-super-store] (here's the [dataset][kaggle-dataset-super-store] btw), or [Terrorism Hotspot analysis][stratascratch-terrorism-hotspot], or [Maven Unicorn challenge][maven-unicorn-challenge]

[//]: # (Links)

[bq-storage-pricing]: https://cloud.google.com/bigquery/pricing#storage
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
