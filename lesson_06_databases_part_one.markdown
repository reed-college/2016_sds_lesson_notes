Okay, this is a topic I love. Databases! Just say it with me. *Databases*. So good. Day-tuh-bace. *Yes*.

We're going to focus particularly on *relational databases*, though I'll mention a few other kinds. We'll do some theory, and then we'll learn some SQL. We'll be working with Postgres as our database of choice.

Why Database?
-------------

Databases give us a lot of tools: the ability to ask very precise questions about a body of data; the ability to aggregate a body of data; guarantees about the correctness of data. We get tools for asserting what shape a certain kind of data should take. We get tools for managing default values, null data, and backups. We get controls for concurrent access, and for access management. It's a pretty sweet deal. (Also, two of the best relational databases – PostgreSQL and MySQL, are open source and free as songs.)

Databases give us a lot to love, but they aren't always the perfect solution to a problem. Here's a set of guidelines:

If you are only 1 person; the data will only ever be accessed by one person at once, manually, use Microsoft Access, Microsoft Excel, Filemaker Pro – something far lighter weight than setting up a DB and an application to access it with.

Use a database if:

-   The number of simultaneous users of a data store is greater than one, or
-   There is a single "user" that is a piece of software, or
-   You could reasonably expect your data to take up gigabytes of storage

Flavors and Styles
------------------

"Databases" is a pretty large topic, and many engineers make long, successful careers out of specializing in database development or administration, or their skill in implementing particular kinds of databases. There are a lot of kinds of databases we wont be spending very much time with, but it's worth knowing something about the field – what's available.

First, let's establish what a database *is*. I think of a database as having, at minimum, two properties:

1.  A database stores discrete pieces of data *on disk*, not (or not *just*) in memory.
2.  A database offers a mechanism for *querying* its contents.

Postgres, which many of you will be using, certainly satisfies both points: data is written do disk, where it's safe; you can retrieve a piece of data from the database pretty easily. LokiJS bills itself as an *in-memory database* – which is to say, no kind of database at all. Loki is a data *store*, which is a perfectly valid and excellent thing to be. But persistence isn't baked in to Loki; it can make no guarantees about the safety of your data. Therefore: not a database.

Beyond those two properties, I find it useful to think of modern databases according to how they organize their data – what kind of *schema* do they use. We wind up with a couple rough categories:

### Relational databases

A relational database stores data in units of rows and columns – each row is an entity, each column is a thing we can know about that entity. One particular grouping of rows and columns is a table. Two tables can be connected (that is, *related*) by mutual columns, allowing the construction of larger and more sophisticated views of the data.

Relational databases often have the property of being *transactional*. A transaction is a way of grouping and thinking about the set of changes you're going to make to a database.

We'll be using and talking about relational databases almost exclusively for the foreseeable future of the SDS.

Common Relational Databases:

-   PostgreSQL
-   MySQL
-   Microsoft SQL Server

### Column Stores

While a relational database stores your data in tables, a column store associates a key with a column. That is: where a relational database stores pieces of data grouped together by some kind of semantic meaning, a column store tries to group all the data together that pertains to a single entity. While you as a user might have information stored in a relational database in a `customers` table and an `addresses` table and a `purchases` table, in a column store, all the data for you would be stored in a single you-column.

Common Column Stores:

-   Amazon RedShift
-   Cassandra
-   Druid
-   HBase

### Key-value Stores

A key-value store is, effectively, a schema-less place to put data. Sometimes called "NoSQL" databases, these systems hang on to some kind of blob of information and hand it back to you when you ask.

This is… not as often a good idea as the makers would have you believe.

Notable key-value stores:

-   Redis
-   MongoDB
-   Couchbase

Let's Refactor some Information
-------------------------------

Let's imagine we're working with the purchase record of a small business. It's been growing lately, and we're going to try and help move the purchase record from the one-computer-at-a-time point-of-sale format it's in to something appropriate for a database. Right now, the purchase record looks like this:

