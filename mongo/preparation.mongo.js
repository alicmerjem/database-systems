// TASK 1
// each session has a tags array
// for every distinct tag used in the data, count how many sessions contain that tag
// sort from most common to least

db.gamehub.aggregate([
    {
        $unwind: "$tags"
    },

    {
        $group: {
            _id: "$tags",
            count: { $sum: 1 }
        }
    },

    {
        $sort: { count: -1 }
    }
])


// TASK 2
// find the three games with the highest total score summed across all their sessions
// show the game title and the total score, ranked highest first

db.gamehub.aggregate([
    {
        $group: {
            _id: "$gameTitle",
            count: { $sum: "$score" }
        }
    },

    {
        $sort: { count: -1 }
    }, 

    {
        $limit: 3
    }
])


// TASK 3
// for each player, compute how many sessions they played and their average session duration
// keep players with at least 3 sessions
// sort by average duration descending
// show username, session count and average duration

db.gamehub.aggregate([
    {
        $group: {
            _id: "$username",
            count: { $sum: 1 },
            averageSession: { $avg: "$durationMin" }
        }
    },

    {
        $match: {
            count: { $gte: 3 }
        }
    },

    {
        $sort: {
            averageSession: -1
        }
    }
])


// TASK 4
// considering only premium players, compute the total score earned per country
// sort countries from highest total to lowest

db.gamehub.aggregate([
    {
        $match: {
            premium: true
        }
    }, 
    {
        $group: {
            _id: "$country",
            count: { $sum: "$score" }
        }
    },
    {
        $sort: {
            totalScore: -1
        }
    }
])


// TASK 5
// for each calendar month, count the number of distinct players who played at least one session that month
// use monthly active players
// return the months in chronological order, labeled as yyyy-mm

db.sessions.aggregate([
    {
        $group: {
            _id: {
                month: { $dateToString: { format: "%Y-%m", date: "playedOn" } },
                username: "$username"
            }
        }
    },

    {
        $group: {
            _id: "$_id.month",
            monthlyActivePlayers: { $sum: 1 }
        }
    },

    {
        $sort: {
            _id: 1
        }
    }
])