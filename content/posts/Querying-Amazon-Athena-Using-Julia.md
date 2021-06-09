---
layout: post
draft: false
unlisted: true
title: Querying Amazon Athena Using Julia
author: Gabriel Gauci Maistre
summary: Julia is a fairly modern scientific programming language that is free, high-level, fast, and bundles a bunch of awesome features that makes Julia working with data great again. Amazon Athena is an interactive query service which allows you to easily analyze your data collecting dust in Amazon S3 storage using your good old friend SQL. Julia is great for working with data, Athena is great for querying data, how can we use both together? Rather than manually export CSV files and use `CSV.jl` to load CSV files in Julia, I'll be showing you how to query the data using Athena directly from Julia, loading the resulting set of data into a DataFrame using `DataFrames.jl` for you to work with.
images:
- /images/julia-loves-aws.png
image: /images/julia-loves-aws.png
audio: []
series: []
videos: []
tags:
- amazon athena
- databases
- julia
date: 2021-06-07 23:00:00 +0000
---


![alt text](/images/julia-loves-aws.png "Logo Title Text 1")

Julia is a fairly modern scientific programming language that is free, high-level, fast, and bundles a bunch of awesome features that makes Julia working with data great again. The language borrows inspiration from languages such as Python, MATLAB and R[[1]](#f1). If you haven't yet read my article on "[10 Reasons Why You Should Learn Julia]({{< ref "/content/posts/10-Reasons-Why-You-Should-Learn-Julia.md" >}})", check it out! Amazon Athena is an interactive query service which allows you to easily analyze your data collecting dust in Amazon S3 storage using your good old friend SQL. Athena is great because it's serverless, meaning there is no infrastructure to manage, and you pay only for the queries that you run.

Sounds awesome right? Julia is great for working with data, Athena is great for querying data, how can we use both together? Rather than manually export CSV files and use `CSV.jl` to load CSV files in Julia, I'll be showing you how to query the data using Athena directly from Julia, loading the resulting set of data into a DataFrame using `DataFrames.jl` for you to work with.

New to Julia? Go ahead and grab the official binaries for your particular Operating System (OS) from the Julia site [here](https://julialang.org/downloads/#current_stable_release). If you're not interested in a detailed write-up but just want to see the intact code solution, check out [this](https://gist.github.com/gabegm/458288fa55437314b7b41b63a53a13a1) GitHub gist.

## ODBC

Open Database Connectivity (ODBC) is a standard Application Programming Interface (API) for accessing Database Management Systems (DBMS). Because of its open standard nature, many databases support it, and many tools use it to connect to such databases. This means that the method of connecting with Amazon Athena shown in this post can actually be used for other databases too with just a few configuration changes that need to be made.

AWS offers an ODBC driver for Athena which you may use to access your data. Make sure to install the corresponding ODBC driver for your OS from the official [user guide](https://docs.aws.amazon.com/athena/latest/ug/connect-with-odbc.html). You may also optionally read the [documentation](https://s3.amazonaws.com/athena-downloads/drivers/ODBC/SimbaAthenaODBC_1.1.9.1001/docs/Simba+Athena+ODBC+Connector+Install+and+Configuration+Guide.pdf) for the ODBC driver should you run into any issues and/or need some extra configurations not covered in this post.

## Configurations

We can use configuration files, or config for short, to configure the parameters and initial settings for our Julia applications. These parameters could range from Machine Learning model parameters to database credentials such as the ones in our example. Config files are widely used across many programming languages and provide a neat way of changing application settings without the need to change any code.

For this example we'll be using `Configs.jl`[[2]](#f2) to load our config file which also supports cascading overrides based on the config location, `ENV` variable mapping, and function calls.

## DataFrames

A DataFrame represents a table of data with rows and columns, just as spreadsheets do. The Julia package `DataFrames.jl` provides an API we can use for working with tabular data in Julia. Similar to Pandas in Python, its design and functionality are quite similar, however thanks to Julia's high degree of modularity, DataFrames in Julia are tightly integrated with a vast range of different packages such as `Plots.jl`, `MLJ.jl`, and many more!

## Athena.jl

Enough chit-chat. Let's start off by creating a new directory to house our code and name it `Athena.jl`. We'll also add a directly to store our database config file called `configs` and another to store our Julia code called `src`. Finally, we'll create two files, one called `Athena.jl` which will be our Julia script, and the other called `default.yml` for our database configurations and secrets.

```sh
~ $ mkdir Athena.jl
~/Athena.jl $ cd Athena.jl
~/Athena.jl $ mkdir src configs
~/Athena.jl $ touch src/Athena.jl
~/Athena.jl $ touch configs/config.yml
```

Go ahead and open the `Athena.jl` directory in your favourite IDE, mine is Visual Studio Code which is what I used. Open the `configs/default.yml` file so that we can add our configurations. You'll need to add your `s3 location`, `uid`, and `pwd`. If your AWS Cloud infrastructure is set up in a different region, you might also need to change the `region` value. Based on the OS, you might also need to change the path to the database driver. If you're running macOS such as myself, you might not need to change anything, just make sure the file exists in that directory.

```yml
database:
  name: "SimbaAthenaODBCConnector"
  path: "/Library/simba/athenaodbc/lib/libathenaodbc_sb64.dylib"
  driver: "SimbaAthenaODBCConnector"
  region: "eu-west-1"
  s3_location: ""
  authentication_type: "IAM Credentials"
  uid: ""
  pwd: ""
```

Open the `src/Athena.jl` Julia script and run the following in your REPL.

```julia
import Pkg
Pkg.activate(".")

Pkg.add(["ODBC", "DataFrames", "Configs"])

using ODBC, DataFrames, Configs
```

The first thing you might ask if you're new to Julia is "what's the difference between `import` and `using`?" Well `import` works the same as in Python, `import MyModule` would bring into scope[[3]](#f3) functions which will remain accessible using `MyModule`, such as `MyModule.x` and `MyModule.y`, kind of like using `import numpy` in Python and then running `numpy.array([])`. However, `using` in Julia is equivalent to running `from numpy import *` in Python, which would bring all of Numpy's functions into scope, allowing you to run `array([])` in Python. Should you wish to only import specific functions into scope in Julia, all you need to do is `import MyModule: x, y` which would now make functions `x` and `y` accessible in scope.

`Pkg` is the package manager bundled with Julia. We can not only use it to install packages but to also create virtual environments[[4]](#f4) to run our code from. By running `Pkg.activate(".")` we are telling Julia's package manager to activate a new virtual environment in the current directly for us to install our Julia dependencies in. This will automatically create two new files, `project.toml` and `Manifest.toml`, the former will list all our direct dependencies while the latter will list the indirect dependencies which our direct dependencies will rely on. These two files will allow any other developer to recreate the same virtual environment as ours which will be neat for reproducing this example.

Next will use the `Pkg.add` function to add a list of Julia packages we'd like to install, and use the `using` command to import them into scope. Now that we've set up our Julia environment with the dependencies we will need to run this example, we can begin loading configurations from our config file using `Configs.jl`'s `getconfig` function. This function returned a `NamedTuple` which is a Julia type that has two parameters: a tuple of symbols giving the field names, and a tuple type giving the field types. This means that we can use the field names from the config file itself to access them directly using the `.` parameter.

```julia
database = getconfig("database")
name = database.name
path = database.path
driver = database.driver
region = database.region
s3_location = database.s3_location
authentication_type = database.authentication_type
uid = database.uid
pwd = database.pwd
sql = "SELECT * FROM table"
```

Before we begin querying Athena, `ODBC.jl` requires that we add the Athena driver we installed earlier by passing it the name and path to the driver. We also need to build the connection string which we will use to connect to Athena.
Julia has native support for string interpolation allowing us to construct strings using any variable(s) which we may need without the need for concatenation[[5]](#f5). The connection string is specific to the database you're using, so if you won't be connecting to Athena you'll have to look up the documentation for the driver you're using to construct the connection string required.

```julia
# locate existing ODBC driver shared libraries or download new, then configure
ODBC.adddriver(name, path)

# build connection string
connection_string = """
Driver=$driver;
AwsRegion=$region;
S3OutputLocation=$s3_location;
AuthenticationType=$authentication_type;
UID=$uid;
PWD=$pwd;
"""
```

Okay, I promise the fun part is coming. Now that we've finished setting up the boring configurations, we can go ahead and establish a connection and query Athena!

```julia
conn = DBInterface.connect(ODBC.Connection, connection_string)


# execute sql statement directly, then materialize results in a DataFrame
df = DBInterface.execute(
    conn,
    sql
) |> DataFrame

297×3 DataFrame
 Row │ dt                       table_name  n_rows
     │ DateTime…?               String?     Int64?
─────┼────────────────────────────────────────────────
   1 │ 2021-05-08T06:46:24.183  Table_A     196040
   2 │ 2021-05-08T06:46:24.183  Table_B     28172242
   3 │ 2021-05-08T06:46:24.183  Table_C     27111764
   4 │ 2021-05-06T06:46:29.916  Table_A     196041
   5 │ 2021-05-06T06:46:29.916  Table_C     27080936
   6 │ 2021-05-23T06:46:26.201  Table_A     196034
  ⋮  │            ⋮                             ⋮
 293 │ 2021-03-03T14:47:56.910  Table_B     27421193
 294 │ 2021-03-03T14:47:56.910  Table_C     26379105
 295 │ 2021-04-27T06:46:34.887  Table_A     196046
 296 │ 2021-04-27T06:46:34.887  Table_B     28016354
 297 │ 2021-04-27T06:46:34.887  Table_C     26960853
                                286 rows omitted
```

Easy right? Julia was also able to parse the types of the columns in our DataFrame without any headaches. You can now run free plotting using `Plots.jl`, train Machine Learning models using `MLJ.jl`, and storing the transformed data back in Athena.

```julia
# load data into database table
ODBC.load(df, conn, "table_nme")
```

## Conclusion

Could you have done all of this in Python? Absolutely, in fact there are many posts like these which you can find on how to do that. However, I think Julia is an interesting language, [is worth learning]({{< ref "/content/posts/10-Reasons-Why-You-Should-Learn-Julia.md" >}}), and can provide many benefits over Python.

However, Julia is still a fairly new language, and although it's steadily rising in popularity[[6]]((#f6))[[7]]((#f7)), still lacks the tooling and community support which a more widely used language such as Python provides. The language indeed has a steeper learning curve for beginners compared to Python, seeing as how the amount of Python StackOverflow questions dwarf Julia's, however I do think the language combats this by making Julia easier to read since most packages are written in pure Julia. Python may be more popular which would explain its immense amount of StackOverflow questions, but that does not automatically make it the best language to use for everything and everyone. Tooling and community support will catch up eventually as popularity continues to grow, and ultimately you need to decide which language fits best your needs.

If you do however find yourself in the situation wanting to use a Python package not available in Julia, `PyCall.jl` is a great package which provides you with the ability to directly call and fully interoperate[[8]](#f8) with Python from the Julia language. It's as simple as:

```julia
import Pkg
Pkg.activate(".")

Pkg.add("PyCall")

using PyCall

# create a variable 'x' of type Float64
x = 1
x = Float64(x)

# use Anaconda to install scipy and it's dependencies
so = pyimport_conda("scipy.optimize", "scipy")

# use scipy's newton function to find a zero of sin(x) given a nearby starting point 1
so.newton(x -> cos(x) - x, 1) # 0.7390851332151607
```

---

* <a name="f1">[1]</a> [QuantEcon](https://cheatsheets.quantecon.org/) has a great table comparing MATLAB, Python, and Julia.
* <a name="f2">[2]</a> [Configs.jl](https://github.com/citkane/Configs) is an open source Julia package maintained by [Michael Jonker](https://github.com/citkane).
* <a name="f3">[3]</a> The scope of a variable is the region of code within which a variable is visible. Variable scoping helps avoid variable naming conflicts.
* <a name="f4">[4]</a> Virtual environments help us ensure our applications and its dependencies remain independent from other applications by avoiding any conflicts in versions which may arise.
* <a name="f5">[5]</a> In Julia, strings would be concatenated by using the `*` operator: `"Hello " * "world"`
* <a name="f6">[6]</a> [The accelerating adoption of Julia](https://lwn.net/Articles/834571/)
* <a name="f7">[7]</a> [Julia Update: Adoption Keeps Climbing; Is It a Python Challenger?](https://www.hpcwire.com/2021/01/13/julia-update-adoption-keeps-climbing-is-it-a-python-challenger/)
* <a name="f8">[8]</a> Julia has excellent interop with not only Python but a vast amount of [other languages](https://github.com/JuliaInterop).