| Name           | Address                                        | Phone Number   | Item               | Price | Kind     |
|----------------|------------------------------------------------|----------------|--------------------|-------|----------|
| Rowan Scott    | 3172 NE Hampstead Rd, New York, New York 12345 | 123-456-7899   | Carpet, very large | 2000  | Shipped  |
| Rowan Scott    | 3172 NE Hampstead Rd, New York, New York 12345 | 123 456-7899   | Tea kettle, brass  | 58    | Shipped  |
| Devon Grantham | 58 Prescott Place, Wichita, Kansas 54321       | (821) 954-2186 | Monkey, Statue of  | 100   | In-store |
| Van Rijn       | 805 SE Belmont, Portland, OR 97214             | 503.554.5108   | Carpet, medium     | 1000  |          |
| Rowan Scott    | 3172 NE Hampstead Rd, New York, New York 12345 | 1234567899     | table              | 250   | Shipped  |
| Devon Grantham | 58 Prescott Place, Wichita, Kansas 54321       | (821) 954-2186 | Monkey, Statue of  | 100   | In-store |

### Uniqueness

So there's a lot going on there – we've got a lot of work to do. The first and second rows – were they the same order? There are no order numbers. Nothing is enforcing a format in the phone number field. Also, the full address is printed every time. Did Devon Grantham buy the same monkey statue twice? Why are there no item numbers?

We sit down and do a long interview with the owner, and eventually, the record looks more like this:

| Name           | Address                                        | Phone Number   | Item               | Item no. | Price | Order No. | Kind     |
|----------------|------------------------------------------------|----------------|--------------------|----------|-------|-----------|----------|
| Rowan Scott    | 3172 NE Hampstead Rd, New York, New York 12345 | 123-456-7899   | Carpet, very large | 7899     | 2000  | 1003      | Shipped  |
| Rowan Scott    | 3172 NE Hampstead Rd, New York, New York 12345 | 123 456-7899   | Tea kettle, brass  | 214      | 58    | 1003      | Shipped  |
| Devon Grantham | 58 Prescott Place, Wichita, Kansas 54321       | (821) 954-2186 | Monkey, Statue of  | 314      | 100   | 1004      | In-store |
| Van Rijn       | 805 SE Belmont, Portland, OR 97214             | 503.554.5108   | Carpet, medium     | 1689     | 1000  | 1005      |          |
| Rowan Scott    | 3172 NE Hampstead Rd, New York, New York 12345 | 1234567899     | table              | 21       | 250   | 1006      | Shipped  |
| Devon Grantham | 58 Prescott Place, Wichita, Kansas 54321       | (821) 954-2186 | Monkey, Statue of  | 315      | 100   | 1004      | In-store |

So that's somewhat reassuring. Devon bought a matched set of monkey statues, and Rowan Scott has actually only made two orders. We still don't know how Van Rijn got their order at all, so that's neat, but we're making some progress. The most important thing we've done is to make every row *unique*. When we started, several of the rows were distinguishable from one another only from typos. Uniqueness of row is a very good database property indeed.

But oye, is there more to do.

### Breaking out a Customer Record

Let's look at our first three columns. Each row in those three columns describes a person – a customer. A lot of information is being repeated. Consider: those three columns make perfect sense on their own:

| Name           | Address                                        | Phone Number   |
|----------------|------------------------------------------------|----------------|
| Rowan Scott    | 3172 NE Hampstead Rd, New York, New York 12345 | 123-456-7899   |
| Rowan Scott    | 3172 NE Hampstead Rd, New York, New York 12345 | 123 456-7899   |
| Devon Grantham | 58 Prescott Place, Wichita, Kansas 54321       | (821) 954-2186 |
| Van Rijn       | 805 SE Belmont, Portland, OR 97214             | 503.554.5108   |
| Rowan Scott    | 4108 Telegraph Ave., Oakland, CA 94625         | 1234567899     |
| Devon Grantham | 58 Prescott Place, Wichita, Kansas 54321       | (821) 954-2186 |

In fact, they actually make *more* sense on their own. Now we can get rid of duplicate rows:

