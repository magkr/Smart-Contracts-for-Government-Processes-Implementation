pragma solidity 0.5.0;

import {ProcessInterface} from "./ProcessInterface.sol";

contract Process42 is ProcessInterface {

  constructor() public {
    intro();
    startup();
    metering();
    calculation();
    payment();
    resolvingResolution = "Afgørelse: Beregningsgrundlag";

    /* test();
    resolvingResolution = "Resolution"; */
  }

  function intro() private {
    bytes32 phase = "Vejledning";
    _addVertex("Vejledning",phase, NodeType.NORMAL);
    _addVertex("Afgørelse: Vejledning", phase, NodeType.RESOLUTION);

    _addEdge(root, "Vejledning");

    _addEdge("Vejledning","Afgørelse: Vejledning");
  }

  function startup() private {
    bytes32 phase = "Målgruppevurdering";
    _addVertex("Dokumentation fra læge", phase, NodeType.NORMAL);
    _addVertex("Dokumentation fra forældre", phase, NodeType.DOC);
    _addVertex("Andet dokumentation", phase, NodeType.NORMAL);
    _addVertex("Partshøring", phase, NodeType.NORMAL);
    _addVertex("Afgørelse: Målgruppevurdering", phase, NodeType.RESOLUTION);

    _addEdge("Afgørelse: Vejledning","Dokumentation fra læge");
    _addEdge("Afgørelse: Vejledning","Dokumentation fra forældre");
    _addEdge("Afgørelse: Vejledning","Andet dokumentation");

    _addEdge("Dokumentation fra læge", "Partshøring");
    _addEdge("Dokumentation fra forældre", "Partshøring");
    _addEdge("Andet dokumentation", "Partshøring");
    _addEdge("Partshøring", "Afgørelse: Målgruppevurdering");
  }

  function metering() private {
    bytes32 phase = "Udmåling";
    _addVertex("Dokmentation af arbejdstider", phase, NodeType.DOC);
    _addVertex("Oplys familieforhold", phase, NodeType.DOC);
    _addVertex("Oplys arbejdsfleksibilitet", phase, NodeType.DOC);
    _addVertex("Bevilligede timer", phase, NodeType.NORMAL);
    _addVertex("Sparede udgifter", phase, NodeType.NORMAL);
    _addVertex("Afgørelse: Udmåling", phase, NodeType.RESOLUTION);

    _addEdge("Afgørelse: Målgruppevurdering","Dokmentation af arbejdstider");
    _addEdge("Afgørelse: Målgruppevurdering","Oplys familieforhold");
    _addEdge("Afgørelse: Målgruppevurdering","Oplys arbejdsfleksibilitet");

    _addEdge("Dokmentation af arbejdstider","Bevilligede timer");
    _addEdge("Dokmentation af arbejdstider","Sparede udgifter");

    _addEdge("Oplys familieforhold","Bevilligede timer");
    _addEdge("Oplys familieforhold","Sparede udgifter");

    _addEdge("Oplys arbejdsfleksibilitet","Bevilligede timer");
    _addEdge("Oplys arbejdsfleksibilitet","Sparede udgifter");

    _addEdge("Bevilligede timer", "Afgørelse: Udmåling");
    _addEdge("Sparede udgifter", "Afgørelse: Udmåling");
  }

  function calculation() private {
    bytes32 phase = "Beregningsgrundlag";
    _addVertex("Indkomstoplysninger", phase, NodeType.DOC);
    _addVertex("Pensionsoplysninger", phase, NodeType.DOC);
    _addVertex("Beregningsgrundlag", phase, NodeType.NORMAL);
    _addVertex("Afgørelse: Beregningsgrundlag", phase, NodeType.RESOLUTION);

    _addEdge("Afgørelse: Udmåling","Indkomstoplysninger");
    _addEdge("Afgørelse: Udmåling","Pensionsoplysninger");

    _addEdge("Indkomstoplysninger", "Beregningsgrundlag");
    _addEdge("Pensionsoplysninger", "Beregningsgrundlag");

    _addEdge("Beregningsgrundlag", "Afgørelse: Beregningsgrundlag");
  }

  function payment() private {
    bytes32 phase = "Udbetaling";
    _addVertex("Dokumentation på t.a.", phase, NodeType.DOC);
    _addVertex("Udbetaling", phase, NodeType.PAYMENT);

    _addEdge("Afgørelse: Beregningsgrundlag","Dokumentation på t.a.");
    _addEdge("Dokumentation på t.a.","Udbetaling");
    _addEdge("Udbetaling", end);
  }

  function test() private {
    _addVertex("Normal","Resolution", NodeType.NORMAL);
    _addVertex("Resolution", "Resolution", NodeType.RESOLUTION);
    _addVertex("Documentation", "Final", NodeType.DOC);
    _addVertex("Final", "Final", NodeType.RESOLUTION);


    _addEdge(root,"Normal");
    _addEdge("Normal","Resolution");

    _addEdge("Resolution","Documentation");
    _addEdge("Documentation","Final");
    _addEdge("Final",end);

  }


}
