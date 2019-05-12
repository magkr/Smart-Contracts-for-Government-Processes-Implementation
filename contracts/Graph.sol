pragma solidity 0.5.0;

contract Graph {

  enum ActivityType { NORMAL, DECISION, DOC, PAYMENT }

  bytes32 paymentGate;
  bytes32 root = "root";
  bytes32 end = "end";

  struct Activity {
    bytes32 title;
    bytes32 phase;
    ActivityType aType;
  }

  Activity[] activities;
  mapping (uint => uint[]) adj;
  mapping (uint => uint[]) req;
  mapping (bytes32 => uint) titleToID;

  function _getIdx(bytes32 title) internal view returns (uint id) {
    return titleToID[title]-1;
  }

  function _addActivity(bytes32 _title, bytes32 _phase, ActivityType _type) internal {
    activities.push(Activity(_title, _phase, _type));
    titleToID[_title] = activities.length;
  }

  function _addDependency(bytes32 from, bytes32 to) internal {
    uint v = _getIdx(from);
    uint w = _getIdx(to);

    if (v < 0 || v >= activities.length || w < 0 || w >= activities.length) return;

    adj[v].push(w);
    req[w].push(v);
  }



}