| Name           | Address                                        | Phone Number   |
|----------------|------------------------------------------------|----------------|
| Rowan Scott    | 3172 NE Hampstead Rd, New York, New York 12345 | 123-456-7899   |
| Devon Grantham | 58 Prescott Place, Wichita, Kansas 54321       | (821) 954-2186 |
| Van Rijn       | 805 SE Belmont, Portland, OR 97214             | 503.554.5108   |

Better and better. Now, let's turn back to our original purchase record. How do we connect what we've just made back to the original data? Hang on: we're about to get Relational.

First, let's give each customer a unique ID:

| ID  | Name           | Address                                        | Phone Number   |
|-----|----------------|------------------------------------------------|----------------|
| 1   | Rowan Scott    | 3172 NE Hampstead Rd, New York, New York 12345 | 123-456-7899   |
| 2   | Devon Grantham | 58 Prescott Place, Wichita, Kansas 54321       | (821) 954-2186 |
| 3   | Van Rijn       | 805 SE Belmont, Portland, OR 97214             | 503.554.5108   |

Now, we replace the first three columns in our original purchase record with a single column; so as not to get confused, let's call that column "Customer ID":

| Customer ID | Item               | Item no. | Price | Order No. | Kind     |
|-------------|--------------------|----------|-------|-----------|----------|
| 1           | Carpet, very large | 7899     | 2000  | 1003      | Shipped  |
| 1           | Tea kettle, brass  | 214      | 58    | 1003      | Shipped  |
| 2           | Monkey, Statue of  | 314      | 100   | 1004      | In-store |
| 3           | Carpet, medium     | 1689     | 1000  | 1005      |          |
| 1           | table              | 21       | 250   | 1006      | Shipped  |
| 2           | Monkey, Statue of  | 315      | 100   | 1004      | In-store |

