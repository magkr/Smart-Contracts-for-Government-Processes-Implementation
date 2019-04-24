pragma solidity 0.5.0;

import {ProcessInterface} from "./ProcessInterface.sol";

contract Process42 is ProcessInterface {

  constructor() public {
    intro();
    startup();
    metering();
    calculation();
    payment();
    resolvingResolution = "Beregningsgrundlag afgørelse";
    lastVtx = "Udbetaling afgørelse";


    /* test();
    resolvingResolution = "Resolution";
    lastVtx = "Final"; */
  }

  function intro() private {
    bytes32 phase = "Vejledning";
    _addVertex("Vejledning",phase, false, NodeType.NORMAL);
    _addVertex("Afgørelse: Vejledning", phase, true, NodeType.RESOLUTION);

    _addEdge(root, "Vejledning");

    _addEdge("Vejledning","Afgørelse: Vejledning");
  }

  function startup() private {
    bytes32 phase = "Målgruppevurdering";
    _addVertex("Dokumentation fra læge", phase, false, NodeType.NORMAL);
    _addVertex("Dokumentation fra forældre", phase, false, NodeType.DOC);
    _addVertex("Andet dokumentation", phase, false, NodeType.NORMAL);
    _addVertex("Partshøring", phase, false, NodeType.NORMAL);
    _addVertex("Afgørelse: Målgruppevurdering", phase, true, NodeType.RESOLUTION);

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
    _addVertex("Dokmentation af arbejdstider", phase, false, NodeType.DOC);
    _addVertex("Oplys familieforhold", phase, false, NodeType.DOC);
    _addVertex("Oplys arbejdsfleksibilitet", phase, false, NodeType.DOC);
    _addVertex("Bevilligede timer", phase, false, NodeType.NORMAL);
    _addVertex("Sparede udgifter", phase, false, NodeType.NORMAL);
    _addVertex("Afgørelse: Udmåling", phase, true, NodeType.RESOLUTION);

    _addEdge("Opstartsbehandling afgørelse","Dokmentation af arbejdstider");
    _addEdge("Opstartsbehandling afgørelse","Oplys familieforhold");
    _addEdge("Opstartsbehandling afgørelse","Oplys arbejdsfleksibilitet");

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
    _addVertex("Indkomstoplysninger", phase, false, NodeType.DOC);
    _addVertex("Pensionsoplysninger", phase, false, NodeType.DOC);
    _addVertex("Beregningsgrundlag", phase, false, NodeType.NORMAL);
    _addVertex("Afgørelse: Beregningsgrundlag", phase, true, NodeType.RESOLUTION);

    _addEdge("Afgørelse: Udmåling","Indkomstoplysninger");
    _addEdge("Afgørelse: Udmåling","Pensionsoplysninger");

    _addEdge("Indkomstoplysninger", "Beregningsgrundlag");
    _addEdge("Pensionsoplysninger", "Beregningsgrundlag");

    _addEdge("Beregningsgrundlag", "Afgørelse: Beregningsgrundlag");
  }

  function payment() private {
    bytes32 phase = "Udbetaling";
    _addVertex("Dokumentation på t.a.", phase, false, NodeType.DOC);
    _addVertex("Afgørelse: Udbetaling", phase, true, NodeType.RESOLUTION);

    _addEdge("Afgørelse: Beregningsgrundlag","Dokumentation på t.a.");
    _addEdge("Dokumentation på t.a.","Afgørelse: Udbetaling");
    _addEdge("Afgørelse: Udbetaling", end);
  }

  function test() private {
    _addVertex("Normal","Resolution", false, NodeType.NORMAL);
    _addVertex("Resolution", "Resolution", true, NodeType.RESOLUTION);
    _addVertex("Documentation", "Final", false, NodeType.DOC);
    _addVertex("Final", "Final", true, NodeType.RESOLUTION);


    _addEdge(root,"Normal");
    _addEdge("Normal","Resolution");

    _addEdge("Resolution","Documentation");
    _addEdge("Documentation","Final");
    _addEdge("Final",end);

  }


}
