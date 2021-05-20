---
layout: post
draft: true
title: Data Science <3 Clean Code
author: "Gabriel Gauci Maistre"
description: "There is a common misconception that being a Data Scientist means that you do not need to care about writing good clean code, because you're not a Software Developer. If you're a firm believer of this, please take some time to hear me out. I hope to have at least gotten you to reconsider by the end of this post."
images:
- /images/data-scientists-should-write-clean-code.png
audio: []
series: []
videos: []
tags: ["data science", "clean code", "python"]
date: 2021-05-18 23:00:00 +0000

---

***DISCLAIMER***

***The following are simply my views and in no way reflect those of the whole industry.***

![alt text](/images/data-scientists-should-write-clean-code.png "Audience booing")
*I'm back with another controversial topic!*

There is a common misconception that being a Data Scientist means that you do not need to care about writing good clean code, because you're not a Software Developer. If you're a firm believer of this, please take some time to hear me out. I hope to have at least gotten you to reconsider by the end of this post.

## Software Development princilpes aren't for Software Developers

Software Development principles might have been curated by Software Developers, but they definitely were not meant just for Software Developers. They were meant for anyone writing software, this of course includes Data Scientists. Below are a few which are worth mentioning.

### Linting
Python is not a compiled language, which means there is no way of knowing whether your code will execute successfully unless you run it and the interpreter finds a problem which halts the execution of your code. This means that it's extremely important to use a linter which is a tool that will help finding bugs and style problems in your code. It's important to note that it's not perfect due to Python's dynamic nature, however spurious warnings should be fairly infrequent.

### Documentation
Documentation is not needed to develop software, neither are comments and docstrings. All of which take more time to do. However they will save your time in the long run as your codebase grows larger and more people other than yourself will have to look at your code, maintain it, or even extend it.

Type hinting is also another form of documentation you may add to your code which also has no effect on the execution of your code but is meant to make your code more legible. Introduced in Python 3.6, type hints allow you to annotate your python code with hints, hence the name, as to what types your function arguments, return values, and variables are using.

```python
def func(a: int) -> List[int]:
```

Just my glazing over this function definition, we now know that the function expect an integer variable, and returns a list consisting of integer elements. None of this effects the execution of your code, but it makes it much easier to read Python code since types are not required.

![alt text](/images/i-feel-bad-for-you.png "Audience booing")

You may not care about making your code easier for others to read, but all of the things I mentioned above are supposed to make life easier for you. The larger your codebase grows, the harder it'll be to maintain. Following these principles will make life a little easier. If you need some extra motivation, imagine that the next person to take over your code is a serial murderer who knows where you live, that should do the trick.

## Consistency
Blank lines and white spaces help make code more readable. Fixed line lengths ensure that your code is legible on all types of screens. However when they're coupled with inconsistency they make confuse others reading your code, or even yourself. Python has many style guides, I suggest you find one that suits your needs and stick to it whenever you're writing code.

## Naming
Whether you're developing your own library or importing someone else's, it's essential to use conventional and meaningful names when importing a library. This not only helps to stay consistent with the library's conventions but also to make your code more clear and concise. Library names can also collide if you're not careful so always be weary of what you're importing.

## Dumping your code on a Machine Learning Engineer won't work

![alt text](/images/dump-truck.png "Audience booing")

If Data Scientists are the head chefs in a restaurant forming new recipes, Machine Learning Engineers (MLEs) are the cooks attempting to recreate the particular dish using the recipe provided to them. If the cooks are to successfully recreate the dish, they're going to need a well detailed recipe which is easy to read and understand.

MLEs are no different to these cooks, if they are to deploy to production a Machine Learning model which a Data Science built, they must be able to understand the code and run it successfully, easily recreate the data that was used, install all the dependencies without running into any issues, and recreate the same results of the model.

![alt text](/images/how-to-run-this-code.png "Audience booing")

This is no easy task, imagine trying to understand the work that someone else did for months. Now imagine that work did not consist of clean commented code, which is documented thoroughly, virtual environments to execute the code, and the SQL queries to retrieve recreate the data that was used. There's a far greater chance of the results not being recreated as the Data Scientist had in mind, causing problems with the model running in production down the line.

## You shouldn't tie your development to a notebook

![alt text](/images/i-want-you-notebook.png "Audience booing")

The topic of notebooks is so vast I could probably have a whole post dedicated to it, *notes this down for later.* But to keeps things short, although notebooks present a fantastic way of prototyping your code, they lack the features you would normally find in an Integrated Development Environment (IDE).

Notebooks don't come with linting out of the box, which makes it hard to identify and correct subtle programming errors or unconventional coding practices that can lead to errors. A linter can tell you that you forgot to pass a variable in your function's argument, or that there's unused variables/functions in your code. All of which can make it even more confusing to understand the code when reading it.

## A better way to use notebooks

Notebooks are great for prototyping but they don't help in following Software Development principles which hopefully by now I have convinced you that you should use them. Wouldn't it be great if you could have your cake and also eat it? Well in this case it's possible. Here's my approach.

Everything I write goes into a function which gets packaged into a library. I develop this code in an IDE which gives me all the benefits of Software Development principles. As I'm doing so, I import my library in a notebook and prototype the code as I'm writing it. Jupyter notebooks also make this easy by allowing me to use magic commands such as `%autoreload` which allows me to automatically reload libraries as I update them within my environment.

```python
[1]: %load_ext autoreload
%autoreload 2 # tells jupyter to autoreload libraries as they're updated in our environment

[2]: from my_library import func # making our function accessible

[3]: l = func(a=5) # returns a list
```

![alt text](/images/data-science-two-buttons.png "Audience booing")
*Do things the right way or just dump the notebook as code[0]*

---

[0] [nbconvert](https://nbconvert.readthedocs.io/en/latest/) is a tool which lets you convert a notebook into executable code, as brilliant as that can sound, the tool doesn't check for any parts of your code which are not being used or might cause problems. So think of it as a dump from one format to another.