// TASK 1
// count how many listings exist for every country and room type pair
// sort by count, desc

db.listingsAndReviews.aggregate([
  {
    $group: {
      _id: {
        country: "$address.country",
        room_type: "$room_type"
      },
      count: { $sum: 1 }
    }
  },
  {
    $sort: { count: -1 }
  }
])


// TASK 2
// for each city/market find the 5 most common amenities across listings

db.listingsAndReviews.aggregate([
    { $unwind: "$amenities" },

    {
        $group: {
            _id: {
                market: "$address.market",
                amenity: "$amenities"
            },

            count: { sum: 1 }
        }
    },

    {
        $sort: { count: -1 }
    },

    {
        $group: {
            _id: "$_id.market",
            amenities: {
                $push: { amenity: $_id.amenity, count: "$count" }
            }
        }
    },

    {
        $project: {
            _id: 1,
            top5: { $slice: ["$amenities", 5] }
        }
    }
])


// TASK 3
// compute the average review_score.review_score_rating for each room_type

db.listingsAndReviews.aggregate([
    {
        $group: {
            _id: "$room_type",
            averageRating: { $avg: "$review_score.review_score_rating" }
        }
    }
])



// TASK 4
// calculate the average number of beds per address.country

db.listingsAndReviews.aggregate([
    {
        $group: {
            _id: "$address.country",
            avg_beds: { $avg: $beds }
        }
    }
])


// TASK 5
// count how many shipwrecks exist for each feature_type

db.listingsAndReviews.aggregate([
    {
        $group: {
            _id: "$feature_type",
            count: { $sum : 1 }
        }
    }
])


// TASK 6
// compute average depth and number of wrecks for each water level of shipwreck

db.listingsAndReviews.aggregate([
    {
        $group: {
            _id:"$water_level",
            averageDepth: { $avg: "$depth" },
            wrecksCount: { $sum: 1 }
        }
    }
])


// TASK 7
// count how many movies belong to each genre
db.movies.aggregate([
    {
        $unwind: "$genres"
    },

    {
        $group: {
            _id: "$genre",
            count: { $sum: 1 }
        }
    }
])


// TASK 8
// compute the average imdb rating per genre
// keep only genres with at least 50 movies

db.movies.aggregate([
    {
        $unwind: "$genres"
    },

    {
        $group: {
            _id: "$genres",
            movieRating: { $avg: "$imdb.rating" },
            movieCount: { $sum: 1 }
        }
    },

    {
        $match: {
            movieCount: { $lte: 50 }
        }
    }
])


// TASK 9
// count how many restaurants exist per (borough, cuisine)
db.restaurants.aggregate([
    {
        $group: {
            _id: {
                borough: "$borough",
                cuisine: "$cuisine"
            },
            count: { $sum: 1 }
        }
    }
])


// TASK 10
// calculate average grades.score for each cuisine

db.restaurants.aggregate([
    {
        $unwind: "$grades"
    },

    {
        $group: {
            _id: "$cuisine",
            averageScore: { $avg: "$grades.score" }
        }
    }
])