What we've just done is to create an entity, which we'll call Customers. Each row in the Customers entity is unique, and has a column which is known to be totally unique. (We didn't use *name* for this because two people might have the same name, eh?) This known-unique column is our *primary key*. We always know that, when we say "Customer ID 2", we always mean "Devon Grantham".

We then replaced all teh duplicate information in or original purchase record with our Customer IDs. We'll now name our original purchase record entity Purchases. In the context of Purchases, "Customer ID" is a *foreign key*. It's known to be a key, but it belongs to an entity other than the current one.

Back at our customer record, we'll make one more change: let's make a separate column for everything that can sensibly be in its own column.

| ID  | Name           | Street Address       | City     | State    | Zipcode | Phone Number   |
|-----|----------------|----------------------|----------|----------|---------|----------------|
| 1   | Rowan Scott    | 3172 NE Hampstead Rd | New York | New York | 12345   | 123-456-7899   |
| 2   | Devon Grantham | 58 Prescott Place    | Wichita  | Kansas   | 54321   | (821) 954-2186 |
| 3   | Van Rijn       | 805 SE Belmont       | Portland | OR       | 97214   | 503.554.5108   |

There we go. That's pretty nice. There are still little pieces of cruft – inconsistent phone number formats, for instance. But in general, we've made something we can work with. We'll do exactly this, again, with Items:

| Item               | ID   | Price |
|--------------------|------|-------|
| Carpet, very large | 7899 | 2000  |
| Tea kettle, brass  | 214  | 58    |
| Monkey, Statue of  | 314  | 100   |
| Carpet, medium     | 1689 | 1000  |
| table              | 21   | 250   |
| Monkey, Statue of  | 315  | 100   |

We're left with a pretty good start at a Purchases record:

| Customer ID | Item ID | Order No. | Kind     |
|-------------|---------|-----------|----------|
| 1           | 7899    | 1003      | Shipped  |
| 1           | 214     | 1003      | Shipped  |
| 2           | 314     | 1004      | In-store |
| 3           | 1689    | 1005      |          |
| 1           | 21      | 1006      | Shipped  |
| 2           | 315     | 1004      | In-store |

### Refining Purchases

We've made great progress on our refactor of that purchase record! We've made two new entities, Items and Customers, given them primary keys, and assigned those as foreign keys to the new Purchases entity. Next step: Purchases doesn't have a primary key, does it?

But: adding a primary key isn't immediately, semantically obvious. We have an order number, sure, but how do we map a given Purchase, and Order Number, and the items in the order together?

We're dealing with a multiplicity of relationships problem. Purchases has, for example, a one-to-one relationship with Customers – a Purchase can have only one customer, and that customer will have a single row in Customers. Purchases and Orders have a one-to-one relationship – you pay once for one order. But Orders and Items have a many-to-many relationship: one item can be in many orders and one order can contain many items.

What we need is an intermediary – something that Purchases can have a one-to-one or one-to-many relationship with, and that can have a many-to-one relationship with Items. Let's make an Orders entity, renaming Order Number to Order ID:

| Order ID | Item ID |
|----------|---------|
| 1003     | 7899    |
| 1003     | 214     |
| 1004     | 314     |
| 1005     | 1689    |
| 1006     | 21      |
| 1004     | 315     |

Notice that there is no primary key, and yet every row is unique. Each *pair* of data is effectively a key in this Entity.

Now, Purchases can be reduced and have an ID:

| Customer ID | ID  | Order ID | Kind     |
|-------------|-----|----------|----------|
| 1           | 1   | 1003     | Shipped  |
| 2           | 2   | 1004     | In-store |
| 3           | 3   | 1005     |          |
| 1           | 4   | 1006     | Shipped  |

Beautiful.

### So What's Missing?

There are some things this lacks. The first, most obvious thing to me is *time* – nothing has a timestamp. In almost every table in almost every relational database, a row should have a timestamp, either specifying when the row was created or when it was updated. Other than that:

-   The Orders table should probably specify what quantity of each item is being bought at a time. It's date column will indicate when an order was placed.
-   The Purchases entity should probably have a calculated column called "total", representing the sum of item price times quantity for all items in a an order. Also, "kind" should be renamed to something clearer. The date column here will indicate when a purchase went through – when payment was received and the transaction was considered "finished."
-   Items should have number in stock

Now, most of that information was missing from the original data, but let's play the role of the eternal optimist – let's imagine that we take our work back to the person we're working for and they're able to help us build a record that makes sense.

### So what's the result?

Here's what we've made:

#### Purchases

| ID  | Customer ID | Order ID | Purchase Date | Total | Delivery Method |
|-----|-------------|----------|---------------|-------|-----------------|
| 1   | 1           | 1003     | 2015-01-01    | 2058  | Shipped         |
| 2   | 2           | 1004     | 2015-01-02    | 200   | In-store        |
| 3   | 3           | 1005     | 2015-02-02    | 1000  |                 |
| 4   | 1           | 1006     | 2015-01-30    | 250   | Shipped         |

#### Orders

| Order ID | Item ID | Item Quantity | Order Date |
|----------|---------|---------------|------------|
| 1003     | 7899    | 1             | 2014-12-31 |
| 1003     | 214     | 1             | 2014-12-31 |
| 1004     | 314     | 1             | 2015-01-01 |
| 1005     | 1689    | 1             | 2015-01-31 |
| 1006     | 21      | 1             | 2015-01-30 |
| 1004     | 315     | 1             | 2014-12-31 |

#### Items

| Item               | ID   | In Stock | Price | Updated On |
|--------------------|------|----------|-------|------------|
| Carpet, very large | 7899 | 0        | 2000  | 2016-03-22 |
| Tea kettle, brass  | 214  | 0        | 58    | 2016-03-22 |
| Monkey, Statue of  | 314  | 0        | 100   | 2016-03-22 |
| Carpet, medium     | 1689 | 0        | 1000  | 2016-03-22 |
| table              | 21   | 0        | 250   | 2016-03-22 |
| Monkey, Statue of  | 315  | 0        | 100   | 2016-03-22 |

#### Customers

| ID  | Name           | Street Address       | City     | State    | Zipcode | Phone Number   | Updated On |
|-----|----------------|----------------------|----------|----------|---------|----------------|------------|
| 1   | Rowan Scott    | 3172 NE Hampstead Rd | New York | New York | 12345   | 123-456-7899   | 2016-03-22 |
| 2   | Devon Grantham | 58 Prescott Place    | Wichita  | Kansas   | 54321   | (821) 954-2186 | 2016-03-22 |
| 3   | Van Rijn       | 805 SE Belmont       | Portland | OR       | 97214   | 503.554.5108   | 2016-03-22 |

### So, why is this good?

I'd like to spend a moment on this – it's worth thinking about. After all: the set of entities we've made above has fragmented one record in to *four*. What, specifically, do we get out of this?

1.  You have probably guessed this, but what we've made is going to be **much** easier to build a functioning database with than what we started with. We can use what we've developed here to produce a database *schema*.
2.  What we've produced here is dramatically easier to keep up to date and accurate. Consider: we only have **one** place to update if Van Rijn's address changes. Now: that also means that if we update data, historical data is lost – but this model also allows us to fix that, if we'd like. We know how many of a given item we have, and its current price (again, another piece of data we'll want to work with in the future.)
3.  We can now answer more specific questions more easily. "How many customers do we have in Portland" would have been a tedious chore in the old system; it's comparatively easy in the new one.

