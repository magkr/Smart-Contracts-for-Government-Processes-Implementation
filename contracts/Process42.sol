pragma solidity 0.5.0;

import {ProcessInterface} from "./ProcessInterface.sol";

contract Process42 is ProcessInterface {

  constructor() public {
    intro();
    startup();
    metering();
    calculation();
    payment();
    paymentGate = "Afgørelse: Beregningsgrundlag";
  }

  function intro() private {
    bytes32 phase = "Vejledning";
    _addActivity("Vejledning",phase, ActivityType.NORMAL);
    _addActivity("Afgørelse: Vejledning", phase, ActivityType.DECISION);
    _addDependency(root, "Vejledning");
    _addDependency("Vejledning","Afgørelse: Vejledning");
  }

  function startup() private {
    bytes32 phase = "Målgruppevurdering";
    _addActivity("Dokumentation fra læge", phase, ActivityType.NORMAL);
    _addActivity("Dokumentation fra forældre", phase, ActivityType.DOC);
    _addActivity("Andet dokumentation", phase, ActivityType.NORMAL);
    _addActivity("Partshøring", phase, ActivityType.NORMAL);
    _addActivity("Afgørelse: Målgruppevurdering", phase, ActivityType.DECISION);

    _addDependency("Afgørelse: Vejledning","Dokumentation fra læge");
    _addDependency("Afgørelse: Vejledning","Dokumentation fra forældre");
    _addDependency("Afgørelse: Vejledning","Andet dokumentation");

    _addDependency("Dokumentation fra læge", "Partshøring");
    _addDependency("Dokumentation fra forældre", "Partshøring");
    _addDependency("Andet dokumentation", "Partshøring");
    _addDependency("Partshøring", "Afgørelse: Målgruppevurdering");
  }

  function metering() private {
    bytes32 phase = "Udmåling";
    _addActivity("Dokmentation af arbejdstider", phase, ActivityType.DOC);
    _addActivity("Oplys familieforhold", phase, ActivityType.DOC);
    _addActivity("Oplys arbejdsfleksibilitet", phase, ActivityType.DOC);
    _addActivity("Bevilligede timer", phase, ActivityType.NORMAL);
    _addActivity("Sparede udgifter", phase, ActivityType.NORMAL);
    _addActivity("Afgørelse: Udmåling", phase, ActivityType.DECISION);

    _addDependency("Afgørelse: Målgruppevurdering","Dokmentation af arbejdstider");
    _addDependency("Afgørelse: Målgruppevurdering","Oplys familieforhold");
    _addDependency("Afgørelse: Målgruppevurdering","Oplys arbejdsfleksibilitet");

    _addDependency("Dokmentation af arbejdstider","Bevilligede timer");
    _addDependency("Dokmentation af arbejdstider","Sparede udgifter");

    _addDependency("Oplys familieforhold","Bevilligede timer");
    _addDependency("Oplys familieforhold","Sparede udgifter");

    _addDependency("Oplys arbejdsfleksibilitet","Bevilligede timer");
    _addDependency("Oplys arbejdsfleksibilitet","Sparede udgifter");

    _addDependency("Bevilligede timer", "Afgørelse: Udmåling");
    _addDependency("Sparede udgifter", "Afgørelse: Udmåling");
  }

  function calculation() private {
    bytes32 phase = "Beregningsgrundlag";
    _addActivity("Indkomstoplysninger", phase, ActivityType.DOC);
    _addActivity("Pensionsoplysninger", phase, ActivityType.DOC);
    _addActivity("Beregningsgrundlag", phase, ActivityType.NORMAL);
    _addActivity("Afgørelse: Beregningsgrundlag", phase, ActivityType.DECISION);

    _addDependency("Afgørelse: Udmåling","Indkomstoplysninger");
    _addDependency("Afgørelse: Udmåling","Pensionsoplysninger");

    _addDependency("Indkomstoplysninger", "Beregningsgrundlag");
    _addDependency("Pensionsoplysninger", "Beregningsgrundlag");

    _addDependency("Beregningsgrundlag", "Afgørelse: Beregningsgrundlag");
  }

  function payment() private {
    bytes32 phase = "Udbetaling";
    _addActivity("Dokumentation på t.a.", phase, ActivityType.DOC);
    _addActivity("Udbetaling", phase, ActivityType.PAYMENT);

    _addDependency("Afgørelse: Beregningsgrundlag","Dokumentation på t.a.");
    _addDependency("Dokumentation på t.a.","Udbetaling");
    _addDependency("Udbetaling", end);
  }
}
