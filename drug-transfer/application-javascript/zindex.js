const express = require("express");
const app = express();
const cors = require("cors");
var fileupload = require("express-fileupload");
const port = 8080;

// Import all function modules
const enrollUsers = require("./zenrollUsers");
const manufacture = require("./zmanufacture");
const transfer = require("./ztransfer");
const retail = require("./zretail");
const drugHistory = require("./zdrugHistory");
const drugState = require("./zdrugState");
const chaincodeStatus = require("./zchaincodeStatus");


// Define Express app settings
app.use(cors());
app.use(fileupload());
app.use(express.json()); // for parsing application/json
app.use(express.urlencoded({ extended: true })); // for parsing application/x-www-form-urlencoded
app.set("title", "Medicochain App");

app.get("/", (req, res) => res.send("hello world"));

//enroll the admin
app.get("/enroll-users", (req, res) => {
  console.log('----------------------------------------------------------------------');
  enrollUsers
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


//manufacture drug
app.get("/manufacture-drug", (req, res) => {
  console.log('just hit the manufacture drug endpoint');
  manufacture
    .execute(
      'manufacturer4',
      'fourplace',
      '00004',
      '2010-10-30',
      '2011-10-30',
      '11mg',
      'glucose-11mg,else-11mg',
      'cefixime bineutrole',
      '11/22',
      '111'
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
      'manufacturer4', //manufacturer of the drug
      '00004',        //drugNumber
      'manufacturer4', // current owner
      'distributor4',       //newOwner
      '444',       //cost
      '2010-10-44',// purchase date time
      'Lucknow',   //purchase place
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
      '75',       //cost
      '2020-10-12',// purchase date time
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
      'manufacturer4', //manufacturer of the drug
      '00004'          //drug number
    )
    .then((state) => {
      console.log("Drug state received");
      const result = {
        status: "success",
        message: "Received drug state",
        state: state,
      };
      res.status(200).json(result);
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
app.get("/chaincode-status", (req, res) => {
  console.log('just hit the drug endpoint');
  chaincodeStatus
    .execute()
    .then((response) => {
      const result = {
        status: "success",
        message: "received chaincode status",
        response
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
app.post("/manufacture-drug", (req, res) => {
  console.log('just hit the manufacture drug endpoint');
  console.log(req.body);
  // res.status(200).json(req.body);
  console.log(req.body.manufacturer,
    req.body.manufacturedIn,
    req.body.drugNumber,
    req.body.mfgDate,
    req.body.expDate,
    req.body.dose,
    req.body.composition,
    req.body.name,
    req.body.bn,
    req.body.mrp)

  manufacture
    .execute(
      req.body.manufacturer,
      req.body.manufacturedIn,
      req.body.drugNumber,
      req.body.mfgDate,
      req.body.expDate,
      req.body.dose,
      req.body.composition,
      req.body.name,
      req.body.bn,
      req.body.mrp
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
app.post("/transfer-drug", (req, res) => {
  console.log('just hit the  drug transfer endpoint');
  console.log(req.body);
  transfer
    .execute(
      req.body.manufacturer, //manufacturer of the drug
      req.body.drugNumber,        //drugNumber
      req.body.currentOwner, // current owner
      req.body.newOwner,       //newOwner
      req.body.boughtAt,       //cost
      req.body.purchaseDateTime,// purchase date time
      req.body.purchasePlace  //purchase place
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
app.post("/retail-drug", (req, res) => {
  console.log('just hit the drug endpoint');
  retail
    .execute(
      req.body.manufacturer, //manufacturer of the drug
      req.body.drugNumber,        //drugNumber
      req.body.currentOwner, // current owner
      req.body.newOwner,       //newOwner
      req.body.boughtAt,       //cost
      req.body.purchaseDateTime,// purchase date time
      req.body.purchasePlace  //purchase place
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
app.post("/drug-history", (req, res) => {
  console.log('just hit the drug endpoint');
  drugHistory
    .execute(
      req.body.manufacturer,
      req.body.drugNumber
    )
    .then((history) => {
      console.log("Drug history is received", history);
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



//uploading of file

//Transfer the asset
app.post("/connection-profile", (req, res) => {
  console.log('just hit the  drug transfer endpoint');
  console.log(req.body.continueAs, 'is the continues as of thingasdf');
  // console.log(config);

  try {

    if (req.body.continueAs === 'Customer') {
      return res.json({
        status: "success",
        message: "Successfully authenticated",
        data: {
          organization: "customer"
        }
      });
    }
    const config = JSON.parse(req.files.certificateFile.data.toString());

    const organization = config.client.organization;
    const peer = config.organizations[organization].peers[0];
    const certificateAuthority = config.organizations[organization].certificateAuthorities[0];
    const peerUrl = config.peers[peer].url;
    const certificateUrl = config.certificateAuthorities[certificateAuthority].url;
    if (req.body.continueAs[0].toLowerCase() + req.body.continueAs.slice(1) !== organization) {
      throw new Error('Error in configuration file!');
    }

    const response = {
      organization,
      peer,
      certificateAuthority,
      peerUrl,
      certificateUrl,
    }
    console.log(response)
    res.json({
      status: "success",
      message: "Successfully authenticated",
      data: response
    });
  } catch (e) {
    res.json({
      status: "failed",
      message: "Error in configuration file!",
      data: e
    });
  }
});

//get the world drug state
app.post("/drug-state", (req, res) => {
  console.log('just hit the drug endpoint');
  console.log(req.body);

  drugState
    .execute(
      req.body.manufacturer,
      req.body.drugNumber
    )
    .then((state) => {
      console.log("Drug state received", JSON.stringify(state));
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



//Retail the drug
app.get("/chaincode-status", (req, res) => {
  console.log('just hit the drug endpoint');
  chaincodeStatus
    .execute()
    .then((response) => {
      const result = {
        status: "success",
        message: "received chaincode status",
        response
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