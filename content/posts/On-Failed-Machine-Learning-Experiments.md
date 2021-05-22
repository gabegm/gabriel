---
layout: post
draft: false
unlisted: true
title: On Failed Machine Learning Experiments
author: Gabriel Gauci Maistre
description: The "science" in Data Science is supposed to refer to the fact that doing Data Science involves conducting experiments. In any other field failed experiments are accepted, you wouldn't want a drug company to push out a new drug which failed internally, so why is it frowend upon in Data Science? There is the sense in industry that a failed experiment equates to failure, thus Data Scientists are icentivised to not conduct experiments which end up in failure. This results in either Data Scientists not advertising experiments as failures and instead covering them up, or not attempting novel experiments in case they do fail. This isn't to say that all Data Science experiments should fail, if that is the case then there is something fundamentally wrong with the type of experiments you are pursuing.
images:
- /images/i-have-no-idea-what-im-doing.jpg
audio: []
series: []
videos: []
tags:
- data science
- machine learning
- failed experiments
date: 2021-05-21 23:00:00 +0000
---

***DISCLAIMER***

***The following are simply my views and in no way reflect those of the whole industry.***

![alt text](/images/i-have-no-idea-what-im-doing.jpg "Logo Title Text 1")

The "science" in Data Science is supposed to refer to the fact that doing Data Science involves conducting experiments. In any other field failed experiments are accepted, you wouldn't want a drug company to push out a new drug which failed internally, so why is it frowend upon in Data Science? There is the sense in industry that a failed experiment equates to failure, thus Data Scientists are icentivised to not conduct experiments which end up in failure. This results in either Data Scientists not advertising experiments as failures and instead covering them up, or not attempting novel experiments in case they do fail. This isn't to say that all Data Science experiments should fail, if that is the case then there is something fundamentally wrong with the type of experiments you are pursuing.

Before we get into failed Machine Learning experiments and how they occur, we first need to cover how such experiments are cenceptualised in the first place. Normally in a data-driven company, either a Product Owner (PO) or a member of the board comes up with an application for Machine Learning within the company. This idea could have either come from having witnessed others applying Machine Learning to the same problem within their own company, or a novel idea which they came up with to try. Maybe one of the investors gives the board an objective to implement Artificial Intelligence (AI) to some part of the product and it's not the board's job to make that happen. The PO's job is to do some research and find out how others were able to apply this, if possible, and approach a Data Scientist to attempt the same at the company. The PO secures a big budget from the board to deliver this experiment into production.

The job of the Data Scientist is to now do more in-depth research into how Machine Learning was applied to the same problem at other companies or industries and form an understanding on how it could be applied at their company. Once the Data Scientist has achieved a thorough understand of the approach, the next step would be to attempt to recreate the experiment using the code and data from the original experiment, assuming this has been shared publically. If not, the Data Scientist must move on to formulate an experiment to try using the data of the company. Thorough analysis of the company's data would need to be done to look for any trends which might suggest such an Machine Learning application would be possible to attempt. At this point the Data Scientist would already have a clear understanding on whether this experiment will turn out successful or not. This is where the road for the Data Scientist now forks.

If the Data Scientist works for a company that is open to failed experiments, they will come forward and openly share the full results of the analysis thus far and express their concerns and why they think this experiment will not pan out. Depending on the receiving audience, some technical discussions might take place and this might give the Data Scientist some ideas to go back to the drawing board and try again. If the experiment cannot be replicated using the company's data, either because the data is not good enough, is not available to them, or does not follow the same trends, then that's another lesson learnt and the Data Scientist moves onto the next potential experiment.

However, if the Data Scientist works for a company that does not accept failed experiments which the Data Scientist is well aware of, they will push forward and try anything that sticks in order to not show up empty handed. The Data Scientist will present to their audience the results of the analysis which they are expecting to see and thus the experiment will be green lit to move forward.

At this point the Data Scientist knows that they will not be able reproduce the results from the experiment using the company data but will have to keep pushing forward and try anything that will work.

## Frankenstein Machine Learning
![alt text](/images/its-alive.png "Logo Title Text 1")

This is where things get ugly. After weeks of hacking away, the Data Scientist find some black box model that seems to perform what everyone wants. However, the Data Scientist is not able to explain what the model is doing, neither is anyone going to ask because no one wants to see this experiment fail. The results are presented to the PO or the board and this is when things spiral out of control and the results are publicised in some internal blog about how Artificial Intelligence was applied to a company problem, or some marketing post on LinkedIn.

After a while the Machine Learning model gets deployed to production and suddenly does not perform well because the model was overfitted to the train data and is now struggling with all of this out-of-sample data. At this rate either of two things happen. Either the Data Scientist comes under fire for delivering something that does not work, or no one bothers to raise any concerns because again no one wants to call this a failed project.

## Data Scientists are too scared to try novel experiments in case they fail

Innovation can't take place if it's hindered by the fear of failure. If Machine Learning applications are to progress within the company Data Scientists must be free to try out new things without the fear of failure hanging over their head. Let's take an e-commerce business as an example. Some executive comes up with the idea that it is possible to use Machine Learning to recommend clothes sizes to customers. This experiment gets green lit and the Data Scientist starts their research. Maybe they find out that there is no way to recommend clothes sizes to a customers because customers tend to not choose the same size for each purpose. Maybe it's because the customer buys various types of clothes, or maybe it's because different clothes manufacturers have varying sizes. One thing that the Data Scientist did not consider is that maybe it's also discriminatory to preselect a size for a customer. Afterall noone likes to be reminded to wear 5XL.

The Data Scientist knows that the business is expecting results so they push forward and come up with a model that "performs well" using in-sample data. The Data Scientist is happy that they were able to produce something management will like, management are happy because they can say they applied AI to their e-commerce product. Fast forward a couple of months and this feature is eventually rolled back because too many customers complained that they were either recommended the incorrect size or they didn't like the choice being made fo them. The feature provided no improvement to the customer and all of this work could have been spared for something more effective.

![alt text](/images/data-scientist-look-away.png "Logo Title Text 1")

If management were open to a failed experiment from the start, the Data Scientist would have gone back to them with their results and they would have concluded that it is not possible to apply Machine Learning to this problem at the time and they might need to revisit this at a later stage. The board can now look for the next problem to try and solve with Machine Learning without wasting months of worthless development, potentially with a successful application this time.

## Progression should not be tied to successful experiments

![alt text](/images/denied-pay-rise.png "Logo Title Text 1")

If Data Scientists are to be allowed to fail at their experiments, their compensation and progression cannot be tied to the success of such experiments. "Deliver 4 models to production in 2021" is the best way to incentivse a Data Scientist to do whatever they can to make sure their experiments do not "fail", whatever the cost.

Instead, progression should be tied towards the experiments themselves and the quality of their results, whether those results deem the experiment to be successful or not.

## Data Science cannot be about budgets

![alt text](/images/product-owner.png "Logo Title Text 1")

Far too often is the case that large budgets are tied to Data Science projects. The PO secures a huge budget to use towards applying Machine Learning towards a problem within the company. It's in the PO's best interest that the project succeeds as they do not want to lose that budget which could go towards infrastructure and new hires.