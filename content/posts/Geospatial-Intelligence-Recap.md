---
layout: post
draft: false
unlisted: true
title: Geospatial Intelligence Recap
author: Gabriel Gauci Maistre
description: I recently had the pleasure of giving a talk on Geospatial Data Science at the Munich Business School (MBS). My talk "Geospatial Intelligence" covered a brief introduction into Geospatial data, what it looks like, its challenges, and its use cases. Some students had a few interesting questions which I thought were worth answering in more detail here.
summary: I recently had the pleasure of giving a talk on Geospatial Data Science at the Munich Business School (MBS). My talk "Geospatial Intelligence" covered a brief introduction into Geospatial data, what it looks like, its challenges, and its use cases. Some students had a few interesting questions which I thought were worth answering in more detail here.
images:
- /images/mbs-me-1.jpg
image: /images/mbs-me-1.jpg
audio: []
series: []
videos: []
tags:
- data science
- machine learning
- geospatial
date: 2021-11-21 23:00:00 +0000
---

![alt text](/images/mbs-me-1.jpg "My talk on Geospatial Intelligence at MBS")

I recently had the pleasure of giving a talk on Geospatial Analytics at the [Munich Business School (MBS)](https://www.munich-business-school.de/en/). My talk "Geospatial Intelligence" covered a brief introduction into Geospatial data, what it looks like, its challenges, and how it can be applied towards business strategies.

Geospatial data is projected onto a flat surface (map) and consists of 3 key components, spatial (where) such as the particular location on the map, attributes (what) such as the name or type of location, and time (when) such as when the data was collected. Such data may be hard and expensive to collect due to its size, however there are many sources providing free data such as [OpenStreetMap](https://openstreetmap.org/) allowing you to extract street networks and building footprints, points of interest, geocoded addresses, and more.

There exist a few challenges when working with Geospatial data that one needs to be made aware of before moving forward. Because the earth is not flat, there exist many types of Coordinate Reference Systems (CRS)[[0]](#f0) which are used to project coordinates onto a map. It's important to be aware of this and to ensure that all the coordinates in your data sets are using the same CRS. If not, it is essential that you reproject the coordinates to a common CRS that you're using. This can lead to many issues as coordinates projected using a differing CRS will not align with each other on the same map.

As Geospatial data is a specialised type of data, it also requires special tools. Popular open source databases such as [PostgresSQL](https://www.postgresql.org/) allow you to install extensions such as [PostGIS](https://postgis.net/) allowing you to store Geospatial objects such as points and polygons, and apply spatial transformations such as joins and aggregations based on location. Tools also exist to allow you to visualise Geospatial data on a map such as [LeafletJS](https://leafletjs.com/) which is an open source JavaScript library allowing you to layer Geospatial objects on a map in your browser.

It's also important to note that although Geospatial analytics is quite an interesting field with many applications, we must ensure that none of the data we collect or the way we use it will put anyone's safety at risk. Points on a map may ultimately refer to a real person's movements, which may put them in harms way should this data be used incorrectly or fall into the wrong hands. Safety first.

In the talk I briefly touch on a few use cases that can be applied with Geospatial data which I will summarise below:
* Competitor tracking
  * Where are my competitors?
  * How close are they?
  * What are their Google ratings[[1]](#f1) compared to mine?
* Points of interest (POI)
  * Which POIs are important?
  * How close are they to my branches?
  * Which common POIs exist in locations where my customers use my product?
* Catchment areas[[2]](#f2)
  * How many customers can I reach within X minutes on foot/by car?
  * How many can my competition reach?
  * How many potential customers can I reach?
* Customer analyses
  * Where are my customers coming from?
  * How close are they to my nearest branch?
  * How close are they to my competitors?
  * What are the core sociodemographics[[3]](#f3) of my customers?
  * Can I use that to find more potential customers?
  * Where can I find travel hubs?[[4]](#f4)

Some students had a few interesting questions which I thought were interesting to elaborate further on in more detail here.

## What are the limitations of Geospatial data when applying it towards business applications?

The world is fairly large, and since Geospatial data can cover the whole globe, gathering and storing all of this data can be fairly challenging. You will rarely find one data set to cover the whole globe, and if you do it will mostly likely come with a hefty price tag. Having to deal with so many varying data sets all coming from varying sources can be challenging as structure and quality from one data set to another can vary enormously.

Finding the right data sets is one important step, but finding the right data store is crucial. If done improperly, you will be fairly limited in what you can do with your data. Geospatial data contains "special" objects just as Points, Lines, and Polygons. Many databases will not only be unable to store such objects in their correct format, but will not provide the functionality to apply spatial transformations such as joining data sets together based on their location. It is also important to be aware of the limitations your data store may have in terms of Geospatial data. For optimal speed when applying spatial transformations, databases need to support indexing on geometry to optimise execution based on location.

Ultimately collecting and storing data is useless is you're not able to share that with others in the form of visualisations. Unfortunately it is quite hard to find mainstream Business Intelligence (BI) tools that are able to support Geospatial objects out of the box. Most are able to visualise points, but fail to visualise anything further than that. Many also suffer from limitations in terms of how many points can be visualised at the same time on a map, and others fail to correctly visualise point sizes as you zoom in and out of a map.

Finally, it's extremely important yet hard to find people, both from technical and business backgrounds, who can truly understand Geospatial data, know its applications and limitations, and how to apply them towards the business' needs.

## Has the latest iOS privacy changes affected business analytics when it comes to Geospatial data provided by customers?

I have very limited experience with advertising data, so anything I say here could be wrong and should most certainly be taken with a grain of salt. Companies tracking your location data, either through your mobile operating system (OS) or directly through their services such as mobile apps, whom are in the business of selling such data to other businesses, do not tend to advertise what you are doing and where individually. Such data is normally aggregated and anonymised to protect your privacy before it is shared with other businesses.

This however does not mean that such companies collecting this data do not have access to each user's individual data, and can use this to target you directly with advertisements. However in the case of companies with mobile apps which require a users location data to function, will already have access to such data to provide the customer with its services. So it is important to distinguish data coming from internal sources such as a company's mobile app, and 3rd party sources such as advertising data.

Apple's iOS privacy changes made it harder for companies to track your activity across all apps on your phone, but they can still see everything you do within their app. However, they will now no longer be able to see what you are also doing in other mobile apps.

## Which skills are required to become a Data Scientist?

The skills you will need will ultimately depend on the project you are working on, and it is quite normal to learn on the job as you work from one project to another. However there are some core skills required which I will touch on briefly below:

* SQL
  * Querying databases to retrieve data
* Programming
  * R/Python/Julia/etc.
  * Automating tasks and report
  * Developing predictive models
* Profiling
  * Optimising code and SQL queries to reduce execution times
  * Knowing how to write good and readable code
* Probability & Statistics
  * Machine Learning
* Explaining things in a simple way
  * Ultimately if you do not know how to explain things simply, others will not be able to understand and use your work
  * Presentation skills are very important, both to technical and business oriented audiences
* Research
  * Understanding how search engines work
  * Looking up solutions to problems
  * Reading research papers to gather ideas

These are all important skills to have, however you might not necessarily have a foot in all in the beginning, and that's fine. However it's good to know what your weaknesses are and learn as you go along.

## What is your general advice for students who'd like to start a career as a Data Scientist?

Do not be disheartened by all the information available, no one knows everything, but you must be open to accepting that you will never need to stop learning. The most important skill for a Data Scientist to have isn't Python, nor is it Machine Learning. SQL is the most critical skill to have when working with data. You will be constantly querying databases on the job and the most common way to do that will be SQL. There is also a lot you can do in SQL to provide the business with insights before needed to look into more technical approaches such as Machine Learning.

My personal advice would be to understand the various data roles that exist and the differences between them. Data Science gets a lot of hype, but there's a lot of other roles which are just as important. I will try to give my own personal breakdown for each role, however these will differ from one company to another.

* Data Engineer
  * Builds and maintains the data platform
  * Gathers data from various sources into one central hub
  * Structures data in a way for others to easily analyse
  * Supports Data Analysts & Scientists
* Data Analyst
  * Leverages work of Data Engineers
  * Analyses data
  * Generates reports and visualisations
  * Communicates findings regularly with business owners
  * Explains what happened in the past and why
* Data Scientist
  * Leverages work of Data Engineers & Analysts
  * Communicates findings regularly with business owners
  * Explains what will happen in the future
* Product Manager
  * Leverages all the work from all data roles above
  * In constant touch with business owners to understand their requirements
  * In constant touch with Data Engineers/Analysts/Scientists to deliver business products
  * Keeps teams focused and on track

## Are there any Data Science internships?

Due to the nature of Data Science projects spanning over multiple months, it can be quite hard to find an internship available and is ultimately down to each company. The barrier for entry is also fairly high as many skills required are only learnt on the job, so I would suggest looking for roles such as Data Analyst/Engineer which can teach you a lot of the analytical skills which you will need for Data Science, of which should be easier to find internship roles.

## Which tools can I use to visualise Geospatial data?

There exist quite a few of which I'll briefly mention, all of which are open source:
* [LeafletJS](https://leafletjs.com/)
  * JavaScript (JS) library
  * Requires some very basic JS knowledge to set up
  * Does not require a server
  * Runs in the browser using an HTML file
  * Very easily shared with others
  * Static view of spatial objects on a map
  * Limited functionality such as hover tooltips to view attribute values
* [Dash](https://plotly.com/dash/)
  * Create dashboard in Python or Julia
  * No need for web development knowledge
  * Complexity is up to you
  * Requires a server to host your dashboard
* [Carto](https://github.com/CartoDB/cartodb)
  * Geospatial platform
  * Bundles a database, dashboard, data connectors, etc.
  * Hard to set up and overkill for just 1 person
* [QGIS](https://qgis.org/en/site/)
  * Desktop application
  * Quickly view Geospatial data on a map
  * Export Geospatial data to share to others using LeafletJS
  * Extend the application with Python scripts

My personal recommendation for a beginner would be to use QGIS as it has an easy to use graphical user interface (GUI) to import, visualise, and export Geospatial data making it extremely easy to share your visualisations with others. The application can run on multiple platforms (Windows/Mac/Linux) and is also quite popular within the Geospatial community, so you shouldn't have any difficulty in finding support or [looking up tutorials](https://qgis.org/en/site/forusers/trainingmaterial/index.html).

## Conclusion

I'd like to thank MBS for giving me the opportunity to share my thoughts on the area of Geospatial Analytics, and to all the students who attended and listened to me go on for a whole hour, I hope it was worth your time.

If you're still interested in finding out more about the field, here's a few books which I can highly recommend:
* [Weapons of Math Destruction](https://www.goodreads.com/book/show/28186015-weapons-of-math-destruction)
  * Helps you understand how machines misinterpret data
  * Talks about real situations where algorithms negatively impacted people's lives
* [Data Science from Scratch](https://www.oreilly.com/library/view/data-science-from/9781492041122/)
  * Will give you a quick introduction to Python and good coding practices
  * Will teach you how many tools in Data Science work by building them from scratch
* [Geospatial Data Science with Python](https://geographicdata.science/book/intro.html)
  * Will give you an brief introduction to Geospatial Analysis
  * Will teach you some tools and technique for Geospatial Data Science in Python

---

* <a name="f0">[0]</a> Because the Earth is not flat, which I hope you know, there is no perfect way to project it onto a flat surface. Thus, based on the location or who you ask, there are preferred CRSs over others. You can look up different CRSs [here](https://epsg.io/).
* <a name="f1">[1]</a> Sociodemographic data can give you a better understanding of the characteristics of a certain population such as population density, age distribution, education level distribution, umemployment rate, and more.
* <a name="f2">[2]</a> Catchment areas are calculated by extracting street networks from mapping data and estimating the time it would take for an individual to reach the centre within a certain amount of time. The larger the catchment area, the wider your reach.
* <a name="f3">[3]</a> If you run a Business-to-Consumer (B2C) business, you most probably have a Google profile where customers can rate your product and provide feedback. It's critical to be aware of your own ratings, but to also compare them to those of your competitors.
* <a name="f4">[4]</a> If your business is heavily dependent on travel, it makes sense to leverage movement data to see where groups of populations are travelling from and to, including the routes which they take.