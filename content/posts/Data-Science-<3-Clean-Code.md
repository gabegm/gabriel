---
layout: post
draft: false
title: Data Science <3 Clean Code
author: Gabriel Gauci Maistre
description: There is a common misconception that being a Data Scientist means that you do not need to care about writing good clean code, because you're not a Software Developer. If you're a firm believer of this, please take some time to hear me out. I hope to have at least gotten you to reconsider by the end of this post.
summary: There is a common misconception that being a Data Scientist means that you do not need to care about writing good clean code, because you're not a Software Developer. If you're a firm believer of this, please take some time to hear me out. I hope to have at least gotten you to reconsider by the end of this post.
images:
- /images/data-scientists-should-write-clean-code.png
image: /images/data-scientists-should-write-clean-code.png
audio: []
series: []
videos: []
tags:
- data science
- clean code
- python
date: 2021-05-20 23:00:00 +0000
---

***DISCLAIMER***

***The following are simply my views and in no way reflect those of the whole industry.***

![alt text](/images/data-scientists-should-write-clean-code.png "Data Scientists should write clean code; change my mind.")
*I'm back with another controversial topic!*

There is a common misconception among people with an academic background that being a Data Scientist means you do not need to care about writing good clean code, because you're not a Software Developer or a Machine Learning Engineer. Data Science is all about running experiments on data and you should not need to spend your precious time worrying about making things look pretty. If you're a firm believer of this, please take some time to hear me out. I hope to have at least gotten you to reconsider by the end of this post.

## Software Development principles aren't for Software Developers

Software Development principles might have been curated by Software Developers to aid in the creation of software, but they definitely were not meant *just* for Software Developers. They were proposed for anyone writing any kind of software, this of course includes Data Scientists. Below are a few which I felt were worth mentioning.

### Linting

Python is not a compiled language, which means there is no way of knowing whether your code will execute successfully unless you attempt to execute it and the interpreter[0] finds a problem which halts the execution of your code. This means that it's extremely important to use a linter which is a tool that will help finding bugs and style problems in your code. It's important to note that it's not perfect due to Python's dynamic nature[1], however false warnings should be fairly infrequent.

In the following example, Pylint[2] will let us know that our script has some issues such as lines being too long, have missing whitespace characterss and unreachable code.

```sh
$ pylint my_script.py
************* Module pylint.checkers.format
W: 50: Too long line (86/80)
W:108: Operator not followed by a space
     print >>sys.stderr, 'Unable to match %r', line
            ^
W:141: Too long line (81/80)
W: 74:searchall: Unreachable code
W:171:FormatChecker.process_tokens: Redefining built-in (type)
W:150:FormatChecker.process_tokens: Too many local variables (20/15)
W:150:FormatChecker.process_tokens: Too many branches (13/12)
```

### Documentation

![alt text](/images/i-feel-bad-for-you.png "Machine Learning Engineers feel bad for Data Scientists but they don't care")

Documentation is not needed to develop software, neither are comments and docstrings. All of which take more time and effort to do. However they will save your time in the long run as your codebase grows larger and more people other than yourself will have to look at your code, maintain it, or even extend it. It goes without saying that it will also help you maintain your own codebase.

The following is an example of how to write docstrings for your Python functions.

```python
"""A one line summary of the module or program, terminated by a period.

Leave one blank line.  The rest of this docstring should contain an
overall description of the module or program.  Optionally, it may also
contain a brief description of exported classes and functions and/or usage
examples.

  Typical usage example:

  foo = ClassFoo()
  bar = foo.FunctionBar()
"""
```
*Google's [Python style guide](https://google.github.io/styleguide/pyguide.html#381-docstrings)*

