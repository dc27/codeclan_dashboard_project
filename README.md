<<<<<<< HEAD
## Team MGCD Dashboard Project - Health in Scotland

# Introduction
This repository showcases a dashboard app created using R studio and Shiny functionality to explore health data in Scotland.  The team created a dashboard which allowed the user to explore two main health overview topics - Life Expectancy and Life Satisfaction.  The dashboard also allowed exploration of the health issues around smoking, drug and alcohol behaviours.  Data was sourced from the Scottish Government.


# Team Members

Our team of four comprised of David Currie, Mark Donaldson, Calum Sey and Geraldine Smith, all from CodeClan DE5 Data Analysis cohort.

# Process Methodology
The team used data from the Scottish Government website, which required some data cleaning and wrangling. The data sets required levels of filtering in order to allow the user to explore by different variables such as council area, health board, age and gender.

# Packages Used
The main packages used for cleaning were tidyverse and janitor.  The packages used to manipulate the spacial data were.....

# App Functionality
The app has four tabs which display data on different topics:
General Health Overview - Life Expectancy/Life Satisfaction
Alcohol - Hospital Related Alcohol Incedents
Drugs - Drug Misuse Discharge's from Hospital
Smoking - 

Each tab allows the user to explore the data set by changing variables such as NHS health board, time period, age range and gender.

# References

All data was sourced from www.gov.scot.  For specific data sets used, please see links below:

1. https://www.gov.scot/binaries/content/documents/govscot/publications/corporate-report/2 018/06/scotlands-public-health-priorities/documents/00536757-pdf/00536757-pdf/govsco t%3Adocument/00536757.pdf​)
2. https://statistics.gov.scot/resource?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2F Life-Expectancy
3. https://statistics.gov.scot/resource?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2F scottish-health-survey-local-area-level-data
4. https://statistics.gov.scot/resource?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2F smoking-sscq
5. https://statistics.gov.scot/resource?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2F drug-related-discharge
6. https://statistics.gov.scot/resource?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Falcohol-related-hospital-statistics

=======
Authors:
David Currie
Geraldine Smith
Mark Donaldson
Calum Sey

## Guide to authors: branch n merge

0. Start at the top level of the git repo.
1. Create new branch for you to work on your feature
```
gco -b feature/name_of_your_feature
```
2. Complete work on your feature and commit changes
```
git add .
git commit -m "adds name_of_my_feature"
```
3. Jump over to main branch
```
gco main
```
4. Pull latest version. Tell other authors you are in the process of merging.
```
git pull
```
5. Jump back to your feature branch
```
gco feature/name_of_your_feature
```
6. Merge main (merge any new commits from main that don't exist in your feature)
```
git merge main
```
7. Resolve any conflicts and **verify the app is working**. 
8. Push working app
```
git push
```
Git will give you code to copy
```
git push --set-upstream origin feature/name_of_your_feature
```
9. Jump over to the main branch
```
gco main
```
10. Merge feature branch (update main branch to include your feature)
```
git merge feature/name_of_your_feature
```
11. Push up main branch
```
git push
```
>>>>>>> 36b7e9f3d9f5c24cfbf367faadfd94cb5678d3c1
