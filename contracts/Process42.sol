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
    _addVertex("Vejledning","Mundtlig vejledning", false, NodeType.NORMAL);
    _addVertex("Mundtlig vejledning afgørelse", "Mundtlig vejledning", true, NodeType.RESOLUTION);

    _addEdge(root, "Vejledning");

    _addEdge("Vejledning","Mundtlig vejledning afgørelse");
  }

  function startup() private {
    bytes32 phase = "Opstartsbehandling";
    _addVertex("Dokumentation fra læge", phase, false, NodeType.NORMAL);
    _addVertex("Dokumentation fra forældre", phase, false, NodeType.DOC);
    _addVertex("Andet dokumentation", phase, false, NodeType.NORMAL);
    _addVertex("Partshøring", phase, false, NodeType.NORMAL);
    _addVertex("Opstartsbehandling afgørelse", phase, true, NodeType.RESOLUTION);

    _addEdge("Mundtlig vejledning afgørelse","Dokumentation fra læge");
    _addEdge("Mundtlig vejledning afgørelse","Dokumentation fra forældre");
    _addEdge("Mundtlig vejledning afgørelse","Andet dokumentation");

    _addEdge("Dokumentation fra læge", "Partshøring");
    _addEdge("Dokumentation fra forældre", "Partshøring");
    _addEdge("Andet dokumentation", "Partshøring");
    _addEdge("Partshøring", "Opstartsbehandling afgørelse");
  }

  function metering() private {
    bytes32 phase = "Udmåling";
    _addVertex("Arbejdstider", phase, false, NodeType.DOC);
    _addVertex("Familieforhold", phase, false, NodeType.NORMAL);
    _addVertex("Arbejdsfleksibilitet", phase, false, NodeType.NORMAL);
    _addVertex("Bevilligede timer", phase, false, NodeType.NORMAL);
    _addVertex("Sparede udgifter", phase, false, NodeType.NORMAL);
    _addVertex("Udmåling afgørelse", phase, true, NodeType.RESOLUTION);

    _addEdge("Opstartsbehandling afgørelse","Arbejdstider");
    _addEdge("Opstartsbehandling afgørelse","Familieforhold");
    _addEdge("Opstartsbehandling afgørelse","Arbejdsfleksibilitet");

    _addEdge("Arbejdstider","Bevilligede timer");
    _addEdge("Arbejdstider","Sparede udgifter");
    _addEdge("Familieforhold","Bevilligede timer");
    _addEdge("Familieforhold","Sparede udgifter");
    _addEdge("Arbejdsfleksibilitet","Bevilligede timer");
    _addEdge("Arbejdsfleksibilitet","Sparede udgifter");
    _addEdge("Bevilligede timer", "Udmåling afgørelse");
    _addEdge("Sparede udgifter", "Udmåling afgørelse");
  }

  function calculation() private {
    bytes32 phase = "Beregningsgrundlag";
    _addVertex("Indkomstoplysninger", phase, false, NodeType.DOC);
    _addVertex("Skatteoplysninger", phase, false, NodeType.DOC);
    _addVertex("Pensionsoplysninger", phase, false, NodeType.DOC);

    _addVertex("Beregning af ydelse", phase, false, NodeType.NORMAL);
    _addVertex("Pensionsselskabs info", phase, false, NodeType.NORMAL);

    _addVertex("Beregningsgrundlag afgørelse", phase, true, NodeType.RESOLUTION);

    _addEdge("Udmåling afgørelse","Indkomstoplysninger");
    _addEdge("Udmåling afgørelse","Skatteoplysninger");
    _addEdge("Udmåling afgørelse","Pensionsoplysninger");

    _addEdge("Indkomstoplysninger", "Beregning af ydelse");
    _addEdge("Skatteoplysninger", "Beregning af ydelse");
    _addEdge("Pensionsoplysninger", "Beregning af ydelse");
    _addEdge("Pensionsoplysninger", "Pensionsselskabs info");

    _addEdge("Beregning af ydelse", "Beregningsgrundlag afgørelse");
    _addEdge("Pensionsselskabs info", "Beregningsgrundlag afgørelse");
  }

  function payment() private {
    _addVertex("Borgerdokumentation", "Udbetaling", false, NodeType.DOC);
    _addVertex("Udbetaling afgørelse", "Udbetaling", true, NodeType.RESOLUTION);

    _addEdge("Beregningsgrundlag afgørelse","Borgerdokumentation");
    _addEdge("Borgerdokumentation","Udbetaling afgørelse");
    _addEdge("Udbetaling afgørelse", end);
  }

  function test() private {
    _addVertex("Normal","Resolution", false, NodeType.DOC);
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
