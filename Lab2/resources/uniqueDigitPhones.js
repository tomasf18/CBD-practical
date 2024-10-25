findUniqueDigitPhones = function() {
    db.phones.aggregate([
        {
            $project: {
                display: 1,
                components: 1,
                numberStr: {$toString: "$components.number"} // convert *!!components.number!!* part od the full number to string
            }
        },
        {
            $match: {
                $expr: {
                    $eq: [
                        {$strLenCP: "$numberStr"}, // get the length of the number string
                        {$size: {$setUnion: {$map: {
                                                input: {$range: [0, {$strLenCP: "$numberStr"}]}, // create an array of indexes
                                                as: "index",  // iterate over the indexes
                                                in: {$substrCP: ["$numberStr", "$$index", 1]} // get the digit at the index
                                            }}
                                }
                        }
                    ]
                }
            }
        }
    ]).forEach(doc => print("Found unique-digit number:", doc.display));
};
  