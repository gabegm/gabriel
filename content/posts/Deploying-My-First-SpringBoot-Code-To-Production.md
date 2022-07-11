---
layout: post
draft: false
unlisted: true
title: They Let Me Deploy Spring Boot Code in Production
author: Gabriel Gauci Maistre
description: I recently got to deploy Java code to a back-end service in production
summary: I recently got to deploy Java code to a back-end service in production
images:
- /images/i-have-no-idea-what-im-doing-2.jpg
image: /images/i-have-no-idea-what-im-doing-2.jpg
audio: []
series: []
videos: []
tags:
- java
- spring
- microservice
date: 2022-07-08 10:00:00 +0000
---

![alt text](/images/i-have-no-idea-what-im-doing-2.jpg "I have no idea what I'm doing")
*SPOILER ALERT: No I did not break production...I think*

Although I have been working as a Data Scientist (henceforth shortened to DS) for the past 5 years, DS was actually never part of my university degree. My introduction to DS came when I decided to base my thesis on automated algorithmic trading with applied machine learning. This in fact was what helped me land a job in DS once I graduated.

The degree itself was very much focused on Software Engineering and Web Development; this meant that I actually never wrote any Python code, Python being a rather unpopular language for web development at the time[0]. Instead I wrote a lot of Java, C#, PHP, and JavaScript. Although I did teach myself Python for my thesis.

Okay. So, why am I telling you all of this? Well I recently got to take off my DS hat and play Software Engineer (henceforth referred to as SWE) for a few days. I have been interested in giving SWE a try for a while now as I've been meaning to improve my engineering skills for the deploying of DS models in the future. It is also my impression that ML (Machine Learning) is slowly moving towards more engineering heavy roles such as MLE (Machine Learning Engineering) or SWE roles specialised in data.

My reasoning was that it would be a good idea for me to learn how to ship some back-end services in production and, lucky for me, I was given the opportunity to work on a ticket for my employer. That's right, I found someone crazy enough to let me ship my crappy code to production.

![alt text](/images/walk-into-mordor.jpg "Walking into Mordor")

These two disciplines (DS vs. SWE) are quite far from each other, both in knowledge and tech stacks. My employer's tech stack is also based on Java ([Spring Boot](https://www.baeldung.com/spring-boot)) rather than Python. This means that I pretty much came into this not knowing anything.

## Why was this scary?

![alt text](/images/impostor.jpg "impostor")

