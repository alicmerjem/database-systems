// find() is used to select data from a collection in mongo

db.listingsAndReviews.find({})

// so the syntax is db.collectionName.find({})

// if we want only one document, we would just use findOne()

db.listingsAndReviews.find({canecllation_policy:"flexible"})

// we want to see our games collection
// we want all games where the genre is shooter
// we also want the title, but don't need the _id field

db.games.find(
    {genre: "Shooter"},
    {_id: 0, title: 1}
)


// another example

db.players.find(
    {country:"Germany"},
    {_id: 0, username: 1}
)

// limit, skip and sort all come after find, and we chain them using a dot 

db.games.find({genre : "action"}).limit(5)

db.games.find({genre: "shooter"}).skip(10)

db.games.find({}).sort({price: -1}) // 1 ascending, -1 descending 

// deleteOne() / deleteMany()

db.players.deleteMany({country: "germany"}) // deletes all matches
db.platers.deleteOne({country: "germany"}) // deletes only the first match

// example: we are looking at the games collection
// we want to find all games
// sort them by price from cheapest to most expensive aka ascending
// we want the top 3 results 

db.games.find({}).sort({price: 1}).limit(3)



// COMPARISON QUERIES WOOOOO
db.games.find({genre: {$ne: "RPG"}}) // gives you all games that are not RPGs

db.games.find({price: {$eq: 20}}) // find games costing exactly 20

db.games.find({rating: {$gt: 20}}) // ratings strictly higher than 4

db.games.find({price: {$gte: 20}}) // price is 20 or higher

db.games.find({storage_gb: {$lt: 50}}) // storage size less than 50

db.games.find({current_players: {$lte: 100}}) // less than 100 players in the lobby

db.games.find({genre: {$in: ["Shooter", "Strategy"]}}) // checking if there are matches in any field in the list

db.games.find({$or: [{genre: "shooter"}, {price: {$lt: 15}}]}) // either the genre is shooter or price is 15

db.games.find({$and: [{price: {$gte: 50}}, {price:{$lte: 120}}]})

db.games.find({$nor: [{genre: "RPG"}, {premium:true}]}) // fails every single condition

db.games.find({price: {$not: {$gte: 50}}})

// example:
// query players collection
// clear out a report finding specific high value users
// find players who match both these criteria at the same time
// country is not germany
// total amount paid is greater than or equal to 100

db.players.find({
    $and: [
        {country: {$ne: "Germany"}},
        {amount_paid: {$gte: 100}}
    ]
})

// also mongo applies and implicityly if you just separate fields with commans inside an object

db.players.find({
    country: {$ne: "germany"},
    amount_paid: {$gte: 100}
})



// AGGREGATION 
// match
// almost always used first
// like a security guard at the front of the line
// if a document does not match a condition it gets thrown out
// we put it first to save memory 

dm.games.aggregate([
    {$match: {genre: "shooter"}}
])

db.listingsAndReviews.aggregate([
    {$match: {room_type:"entire home/apt"}}
])

// multi stage pipeline
// we do not use . here to chain like we did for find
// we just mkae separate objects, in a way
db.listingsAndReviews.aggregate([
    { $match: {room_type: "entire home/apt"} },
    { $sort: {price: 1} },
    { $limit: 3 }
])

// project
// used for controlling what gets displayed
// similar to when we did _id, title in find

db.listingsAndReviews.aggregate([
    { $match: {room_type: "entire home/apt"} },
    { $project: { _id: 0, name: 1, price: 1 } }
])

// example:
// use listingsandreviews collection
// build an aggregation pipeline
// filter documents where beds is greater than or equals to 4
// sort the results by price from highest to lowest / desc
// display only the name field and completely hide the _id

db.listingsAndReviews.aggregate([
    { $match: {beds: {$gte: 4}} },
    { $sort: {price: -1} },
    { $project: {_id: 0, name: 1} }
])

// group
// this is mongo's version of group by combined with aggregate functions like sum, avg, min and max
// _id is mandatory, tells us what to group by 
// when you are using an existing field, you must combine it with $

db.listingsAndReviews.aggregate([
  {
    $group: {
      _id: "$room_type",                // Group by room_type (Notice the $ prefix!)
      averagePrice: { $avg: "$price" }  // Create a custom field, use the $avg operator on the price field
    }
  }
])

// example 
// use grouping
// we want to count how many listings for each property type

db.listingsAndReviews.aggregate([
    {
        $group: {
            _id: "$property_type",
            count: { $sum: 1 }
        }
    }
])


// unwind
// basically unpacks an arraylist
// array exploder
// replaces a nested array with a flat item 

{ $unwind: "$amenities" }

// thats it
// thats the syntax