Our data at this point has a special property: it's in First Normal Form (abbreviated 1NF). Every entity contains no duplicate rows and has a clear way to identify a row as unique.<sup><span id="fnr.1">[1](#fn.1)</span></sup> This matters partly for questions of database usability – imagine how much harder it would be to write code to update a customer's address if you had multiple addresses, or if each address came as a single string unit along with a customer's full name.

The other part of 1NF's value is its role in being able to assert the correctness of the data in a database. The theoretical underpinning of relational databases is a field called [Relational Algebra](https://en.wikipedia.org/wiki/Relational_algebra) by making sure the schema of a database conforms to certain restrictions, like 1NF, let's us use tools like SQL to query our data with confidence that the answer will be correct.

Correct normalization is also an important part of the ACID standard.

### ACID

ACID is a set of standards for data in transactional/relational databases:

-   **A**: Atomicity. A transaction is all-or-nothing; if any part of a transaction fails, the entire transaction fails, and no change is affected in the data. If the transaction succeeds, we know it **all** succeeded.
-   C: Consistency. A transaction will transition a database from one valid state to a new valid state, where "valid" is defined by a certain set of known rules. This is a bounded consistency. The database cannot, for instance, stop you from setting a customer's address to "12345 Butts Butts Butts", but it *can* have a constraint against the address being empty.
-   **I**: Isolation. This property manages the effect of concurrent transactions on the same data, and makes guarantees about the outcome of those transactions. Most typically, the outcome of two concurrent transactions should be identical to the same two transactions being applied in serial, though this can sometimes be configured in the database.
-   D: Durability. Committed transactions are never lost. If the database crashes, looses power, is cut off from the network – every committed transaction is safe.

Defining a database schema
--------------------------

Let's consider our `items` table:

| Item               | ID   | In Stock | Price | Updated On |
|--------------------|------|----------|-------|------------|
| Carpet, very large | 7899 | 0        | 2000  | 2016-03-22 |
| Tea kettle, brass  | 214  | 0        | 58    | 2016-03-22 |
| Monkey, Statue of  | 314  | 0        | 100   | 2016-03-22 |
| Carpet, medium     | 1689 | 0        | 1000  | 2016-03-22 |
| table              | 21   | 0        | 250   | 2016-03-22 |
| Monkey, Statue of  | 315  | 0        | 100   | 2016-03-22 |

We know the name of this entity: `items`. Our next task is to describe the columns in each entity. This means knowing something of the *type* of each column, and also the constraints we want the database to impose. We'll start by transposing the table, and removing everything but the column names:

|------------|
| Item       |
| ID         |
| In Stock   |
| Price      |
| Updated On |

While we're at it, let's tidy up these names to something more idiomatic for a database:

| Column Name       |
|-------------------|
| item\_name        |
| id                |
| number\_in\_stock |
| price             |
| updated\_on       |

Great. Lets think about types.

### Types

We already know something about the types of each thing, so let's notate that:

| Column Name       | Type    |
|-------------------|---------|
| item\_name        | String  |
| id                | Integer |
| number\_in\_stock | Integer |
| price             | Float   |
| updated\_on       | Date    |

Every database has its own types; I'll add the equivalent Postgres types here:

