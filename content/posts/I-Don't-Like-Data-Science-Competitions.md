---
layout: post
title: I Don't Like Data Science Competitions
date: 2021-05-16 23:00:00 +0000

---

***DISCLAIMER***

***The following are simply my views and in no way reflect those of the whole industry.***

![alt text](/images/audience-booing.gif "Logo Title Text 1")

## What is a Data Science competition?

Data Science competitions have become extremely popular. They are not only popular on sites such as [Kaggle](https://www.kaggle.com/), a site renown for bringing Data Scientists and Machine Learning practitioners together to enter competitions to solve Data Science challenges, but also when interviewing with a company for a role on the job market in the form of a candidate test.

![alt text](/images/titanic-competition.png "Logo Title Text 1")
*Popular titanic competition*

These competitions/tests normally consist of a time constrained objective where the organiser provides some data, many times a train and test set, dependant variable omitted from the test set of course, and submit the predictions which your model spat out in order to see how well you faired compared to all the other participants. That is, your predictions are compared with the dependant variable omitted from the test set. Those yielding the highest accuracy fair much better compared to the rest. In certain cases your methods may also be questioned, but this is more the case in job interviews, although not as often as it should, rather than in online competitions.

Having not only studied data science in university but also practised it in industry, I can definitely say that these are two worlds apart. This is not to say that edication doesn't have its place in the space of Machine Learning. My bachelor thesis revolved around algorithmic trading. I trained a Machine Learning model to pick correlated and inversely correlated stocks from a basket, forecast future price movements in said stocks, and decide on whether to hold, buy, or sell based on those insights without the need of any human input. Although I did learn a lot from this experience, I would definitely not use the model in industry and I would absolutely not let it use real money to invest.

![alt text](/images/algorithmic-trading.jpg "Logo Title Text 1")

## Industry isn't about producing the highest fraction of accuracy

Data sets found in industry are completely different compared to those found in competitions. In fact, I wouldn't even go as far as to call them data sets but a huge database, sometimes multiple if you're not lucky enough to have a centralised data warehouse, where you need to sift through multiple tables looking for the data you need, do some heavy tidying, and checking the data before you can even consider using it in a Machien Learning model. This is completely different to a `.csv` file which you're handed in a competition, a data set where someone has already gone through the work of packaging the data for you. There's a joke that "Data scientists spend 80% of their time cleaning data and the other 20% complaining about it." This is of course an overexaggeration, however it is meant to emphasise how hard it is for a Data Scientist to get the data they need before they may even begin modelling. This is something which these competitions fail to teach you.

![alt text](/images/data-science.jpg "Logo Title Text 1")

## Competitions do not help you understand your model

The ultimate goal of a competition is to obtain the highest accuracy where even a fraction could make a difference, all under time contrained conditions. This does not encourage you to take the time to understand the data, it's imperfections, and train a model which is robust to adversarial examples. Instead you are incentivised to try anything which will edge you forward even slightly, not matter the cost. This encourages the use of black box models, leaving you unable to understand what your model is learning from your data.

## Not all submissions require submitted code

If you weren't incentivised enough to produce a black box solution to yield the highest accuracy, some competitions do not even enforce the need to submit your solutions for others to try, placing further importance on the accuracy result rather than the method that was used to achieve said result.

## You are not required to write good clean code

Data Science isn't just about modelling, but it's also about writing good clean code which others are able to understand and reproduce the results which you obtained with the data. Since Data Science challenges are so focused on model accuracy, you are not being incentivised to properly document your code and the approach you took to reach the conclusions which you presented.

## You are not taught SQL

SQL is one of if not the most important skill to have in Data Science. Without any knowledge of SQL, you will not be able to query the databases where your data lies in order to get the data you need in the format which your model requires.

## How to improve your Data Science skills

If you're looking for ways to learn, find a particular industry that interests you and try to apply Machine Learning too it. Let's say you're into real estate and would like to train a model to predict the value of a proprty based on its features. You might even try to forecast the future price increase X years in the future. This could help others looking to buy property and shed a light on the price fluctuations in the property market right now.

You could definitely find a data set online which will give you this information, however as I explain above these data sets won't hold in real world examples. It would be more realistic if you found a website(s) listing the information you need and build a [scraper](https://scrapy.org/) to collect the data you need and schedule it to run on a regular basis so that you can start to collect historical data over time. In certain cases some websites may even offer an API to make your life a little easier in getting the data which you need.

You can now start to analyse the data you're collecting over time and understand the features that really matter in evaluating the value of a property along with the events which cause the prices to move over time. Once you have a model you might even want to serve it over an API for others to use, allowing them to input the property features and get back a prediction from your model.

![alt text](/images/hacker-man.jpg "Logo Title Text 1")

Why am I suggesting all of this? Because although it's easy to just find a data set on the internet, this isn't how you're going to get your data in industry and if you've found you're data set online chances are someone has already done something with it, this might be your chance to try something new.

## What competitions are good for

This isn't to say that competitions don't have a place at all in Data Science. I do believe that such competitions present an excellent way of bouncing ideas off of each other, assuming the code was submitted, in order for you to try out on your own data.

Good competitions which also include writeups present a great opportunity for knowledge sharing within the community, allowing for the community to ask questions about the submitter's approach.

![alt text](/images/sharing-is-caring.jpg "Logo Title Text 1")