Type hinting is also another form of documentation you may add to your code which also has no effect on its execution but is meant to make it more legible. Specified in [PEP 484](https://www.python.org/dev/peps/pep-0484/) and introduced in [Python 3.5](https://docs.python.org/3.5/whatsnew/3.5.html), type hints allow you to annotate your Python code with hints, hence the name, as to what types your function arguments, return values, and variables are using.

```python
def fib(n):
    a, b = 0, 1
    while a < n:
        yield a
        a, b = b, a+b
```

Just by looking at this code block, it is hard to tell what types the function is expecting unless we run it. For small codebases this might be okay, but as you can imagine it would be quite counterproductive to have to stay running each and every function when we want to get a better idea of which types are required.

```python
from typing import Iterator

def fib(n: int) -> Iterator[int]:
    a, b = 0, 1
    while a < n:
        yield a
        a, b = b, a+b
```

Thanks to the type hints present in this function definition, we now know that the function expects an `integer` variable, and returns an iterator consisting of `integer` elements. None of this effects the execution of your code, but it makes it much easier to read Python code since types are not required.

Static type checkers will also allow you to check your code for type errors making it easier to find bugs with less debugging. In the following example, mypy[3] will find a bug where we tried to pass a `string` as an argument to the `fib` function which was expecting an `integer` instead. If we were to run this code, this bug would cause the execution to come to a halt.

```sh
$ mypy my_script.py
my_script.py:10: error: Argument "n" to "fib" has incompatible
                        type "str"; expected "int"
```

You may not care about making your code easier for others to read, but all of the things I mentioned above are supposed to make life easier for you. The larger your codebase grows, the harder it'll be to maintain. Following these principles will make life a little easier. If you need some extra motivation, imagine that the next person to end up maintaining your code is a violent psychopath who knows where you live, that should do the trick.

## Consistency

Blank lines and white spaces help make code more readable. Fixed line lengths ensure that your code is legible on all types of screens. However, even the best of intentions can be wasted by an inconsistent use of lines and white spaces, rendering even the most well-written code to be confusing. The antidote to inconsistency is the same as with any other form of writing: the style guide. Python has many style guides, your place of work might actually have one too.

Unfortunately it is fairly common for each team within a company to follow their own style guide which makes it hard to standardise within a company. If your company does not yet have one, I suggest you find one that suits your needs and stick to it whenever you're writing code.[4]

```python
No:
def to_sql(frame, name: str, con, schema: str | None = None, if_exists: str = "fail", index: bool = True, index_label=None, chunksize: int | None = None, dtype: DtypeArg | None = None, method: str | None = None, engine: str = "auto", **engine_kwargs,) -> None

Yes:
def to_sql(
    frame,
    name: str,
    con,
    schema: str | None = None,
    if_exists: str = "fail",
    index: bool = True,
    index_label=None,
    chunksize: int | None = None,
    dtype: DtypeArg | None = None,
    method: str | None = None,
    engine: str = "auto",
    **engine_kwargs,
) -> None
```
*An example of fixed line lengths*

## Naming

Whether you're developing your own library or importing someone else's, it's essential to use conventional and meaningful names. This not only helps to stay consistent with the library's conventions but also to make your code more clear and concise. Library names can also collide if you're not careful so always be weary of what you're importing.

Importing `numpy` as `n` rather than `np` which is the preferred alias and used by the community is not going to help others get up to speed with what you're trying to achieve with your code.

![alt text](/images/variable-naming.png "Giving a variable a well thought out name, no. Naming it 'x', definitely.")

This also goes for naming your variables and functions. A variable named `x` isn't going to help anyone understand what `x` is meant to be storing and used for. You can never know when you'll need to look at your own code again down the line and forget what `x` was meant to be used for.

## Dumping your code on a Machine Learning Engineer won't work

![alt text](/images/dump-truck.png "Data Scientists dumping their code onto Machine Learning Engineers")

If Data Scientists are the head chefs in a restaurant forming new recipes, Machine Learning Engineers are the cooks attempting to recreate the particular dish using the recipe provided to them. If the cooks are to successfully recreate the dish, they're going to need a well detailed recipe which is easy to read and understand.

Machine Learning Engineers are no different to these cooks, if they are to deploy to production a Machine Learning model which a Data Science built, they must be able to understand the code and run it successfully, easily recreate the data that was used, install all the dependencies without running into any issues, and recreate the same results of the model.

![alt text](/images/how-to-run-this-code.png "Machine Learning Engineers asking Data Scientists how to run their code.")

This is no easy task, imagine trying peak into someone else's brain and understand the very thing which they've been working on for months. Now imagine that work did not consist of clean commented code, which is documented thoroughly, uses virtual environments to execute the code, and includes SQL queries to retrieve and recreate the data that was used to train the Machine Learning model. There's a far greater chance of the results not being recreated as the Data Scientist had in mind, causing problems with the model running in production down the line.

## You shouldn't tie your development to a notebook

![alt text](/images/i-want-you-notebook.png "Data Scientists want be with notebooks forever")

The topic of notebooks[5] is so vast I could probably have a whole post dedicated to it, *notes this down for later.* But to keep things short, although notebooks present a fantastic way of prototyping your code, they lack the features you would normally find in an Integrated Development Environment (IDE)[6].

Notebooks don't come with linting out of the box, which makes it hard to identify and correct subtle programming errors or unconventional coding practices that can lead to errors. A linter can tell you that you forgot to pass a variable in your function's argument, or that there's unused variables/functions in your code. All of which can make it even more confusing to understand the notebook code when reading it.

Now you could make the argument that you could always prototype your code in a quick and dirty way and then rewrite it using the proper principles once you know what it is you want from your code. But you're still going to have to go through your code, figure out what you had in mind at the time when you wrote it, and rewrite it again. It would be a lot easier if you followed the correct principles in the first place and had the proper documentation, such as comments and docstrings, to work off from.

## A better way to use notebooks

![alt text](/images/data-science-two-buttons.png "Use proper software development principles v.s. dumping all code in the notebook to a script.")
*Use proper software development principles or just dump the notebook as code[7]*

Notebooks are great for prototyping but they don't help in following Software Development principles, which hopefully by now I have convinced you that you should use them. Wouldn't it be great if you could have your cake and also eat it? Well in this case it's possible. Here's my approach.

Everything I write goes into a function which gets packaged into a library. I develop this code in an IDE which gives me all the benefits of Software Development principles. As I'm doing so, I import my library in a notebook and prototype the code as I'm writing it. Jupyter notebooks also make this easy by allowing me to use magic commands such as `%autoreload` which allows me to automatically reload libraries as I update them within my environment without the need to restart the kernel.

```python
[1]: %load_ext autoreload
%autoreload 2 # tells jupyter to autoreload libraries as they're updated in our environment

[2]: from my_library import fib # makes our function accessible

[3]: [print(i) for i in fib(5)] # executes our function
0
1
1
2
3
```

Whenever I need to change the code behind the function `fib`, all I need to do is simply reinstall it by running `$ pip install .`[8] in my terminal and simply rerunning cell `3` above which will now use the function from my newly updated library.

---

* [0] An interpreter directly executes code without the need to have been previously compiled into a machine language program.
* [1] Python is dynamically typed, meaning the types of variables are only determined at runtime and do not need to be specified beforehand.
* [2] [Pylint](https://pylint.org/) is a source-code, bug and quality checker for the Python programming language.
* [3] [Mypy](http://mypy-lang.org/) is an optional static type checker for Python that aims to combine the benefits of dynamic (or "duck") typing and static typing.
* [4] Google have a public [Python style guide](https://google.github.io/styleguide/pyguide.html) which I highly recommend to check out.
* [5] A Jupyter notebook consists of an interactive web tool known as a computational notebook, which researchers can use to combine software code, computational output, explanatory text, and multimedia resources in a single document.
* [6] An IDE normally consists of at least a source code editor, build automation tools, and a debugger.
* [7] [nbconvert](https://nbconvert.readthedocs.io/en/latest/) is a tool which lets you convert a notebook into executable code, as brilliant as that can sound, the tool doesn't check for any parts of your code which are not being used or might cause problems. So think of it as a dump from one format to another.
* [8] `.` refers to the current directory which in this case is the one where our library is located.