| Column Name       | Type    | PG Type                   |
|-------------------|---------|---------------------------|
| item\_name        | String  | `varchar(100)`            |
| id                | Integer | `integer`                 |
| number\_in\_stock | Integer | `integer`                 |
| price             | Float   | `numeric(10, 2)`          |
| updated\_on       | Date    | `timestamp with timezone` |

`varchar`, a shortening of "character varying", is what it sounds like – a string field of bounded length. `integer` is a 32-bit signed integer, and is Postgres' standard for most whole numbers. `numeric` is a user-specified precision decimal number; here we specify it has ten total digits with two digits of precision. Lastly, `timestamp` – which comprises both date and time; I've chosen to specify timezone, which is optional, but encouraged.

In general, pick the smallest unit that will satisfy your needs. For instance: we choose a bounded `varchar(100)` for our `items`, instead of the unbounded (and thus more expensive to store) `text`. It's important to understand what your needs *are*, so you can avoid making an unnecessary crusade of optimization you don't need. For instance `integer` takes 4 bytes of storage, while `smallint` only takes two. So, does it matter that we picked `integer` for our `items` schema? Remember, our motivating hypothetical is a store that's *just* grown big enough to need a database. It's unlikely such a store would have *so many* items in stock that use of an `integer` would make a different. On the other hand, if you were to ever design a database schema for a business doing lots and *lots* of retail on the internet, you'd want to think very carefully about the storage needs of whatever table stores purchase transactions – that table might get huge, fast.

Can you change schemas later? Why yes! How difficult this is to do is a function of a lot of factors that are hard to predict. How difficult is it to take "down time" – shut down your service while you modify the database? How big is your data set? Are you well provisioned – that is, you have plenty of extra resources around – or under-provisioned? But: schemas are not set in stone. You don't have to get them right the first time *or else*.

### Properties and Constraints

Relational databases give us a rich language in which to describe expectations about our data. Some of this relates to what we've been talking about – which columns are keys? Other times, we describe constraints around our data. Can a given datum be missing? What default values can be used?

To give us very slightly more to talk about, I'm going to first make two changes to our nascent schema. First: I'm going to change `id` to `inventory_number`, and add `id` back in as an integer column the database will use to guarantee uniqueness. Second, I'm going to add an `item_description` field. Like so:

| Column Name       | Type    | PG Type                   |
|-------------------|---------|---------------------------|
| item\_name        | String  | `varchar(100)`            |
| inventory\_number | Integer | `integer`                 |
| id                | Integer | `integer`                 |
| number\_in\_stock | Integer | `integer`                 |
| price             | Float   | `numeric(10, 2)`          |
| updated\_on       | Date    | `timestamp with timezone` |
| item\_description | String  | `text`                    |

Given this, let's start with a prose description of this data:

> Ever item is required to have a name and inventory number – there's no sensible default value for either. The inventory number should be unique, but the item name doesn't have to be. The id of an item should be the next higher id after the last id added. If no number of units in stock is provided, default to zero; do not let this be negative. If no price is specified, default to zero dollars and zero cents; do not allow this to be negative. Item description can be omitted entirely. Updated on should always be the timestamp of the last time this row was modified. Because we're sure id will always be unique, it will be our primary key.

Now, in Postgres terms:

| Column Name       | Type    | PG Type                   | Properties                              |
|-------------------|---------|---------------------------|-----------------------------------------|
| item\_name        | String  | `varchar(100)`            | `NOT NULL`                              |
| inventory\_number | Integer | `integer`                 | `NOT NULL UNIQUE`                       |
| id                | Integer | `integer`                 | `PRIMARY KEY SERIAL`                    |
| number\_in\_stock | Integer | `integer`                 | `DEFAULT 0 CHECK (number_in_stock > 0)` |
| price             | Float   | `numeric(10, 2)`          | `DEFAULT 0.00 CHECK (price > 0)`        |
| updated\_on       | Date    | `timestamp with timezone` | `DEFAULT CURRENT_TIMESTAMP`             |
| item\_description | String  | `text`                    |                                         |

Et voila. It's a schema for a single database table! This could be converted in to a `CREATE TABLE` statement with very little work:

