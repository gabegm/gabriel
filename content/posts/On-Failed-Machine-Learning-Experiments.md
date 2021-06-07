---
layout: post
draft: false
unlisted: false
title: On Failed Machine Learning Experiments
author: Gabriel Gauci Maistre
description: The "science" in Data Science is supposed to refer to the fact that doing Data Science involves conducting experiments with data. In any other field failed experiments are accepted, you wouldn't want a drug company to push out a new drug which failed internal tests, so why is it frowned upon in Data Science?
images:
- /images/i-have-no-idea-what-im-doing.jpg
audio: []
series: []
videos: []
tags:
- data science
- machine learning
- failed experiments
date: 2021-06-06 23:00:00 +0000
---

***DISCLAIMER***

***The following are simply my views and in no way reflect those of the whole industry.***

![alt text](/images/i-have-no-idea-what-im-doing.jpg "Logo Title Text 1")

The "science" in Data Science is supposed to refer to the fact that doing Data Science involves conducting experiments with data[[0]](#f0). In any other field failed experiments are accepted, you wouldn't want a drug company to push out a new drug which failed internal tests, so why is it frowned upon in Data Science?

There is this sense in industry that a failed experiment equates to a failed project, thus Data Scientists are incentivised to not conduct experiments which end up in failure. This results in either Data Scientists not advertising experiments as failures and instead adding model complexity to cover up the fact that the model was just overfit on in-sample data[[1]](#f1), or not attempting novel experiments in case they do fail. This isn't to say that all Data Science experiments should fail, if that is the case then there is something fundamentally wrong with the type of experiments that are being pursued.

## How Machine Learning experiments are conceptualised

Normally in a data-driven organisation, either a Product Owner (PO)[[2]](#f2) or a member of the board comes up with an application for Machine Learning within the organisation. This idea could have either come from having witnessed others applying Machine Learning to the same problem within their own organisation[[3]](#f3), or a novel idea which they came up with to try[[4]](#f4). Maybe one of the investors gives the board an objective to implement "Artificial Intelligence" (AI) to some part of the product and it's now the board's job to make that happen. The PO's job is to do some research and find out how others were able to apply this to their product, how to integrate such a feature within the PO's product, and approach a Data Scientist to attempt the same at the organisation. The PO secures a budget from the board to deliver this project into production against a specific deadline.

This is often where the first issue occurs, the budget was approved without first awaiting the preliminary results from the Data Scientist to see whether there is a Machine Learning application for such such a problem within the organisation. Another common mistake takes place when the deadline was set without even discussing the work required with the Data Scientist who is ultimately doing the work. This is at a stage where the Data Scientist has not yet conducted any proper analyses of the data and does not know what to expect.

The job of the Data Scientist is to now do a more in-depth research into how Machine Learning was applied to the same problem at other companies or industries and form an understanding on how it could be applied at their organisation. Once the Data Scientist has achieved a thorough understanding of the approach, the next step would be to attempt to recreate the experiment using the code and data from the original experiment, assuming this has been shared publicly. If not, the Data Scientist must move on to formulate an experiment using the data belonging to the organisation. Thorough analysis of the organisation's data would need to be done to look for any trends which might suggest such a Machine Learning model would be applicable. At this point the Data Scientist would already have a clear understanding on whether this experiment will turn out successful or not. This is where the road for the Data Scientist now forks.

If the Data Scientist works for an organisation that is open to failed experiments, they will come forward and openly share the full results of the analysis thus far and express their concerns and why they think this experiment will not pan out. Depending on the receiving audience, some technical discussions might take place and this might give the Data Scientist some ideas to go back to the drawing board and try again. If the experiment cannot be replicated using the organisation's data, either because the data is not good enough, is not available to them, does not follow the same trends, or the original experiment was flawed, then that's another lesson learnt and the Data Scientist moves onto the next potential experiment.

However, if the Data Scientist works for an organisation that does not accept failed experiments which the Data Scientist is well aware of, they will push forward and try anything that sticks in order to not show up empty handed. The Data Scientist will present to their audience the results of the analysis which they are expecting to see and thus the project will be green lit to move forward.

At this point the Data Scientist knows that they will not be able reproduce the results from the experiment using the organisation's data but will have to keep pushing forward and try anything that will work.

## Frankenstein Machine Learning

![alt text](/images/its-alive.png "Logo Title Text 1")

This is where things get ugly. After weeks of hacking away, the Data Scientist finds some black box model that seems to perform what everyone expects. However, the Data Scientist is not able to explain what the model is doing, neither is anyone going to ask because no one wants to see this project fail. The results are presented to the PO or the board and this is when things spiral out of control and the results are publicised in some internal blog about how Artificial Intelligence was applied to an organisation problem, or some marketing post on LinkedIn.

After a while the Machine Learning model gets deployed to production and suddenly does not perform well because the model was overfit to the training data and is now struggling with all of this out-of-sample data. At this rate either of two things happen. Either the Data Scientist comes under fire for delivering something that does not work, or no one bothers to raise any concerns because again no one wants to label this a failed project.

## Data Scientists are too scared to try novel experiments in case they fail

Data Science innovation can't grow within an organisation if it's hindered by the fear of failure. If Machine Learning applications are to advance within the organisation, Data Scientists must be free to try out new things without the fear of failure hanging over their head. Let's take an e-commerce business as an example. Some executive comes up with the idea that it is possible to use Machine Learning to recommend clothes sizes to customers. This experiment gets green lit and the Data Scientist starts their research. Maybe they find out that there is no way to recommend clothes sizes to a customers because customers tend to not choose the same size for each type of clothing. Maybe it's because the customer often buys various types of clothes and thus no trend can be derived, or maybe it's because different clothes manufacturers have varying sizes for the same types of clothing. One thing that the Data Scientist did not consider is that maybe it's also discriminatory to preselect a size for a customer, something which the PO should have flagged before this experiment ever saw the light of day. After all no one likes to be reminded to wear 5XL.

The Data Scientist knows that the business is expecting results, so they push forward and come up with a model that "performs well" using in-sample data. The Data Scientist is happy that they were able to produce something management will like, management are happy because they can say they applied "AI" to their e-commerce product. Fast forward a couple of months and this feature is eventually rolled back because too many customers complained that they were either recommended the incorrect size or they didn't like the choice being made for them. The feature provided no improvement to the customer and all of this work could have been spared for something more effective.

![alt text](/images/data-scientist-look-away.png "Logo Title Text 1")

If management were open to a failed experiment from the start, the Data Scientist would have gone back to them with their results and they would have concluded that it is not possible or valuable to apply Machine Learning to this problem at the time and they might need to revisit this at a later stage or rule it out completely. The board can now look for the next problem to try and solve with Machine Learning without wasting months of worthless development, potentially with a successful application this time.

## Progression should not be tied to successful experiments

![alt text](/images/denied-pay-rise.png "Logo Title Text 1")

If Data Scientists are to be allowed to fail at their experiments, their compensation and progression cannot be tied to the success of such experiments. "Deliver 4 models to production in 2021" is the best way to incentivise a Data Scientist to do whatever they can to make sure their experiments do not "fail", whatever the cost.

Instead, progression should be tied towards the experiments themselves and the quality of their results, whether those results deem the experiment to be successful or not. The essential thing here is that the organisation learns from its data because the Data Scientist is able to answer the questions which they may have, by conducting the rigorous experiments required, in which the management accepts the results, whether or not they follow their gut feeling.

## Data Science cannot be about budgets

![alt text](/images/product-owner.png "Logo Title Text 1")

Far too often is the case that large budgets are tied to Data Science projects. The PO secures a huge budget to use towards applying Machine Learning towards a problem within the organisation. It's in the PO's best interest that the project succeeds as they do not wish to lose their budget which could go towards improved infrastructure and new hires which would be both desperately needed.

Instead, budgets should only be assigned once the results from the Data Science experiments are completed and have gone through extensive review by peers in order to have a stronger foundation for presenting the results to the board and ultimately apply a Machine Learning model towards a specific part of the organisation's product to increase its value.

## Conclusion

Data Science projects are different to Software Engineering projects. Machine Learning applications heavily depend on the data available and the product to which it would be applied and the customers interacting with it. Data Science relies heavily on experiments and businesses should be open towards results from experiments which may not be in line with what they originally thought to be true.

Successful experiments are not those which prove a hypothesis to be true, but one which is carried out fairly to prove a particular hypothesis to be true or not. Ultimately many lessons are learnt from such experiments which is why it's always a good idea to keep an open mind and to always question things but to never believe something blindly.

I tried my best to keep my examples as vague as possible so that they can be applied to any organisation working with data, no matter the extent of Machine Learning experiments being carried out within the organisation. This should hopefully aid in the self reflection required to see that Machine Learning experiments are done right, rather than fuelling a debate of good v.s. bad Machine Learning experiments. If applied correctly, Machine Learning can provide vast amounts of benefits to an organisation's product(s) and its customers, which is why it's always a good exercise to have these kinds of discussions of self-reflection.

---

* <a name="f0">[0]</a> Testing whether it's possible to apply Machine Learning to recommend a clothing brand to a customer using the data available to the Data Scientist.
* <a name="f1">[1]</a> In-sample data refers to the data available used to train and test a Machine Learning model to predict on data not yet observed.
* <a name="f2">[2]</a> The Product Owner, while responsible for maximizing the value of the product and the work of the Development Team, is the sole person responsible for managing the Product Backlog.
* <a name="f3">[3]</a> Commonly witnessed through conferences, webinars, and articles.
* <a name="f4">[4]</a> "Let's recommend items on the food menu for our customers based on their age!"