---
layout: post
draft: false
unlisted: true
title: The Future of Machine Learning is not Python, it's SQL
author: Gabriel Gauci Maistre
description: Python is touted as the language to learn and use for DS and ML thanks to its easy to understand syntax making it quick to write, free and open-source for simple adoption, vast DS & ML toolset making you spoilt for choice, and large community ready to help. However, there are many cracks which start to show when using Python in production.
summary: Python is touted as the language to learn and use for DS and ML thanks to its easy to understand syntax making it quick to write, free and open-source for simple adoption, vast DS & ML toolset making you spoilt for choice, and large community ready to help. However, there are many cracks which start to show when using Python in production.
images:
- /images/make-sql-great-again.png
image: /images/make-sql-great-again.png
audio: []
series: []
videos: []
tags:
- python
- sql
- data science
- machine learning
date: 2023-02-19 10:00:00 +0000
---

![alt text](/images/make-sql-great-again.png "Make SQL great again!")

Python is often touted as the language to learn and use for Data Science (DS) and Machine learning (ML), thanks to its easy to understand syntax making it quick to write, free and open-source for easy adoption, vast DS & ML toolset (libraries and frameworks) spoiling you for choice, and a large community ready to help. Many businesses mining their data are doing it in Python nowadays, which means that there's a huge demand for Python skills and a large talent pool to tap into. However, while all this sounds like a no-brainer, there are many cracks which start to show when deploying Python in production for DS & ML.

Python may indeed be easy to learn and use, however it is often rarely used in production for DS & ML sucessfully. It is extremely slow when compared to other back-end programming languages, and its lack of type safety can cause many issues in critical flows on production. Many companies follow the approach of rewriting DS models written in Python in a language their tech stack supports, such as Java. This is mostly due to the language's lack of reliability when compared to other back-end languages.

## The Current Situation

![alt text](/images/what-is-this-ds-model.png "What the hell is this?")

Now you probably must be thinking, what's wrong with rewriting such models in another language? Python is great for prototyping as its quick and easy to get started, so why not use a more robust language for porting to production? Let's take a moment to play this scenario out. A Data Scientist is tasked with developing a model to predict a business related KPI. The Data Scientist completes the project and presents it to the business with success. This is where a back-end engineer is tasked with porting this model to deploy on the back-end. If the Data Scientist was proficient in writing good clean code, the engineer should be able to quickly reproduce the work done so far and take over from there.

But this is seldom the case. Data Scientists tend to have stronger mathematical backgrounds, and finding those with good software engineering skills is extremely hard. Many times such DS models are written in interactive notebooks, having many code cells which are no longer relevant, do not work, were run out of order, or are not able to be reproduced since the engineer did not have the exact dependencies used to run the notebook.

However, even if this is not the case and the Data Scientist followed good software engineering practices, the back-end engineer tasked with rewriting the model from one language to another, which in itself is never a simple task due to language differences, is rarely the expert in DS & ML and neither is the Data Scientist in Software Engineering. This tends to increase the risks for communication breakdowns and the end results not reflecting those of the initial DS model.

Python is also the standard for DS & ML thanks to the large vast of open-source libraries and frameworks that have been developed over the years and battle tested by academics. This is hard to find in any other language, where most of the times such tools will either be missing, or their implementation is not pure to the language but simply a binding to the Python tool. This means that the rewrites of such Python models will take a hefty amount of time and will likely introduce bugs which did not exist in the initial Python model.

The issues of performance are not just specific to Python, microservices built to serve such predictions are by design separating data from code which creates a large bottleneck. For training of such DS models, large amounts of data need to be first unloaded from the database, and the same goes for serving predictions.

All of this creates the risk of DS & ML projects ending in failure, as the implementation either takes to look to complete, or the final results do not reflect those of the initial ones.

## The Future

![alt text](/images/society-if-ds-used-sql.png "Society if Data Scientists' used SQL to develop and deploy their models")

So what's a solution to such problems? For many years database vendors have made it possible to extend database functions using programming languages such as Python. This made it easier to go beyond the limits of a query language like SQL with that of a programming language such as Python. However these features always had limitations, such as implementing Python libraries which were not written in pure Python underneath the hood, as most Python libraries are to combat the lack of speed of the language. However, nowadays many modern database vendors are starting to overcome such limitations and are implementing ML algorithms as SQL functions.