``` src
CREATE TABLE items (
       item_name varchar(100) NOT NULL,
       inventory_number integer NOT NULL UNIQUE,
       id integer PRIMARY KEY SERIAL,
       number_in_stock integer DEFAULT 0 CHECK (number_in_stock > 0),
       price numeric(10,2) DEFAULT 0.00 CHECK (price > 0),
       updated_on timestamp with timezone DEFAULT CURRENT_TIMESTAMP,
       item_description text
);
```

### In Conclusion

At this point, we're pretty much ready to make a database! Which we will do! Next week.

I leave you with the completed schemas, for your reference:

#### customers

| Column Name     | PG Type                   | Properties                                |
|-----------------|---------------------------|-------------------------------------------|
| id              | `integer`                 | `PRIMARY KEY SERIAL`                      |
| name            | `varchar(100)`            | `NOT NULL`                                |
| street\_address | `varchar(100)`            | `NULL CHECK (zipcode IS NOT NULL)`        |
| city            | `varchar(100)`            | `NULL CHECK (street_address IS NOT NULL)` |
| state           | `varchar(2)`              | `NULL CHECK (city IS NOT NULL)`           |
| zipcode         | `numeric(5)`              | `NULL CHECK (state IS NOT NULL)`          |
| phone\_number   | `numeric(10)`             | `NOT NULL`                                |
| updated\_on     | `timestamp with timezone` | `DEFAULT CURRENT_TIMESTAMP`               |

This set of checks dictates that if one of `street_address`, `city`, `state`, `zipcode` are set, the other three must be set.

#### items

| Column Name       | Type    | PG Type                   | Properties                              |
|-------------------|---------|---------------------------|-----------------------------------------|
| item\_name        | String  | `varchar(100)`            | `NOT NULL`                              |
| inventory\_number | Integer | `integer`                 | `NOT NULL UNIQUE`                       |
| id                | Integer | `integer`                 | `PRIMARY KEY SERIAL`                    |
| number\_in\_stock | Integer | `integer`                 | `DEFAULT 0 CHECK (number_in_stock > 0)` |
| price             | Float   | `numeric(10, 2)`          | `DEFAULT 0.00 CHECK (price > 0)`        |
| updated\_on       | Date    | `timestamp with timezone` | `DEFAULT CURRENT_TIMESTAMP`             |
| item\_description | String  | `text`                    | `NULL`                                  |

#### purchases

| Column Name      | PG Type                       | Properties                  |
|------------------|-------------------------------|-----------------------------|
| id               | `integer`                     | `PRIMARY KEY SERIAL`        |
| customer\_id     | `integer`                     | `REFERENCES customers (id)` |
| order\_id        | `integer`                     | `REFERENCES orders (id)`    |
| purchase\_date   | `timestamp with timezone`     | `NOT NULL`                  |
| updated\_on      | `timestamp with timezone`     | `DEFAULT CURRENT_TIMESTAMP` |
| total            | `numeric(10,2)`               | `NOT NULL`                  |
| delivery\_method | `enum('in-store', 'shipped')` | `NULL`                      |

#### orders

| Column Name    | PG Type                   | Properties                  |
|----------------|---------------------------|-----------------------------|
| order\_id      | `integer`                 | `REFERENCES orders (id)`    |
| item\_id       | `integer`                 | `REFERENCES items (id)`     |
| item\_quantity | `integer`                 | `NOT NULL`                  |
| ordered\_on    | `timestamp with timezone` | `DEFAULT CURRENT_TIMESTAMP` |

Footnotes:
----------

<sup><span id="fn.1">[1](#fnr.1)</span></sup>
Are there more normal forms? Why yes! But they rapidly become more and more difficult to reason about, and it's unlikely you'll need to understand them. But, you can read about [Second Normal Form](https://en.wikipedia.org/wiki/Second_normal_form) and [Third Normal Form](https://en.wikipedia.org/wiki/Third_normal_form) if you want to.

Author: Ross Donaldson

Created: 2016-04-09 Sat 18:07

[Validate](http://validator.w3.org/check?uri=referer)


