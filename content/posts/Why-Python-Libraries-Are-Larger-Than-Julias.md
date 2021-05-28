---
layout: post
draft: true
unlisted: true
title: Why are Python Packages Much Larger Compared to Julia's?
author: Gabriel Gauci Maistre
description: Julia has a number of features which make it favourable for developers to resuse code written by others when developing their own Julia packages. This high degree of modularity found in Julia allows packages to remain fairly small in size compared those found in Python. Let's explore why that may be.
images:
- /images/julia-packages.jpg
audio: []
series: []
videos: []
tags:
- julia
- python
- package development
date: 2021-05-27 23:00:00 +0000
---

![alt text](/images/julia-package.png "Logo Title Text 1")
*A very bad Julia package logo made by yours truly*

Julia has a number of features which make it favourable for developers to resuse code written by others when developing their own Julia packages. This high degree of modularity found in Julia allows packages to remain fairly small in size compared those found in Python. Let's explore why that may be.

## Python Packages

Not all Python packages are overly large in size. In fact all the Python packages I have ever written were all small, both in size and scope, and probably yours were too. But these aren't the packages I would like discuss. The packages I have in mind are the ones used by most Python developers on a daily basis. Packages such as Pandas and Numpy which are fairly large and depended on by most Python developers when developing their packages.

Every Python developer faces the same dilemma as the codebase for package starts to grow. Implement things from scratch or make use of someone else's code? This question is not that easy to answer in Python. Python as language is quite easy to get started with but is quite slow in terms of performance. Many developers must resolve to implementing the heaving parts of their code in C/C++ and writing Python wrappers to be able to do that same thing in Python without losing any speed.

This means that as a Python developer it is not easy to know at first glance whether other developer's packages are using pure Python or C/C++ underneath the hood. On one hand if they're using pure Python their code might be easy to use however at the cost of performance. On the other if their code is using C/C++ underneath the hood then you need to be extra careful that their code will be compatible with yours.

## Julia's high degree of modularity

Because Julia does not share the same performance penalty as Python, Julia packages need not be written in other languages in order to remain performant. This makes it easy for any Julia developer to easily rely on other developer's code knowing in full that their code, also written in Julia, will be as performant as the one they're writing. This in turn makes developers within the Julia community more likely to collaborate between projects as your typical Julia package will be written in Julia.

Julia has built-in multiple dispatch which is central to the language design. This means that the compiler will select which function to use, not just by its name, but also by the types of the arguments which are being passed tp the particular function. This eliminates the need for long `if-then-else` blocks checking for types and executing code specific to the argument types. Multiple dispatch, although not new to Julia,  allows Julia's compiler to deploy the optimisations needed to make the execution of the code more performant, by keeping code execution paths tight and minimal.

All of this makes it extremely easy and advantageous for developers to mix and match code from other packages with their own even though they were never designed to do so in the first place.


- High degree of modularity
- Mix and match even thought there were never designed to do so
- No performance penalty
- Python packages tend to be large because pure python is super slow
- Communities are very collaborative
- DataFrames.jl using CSV.jl