* I have not written any Java code in over 5 years, and never in a professional work environment
* The only Java web development I've ever done were [JSPs](https://en.wikipedia.org/wiki/Jakarta_Server_Pages) and I don't recall being particularly good at it either
* I have never used Spring or Spring Boot, but I have used [ASP.NET](https://docs.microsoft.com/en-us/aspnet/mvc/mvc4)
* I have never developed nor deployed a microservice, but I have developed a few monoliths in C#, PHP, and Python
* I have never used Kubernetes or Kafka, but I have used Docker for shipping containerised Python code
* RPCs and Protocol Buffers are completely new to me, but I have used REST APIs
* I consistently choose to spend 6 hours failing to automate something that takes 6 minutes to do by hand
* Breaking a back end service in production is a lot worse than breaking a DS model

## My task

![alt text](/images/honest-work.jpg "It's not much but it's honest work")

I needed to add a new field to an existing micro service. This meant that the service, which was already listening to a particular event through Kafka, needed to now grab this new field, and persist it should it's value differ from what already exists in the service's database.

The service would also need to republish this new field back to Kafka as part of an existing event, and additionally in an existing RPC endpoint for other services to call directly.

I also needed to update the protobuf files used by Kafka to add the new field for other services to consume.

So, I basically needed to grab something from A, put it in B, and put it back in A. Sounds simple right?

## What went wrong

* My Object Oriented Programming (OOP) principles were way rustier than I first thought
* I needed to get reacquainted with [IntelliJ IDEA](https://www.jetbrains.com/idea/) after over 5 years
* Although I got many of my questions answered, it was not always easy to understand them
* I was overwhelmed with all the things I needed to know
* Documentation could have been improved
* It was hard to find an "easy" ticket for me to work on
* I struggled to juggle between my DS tasks and this particular task
* Setting up a local environment also proved to be hard to do
* I used the incorrect data structure ([strings vs. enums](https://forums.ni.com/t5/LabVIEW/what-is-the-advantages-disadvantages-of-an-enum-vs-strings-for/td-p/2301458))

## What I learnt

![alt text](/images/expert.png "I'm totally an expert now")

* [Java changed a lot since SE8 (2014)](https://advancedweb.hu/new-language-features-since-java-8-to-18/)
  * [There's a lot more version numbers now `(8=>18)`](https://en.wikipedia.org/wiki/Java_version_history)
  * [Huge strides in performance gains have been made](https://advancedweb.hu/a-categorized-list-of-all-java-and-jvm-features-since-jdk-8-to-18/#performance-improvements)
  * [Inferred types at compile time using the `var` keyword](https://advancedweb.hu/new-language-features-since-java-8-to-18/#local-variable-type-inference)
  * [Arrows `->` made it into Java for switch statements](https://advancedweb.hu/new-language-features-since-java-8-to-18/#switch-expressions)
  * [The compiler got much better at detecting my crappy code thanks to `NullPointerExceptions`](https://advancedweb.hu/new-language-features-since-java-8-to-18/#helpful-nullpointerexceptions)
  * [Python style text blocks are finally here!](https://advancedweb.hu/new-language-features-since-java-8-to-18/#text-blocks)
  * [The official website was updated]([java.com](https://www.java.com/))

![alt text](/images/new-javacom.gif "Java.com was updated after an eternity")
*[source](https://old.reddit.com/r/ProgrammerHumor/comments/v0c9ox/after_an_eternity_javacom_has_updated_its_homepage/)*

* Spring exploded in popularity for Java back-end development
* There's now much less boilerplate code needed to be written, but that also makes it a lot harder for a newbie like me to grasp when looking at a new codebase [1]
* Many class dependencies are automatically generated (e.g. [protobuf](https://developers.google.com/protocol-buffers/docs/reference/java-generated)) which is confusing at times for a newbie such as myself
* People are also clueless, just a little less than you
* 3 billion devices still run Java

![alt text](/images/3-billion-devices-run-java.png "3 Billion Devices Still Run Java")

* It's better to grasp Java first and learn Spring Boot and microservices along the way
* You still won't understand much, just take things one step at a time and keep pushing until things start to stick
* It's easier to grab someone's attention in the office
* There's so much infrastructure needed for local development
* Testing is even harder now with having to mimic all the moving parts in a micro service architecture
* Having a someone mentor and encourage you really helps
* I'm ready to work on the next task
* [Annotations, annotations everywhere](https://www.baeldung.com/spring-boot-annotations)


![alt text](/images/mason-annotations.png "The annotations Mason, what do they mean?")

## Getting started

A somewhat ordered list.

* [Java Back End Developer Path](https://www.devoxify.com/posts/the-definitive-guide-to-java-backend-developer-career-path/) (~45 minutes)
  * Read this first if you're thinking about moving into this role which should give you a high level overview of what's expected
* [Introduction to Programming Using Java](https://math.hws.edu/javanotes/) (book) OR [Learn Java 8](https://www.youtube.com/watch?v=grEKMHGYyns) (~10 hours)
  * Choose one based on your preferred learning method, I highly recommend following the video course and using the book to supplement further reading
* [What is Spring Framework? An Unorthodox Guide](https://www.marcobehler.com/guides/spring-framework) (~20 minutes)
  * An in-depth introduction to the core framework behind Spring Boot
* [Java Microservices: A Practical Guide](https://www.marcobehler.com/guides/java-microservices-a-practical-guide) (~50 minutes)
  * An in-depth guide on building micro services in Java
* [Spring Boot Tutorial](https://www.freecodecamp.org/news/spring-boot-tutorial-build-fast-modern-java-app/) (~2 hours)
  * This is a hands-on introduction if you're not afraid of getting your hands dirty
* [Data Structures](https://www.youtube.com/watch?v=RBSGKlAvoiM) (8 hours) OR [Problem Solving](https://neetcode.io/) (150 problems)
  * As you start cover all the basics, you'll probaly want to move towards grasping data structures. I recommend following the video course and using the problem set for practice.

---

* [0] This is of course no longer the case with the rise in adoption of Django in production.
* [1] I'm talking about annotations, of course.