PostgresML is an open-source extension developed for the widely popular Postgres database, which has been battle tested in many production environments, providing you with access to various ML algorithms from the most popular libraries such as Scikit Learn, XGBoost, and LightGBM, but also pre-trained deep learning models from Hugging Face, all without needing to write any code. Since the ML functions needed are now available within the database, there is also no need to un/load large amounts of data from the database, keeping performance and reliability high. It is far more efficient to move your code to where your data lives rather than move your data to where your code does. There is also no need to worry about extra security, as the data does not need to leave the database. Data Scientists can now be in full control of their own model deployments, just as they designed them, thanks to model periodic training and versioning with rollback capability.

If Python is great for DS & ML because it's so easy to use and learn, SQL should be an even bigger contender as it is easier to pick up being a query language rather than a programming language. There is also more talent with SQL experience than Python as almost all database vendors support SQL. Why not build your DS model in the same place where you query your data? PostgresML is just one example, other cloud vendors also provide the ability to extend their in-house data stores with ML algorithms, however I used PostgresML as an example as it does not introduce vendor lock-in. Also, since PostgresML is open-source, any ML algorithms which have not yet been implemented in the extension, can easily be be requested or added.

## A Sneak Peak into PostgresML

Since PostgresML only requires SQL, its syntax is fairly easy to use. Just as in ML libraries in Python, we have a train and a predict function to build predictions. Both these functions provide very similar arguments to what's available in their corresponding Python ML libraries.

```sql
 pgml.train(
    project_name TEXT -- used to identify this machine learning project
    , task TEXT DEFAULT NULL -- predict true or false
    , relation_name TEXT DEFAULT NULL -- the data table
    , y_column_name TEXT DEFAULT NULL -- the column to predict
    , algorithm TEXT DEFAULT 'linear' -- the ML algorithm
    , hyperparams JSONB DEFAULT '{}'::JSONB
    , search TEXT DEFAULT NULL
    , search_params JSONB DEFAULT '{}'::JSONB
    , search_args JSONB DEFAULT '{}'::JSONB
    , test_size REAL DEFAULT 0.25 -- the size to reserve for testing
    , test_sampling TEXT DEFAULT 'random' -- whether to take a random sample of a specific order
);

pgml.predict (
    project_name TEXT -- the name used to create the machine learning project
    , features REAL[] -- the columns needed to predict
);
```

Once we have a table prepared for our model, we can use the train function.

```sql
SELECT * FROM pgml.train(
  project_name => 'Fraud Classifier'
  , task => 'classification'
  , relation_name => 'fraud_samples'
  , y_column_name => 'fraudulent'
  , algorithm => 'xgboost'
  , test_size => 0.5
  , test_sampling => 'last'
);

|     project      |      task      |   algorithm   |   deployed    |
|------------------|----------------|---------------|---------------|
| Fraud Classifier | classification | 	 xgboost    | 	   true     |
```

```sql
SELECT
  perishable_percentage -- feature
  , fraudulent AS y_true -- the true classification
  , pgml.predict('Fraud Classifier', ARRAY[perishable_percentage::real]) AS y_pred -- the predicted classification
FROM fraud_samples;

| y_pred  | y_true |
|---------|--------|
|  false  |   0    |
|  true   |   1    |
|  false  |   1    |
|  true   |   1    |
```

Once the model is ready to be deployed, we can use the deploy function along with a strategy on how newer versions of the model should be deployed, along with an algorithm or a list of algorithms to be chosen based on their performance.

```sql
pgml.deploy(
    project_name TEXT -- used to identify machine learning project
    , strategy TEXT DEFAULT 'best_score' -- 'rollback', 'best_score', or 'most_recent'
    , algorithm TEXT DEFAULT NULL -- filter candidates to a particular algorithm, NULL = all qualify
)
```

```sql
-- deploy the "best" model for prediction use
SELECT * FROM pgml.deploy('Handwritten Digits', 'best_score');
```

Still interested? The PostgresML team have launched an [interactive environment](https://postgresml.org/blog/data-is-living-and-relational/) for anyone to launch a test database and give it a try. There are also a couple of sample notebooks which make use of some sample data bundled with PostgresML to show you the ins and outs of the extension.