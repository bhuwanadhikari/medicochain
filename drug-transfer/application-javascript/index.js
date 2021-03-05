const express = require("express");
const app = express();
const cors = require("cors");
const port = 8080;

// Import all function modules
const enrollUser = require("./auth/_enrollUser");
const enrollAdmin = require("./auth/_enrollAdmin");
const manufacture = require("./_manufacture");
const transfer = require("./_transfer");
const retail = require("./_retail");
const drugHistory = require("./_drugHistory");
const drugState = require("./_drugState");


// Define Express app settings
app.use(cors());
app.use(express.json()); // for parsing application/json
app.use(express.urlencoded({ extended: true })); // for parsing application/x-www-form-urlencoded
app.set("title", "Medicochain App");

app.get("/", (req, res) => res.send("hello world"));

//enroll the admin
app.get("/enroll-admin", (req, res) => {
  console.log('----------------------------------------------------------------------');
  enrollAdmin
    .execute()
    .then((reply) => {
      console.log("admin Created");
      const result = {
        status: "success",
        message: reply,
      };
      res.json(result);
    })
    .catch((e) => {
      const result = {
        status: "error",
        message: "Failed",
        error: e,
      };
      res.status(500).send(result);
    });
});

//enroll the user
app.get("/enroll-user", (req, res) => {
  console.log('----------------------------------------------------------------------');
  enrollUser
    .execute()
    .then((reply) => {
      console.log("User Created");
      const result = {
        status: "success",
        message: reply,
      };
      res.json(result);
    })
    .catch((e) => {
      const result = {
        status: "error",
        message: "Failed",
        error: e,
      };
      res.status(500).send(result);
    });
});


//manufacture drug
app.get("/manufacture-drug", (req, res) => {
  console.log('just hit the manufacture drug endpoint');
  manufacture
    .execute(
      'manufacturer3',
      'Threeplace',
      '00003',
      '2020-10-30',
      '2021-10-30',
      '10mg',
      'glucose-60mg,else-98mg',
      'cefixime',
      '99/54',
      'false',
      '55'
    )
    .then((newDrug) => {
      console.log("New drug is manufactured");
      const result = {
        status: "success",
        message: "New drug is manufactured",
        drug: newDrug,
      };
      res.json(result);
    })
    .catch((e) => {
      const result = {
        status: "error",
        message: "Failed",
        error: e,
      };
      res.status(500).send(result);
    });
});


//Transfer the asset
app.get("/transfer-drug", (req, res) => {
  console.log('just hit the drug endpoint');
  transfer
    .execute(
      'manufacturer3', //manufacturer of the drug
      '00003',        //drugNumber
      'manufacturer3', // current owner
      'distributor3',       //newOwner
      '45',       //cost
      '2020-10-10',// purchase date time
      'Patna',   //purchase place
    )
    .then((updatedDrug) => {
      console.log("Drug is updated");
      const result = {
        status: "success",
        message: "Drug is updated",
        drug: updatedDrug,
      };
      res.json(result);
    })
    .catch((e) => {
      const result = {
        status: "error",
        message: "Failed",
        error: e,
      };
      res.status(500).send(result);
    });
});


//Retail the drug
app.get("/retail-drug", (req, res) => {
  console.log('just hit the drug endpoint');
  retail
    .execute(
      'manufacturer3', //manufacturer of the drug
      '00003',        //drugNumber
      'distributor3', // current owner
      'ram',       //newOwner
      '45',       //cost
      '2020-10-10',// purchase date time
      'tallobesi',   //purchase place
    )
    .then((updatedDrug) => {
      console.log("Drug is sold to customer");
      const result = {
        status: "success",
        message: "Drug is sold to customer",
        drug: updatedDrug,
      };
      res.json(result);
    })
    .catch((e) => {
      const result = {
        status: "error",
        message: "Failed",
        error: e,
      };
      res.status(500).send(result);
    });
});


//get the drug history
app.get("/drug-history", (req, res) => {
  console.log('just hit the drug endpoint');
  drugHistory
    .execute(
      'manufacturer3', //manufacturer of the drug
      '00003'
    )
    .then((history) => {
      console.log("Drug history is received");
      const result = {
        status: "success",
        message: "Received drug history",
        history: history,
      };
      res.json(result);
    })
    .catch((e) => {
      const result = {
        status: "error",
        message: "Failed",
        error: e,
      };
      res.status(500).send(result);
    });
});


//get the world drug state
app.get("/drug-state", (req, res) => {
  console.log('just hit the drug endpoint');
  drugState
    .execute(
      'manufacturer3', //manufacturer of the drug
      '00003'
    )
    .then((state) => {
      console.log("Drug state received");
      const result = {
        status: "success",
        message: "Received drug state",
        state: state,
      };
      res.json(result);
    })
    .catch((e) => {
      const result = {
        status: "error",
        message: "Failed",
        error: e,
      };
      res.status(500).send(result);
    });
});



app.listen(port, () => console.log(`Distributed medicochain listening on port ${port}!`));