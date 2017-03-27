Last week we worked through the process of defining a database schema. This week we're going to work through two different approaches to creating and interacting with a database. We'll look at a raw Structured Query Language (SQL) approach; we'll work through the same example using an Object-Relational Mapper (ORM).


# Getting Setup


## Installing Postgres

First things first: installing a database. A database is its own kind of program; it needs to be run and managed separately from the code you write. Both the SQL and ORM approaches require a database, run in the same way. For our work here, we'll be using Postgres.

You have two choices: [Postgres.app](http://postgresapp.com/), or homebrew. Both do pretty much the same thing: install a Postgres database and the `psql` CLI on your computer. Heroku's Postgres.app makes running your database slightly less arcane; the flip side is that installing and running your database via homebrew is more "standard" &#x2013; so these notes will assume that's what you're up to.

My friends, let us begin:

```sh
brew install postgresql
```

If all goes well, your output should end with something like:

    To have launchd start postgresql at login:
      ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
    Then to load postgresql now:
      launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
    Or, if you don't want/need launchctl, you can just run:
      postgres -D /usr/local/var/postgres
    ==> Summary
    /usr/local/Cellar/postgresql/9.5.1: 3,118 files, 35M

I find this output a little arcane, myself, so let's do a quick breakdown of the three things in there:

1.  You can tell your Mac to turn Postgres on every time the computer turns on. To do this, run the first command.
2.  If you've decided to wire things up with command 1, Postgres will now start when your computer boots. However, it will not be running *right now*. To make it run right now, *if* you went with command 1, run command 2.
3.  Or, you can choose to run Postgres manually, so it's only on when you need it to be. To run Postgres manually, run the third command.

If performance isn't a concern for your laptop or if you're going to be using Postgres *all the flipping time*, maybe do commands 1 and 2. If performance *is* a concern for your Mac, or if you just don't like unnecessary software cluttering things up, skip 1 and 2 and just use command 3 whenever you need it.<sup><a id="fnr.1" class="footref" href="#fn.1">1</a></sup>


## Making Databases

At this point you've got postgres installed! Rad. So that's a *database*, but it turns out, there are no *databases* in it yet. Vis:

    $ psql
    psql: FATAL:  database "rossdonaldson" does not exist

Postgres is a "database" &#x2013; that is, that's the type of program Postgres is. But it can also contain many "databases" &#x2013; that is, groupings of tables, users, and permissions. What's happening at our command line is that by default, when you call `psql`, Postgres will try to connect you to a database named after your current user.

We can fix this with `createdb`:

    $ createdb rossdonaldson
    $ psql
    psql (9.5.1)
    Type "help" for help.

    rossdonaldson=#

Sweet. Now we need two more databases: one for our SQL lesson, and one for the ORM lesson. Exit `psql` (if you started it) and do two more `createdb` invocations:

```sh
createdb db_lesson_sql
createdb db_lesson_orm
```

Raaaad.


## Talking through our demonstration data

Last week we did a set of information refactoring work and eventually produced schemas we could make databases out of. We'll be coming back to those, but for now, we'll take a vastly simpler approach. We're going to model people, foods, and people's preferences for different foods, like so:


### people

| Column Name | Type                     | Properties                 |
| id          | INTEGER                  | PRIMARY KEY SERIAL         |
| first\_name | VARCHAR(20)              | NOT NULL                   |
| last\_name  | VARCHAR(30)              | NOT NULL                   |
| created\_on | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT\_TIMESTAMP |


### foods

| Column Name | Type                     | Properties                 |
| id          | INTEGER                  | PRIMARY KEY SERIAL         |
| name        | VARCHAR(50)              | NOT NULL                   |
| kind        | VARCHAR(10)              | NULL                       |
| description | TEXT                     | NULL                       |
| updated\_on | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT\_TIMESTAMP |


### preferences

| Column Name | Type                        | Properties                     |
| id          | INTEGER                     | PRIMARY KEY SERIAL             |
| person\_id  | INTEGER                     | NOT NULL REFERENCES people(id) |
| food\_id    | INTEGER                     | NOT NULL REFERENCES foods(id)  |
| attitude    | ENUM('love', 'hate', 'meh') | NOT NULL                       |


## A couple quick notes about `psql`

`psql` is the Postgres command-line tool. Where calling `python` from the command line gets you a REPL (read-eval-print loop), `psql` gets you a full-blown application you can use to administer and interact with Postgres on your computer. You may be thinking, "great, a full-blown application what does that even mean?" Good question!

What I mean is that in `psql`, you can type literal SQL and have it executed, *or* you can use a variety of `psql` specific commands. For instance, we can list our databases like so:

    psql (9.5.1)
    Type "help" for help.

    rossdonaldson=# \l
                                               List of databases
         Name      |     Owner     | Encoding |   Collate   |    Ctype    |        Access privileges
    ---------------+---------------+----------+-------------+-------------+---------------------------------
     db_lesson_orm | rossdonaldson | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
     db_lesson_sql | rossdonaldson | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
     postgres      | rossdonaldson | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
     rossdonaldson | rossdonaldson | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
     template0     | rossdonaldson | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/rossdonaldson               +
                   |               |          |             |             | rossdonaldson=CTc/rossdonaldson
     template1     | rossdonaldson | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/rossdonaldson               +
                   |               |          |             |             | rossdonaldson=CTc/rossdonaldson
    (6 rows)

    rossdonaldson=#

`\l` is no kind of SQL command &#x2013; it's a specific administration command to the `psql` client.

If we want to take action on a given database, we should first connect to that database using `\c`:

    rossdonaldson=# \c rossdonaldson
    You are now connected to database "rossdonaldson" as user "rossdonaldson".
    rossdonaldson=#

There's very little in here right now so I can't show you anything else. But! Postgres will cheerfully tell you how to use it. For help, use `\?`. Here's the first five lines of it (the output is too long to duplicate here):

    rossdonaldson=# \?
    General
      \copyright             show PostgreSQL usage and distribution terms
      \g [FILE] or ;         execute query (and send results to file or |pipe)
      \gset [PREFIX]         execute query and store results in psql variables
      \q                     quit psql
      \watch [SEC]           execute query every SEC seconds


# SQL

Let's get SQLing! Everything we'll be doing from here will be executed by writing it in to the `psql` client. First, a couple of notes:


## "The" SQL

There is "a" SQL, defined by the American National Standards Institute (ANSI). It specifies how a SQL database ought to behave. And: nobody I know of follows the ANSI standard precisely. Instead, every database is in its own "dialect" of SQL. These dialects are very close to one another in major details, but have small differences that can throw you well and truly Off. For instance, in Postgres, to get the current date and time, you'd use \`CURRENT\_DATE\`, which is a constant; in MySQL, you use \`CURDATE()\`, which is a function. Whee? Whee.


## Syntax

SQL is case INsensitive &#x2013; SQL doesn't care one whit which words you capitalize or not. SQL also doesn't care about white space, other than at minimum one whitespace character between words. This means these two queries are totally identical, as far as SQL is concerned:

```sql
-- you could do like this
select foo, bar from place where thing = 'condition';

-- or technically even like this
Select
 foo
 ,                                  bar
 From BAR WHERE
 thing = 'condition'

;
```

I follow a pretty standard convention in my own SQL: tables and their columns are always lower case; SQL reserved words are always in block caps; break statements up on new lines; final semi-colon on its own line. Something like this:

```sql
SELECT foo
       , bar
FROM place
WHERE thing = 'condition'
      AND other_thing = 'different_condition'
;
```

**A-two**: a SQL statement always ends in `;`, and `psql` will let you copy/paste or hit "enter" as many times as you like without executing your code *until you add a ;*.


## Setup


### Creating Tables

We saw a `CREATE TABLE` statement last time. Here's the [API documentation](http://www.postgresql.org/docs/9.5/static/sql-createtable.html) for Postgres' `CREATE TABLE` statement. There are a *lot* of options, so the doc is a little daunting. Let's look at the pretty simple SQL that will make our `people` table:

```sql
CREATE TABLE people (
       id SERIAL PRIMARY KEY,
       first_name VARCHAR(20) NOT NULL,
       last_name VARCHAR(30) NOT NULL,
       created_on TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
```

`SERIAL` is effectively the type of `id`, so Postgres lets us use it on its own. Everything else here is pretty bog-standard (and a lot less daunting than the vast panoply of options Postgres supports). Here's the next two statements:

-   food

    ```sql
    CREATE TABLE food (
           id SERIAL PRIMARY KEY,
           name VARCHAR(50) NOT NULL,
           kind VARCHAR(10) NULL,
           description TEXT NULL,
           updated_on TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    );
    ```

-   preferences

    Note something here: in Postgres, `ENUM` types cannot be declared in place &#x2013; we need a separate `CREATE TYPE` statement:

    ```sql
    CREATE TYPE attitudes AS ENUM ('love', 'hate', 'meh');
    CREATE TABLE preferences (
           id SERIAL PRIMARY KEY,
           person_id INTEGER NOT NULL REFERENCES people(id),
           food_id INTEGER NOT NULL REFERENCES food(id),
           attitude attitudes NOT NULL,
           created_on TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
           updated_on TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    );
    ```


### Loading some test data

We've got three tables! We can add data to them using the SQL `INSERT` statement.

Here are some people:

```sql
INSERT INTO people (first_name, last_name)
VALUES ('Captain', 'Vegetable')
       , ('Samus', 'Aran')
       , ('Bork', 'the Barbarian')
;
```

And some foods:

```sql
INSERT INTO food (name, kind, description)
VALUES ('carrot', 'vegetable', 'how much beta carotene can be in one food IT IS SO MUCH')
       , ('celery', 'vegetable', 'eating crunchy vegetables is good for me')
       , ('quinoia', NULL, 'are we actually sure what this is?')
       , ('roast beef', 'meat', NULL)
       , ('tuna sandwich', 'sandwich', 'made with apples and sourdough bread')
;
```

And some preferences:

```sql
INSERT INTO preferences (person_id, food_id, attitude)
VALUES (1, 1, 'love')
       , (1, 2, 'love')
       , (1, 3, 'meh')
       , (1, 4, 'hate')
       , (2, 1, 'hate')
       , (2, 5, 'love')
       , (3, 4, 'love')
       , (3, 1, 'love')
;
```

Some things to notice about all of this:

-   `VALUES` clauses must all be of identical length, which means we have to pass `NULL` as the description of `roast beef`.
-   We have to specify both `people` and `foods` by `id` to insert them in to the `preferences` table, which can get cumbersome.
-   While we pass `ENUM` values as strings, we'll get an error if we try to pass a string we didn't put in the `ENUM`:

```sql
INSERT INTO preferences (person_id, food_id, attitude)
VALUES (1, 1, 'hoobastank');
```

    ERROR:  invalid input value for enum attitudes: "hoobastank"
    LINE 2: VALUES (1, 1, 'hoobastank');


## Querying


### `SELECT`

Now that we have tables, there's a **lot** we can do. Recall that SQL stands for Structured Query Language &#x2013; so let's write some queries!

A SQL query has this basic form:

```sql
SELECT column_name_one, column_name_two
FROM table_name
(optionally) WHERE condition = value;
```

Each part of a SQL query is called a *clause* &#x2013; for instance, the `SELECT` clause versus the `FROM` clause. The `SELECT` clause specifies what we want to return out of the entities specified in our `FROM` clause, optionally pared down by statements in the `WHERE` clause.

So for instance, what are the names of all the vegetables in the `foods` table?

```sql
SELECT name
FROM food
WHERE kind = 'vegetable';
```

The `WHERE` clause supports an incredible number of operations, including boolean comparison, greater-than/less-than, string comparison, and lots, lots more.

In our `SELECT` clause, we can use an asterisk to get *all* of something from a place:

```sql
SELECT *
FROM people
```

SQL also supports a variety of different kinds of aggregations, by calling a function (to perform the aggregation) and adding a `GROUP BY` clause (to specify how data should be aggregated). For instance, how many of each kind of food do we have?

```sql
SELECT kind, COUNT(*)
FROM food
GROUP BY kind
```


### Joins

-   The Basics of Joins

    So being able to find all the things `WHERE` a certain condition is true, but it lacks a certain pizzazz. After all: we've been working to make a *schema* for something called a "relational database". We keep talking about "primary keys".

    What we're approaching is the notion of a *join*. When we join data, we take two (or more!) tables and declare that they should be, in effect, combined in to a single large table using common columns to line up values. Let's look at the simplest example:

    If I have table one as:

    | col\_1 | col\_2 |
    | 1      | cat    |

    And table two as:

    | col\_1 | col\_2 |
    | 1      | meow   |

    I can say, "in these two tables, `col_1` means the same thing in both tables", and I could make a table like this:

    | table\_1.col\_1 | table\_2.col\_1 | table\_1.col\_2 | table\_2.col\_2 |
    | 1               | 1               | cat             | meow            |

    In this example, we had a one-to-one relationship between table one and table two. Let's make this example exactly three rows more complex; table one is now:

    | col\_1 | col\_2 |
    | 1      | cat    |
    | 2      | dog    |

    | col\_1 | col\_2 |
    | 1      | meow   |
    | 2      | woof   |
    | 3      | quack  |

    Now we need to be more specific about how we do our join. There are three basic kinds of joins:

    -   Inner
    -   Right/Left
    -   Outer

    Let's see each of these with our two tables:

    -   `INNER JOIN`

        In Postgres, by default, a `JOIN` is an `INNER JOIN` unless otherwise specified. An `INNER JOIN` is analogous to a set intersection, and returns only rows that match perfectly from both sides of the join. So, even with our added row in table 2, with an inner join our output is now:

        | table\_1.col\_1 | table\_2.col\_1 | table\_1.col\_2 | table\_2.col\_2 |
        | 1               | 1               | cat             | meow            |
        | 2               | 2               | dog             | woof            |

        `table_2` row 3 is omitted entirely; it does not match exactly.

    -   `LEFT JOIN` and `RIGHT JOIN`

        The `LEFT JOIN` says, "for every thing on the left, I want you to find me every match available on the right." That is, it is a one-to-zero-or-more join. (A `RIGHT JOIN` is fairly uncommon, and is exactly the reverse of a `LEFT JOIN` &#x2013; a zero-or-more-to-one join).

        If we did `table_1 LEFT JOIN table_2`, we'll get exactly the same result as our inner join &#x2013; only rows from the right that exactly match rows on the left will be kept, and now rows from the left will be dropped:

        | table\_1.col\_1 | table\_2.col\_1 | table\_1.col\_2 | table\_2.col\_2 |
        | 1               | 1               | cat             | meow            |
        | 2               | 2               | dog             | woof            |

        On the other hand, if we do `table_2 LEFT JOIN table_1`, we get something different:

        | table\_1.col\_1 | table\_2.col\_1 | table\_1.col\_2 | table\_2.col\_2 |
        | 1               | 1               | cat             | meow            |
        | 2               | 2               | dog             | woof            |
        | NULL            | 3               | NULL            | quack           |

        Because a `LEFT JOIN` preserves every row on the left, we get `NULLs` where there was no match from the right.

    -   `OUTER JOIN`

        An `OUTER JOIN` returns all rows from both sides of the join. In our present example, this will be the same as `table_2 LEFT JOIN table_1`. Outer joins are done very uncommonly.

    -   An Important Thing to Know about `INNER` and `OUTER` joins

        `INNER` and `OUTER` joins both have a multiplicative effect if there is more than one match on either side. Consider two tables like so:

        `table_1`:

        | col\_1 | col\_2 |
        | 1      | foo    |
        | 1      | bar    |
        | 2      | bizz   |
        | 2      | bazz   |

        `table_2`

        | col\_1 | col\_2 |
        | 1      | poot   |
        | 1      | scoot  |

        The `INNER JOIN` result would be:

        | table\_1.col\_1 | table\_2.col\_1 | table\_1.col\_2 | table\_2.col\_2 |
        | 1               | 1               | foo             | poot            |
        | 1               | 1               | foo             | scoot           |
        | 1               | 1               | bar             | poot            |
        | 1               | 1               | bar             | scoot           |

        And the `OUTER JOIN` would give you:

        | table\_1.col\_1 | table\_2.col\_1 | table\_1.col\_2 | table\_2.col\_2 |
        | 1               | 1               | foo             | poot            |
        | 1               | 1               | foo             | scoot           |
        | 1               | 1               | bar             | poot            |
        | 1               | 1               | bar             | scoot           |
        | 2               | NULL            | bizz            | NULL            |
        | 2               | NULL            | bazz            | NULL            |

        This is very usually not at all what you want, especially if you're going to aggregate your results.

-   Joining our example data

    What if we want to know how many foods Captain Vegetable loves? That's all three tables &#x2013; this question cannot be answered without information from every place. Fortuanely, SQL is awesome for this.

    First, let's check out the SQL syntax:

    ```sql
    SELECT table_one_alias.column, table_two_alias.different_column
    FROM table_one AS table_one_alias -- We can alias long table names; this is optional, but typical.
    LEFT JOIN table_two AS table_two_alias
    ON table_one_alias.column = table_two_alias.column
    ```

    ```sql
    SELECT peeps.first_name
           , COUNT(DISTINCT foods.id) AS liked_foods
    FROM people AS peeps
    LEFT JOIN preferences AS prefs ON peeps.id = prefs.person_id
    LEFT JOIN food ON foods.id = prefs.food_id
    WHERE peeps.first_name = 'Captain'
          AND peeps.last_name = 'Vegetable'
          AND prefs.attitude = 'love'
    GROUP BY peeps.first_name
    ;
    ```


### Exercise

Let's write some SQL! Break out your text editor and `psql`. Note that you're going to have to find the PostgreSQL statements to make some of this exercise work.

Figure out how to answer these questions using SQL:

1.  Which food is the most liked?
2.  Find the food that doesn't have a description.
3.  Who likes the food with "beta carotene" in the description?

## Footnotes

<sup><a id="fn.1" class="footnum" href="#fnr.1">1</a></sup> Here's a handy trick to make command 3 a little nicer:

1.  Make a directory under your home directory and add it to your `$PATH`. I use `/Users/gastove/bin`. This gives you an easy, sudo-free place to put commands on your path, where your computer can find them.
2.  Make a file in your handy `bin` directory called `start-postgres`. Make the contents of that file be this:

```sh
#!/usr/bin/env bash
postgres -D /usr/local/var/postgres
```

1.  Run `sudo chmod a+x /where/you/put/the/file/start-postgres`. This makes the file executable.
2.  Now you can run postgres whenevery you like with the `start-postgres` command.
