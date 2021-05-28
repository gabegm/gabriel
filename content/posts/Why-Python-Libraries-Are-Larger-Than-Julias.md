---
layout: post
draft: true
unlisted: true
title: Why are Python Packages Much Larger Compared to Julia's?
author: Gabriel Gauci Maistre
description: Julia has a number of features which make it favourable for developers to resuse code written by others when developing their own Julia packages. This high degree of modularity found in Julia allows packages to remain fairly small in size compared those found in Python. Let's explore why.
images:
- /images/julia-packages.jpg
audio: []
series: []
videos: []
tags:
- julia
- python
- package development
date: 2021-05-24 23:00:00 +0000
---

![alt text](/images/julia-package.png "Logo Title Text 1")
*A very bad Julia package logo made by yours truly*

Julia has a number of features which make it favourable for developers to resuse code written by others when developing their own Julia packages. This high degree of modularity found in Julia allows packages to remain fairly small in size compared those found in Python. Let's explore why that may be.

## Python Packages

Most small to medium sized Python packages are mostly written in pure Python. I have personally never had the liberty to contribute code to a large codebase. Most usecases would satisfy the need for a small Python library. However, many large packages are not large because they need to be.

## Julia's high degree of modularity

Because Julia does not share the same performance penalty as Python, Julia packages need not be written in other languages in order to remain performant. This makes it exteremly easy and advantageous for developers to mix and match code from other packages with their own even though they were never designed to do so in the first place. This in turn makes developers within the Julia community more likely to collaborate between projects as your typical Julia package will be written in Julia.

- High degree of modularity
- Mix and match even thought there were never designed to do so
- No performance penalty
- Python packages tend to be large because pure python is super slow
- Communities are very collaborative
- DataFrames.jl using CSV.jl
