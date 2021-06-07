---
layout: post
draft: false
title: I Don't Like Data Science Competitions
author: Gabriel Gauci Maistre
tags:
- kaggle
- machine learning
- python
date: 2021-05-17 23:00:00 +0000
description: Data Science competitions have become extremely popular in the past 5 years. They are not only popular on sites such as Kaggle, but also when interviewing with companies for a role on the job market in the form of a candidate test. These tests have quickly turned into a way to judge the performance of a participant/candidate's submission and determine whether they have succeeded in the challenge or not.
summary: Data Science competitions have become extremely popular in the past 5 years. They are not only popular on sites such as Kaggle, but also when interviewing with companies for a role on the job market in the form of a candidate test. These tests have quickly turned into a way to judge the performance of a participant/candidate's submission and determine whether they have succeeded in the challenge or not.
images:
- /images/audience-booing.gif
audio: []
series: []
videos: []
date: 2021-05-18 23:00:00 +0000

---

***DISCLAIMER***

***The following are simply my views and in no way reflect those of the whole industry.***

![alt text](/images/audience-booing.gif "Audience booing")

## What is a Data Science competition?

Data Science competitions have become extremely popular in the past 5 years. They are not only popular on sites such as [Kaggle](https://www.kaggle.com/)[0], but also when interviewing with companies for a role on the job market in the form of a [candidate test](https://exercism.io/). These tests have quickly turned into a way to judge the performance of a participant/candidate's submission and determine whether they have succeeded in the challenge or not.

![alt text](/images/titanic-competition.png "Kaggle titanic competition")
*Popular titanic competition*

These competitions/tests normally consist of a time constrained objective where the organiser provides some data, many times a train and test set[1], and participants submit the predictions which their model spat out in order to see how well they fared compared to all the other participants. That is, the predictions are compared with the dependant variable[2] omitted from the test set. Those yielding the highest accuracy fair much better compared to the rest. In certain cases the participant's methods may also be questioned, but this is more the case in job interviews, although not as often as it should, rather than in online competitions.

While my introduction to Data Science happened during my studies at university, it practice in the industry that helped me see that these are two worlds apart. This is not to say that education does not have its place in the space of Data Science and Machine Learning.

My bachelor thesis revolved around algorithmic trading. I trained a Machine Learning model to pick correlated and inversely correlated stocks from a basket, forecast future price movements in said stocks, and decide on whether to hold, buy, or sell based on those insights without the need of any human input. Although I did learn a lot from this experience, I would definitely not use the model in industry and I would absolutely not let it use real money to invest.

![alt text](/images/algorithmic-trading.jpg "Stock market prediction")

## Real data does not come in a CSV file

Data sets found in industry are completely different compared to those found in competitions. In fact, I would not even go as far as to call them data sets but a huge database, sometimes multiple if you are not lucky enough to have a centralised data warehouse. You would need to sift through numerous tables, of which lacking proper documentation, looking for the data you need, only to then do some heavy tidying to structure your data, and thoroughly checking the data before you can even consider using it in a Machine Learning model.

This is completely different to a `.csv` file which you are handed in a competition, a data set where someone has already gone through the work of packaging the data for you. There is a joke that "Data Scientists spend 80% of their time cleaning data and the other 20% complaining about it." This is of course an over exaggeration, however it is meant to emphasise how hard it is for a Data Scientist to get the data they need before they may even begin modelling. This is something which these competitions fail to teach you.

## Industry is not about producing the highest fraction of accuracy

When you are dealing with companies and their customers, it is more important to understand how a model is forming its decisions rather than the highest accuracy it can achieve. Ultimately a weak model can hurt a company's business and their image, potentially at a loss of both their customers and money. A Machine Learning model may achieve excellent results in a test set, however that does not mean that its assumptions will hold once the model is deployed in production and tested against real data. What will your model do when it finds an example which its never come across before?

It is also possible that the model has been [overfit](https://en.oxforddictionaries.com/definition/overfitting)[3] on the training data, performing excellently in test environments but less so in production. In other cases the train and test sets could also include biases introduced by humans allowing the Machine Learning model to learn from the same biases and apply them in its decisions.

![alt text](/images/amazon-ai-scandal.png "Amazon AI scandal")
*[reuters](https://www.reuters.com/article/us-amazon-com-jobs-automation-insight-idUSKCN1MK08G)*

When it comes to lawful conduct, if a company is ever sued because of the decisions which its Machine Learning models were making, the company is liable for damages unless they are able to understand the inner workings of their models and explain such decisions to the public, assuming the decision making behind those decisions were justifiable.

In order to comply with regulatory frameworks, companies need to be able to explain their processes in order to get regulatory approval. If a company's Anti Money Laundering (AML) processes come into question caused by a particular case falling through the cracks, "Machine Learning" as an excuse will not fly. This is why easy to understand and transparent Machine Learning algorithms such as Decision Trees[4] tend to be preferred when applied to compliance problems.

![alt text](/images/revolut-aml.png "Revolut AML scandal")
*[telegraph](https://www.telegraph.co.uk/technology/2019/02/28/revolut-failed-block-suspicious-transactions/)*

## Competitions do not help you understand your model

The ultimate goal of a competition is to obtain the highest accuracy where even a fraction could make a difference, all under time constrained conditions. This does not encourage you to take the time to understand the data, its imperfections, and train a model which is robust to adversarial examples. Instead you are incentivised to try anything which will edge you forward even slightly, no matter the cost. This encourages the use of black box models, leaving you unable to understand what your model is learning from your data.

![alt text](/images/data-science.jpg "Data Scientist hacking things together")

Competitions tend to use data sets which are less complex in order to lower the barrier of entry and boost participation, apart from the time constraint of course. They also do this because they're not allowed to publicly share personally identifiable information (PII) about their customers. Another reason is that a company's data is propriety. There's a reason why data is called ["the new oil."](https://www.forbes.com/sites/forbestechcouncil/2019/11/15/data-is-the-new-oil-and-thats-a-good-thing/) No company is going to willingly give out their secret sauce for others to use for their own businesses. This limits the things you can learn from competing in such competitions.

## Not all submissions require source code

If you were not incentivised enough to produce a black box solution to yield the highest accuracy, some competitions do not even enforce the need to submit the code behind your solutions for others to try, placing further importance on the accuracy result rather than the method that was used to achieve said result.

## You are not required to write good clean code

Working as a Data Scientist is not just about modelling, it is also about writing good clean code, in which others are able to understand and reproduce the results which you obtained with the same data. Since Data Science challenges are so focused on model accuracy, you are not being incentivised to properly document your code and the approach you took to reach the conclusions which you presented. This stops others from being able to learn from your methods, and of course stops you from doing the same from others.

## You are not taught SQL

SQL is one of if not the most important skill to have in Data Science. Without any knowledge of SQL, you will not be able to query the databases where your data lies in order to get the data you need in the format which your model requires. Sure you can dump a table to a file and then just use [Pandas](https://pandas.pydata.org/) to do the rest, but that will not get you very far.

What if your database spans in the hundreds of GBs, if not TBs?. The general rule of thumb is that in Pandas you need ten times the amount of RAM that you do data. This means that for just 1GB of data you will need 10GB of RAM. Databases are far more efficient at processing data than a library like Pandas, which is why I always recommend to do as much processing as possible in the database, and only extract the data as a last resort once you really need a library like Pandas to continue with your work. This is not to say that there are not more efficient libraries than Pandas[5], however there is an efficiency v.s complexity trade-off which you will have to make.

## How to improve your Data Science skills

If you are looking for ways to learn, find a particular industry that interests you and try to apply Machine Learning to it. Let's say you are into real estate and would like to train a model to predict the value of a property based on its features. You might even try to forecast the future price increase X years in the future. This could help others looking to buy property and shed a light on the price fluctuations in the property market right now.

You could definitely find a data set online which will give you this information, however as I explained above these data sets will not hold in real world examples. It would be more realistic if you found a website(s) listing the information you need and build a [scraper](https://scrapy.org/) to collect the data you need and schedule it to run on a regular basis so that you can start to collect historical data over time. In certain cases some websites may even offer an API to make your life a little easier in getting the data which you need.

Simply scraping the data is not enough, since you are going to do this regularly you need to think of an efficient way to store the data and keep track of the historicals. This is where a database would come in. There is no need to go off and set up a distributed database, [SQLite](https://www.sqlite.org/index.html) would suffice for a project like this, saving you the pain of having to setup and maintain a database server, while still providing you a fast SQL query engine you can use to query your data.

You can now start to analyse the data you are collecting over time and understand the features that really matter in evaluating the value of a property along with the events which cause the prices to move over time. Once you have a model you might even want to serve it over an API for others to use, allowing them to input the property features and get back a prediction from your model.

![alt text](/images/hacker-man.jpg "Hacker man")

Why am I suggesting all of this? Because although it is easy to just find a data set on the internet, this is not how you are going to get your data in industry. And if you have found your data set online, chances are someone has already done something with it. This might be your chance to try something new.

## What competitions are good for

This is not to say that competitions do not have a place at all in Data Science. I do believe that such competitions present an excellent way of bouncing off ideas from each other, assuming the code was submitted, in order for you to try new methods out on your own data.

Good competitions which also include write ups present a great opportunity for knowledge sharing within the community, allowing for the community to ask questions about the submitter's approach.

![alt text](/images/sharing-is-caring.jpg "Sharing is caring")

---

* [0] Kaggle is a site renowned for bringing Data Scientists and Machine Learning practitioners together to enter competitions to solve Data Science challenges.
* [1] A test set is a subset of the data used to test the accuracy of your model based on data it has never seen before. In the case of competitions test sets tend to have the dependant variable omitted.
* [2] A dependant variable is the value you're trying to predict which is dependant on the values of other variables.
* [3] Overfitting is "the production of an analysis that corresponds too closely or exactly to a particular set of data, and may therefore fail to fit additional data or predict future observations reliably".
* [4] A decision tree is a diagram or chart that helps determine a course of action or show a statistical probability. Each branch of the decision tree represents a possible decision, outcome, or reaction. The furthest branches on the tree represent the end results of a certain decision pathway.
* [5] [NumPy](https://numpy.org/) is a Python library used to compute mathematical operations on data. It is written in C which makes it blazingly fast compared to other libraries.